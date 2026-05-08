package com.learnify.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.learnify.entity.Flashcard;
import com.learnify.entity.StudyFile;
import com.learnify.repository.FlashcardRepository;

@Service
public class FlashcardService {

    private FlashcardRepository repo;
    private AIService aiService;
    private PdfService pdfService;

    public FlashcardService(FlashcardRepository repo, AIService aiService, PdfService pdfService) {
        this.repo       = repo;
        this.aiService  = aiService;
        this.pdfService = pdfService;
    }

    public List<Flashcard> getByFile(StudyFile file) {
        return repo.findByFile(file);
    }

    // =============================================
    // GENERATE — cache first
    // =============================================
    public List<Flashcard> generateAndSave(StudyFile file) {
        // Cache check
        List<Flashcard> cached = repo.findByFile(file);
        if (!cached.isEmpty() && !cached.get(0).getQuestion().startsWith("⚠️")) {
            System.out.println("✅ Flashcard cache hit: " + file.getFileName());
            return cached;
        }
        repo.deleteAll(cached);

        String content = getContent(file);
        if (content == null || content.isBlank()) return fallback(file);

        String response;
        if (content.length() > 3000) {
            response = aiService.askWithChunks(
                "Create flashcards from this content.\nFormat each line as: Q: question || A: answer\nNo numbering, no blank lines.",
                content,
                "Combine all flashcards into one list. Format: Q: question || A: answer\nKeep the 10 best unique ones."
            );
        } else {
            response = aiService.askSafe(
                "Create 10 flashcards from this content.\n"
              + "Format each line as: Q: question || A: answer\n"
              + "No numbering, no blank lines, concise answers.\n\n" + content
            );
        }
        if (response == null || response.startsWith("Error")) return fallback(file);

        List<Flashcard> parsed = parse(response, file);
        if (parsed.isEmpty()) return fallback(file);

        return repo.saveAll(parsed);
    }

    private List<Flashcard> parse(String response, StudyFile file) {
        List<Flashcard> list = new ArrayList<>();
        if (response == null) return list;

        for (String line : response.split("\n")) {
            line = line.trim();
            if (!line.contains("||")) continue;

            String[] parts = line.split("\\|\\|");
            if (parts.length < 2) continue;

            String q = parts[0].replaceAll("(?i)^\\d+\\.?\\s*q\\s*:\\s*", "").replaceAll("(?i)^q\\s*:\\s*", "").trim();
            String a = parts[1].replaceAll("(?i)^a\\s*:\\s*", "").trim();

            if (q.isBlank() || a.isBlank()) continue;

            Flashcard card = new Flashcard();
            card.setQuestion(q);
            card.setAnswer(a);
            card.setFile(file);
            list.add(card);
        }
        return list;
    }

    private String getContent(StudyFile file) {
        if (file.getFileName().toLowerCase().endsWith(".pdf")) {
            return pdfService.extractText(file.getFilePath());
        }
        String c = file.getContent();
        return (c != null) ? c : "";
    }

    private List<Flashcard> fallback(StudyFile file) {
        List<Flashcard> list = new ArrayList<>();
        Flashcard f = new Flashcard();
        f.setQuestion("⚠️ Flashcards could not be generated");
        f.setAnswer("Please try regenerating or check your file content.");
        f.setFile(file);
        list.add(f);
        return repo.saveAll(list);
    }
}
