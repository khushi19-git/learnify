<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var s=localStorage.getItem("learnify_theme")||"dark";document.documentElement.setAttribute("data-theme",s);})();</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password — Learnify</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-wrapper">

<nav class="auth-nav">
  <a href="${pageContext.request.contextPath}/" class="auth-logo">
    <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
  <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">Back to login</a>
</nav>
  <button class="theme-toggle-btn" style="position:fixed;bottom:20px;right:20px;z-index:999" onclick="window.learnifyTheme.toggle()" title="Toggle theme">🌙</button>

<main class="auth-container">
  <div class="auth-card">
    <div class="auth-logo-row">
      <div class="auth-logo">
        <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
        Learnify
      </div>
    </div>

    <div class="step-indicator">
      <span class="step-ind-item active">1. Email</span>
      <span class="step-ind-arrow">→</span>
      <span class="step-ind-item">2. OTP</span>
      <span class="step-ind-arrow">→</span>
      <span class="step-ind-item">3. Reset</span>
    </div>

    <h1 class="auth-heading">Forgot password?</h1>
    <p class="auth-sub">Enter your email and we'll send you a 6-digit OTP.</p>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
      <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/send-otp" method="post">
      <div class="form-group">
        <label>Registered email</label>
        <input type="email" name="email" placeholder="you@example.com" required autofocus>
      </div>
      <button type="submit" class="btn btn-primary btn-full">Send OTP</button>
    </form>

    <div class="auth-switch">
      <a href="${pageContext.request.contextPath}/login">← Back to login</a>
    </div>
  </div>
</main>


  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
