package com.learnify.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.learnify.entity.History;
import com.learnify.entity.User;


public interface HistoryRepository extends JpaRepository<History, Integer> {

   
    List<History> findTop10ByUserOrderByActivityDateDesc(User user);
}
