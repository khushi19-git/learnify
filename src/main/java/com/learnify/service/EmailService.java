package com.learnify.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

@Service
public class EmailService {

    @Value("${mail.username}")
    private String from;

    @Value("${mail.password}")
    private String password;

    public void sendOtp(String toEmail, String otp) {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));
            message.setSubject("Learnify OTP Verification");
            message.setText("Your OTP is: " + otp + "\nValid for 2 minutes");

            Transport.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}