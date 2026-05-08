package com.learnify.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service
public class AIService {

    @Value("${gemini.api.key}")
    private String apiKey;

    private static final String URL =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

    // Free tier: 3000 chars per chunk is safe
    private static final int CHUNK_SIZE = 3000;

    private final HttpClient client = HttpClient.newBuilder()
        .connectTimeout(Duration.ofSeconds(30)).build();
    private final ObjectMapper mapper = new ObjectMapper();

    // ── Single API call ──────────────────────────────────────
    public String ask(String prompt) {
        try {
            if (prompt == null || prompt.isBlank()) return "Error: empty";

            HttpRequest req = HttpRequest.newBuilder()
                .uri(new URI(URL + apiKey))
                .header("Content-Type", "application/json")
                .timeout(Duration.ofSeconds(60))
                .POST(HttpRequest.BodyPublishers.ofString(buildJson(prompt)))
                .build();

            HttpResponse<String> res = client.send(req, HttpResponse.BodyHandlers.ofString());

            // 429 = rate limit → wait 10s, retry once
            if (res.statusCode() == 429) {
                System.out.println("429 rate limit — waiting 10s...");
                Thread.sleep(10_000);
                res = client.send(req, HttpResponse.BodyHandlers.ofString());
                if (res.statusCode() == 429) return "Error: rate_limit";
            }

            if (res.statusCode() != 200) {
                System.out.println("API error: " + res.statusCode());
                return "Error: api_" + res.statusCode();
            }

            String out = extractText(res.body());
            // Strip markdown fences
            if (out != null && out.startsWith("```"))
                out = out.replaceAll("^```[a-zA-Z]*\\n?","").replaceAll("\\n?```$","").trim();
            return out;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); return "Error: interrupted";
        } catch (Exception e) {
            System.out.println("AIService error: " + e.getMessage()); return "Error: exception";
        }
    }

    // ── Retry (max 1 retry for free tier) ───────────────────
    public String askWithRetry(String prompt, int ignored) {
        String r = ask(prompt);
        if (r != null && !r.startsWith("Error")) return r;
        System.out.println("Retry after 5s...");
        try { Thread.sleep(5_000); } catch (Exception e) { Thread.currentThread().interrupt(); }
        return ask(prompt);
    }

    public String askSafe(String prompt) { return askWithRetry(prompt, 1); }

    // ── Chunk-based call for large content ──────────────────
    // Splits into 3000-char chunks, 3s delay between each
    // Prevents 429 on free tier
    public String askWithChunks(String systemPrompt, String content, String combinePrompt) {
        if (content == null || content.isBlank()) return "Error: no_content";

        // Small content → direct call
        if (content.length() <= CHUNK_SIZE)
            return askSafe(systemPrompt + "\n\n" + content);

        List<String> chunks = splitChunks(content, CHUNK_SIZE);
        System.out.println("Chunks: " + chunks.size());
        List<String> results = new ArrayList<>();

        for (int i = 0; i < chunks.size(); i++) {
            System.out.println("Processing chunk " + (i+1) + "/" + chunks.size());
            String r = askSafe(systemPrompt + "\n\n[Part " + (i+1) + " of " + chunks.size() + "]\n\n" + chunks.get(i));
            if (r != null && !r.startsWith("Error")) results.add(r);
            // 3s delay between chunks — free tier safety
            if (i < chunks.size() - 1)
                try { Thread.sleep(3_000); } catch (Exception ignored) {}
        }

        if (results.isEmpty()) return "Error: all_chunks_failed";
        if (results.size() == 1) return results.get(0);

        // Combine results
        String combined = String.join("\n\n---\n\n", results);
        String final2 = askSafe(combinePrompt + "\n\n" + smartTrim(combined, 4000));
        return (final2 != null && !final2.startsWith("Error")) ? final2 : combined;
    }

    // ── Trim large content ───────────────────────────────────
    public String smartTrim(String content, int max) {
        if (content == null) return "";
        if (content.length() <= max) return content;
        int begin = (int)(max * 0.6);
        int end   = max - begin;
        return content.substring(0, begin) + "\n\n[...]\n\n" + content.substring(content.length() - end);
    }

    // ── Split into chunks on word boundary ──────────────────
    private List<String> splitChunks(String text, int size) {
        List<String> list = new ArrayList<>();
        int start = 0;
        while (start < text.length()) {
            int end = Math.min(start + size, text.length());
            if (end < text.length()) {
                int sp = text.lastIndexOf(' ', end);
                if (sp > start) end = sp;
            }
            list.add(text.substring(start, end).trim());
            start = end;
        }
        return list;
    }

    // ── Build Gemini JSON body ───────────────────────────────
    private String buildJson(String prompt) {
        return "{\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt)
            + "\"}]}],\"generationConfig\":{\"maxOutputTokens\":4096,\"temperature\":0.3}}";
    }

    // ── Extract text from response ───────────────────────────
    private String extractText(String json) {
        try {
            JsonNode root = mapper.readTree(json);
            StringBuilder sb = new StringBuilder();
            JsonNode cands = root.get("candidates");
            if (cands != null)
                for (JsonNode c : cands)
                    for (JsonNode p : c.path("content").path("parts"))
                        if (p.has("text")) sb.append(p.get("text").asText());
            return sb.toString().trim();
        } catch (Exception e) { return "Error: parse"; }
    }

    private String escapeJson(String t) {
        if (t == null) return "";
        return t.replace("\\","\\\\").replace("\"","\\\"")
                .replace("\r\n","\\n").replace("\n","\\n")
                .replace("\r","\\n").replace("\t","\\t");
    }

    // Legacy methods
    public String generateSummaryChunk(String c) { return askSafe("Summarize in bullet points:\n\n" + c); }
    public String generateSummary(String c)       { return askSafe("Final summary in bullet points:\n\n" + c); }
    public String generateFlashcards(String c)    { return askSafe("Create 5 flashcards.\nFormat: Q: question || A: answer\n\n" + c); }
    public String generateQuiz(String c)          { return askSafe("Create 5 MCQ. Format: Question|A|B|C|D|INDEX\n\n" + c); }
}
