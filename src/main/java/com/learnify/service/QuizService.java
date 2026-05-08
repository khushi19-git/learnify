package com.learnify.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.learnify.entity.Quiz;
import com.learnify.entity.StudyFile;
import com.learnify.repository.QuizRepository;

@Service
public class QuizService {

    private QuizRepository repo;
    private AIService aiService;
    private PdfService pdfService;

    public QuizService(QuizRepository repo, AIService aiService, PdfService pdfService) {
        this.repo       = repo;
        this.aiService  = aiService;
        this.pdfService = pdfService;
    }

    public List<Quiz> getByFile(StudyFile file) {
        return repo.findByFile(file);
    }

    // =============================================
    // GENERATE — cache first
    // =============================================
    public List<Quiz> generateAndSave(StudyFile file) {
        // Cache check
        List<Quiz> cached = repo.findByFile(file);
        if (!cached.isEmpty() && !cached.get(0).getQuestion().startsWith("⚠️")) {
            System.out.println("✅ Quiz cache hit: " + file.getFileName());
            return cached;
        }
        repo.deleteAll(cached);

        String content = getContent(file);
        if (content == null || content.isBlank()) return fallback(file);

        String response;
        if (content.length() > 3000) {
            response = aiService.askWithChunks(
                "Create MCQ questions from this content.\nFormat: Question|OptionA|OptionB|OptionC|OptionD|CORRECT_INDEX\nCORRECT_INDEX is 0,1,2 or 3. No extra text.",
                content,
                "Combine all questions into one list. Format: Question|A|B|C|D|INDEX\nKeep the 8 best unique questions."
            );
        } else {
            response = aiService.askSafe(
                "Generate 8 MCQ questions from this content.\n"
              + "Format each line: Question|OptionA|OptionB|OptionC|OptionD|CORRECT_INDEX\n"
              + "CORRECT_INDEX = 0,1,2 or 3 only. No numbering, no blank lines.\n\n" + content
            );
        }

        if (response == null || response.startsWith("Error")) return fallback(file);

        List<Quiz> parsed = parse(response, file);
        if (parsed.isEmpty()) return fallback(file);

        return repo.saveAll(parsed);
    }

    // =============================================
    // PARSER — index-based, handles all AI formats
    // =============================================
    private List<Quiz> parse(String response, StudyFile file) {
        List<Quiz> list = new ArrayList<>();
        if (response == null || response.isBlank()) return list;

        for (String line : response.split("\n")) {
            line = line.trim();
            // Skip blank lines, markdown, headers
            if (line.isBlank() || line.startsWith("#") || line.startsWith("=")
                    || line.startsWith("*") || line.startsWith("-") || line.startsWith("`"))
                continue;

            String[] parts = line.split("\\|");
            if (parts.length < 6) continue;

            String q      = parts[0].trim();
            String optA   = parts[1].trim();
            String optB   = parts[2].trim();
            String optC   = parts[3].trim();
            String optD   = parts[4].trim();
            String idxRaw = parts[5].trim();

            if (q.isBlank() || optA.isBlank()) continue;

            // Parse correct index robustly
            int correctIdx = parseCorrectIndex(idxRaw, optA, optB, optC, optD);

            Quiz quiz = new Quiz();
            quiz.setQuestion(q);
            quiz.setOptions(optA + "|" + optB + "|" + optC + "|" + optD);
            // Store as index string "0"/"1"/"2"/"3" — reliable
            quiz.setCorrectAnswer(String.valueOf(correctIdx));
            quiz.setFile(file);
            list.add(quiz);
        }
        return list;
    }

    // =============================================
    // PARSE CORRECT INDEX
    // Handles: "0", "1", "A", "B", full text match
    // =============================================
    private int parseCorrectIndex(String raw, String a, String b, String c, String d) {
        if (raw == null || raw.isBlank()) return 0;
        String r = raw.trim();

        // Direct digit
        if (r.matches("[0-3]")) return Integer.parseInt(r);

        // Letter
        if (r.equalsIgnoreCase("A")) return 0;
        if (r.equalsIgnoreCase("B")) return 1;
        if (r.equalsIgnoreCase("C")) return 2;
        if (r.equalsIgnoreCase("D")) return 3;

        // Full text match with options
        String rl = r.toLowerCase();
        if (rl.equals(a.toLowerCase())) return 0;
        if (rl.equals(b.toLowerCase())) return 1;
        if (rl.equals(c.toLowerCase())) return 2;
        if (rl.equals(d.toLowerCase())) return 3;

        // Partial match
        if (a.toLowerCase().contains(rl) || rl.contains(a.toLowerCase())) return 0;
        if (b.toLowerCase().contains(rl) || rl.contains(b.toLowerCase())) return 1;
        if (c.toLowerCase().contains(rl) || rl.contains(c.toLowerCase())) return 2;
        if (d.toLowerCase().contains(rl) || rl.contains(d.toLowerCase())) return 3;

        System.out.println("⚠️ Could not parse index: " + raw + " → defaulting 0");
        return 0;
    }

    private String getContent(StudyFile file) {
        if (file.getFileName().toLowerCase().endsWith(".pdf")) {
            return pdfService.extractText(file.getFilePath());
        }
        String c = file.getContent();
        return (c != null) ? c : "";
    }

    private List<Quiz> fallback(StudyFile file) {
        List<Quiz> list = new ArrayList<>();
        Quiz q = new Quiz();
        q.setQuestion("⚠️ Quiz could not be generated. Please try again.");
        q.setOptions("Try again|Check file content|API issue|Contact support");
        q.setCorrectAnswer("0");
        q.setFile(file);
        list.add(q);
        return repo.saveAll(list);
    }
}
