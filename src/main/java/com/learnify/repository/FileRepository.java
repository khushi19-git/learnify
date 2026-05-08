package com.learnify.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.learnify.entity.StudyFile;
import com.learnify.entity.User;

public interface FileRepository extends JpaRepository<StudyFile, Integer> {

    List<StudyFile> findByUser(User user);

}