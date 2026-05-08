package com.learnify.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xslf.usermodel.*;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.learnify.entity.StudyFile;
import com.learnify.entity.User;
import com.learnify.repository.FileRepository;

@Service
public class FileService {

    private final FileRepository fileRepo;
    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper mapper = new ObjectMapper();

    @Value("${upload.path}")
    private String uploadPath;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    public FileService(FileRepository fileRepo) {
        this.fileRepo = fileRepo;
    }

    // =============================================
    // UPLOAD FILE
    // =============================================
    public StudyFile uploadFile(MultipartFile file, User user) throws IOException {
        String originalName = file.getOriginalFilename();
        if (originalName == null || originalName.isBlank()) throw new IOException("Invalid file name");

        String fileName = UUID.randomUUID() + "_" + originalName;
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        File dest = new File(dir, fileName);
        file.transferTo(dest);

        StudyFile sf = new StudyFile();
        sf.setFileName(originalName);
        sf.setFilePath(dest.getAbsolutePath());
        sf.setUser(user);

        // Extract content at upload time
        String content = extractContent(sf);
        sf.setContent(content);

        return fileRepo.save(sf);
    }

    // =============================================
    // UNIVERSAL CONTENT EXTRACTOR
    // =============================================
    public String extractContent(StudyFile file) {
        String name = file.getFileName().toLowerCase();
        String path = file.getFilePath();
        try {
            if (name.endsWith(".pdf"))  return extractPdf(path);
            if (name.endsWith(".txt") || name.endsWith(".java") || name.endsWith(".js"))
                return Files.readString(Paths.get(path));
            if (name.endsWith(".docx")) return extractDocx(path);
            if (name.endsWith(".pptx")) return extractPptx(path);
            if (name.endsWith(".xlsx")) return extractExcel(path);
            // Images — Gemini Vision se describe karwao
            if (name.endsWith(".jpg") || name.endsWith(".jpeg")
                    || name.endsWith(".png") || name.endsWith(".webp"))
                return extractImageWithGemini(path, name);
            return "Unsupported file type";
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // =============================================
    // PDF EXTRACTOR
    // =============================================
    private String extractPdf(String path) throws Exception {
        try (PDDocument doc = PDDocument.load(new File(path))) {
            return new PDFTextStripper().getText(doc);
        }
    }

    // =============================================
    // DOCX EXTRACTOR
    // =============================================
    private String extractDocx(String path) throws Exception {
        try (XWPFDocument doc = new XWPFDocument(new FileInputStream(path))) {
            return new XWPFWordExtractor(doc).getText();
        }
    }

    // =============================================
    // PPTX EXTRACTOR
    // =============================================
    private String extractPptx(String path) throws Exception {
        StringBuilder text = new StringBuilder();
        try (XMLSlideShow ppt = new XMLSlideShow(new FileInputStream(path))) {
            ppt.getSlides().forEach(slide ->
                slide.getShapes().forEach(shape -> {
                    if (shape instanceof XSLFTextShape ts) text.append(ts.getText()).append("\n");
                })
            );
        }
        return text.toString();
    }

    // =============================================
    // EXCEL EXTRACTOR
    // =============================================
    private String extractExcel(String path) throws Exception {
        StringBuilder text = new StringBuilder();
        try (Workbook wb = WorkbookFactory.create(new File(path))) {
            for (Sheet sheet : wb)
                for (Row row : sheet) {
                    for (Cell cell : row) text.append(cell.toString()).append(" ");
                    text.append("\n");
                }
        }
        return text.toString();
    }

    // =============================================
    // IMAGE — Gemini Vision API
    // Image upload hone par Gemini se describe karwao
    // Phir us description se summary/flashcard/quiz generate hogi
    // =============================================
    private String extractImageWithGemini(String path, String fileName) {
        try {
            byte[] imageBytes = Files.readAllBytes(Paths.get(path));
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            String mimeType = "image/jpeg";
            if (fileName.endsWith(".png"))  mimeType = "image/png";
            if (fileName.endsWith(".webp")) mimeType = "image/webp";

            String jsonBody = "{\"contents\":[{\"parts\":["
                + "{\"text\":\"Describe this image in detail. Extract all visible text. List all key concepts, topics, formulas, and information. Be thorough so this can be used for study summaries, flashcards, and quiz generation.\"},"
                + "{\"inline_data\":{\"mime_type\":\"" + mimeType + "\",\"data\":\"" + base64Image + "\"}}"
                + "]}]}";

            String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + geminiApiKey;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(new URI(apiUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                System.out.println("Gemini Vision error: " + response.body());
                return "Image uploaded. Content extraction failed.";
            }

            JsonNode root = mapper.readTree(response.body());
            return root.path("candidates").get(0)
                       .path("content").path("parts").get(0)
                       .path("text").asText("Image could not be described.");

        } catch (Exception e) {
            e.printStackTrace();
            return "Image uploaded. Text extraction unavailable.";
        }
    }

    // =============================================
    // DELETE FILE
    // =============================================
    public void deleteFile(int id) {
        StudyFile file = fileRepo.findById(id).orElse(null);
        if (file != null) {
            File f = new File(file.getFilePath());
            if (f.exists()) f.delete();
            fileRepo.deleteById(id);
        }
    }

    // =============================================
    // GET ALL FILES (Admin use)
    // =============================================
    public List<StudyFile> getAllFiles() {
        return fileRepo.findAll();
    }
}
