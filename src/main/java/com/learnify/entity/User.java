package com.learnify.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = true)
    private int verified;

    // ✅ ALWAYS UPPERCASE ROLE
    @Column(nullable = false, length = 20)
    private String role = "USER";

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<StudyFile> files;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<History> history;

    // ✅ Auto set on insert
    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();

        if (this.role == null || this.role.isEmpty()) {
            this.role = "USER";
        }
    }

    // ================= GETTERS =================

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public int getVerified() {
        return verified;
    }

    public String getRole() {
        return role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public List<StudyFile> getFiles() {
        return files;
    }

    public List<History> getHistory() {
        return history;
    }

    // ✅ Admin check (SAFE)
    public boolean isAdmin() {
        return this.role != null && this.role.equalsIgnoreCase("ADMIN");
    }

    // ================= SETTERS =================

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setVerified(int verified) {
        this.verified = verified;
    }

    public void setRole(String role) {
        if (role != null) {
            this.role = role.toUpperCase(); // ✅ auto fix case
        }
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setFiles(List<StudyFile> files) {
        this.files = files;
    }

    public void setHistory(List<History> history) {
        this.history = history;
    }
}