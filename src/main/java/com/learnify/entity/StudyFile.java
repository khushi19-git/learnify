package com.learnify.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "files")
public class StudyFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "file_path")
    private String filePath;

    @Column(name = "upload_date")
    private LocalDateTime uploadDate;

    //Many files -> One user
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public LocalDateTime getUploadDate() {
		return uploadDate;
	}

	public void setUploadDate(LocalDateTime uploadDate) {
		this.uploadDate = uploadDate;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<Summary> getSummaries() {
		return summaries;
	}

	public void setSummaries(List<Summary> summaries) {
		this.summaries = summaries;
	}

	public List<Flashcard> getFlashcards() {
		return flashcards;
	}

	public void setFlashcards(List<Flashcard> flashcards) {
		this.flashcards = flashcards;
	}

	public List<Quiz> getQuizzes() {
		return quizzes;
	}

	public void setQuizzes(List<Quiz> quizzes) {
		this.quizzes = quizzes;
	}

	//One file -> Many summaries
    @OneToMany(mappedBy = "file", cascade = CascadeType.ALL)
    private List<Summary> summaries;

    //One file -> Many flashcards
    @OneToMany(mappedBy = "file", cascade = CascadeType.ALL)
    private List<Flashcard> flashcards;

    // One file ->Many quizzes
    @OneToMany(mappedBy = "file", cascade = CascadeType.ALL)
    private List<Quiz> quizzes;

    // Auto timestamp
    @PrePersist
    public void onCreate() {
        this.uploadDate = LocalDateTime.now();
    }

    
}