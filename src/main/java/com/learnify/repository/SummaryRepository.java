package com.learnify.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import com.learnify.entity.StudyFile;
import com.learnify.entity.Summary;

public interface SummaryRepository extends JpaRepository<Summary, Integer> {

    // ✔ Get summary by file (single latest)
    Optional<Summary> findByFile(StudyFile file);

    // ✔ Delete old summary before inserting new one
    @Transactional
    void deleteByFile(StudyFile file);
}