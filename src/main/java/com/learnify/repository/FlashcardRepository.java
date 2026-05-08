package com.learnify.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.learnify.entity.StudyFile;
import com.learnify.entity.Flashcard;

public interface FlashcardRepository extends JpaRepository<Flashcard, Integer> {

    List<Flashcard> findByFile(StudyFile file);

}