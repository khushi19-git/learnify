package com.learnify.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.learnify.entity.StudyFile;
import com.learnify.entity.User;
import com.learnify.repository.UserRepository;
import com.learnify.service.FileService;
import com.learnify.service.HistoryService;
import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    private UserRepository userRepo;
    private FileService fileService;
    private HistoryService historyService;

    public AdminController(UserRepository userRepo, FileService fileService, HistoryService historyService) {
        this.userRepo = userRepo;
        this.fileService = fileService;
        this.historyService = historyService;
    }

    @GetMapping("/admin")
    public String adminPanel(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!user.isAdmin()) return "redirect:/dashboard?msg=noaccess";

        List<User> allUsers = userRepo.findAll();
        List<StudyFile> allFiles = fileService.getAllFiles();

        model.addAttribute("allUsers",     allUsers);
        model.addAttribute("allFiles",     allFiles);
        model.addAttribute("totalUsers",   (long) allUsers.size());
        model.addAttribute("totalFiles",   (long) allFiles.size());
        model.addAttribute("verifiedUsers", allUsers.stream().filter(u -> u.getVerified()==1).count());
        model.addAttribute("totalAdmins",  allUsers.stream().filter(User::isAdmin).count());
        return "admin";
    }

    @GetMapping("/admin/delete-user/{id}")
    public String deleteUser(@PathVariable int id, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !admin.isAdmin()) return "redirect:/login";
        if (id == admin.getId()) return "redirect:/admin?msg=cannotDeleteSelf";
        userRepo.deleteById(id);
        historyService.log(admin, "Admin deleted user ID: " + id);
        return "redirect:/admin?msg=userDeleted";
    }

    @GetMapping("/admin/delete-file/{id}")
    public String deleteFile(@PathVariable int id, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !admin.isAdmin()) return "redirect:/login";
        fileService.deleteFile(id);
        historyService.log(admin, "Admin deleted file ID: " + id);
        return "redirect:/admin?msg=fileDeleted";
    }

    @GetMapping("/admin/make-admin/{id}")
    public String makeAdmin(@PathVariable int id, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !admin.isAdmin()) return "redirect:/login";
        User target = userRepo.findById(id).orElse(null);
        if (target != null) {
            target.setRole("admin");
            userRepo.save(target);
            historyService.log(admin, "Promoted to admin: " + target.getEmail());
        }
        return "redirect:/admin?msg=madeAdmin";
    }

    @GetMapping("/admin/remove-admin/{id}")
    public String removeAdmin(@PathVariable int id, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !admin.isAdmin()) return "redirect:/login";
        if (id == admin.getId()) return "redirect:/admin?msg=cannotDeleteSelf";
        User target = userRepo.findById(id).orElse(null);
        if (target != null) {
            target.setRole("user");
            userRepo.save(target);
            historyService.log(admin, "Removed admin: " + target.getEmail());
        }
        return "redirect:/admin?msg=adminRemoved";
    }
}
