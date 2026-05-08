<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var s=localStorage.getItem("learnify_theme")||"dark";document.documentElement.setAttribute("data-theme",s);})();</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — Learnify</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-wrapper">

<nav class="auth-nav">
  <a href="${pageContext.request.contextPath}/" class="auth-logo">
    <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
  <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">Sign in</a>
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
    <h1 class="auth-heading">Create your account</h1>
    <p class="auth-sub">Start your AI-powered study journey</p>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
      <div class="alert alert-error"><%= error %></div>
    <% } %>



    <form action="register" method="post">
      <div class="form-group">
        <label>Full name</label>
        <input type="text" name="name" placeholder="Your full name" required>
      </div>
      <div class="form-group">
        <label>Email address</label>
        <input type="email" name="email" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Min. 6 characters" required>
      </div>
      <button type="submit" class="btn btn-primary btn-full" style="margin-top:4px">Create Account</button>
    </form>

    <div class="auth-switch">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>
  </div>
</main>


  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
