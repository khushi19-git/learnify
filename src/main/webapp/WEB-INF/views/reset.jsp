<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var s=localStorage.getItem("learnify_theme")||"dark";document.documentElement.setAttribute("data-theme",s);})();</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password — Learnify</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-wrapper">

<nav class="auth-nav">
  <a href="${pageContext.request.contextPath}/" class="auth-logo">
    <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
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
      <span class="step-ind-item done">✓ Email</span>
      <span class="step-ind-arrow">→</span>
      <span class="step-ind-item done">✓ OTP</span>
      <span class="step-ind-arrow">→</span>
      <span class="step-ind-item active">3. Reset</span>
    </div>

    <h1 class="auth-heading">Set new password</h1>
    <p class="auth-sub">Choose a strong password for your account.</p>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
      <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm">
      <input type="hidden" name="email" value="${email}">
      <div class="form-group">
        <label>New password</label>
        <input type="password" name="password" id="newPwd" placeholder="Min. 6 characters" required minlength="6" autofocus>
      </div>
      <div class="form-group">
        <label>Confirm password</label>
        <input type="password" name="confirmPassword" id="confirmPwd" placeholder="Repeat new password" required>
        <small id="matchMsg" style="font-size:12px"></small>
      </div>
      <button type="submit" class="btn btn-primary btn-full">Reset Password</button>
    </form>
  </div>
</main>

<script>
var confirmPwd = document.getElementById("confirmPwd");
var matchMsg = document.getElementById("matchMsg");
confirmPwd.addEventListener("input", function(){
  var p1 = document.getElementById("newPwd").value, p2 = confirmPwd.value;
  if(!p2.length){ matchMsg.textContent=""; return; }
  if(p1===p2){ matchMsg.textContent="✓ Passwords match"; matchMsg.style.color="var(--green)"; }
  else { matchMsg.textContent="✕ Passwords do not match"; matchMsg.style.color="var(--red)"; }
});
</script>

  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
