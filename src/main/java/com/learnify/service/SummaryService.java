package com.learnify.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.learnify.entity.StudyFile;
import com.learnify.entity.Summary;
import com.learnify.repository.SummaryRepository;

@Service
public class SummaryService {

    private final SummaryRepository summaryRepo;
    private final AIService aiService;
    private final PdfService pdfService;

    public SummaryService(SummaryRepository summaryRepo,
                          AIService aiService,
                          PdfService pdfService) {
        this.summaryRepo = summaryRepo;
        this.aiService   = aiService;
        this.pdfService  = pdfService;
    }

    // =============================================
    // GENERATE — cache check pehle, phir API call
    // =============================================
    public Summary generateSummary(StudyFile file) {
        // Cache hit — DB mein already hai to return karo, no API call
        Optional<Summary> cached = summaryRepo.findByFile(file);
        if (cached.isPresent()) {
            Summary s = cached.get();
            if (s.getSummaryLong() != null && !s.getSummaryLong().isBlank()
                    && !s.getSummaryLong().startsWith("AI failed")
                    && !s.getSummaryLong().startsWith("No content")
                    && !s.getSummaryLong().startsWith("AI temporarily")) {
                System.out.println("✅ Summary cache hit: " + file.getFileName());
                return s;
            }
        }
        return regenerateSummary(file);
    }

    // =============================================
    // REGENERATE — force fresh AI call
    // =============================================
    public Summary regenerateSummary(StudyFile file) {
        summaryRepo.deleteByFile(file);

        String content = getContent(file);
        if (content == null || content.isBlank()) {
            return saveFallback(file, "No content available in this file.");
        }

        String result;
        if (content.length() > 3000) {
            result = aiService.askWithChunks(
                "Summarize this content. Write clear bullet points starting with '- '. No intro text.",
                content,
                "Combine these summaries into one list of 10-15 bullet points. Each starts with '- '."
            );
        } else {
            result = aiService.askSafe(
                "Summarize this content in 10-15 bullet points. Each starts with '- '. No intro.\n\n" + content
            );
        }

        if (result == null || result.startsWith("Error") || result.isBlank()) {
            return saveFallback(file, "AI temporarily unavailable. Please try again.");
        }

        Summary summary = new Summary();
        summary.setFile(file);
        summary.setSummaryLong(result);
        summary.setSummaryShort(result.substring(0, Math.min(200, result.length())));
        return summaryRepo.save(summary);
    }

    // =============================================
    // GET CONTENT — PDF ya stored content
    // =============================================
    private String getContent(StudyFile file) {
        String name = file.getFileName().toLowerCase();
        // PDF ke liye direct extract
        if (name.endsWith(".pdf")) {
            return pdfService.extractText(file.getFilePath());
        }
        // Baaki ke liye stored content
        String content = file.getContent();
        return (content != null) ? content : "";
    }

    private Summary saveFallback(StudyFile file, String msg) {
        Summary s = new Summary();
        s.setFile(file);
        s.setSummaryShort(msg);
        s.setSummaryLong(msg);
        return summaryRepo.save(s);
    }
}
