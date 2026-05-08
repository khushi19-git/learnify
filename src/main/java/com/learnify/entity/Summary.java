package com.learnify.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "summaries")
public class Summary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "summary_short", columnDefinition = "TEXT")
    private String summaryShort;

    @Column(name = "summary_long", columnDefinition = "LONGTEXT")
    private String summaryLong;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Many summaries → One file
    @ManyToOne
    @JoinColumn(name = "file_id")
    private StudyFile file;

    
    public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}


	public String getSummaryShort() {
		return summaryShort;
	}


	public void setSummaryShort(String summaryShort) {
		this.summaryShort = summaryShort;
	}


	public String getSummaryLong() {
		return summaryLong;
	}


	public void setSummaryLong(String summaryLong) {
		this.summaryLong = summaryLong;
	}


	public LocalDateTime getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}


	public StudyFile getFile() {
		return file;
	}


	public void setFile(StudyFile file) {
		this.file = file;
	}


	@PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

   
}