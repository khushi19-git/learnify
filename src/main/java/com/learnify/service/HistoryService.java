package com.learnify.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.learnify.entity.History;
import com.learnify.entity.User;
import com.learnify.repository.HistoryRepository;

// HistoryService = user ki har activity log karta hai
// Dashboard pe "Recent Activity" section mein dikhta hai
@Service
public class HistoryService {

    private HistoryRepository historyRepo;

    public HistoryService(HistoryRepository historyRepo) {
        this.historyRepo = historyRepo;
    }

    // =============================================
    // LOG: Ek naya activity record save karo
    //
    // Example:
    //   historyService.log(user, "Uploaded file: notes.pdf")
    //   historyService.log(user, "Generated summary for: notes.pdf")
    // =============================================
    public void log(User user, String activityText) {

        // History object banao
        History history = new History();
        history.setUser(user);
        history.setActivity(activityText);
        // Timestamp @PrePersist mein automatically set hoga

        // DB mein save karo
        historyRepo.save(history);
    }

    // =============================================
    // GET RECENT: User ke last 10 activities lo
    // Dashboard pe show karne ke liye
    // =============================================
    public List<History> getRecent(User user) {
        return historyRepo.findTop10ByUserOrderByActivityDateDesc(user);
    }
}
