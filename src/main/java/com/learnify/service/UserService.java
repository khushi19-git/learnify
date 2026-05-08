package com.learnify.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.learnify.entity.User;
import com.learnify.repository.UserRepository;

// UserService = user ke saare database operations
@Service
public class UserService {

    private UserRepository userRepo;

    public UserService(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    // Register: naya user save karo
    public User register(User user) {
        return userRepo.save(user);
    }

    // Login ke liye email se user dhundo
    public Optional<User> findByEmail(String email) {
        return userRepo.findByEmail(email);
    }

    // Profile update karo (password reset etc.)
    public User update(User user) {
        return userRepo.save(user);
    }

    // Admin: saare users ki list
    public List<User> getAllUsers() {
        return userRepo.findAll();
    }

    // Admin: kisi bhi user ko ID se lo
    public User getUserById(int id) {
        return userRepo.findById(id).orElse(null);
    }

    // Admin: user delete karo
    public void deleteUser(int id) {
        userRepo.deleteById(id);
    }

    // Total users count — admin dashboard stats ke liye
    public long getTotalUsers() {
        return userRepo.count();
    }
}
