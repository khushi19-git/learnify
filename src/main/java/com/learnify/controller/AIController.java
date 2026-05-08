package com.learnify.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.learnify.entity.*;
import com.learnify.repository.FileRepository;
import com.learnify.service.*;

import jakarta.servlet.http.HttpSession;

@Controller
public class AIController {

    private SummaryService summaryService;
    private FlashcardService flashcardService;
    private QuizService quizService;
    private FileRepository fileRepo;
    private HistoryService historyService;

    public AIController(SummaryService summaryService,
                        FlashcardService flashcardService,
                        QuizService quizService,
                        FileRepository fileRepo,
                        HistoryService historyService) {

        this.summaryService = summaryService;
        this.flashcardService = flashcardService;
        this.quizService = quizService;
        this.fileRepo = fileRepo;
        this.historyService = historyService;
    }

    // =========================
    // COMMON METHOD (IMPORTANT FIX)
    // =========================
    private StudyFile validateUserFile(int fileId, User user) {

        StudyFile file = fileRepo.findById(fileId).orElse(null);

        if (file == null || file.getUser().getId() != user.getId()) {
            return null;
        }

        return file;
    }

    // =========================
    // SUMMARY
    // =========================
    @GetMapping("/summary/{fileId}")
    public String generateSummary(@PathVariable int fileId,
                                 HttpSession session,
                                 Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        StudyFile file = validateUserFile(fileId, user);

        if (file == null) {
            model.addAttribute("error", "File not found");
            return "dashboard";
        }

        Summary summary = summaryService.generateSummary(file);

        if (summary == null || summary.getSummaryLong() == null) {
            model.addAttribute("file", file);
            model.addAttribute("error", "⚠️ Summary generation failed");
            return "summary";
        }

        model.addAttribute("file", file);
        model.addAttribute("summary", summary);

        historyService.log(user, "Generated summary: " + file.getFileName());

        return "summary";
    }

    // =========================
    // REGENERATE SUMMARY
    // =========================
    @GetMapping("/summary/regenerate/{fileId}")
    public String regenerateSummary(@PathVariable int fileId,
                                    HttpSession session,
                                    Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        StudyFile file = validateUserFile(fileId, user);
        if (file == null) return "redirect:/dashboard";

        Summary summary = summaryService.regenerateSummary(file);

        model.addAttribute("file", file);
        model.addAttribute("summary", summary);
        model.addAttribute("msg", "Summary regenerated");

        historyService.log(user, "Regenerated summary: " + file.getFileName());

        return "summary";
    }

    // =========================
    // FLASHCARDS
    // =========================
    @GetMapping("/flashcards/{fileId}")
    public String generateFlashcards(@PathVariable int fileId,
                                     HttpSession session,
                                     Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        StudyFile file = validateUserFile(fileId, user);

        if (file == null) {
            model.addAttribute("error", "File not found");
            return "dashboard";
        }

        List<Flashcard> flashcards = flashcardService.generateAndSave(file);

        if (flashcards == null || flashcards.isEmpty()) {
            model.addAttribute("file", file);
            model.addAttribute("error", "⚠️ Flashcards generation failed");
            return "flashcard";
        }

        model.addAttribute("file", file);
        model.addAttribute("flashcards", flashcards);
        model.addAttribute("flashcardCount", flashcards.size());

        historyService.log(user,
                "Generated " + flashcards.size() + " flashcards");

        return "flashcard";
    }

    // =========================
    // QUIZ
    // =========================
    @GetMapping("/quiz/{fileId}")
    public String generateQuiz(@PathVariable int fileId,
                               HttpSession session,
                               Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        StudyFile file = validateUserFile(fileId, user);

        if (file == null) {
            model.addAttribute("error", "File not found");
            return "dashboard";
        }

        List<Quiz> quizzes = quizService.generateAndSave(file);

        if (quizzes == null || quizzes.isEmpty()) {
            model.addAttribute("file", file);
            model.addAttribute("error", "⚠️ Quiz generation failed");
            return "quiz";
        }

        model.addAttribute("file", file);
        model.addAttribute("quizzes", quizzes);
        model.addAttribute("quizCount", quizzes.size());
        model.addAttribute("score", 0);
        model.addAttribute("total", quizzes.size());

        historyService.log(user,
                "Generated " + quizzes.size() + " quiz questions");

        return "quiz";
    }

    // =========================
    // VIEW FLASHCARDS
    // =========================
    @GetMapping("/flashcards/view/{fileId}")
    public String viewFlashcards(@PathVariable int fileId,
                                 HttpSession session,
                                 Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        StudyFile file = validateUserFile(fileId, user);
        if (file == null) return "redirect:/dashboard";

        List<Flashcard> flashcards = flashcardService.getByFile(file);

        if (flashcards == null || flashcards.isEmpty()) {
            return "redirect:/flashcards/" + fileId;
        }

        model.addAttribute("file", file);
        model.addAttribute("flashcards", flashcards);
        model.addAttribute("flashcardCount", flashcards.size());

        return "flashcard";
    }
}