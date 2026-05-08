package com.learnify.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.learnify.entity.StudyFile;
import com.learnify.entity.User;
import com.learnify.service.FileService;
import com.learnify.service.HistoryService;

import jakarta.servlet.http.HttpSession;

@Controller
public class FileController {

	private FileService fileService;
	private HistoryService historyService;

	public FileController(FileService fileService, HistoryService historyService) {
		this.fileService = fileService;
		this.historyService = historyService;
	}

	@PostMapping("/upload")
	public String uploadFile(@RequestParam("file") MultipartFile file, HttpSession session) {

		// Login check
		User user = (User) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		// File empty check
		if (file == null || file.isEmpty()) {
			return "redirect:/dashboard?msg=error";
		}

		// Sirf PDF aur TXT allow karo
		String name = file.getOriginalFilename();
		if (name == null) {
			return "redirect:/dashboard?msg=error";
		}

		String nameLower = name.toLowerCase();

		// PDF, TXT, aur Images (JPG, PNG, WEBP) allow karo
		boolean allowed = nameLower.endsWith(".pdf")
				|| nameLower.endsWith(".txt")
				|| nameLower.endsWith(".jpg")
				|| nameLower.endsWith(".jpeg")
				|| nameLower.endsWith(".png")
				|| nameLower.endsWith(".webp");

		if (!allowed) {
			return "redirect:/dashboard?msg=wrongType";
		}

		try {
			StudyFile saved = fileService.uploadFile(file, user);
			historyService.log(user, "Uploaded file: " + saved.getFileName());
			return "redirect:/dashboard?msg=uploaded";

		} catch (Exception e) {
			// Print full error to console — helps debugging
			e.printStackTrace();
			System.out.println("Upload error: " + e.getMessage());
			return "redirect:/dashboard?msg=error";
		}
	}

	// =============================================
	// DELETE: GET /delete/{id}
	// =============================================
	@GetMapping("/delete/{id}")
	public String deleteFile(@PathVariable("id") int id, HttpSession session) {

		User user = (User) session.getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		}

		fileService.deleteFile(id);
		historyService.log(user, "Deleted file #" + id);

		return "redirect:/dashboard?msg=deleted";
	}
}
