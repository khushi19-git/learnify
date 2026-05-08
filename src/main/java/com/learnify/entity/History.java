package com.learnify.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

// History entity = `history` table ka ek row
// Har user action ka record yahaan store hota hai
@Entity
@Table(name = "history")
public class History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    // Kya action hua — e.g. "Uploaded file: notes.pdf"
    @Column(nullable = false, length = 255)
    private String activity;

    // Kab hua — automatically set hota hai
    @Column(name = "activity_date")
    private LocalDateTime activityDate;

    // Kaun tha — user foreign key
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Automatically activityDate set karo jab row insert ho
    @PrePersist
    public void onCreate() {
        this.activityDate = LocalDateTime.now();
    }

    // --- Getters ---
    public int getId() {
        return id;
    }

    public String getActivity() {
        return activity;
    }

    public LocalDateTime getActivityDate() {
        return activityDate;
    }

    public User getUser() {
        return user;
    }

    // --- Setters ---
    public void setId(int id) {
        this.id = id;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public void setActivityDate(LocalDateTime activityDate) {
        this.activityDate = activityDate;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
