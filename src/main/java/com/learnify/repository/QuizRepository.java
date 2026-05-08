package com.learnify.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.learnify.entity.StudyFile;
import com.learnify.entity.Quiz;

public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    List<Quiz> findByFile(StudyFile file);

}