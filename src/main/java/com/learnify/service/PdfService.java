package com.learnify.service;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Service;

@Service
public class PdfService {

    // Max pages process karenge — memory safe
    private static final int MAX_PAGES = 60;

    // Max chars per chunk
    private static final int MAX_CHUNK_CHARS = 12_000;

    // =============================================
    // FULL TEXT
    // =============================================
    public String extractText(String filePath) {
        File file = new File(filePath);
        if (!file.exists()) return "";
        try (PDDocument doc = PDDocument.load(file)) {
            PDFTextStripper stripper = new PDFTextStripper();
            int limit = Math.min(doc.getNumberOfPages(), MAX_PAGES);
            stripper.setStartPage(1);
            stripper.setEndPage(limit);
            String text = stripper.getText(doc);
            System.out.println("PDF pages=" + doc.getNumberOfPages() + " processed=" + limit + " chars=" + text.length());
            return text;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // =============================================
    // SMART CHUNKS — paragraph-aware splitting
    // =============================================
    public List<String> extractPageChunks(String filePath, int pagesPerChunk) {
        List<String> chunks = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return chunks;

        try (PDDocument doc = PDDocument.load(file)) {
            PDFTextStripper stripper = new PDFTextStripper();
            int total = doc.getNumberOfPages();
            int limit = Math.min(total, MAX_PAGES);

            stripper.setStartPage(1);
            stripper.setEndPage(limit);
            String fullText = stripper.getText(doc).trim();

            System.out.println("PDF total=" + total + " processed=" + limit + " chars=" + fullText.length());

            if (!fullText.isBlank()) {
                chunks = splitIntoChunks(fullText, MAX_CHUNK_CHARS);
                System.out.println("Created " + chunks.size() + " chunks");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chunks;
    }

    // =============================================
    // PARAGRAPH-AWARE SPLITTER
    // =============================================
    private List<String> splitIntoChunks(String text, int maxChars) {
        List<String> chunks = new ArrayList<>();
        StringBuilder current = new StringBuilder();

        for (String para : text.split("\n\n+")) {
            para = para.trim();
            if (para.isBlank()) continue;

            if (para.length() > maxChars) {
                if (current.length() > 0) {
                    chunks.add(current.toString().trim());
                    current = new StringBuilder();
                }
                // Split large para by sentences
                StringBuilder sentBuf = new StringBuilder();
                for (String sent : para.split("(?<=[.!?])\\s+")) {
                    if (sentBuf.length() + sent.length() > maxChars && sentBuf.length() > 0) {
                        chunks.add(sentBuf.toString().trim());
                        sentBuf = new StringBuilder();
                    }
                    sentBuf.append(sent).append(" ");
                }
                if (sentBuf.length() > 0) chunks.add(sentBuf.toString().trim());
                continue;
            }

            if (current.length() + para.length() + 2 > maxChars && current.length() > 0) {
                chunks.add(current.toString().trim());
                current = new StringBuilder();
            }
            current.append(para).append("\n\n");
        }

        if (current.length() > 0) chunks.add(current.toString().trim());
        return chunks;
    }
}
