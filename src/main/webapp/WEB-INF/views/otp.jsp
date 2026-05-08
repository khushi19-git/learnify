<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var s=localStorage.getItem("learnify_theme")||"dark";document.documentElement.setAttribute("data-theme",s);})();</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify OTP — Learnify</title>
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
      <span class="step-ind-item active">2. OTP</span>
      <span class="step-ind-arrow">→</span>
      <span class="step-ind-item">3. Reset</span>
    </div>

    <h1 class="auth-heading">Check your email</h1>
    <p class="auth-sub">We sent a 6-digit code to <strong style="color:var(--text)">${email}</strong></p>

    <div class="otp-timer">Expires in: <span id="timer">2:00</span></div>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
      <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
      <input type="hidden" name="email" value="${email}">
      <div class="form-group">
        <label>6-digit OTP</label>
        <input type="text" name="otp" class="otp-input" placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autofocus oninput="this.value=this.value.replace(/[^0-9]/g,'')">
        <small style="color:var(--text3);font-size:12px">Numbers only</small>
      </div>
      <button type="submit" class="btn btn-primary btn-full">Verify Code</button>
    </form>

    <div class="auth-switch">
      Didn't get it? <a href="${pageContext.request.contextPath}/forgot">Resend OTP</a>
    </div>
  </div>
</main>

<script>
var seconds = 120;
var timerEl = document.getElementById("timer");
var interval = setInterval(function(){
  seconds--;
  var m = Math.floor(seconds/60), s = seconds%60;
  timerEl.textContent = m+":"+(s<10?"0":"")+s;
  if(seconds<=30) timerEl.style.color="var(--red)";
  if(seconds<=0){
    clearInterval(interval);
    timerEl.textContent="Expired";
    timerEl.style.color="var(--red)";
    document.querySelector("button[type='submit']").disabled=true;
  }
},1000);
</script>

  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
