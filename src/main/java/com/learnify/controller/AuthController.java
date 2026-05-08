package com.learnify.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.learnify.entity.History;
import com.learnify.entity.User;
import com.learnify.repository.FileRepository;
import com.learnify.service.EmailService;
import com.learnify.service.HistoryService;
import com.learnify.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    private final UserService userService;
    private final FileRepository fileRepo;
    private final EmailService emailService;
    private final HistoryService historyService;

    private Map<String, String> otpStorage = new HashMap<>();
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AuthController(UserService userService,
                          FileRepository fileRepo,
                          EmailService emailService,
                          HistoryService historyService) {

        this.userService = userService;
        this.fileRepo = fileRepo;
        this.emailService = emailService;
        this.historyService = historyService;
    }

    // ================= REGISTER =================
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {

        // FIXED: Optional check
        if (userService.findByEmail(user.getEmail()).isPresent()) {
            model.addAttribute("error", "Email already registered. Please login.");
            return "register";
        }

        if (user.getPassword() == null || user.getPassword().length() < 6) {
            model.addAttribute("error", "Password must be at least 6 characters.");
            return "register";
        }

        user.setPassword(encoder.encode(user.getPassword()));
        userService.register(user);

        return "redirect:/login?msg=registered";
    }

    // ================= LOGIN =================
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute User user,
                        HttpSession session,
                        Model model) {

        Optional<User> optionalUser = userService.findByEmail(user.getEmail());

        if (optionalUser.isEmpty()) {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }

        User found = optionalUser.get();

        if (!encoder.matches(user.getPassword(), found.getPassword())) {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }

        session.setAttribute("user", found);
        historyService.log(found, "Logged in");

        // Admin ko seedha admin panel pe bhejo
        if (found.isAdmin()) return "redirect:/admin";
        return "redirect:/dashboard";
    }

    // ================= DASHBOARD =================
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("files", fileRepo.findByUser(user));
        model.addAttribute("history", historyService.getRecent(user));

        return "dashboard";
    }

    // ================= LOGOUT =================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?msg=loggedOut";
    }

    // ================= FORGOT PASSWORD =================
    @GetMapping("/forgot")
    public String forgotPage() {
        return "forgot";
    }

    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email, Model model) {

        Optional<User> optionalUser = userService.findByEmail(email);

        if (optionalUser.isEmpty()) {
            model.addAttribute("error", "No account found with this email.");
            return "forgot";
        }

        String otp = String.valueOf((int)(Math.random() * 900000) + 100000);
        otpStorage.put(email, otp);

        emailService.sendOtp(email, otp);

        return "redirect:/otp?email=" + email;
    }

    // ================= OTP =================
    @GetMapping("/otp")
    public String otpPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String email,
                            @RequestParam String otp,
                            Model model) {

        String savedOtp = otpStorage.get(email);

        if (savedOtp == null || !savedOtp.equals(otp.trim())) {
            model.addAttribute("email", email);
            model.addAttribute("error", "Invalid OTP.");
            return "otp";
        }

        String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
        return "redirect:/reset?email=" + encodedEmail;
    }

    // ================= RESET PASSWORD =================
    @GetMapping("/reset")
    public String resetPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "reset";
    }

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String email,
                                @RequestParam String password,
                                @RequestParam String confirmPassword,
                                Model model) {

        if (!password.equals(confirmPassword)) {
            model.addAttribute("email", email);
            model.addAttribute("error", "Passwords do not match.");
            return "reset";
        }

        Optional<User> optionalUser = userService.findByEmail(email);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            user.setPassword(encoder.encode(password));
            userService.update(user);
        }

        otpStorage.remove(email);

        return "redirect:/login?msg=resetSuccess";
    }
}