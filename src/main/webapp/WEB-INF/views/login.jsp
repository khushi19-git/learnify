<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var t=localStorage.getItem('lf_theme')||'light';document.documentElement.setAttribute('data-theme',t);})()</script>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Login — Learnify</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-wrapper">

<nav class="auth-nav">
  <div class="auth-logo">
    <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </div>
  <div style="display:flex;align-items:center;gap:8px">
    <button class="theme-toggle-btn" onclick="toggleTheme()">🌙</button>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-sm">Sign up</a>
  </div>
</nav>

<div class="auth-container">
  <div class="auth-card">
    <div class="auth-logo-row">
      <div class="auth-logo">
        <div class="lg-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
        Learnify
      </div>
    </div>
    <h1 class="auth-heading">Welcome back</h1>
    <p class="auth-sub">Sign in to your account</p>

    <%-- Alerts --%>
    <% String err = (String) request.getAttribute("error");
       if (err != null) { %><div class="alert alert-error"><%= err %></div><% } %>
    <% String pm = request.getParameter("msg");
       if ("registered".equals(pm)) { %><div class="alert alert-success">Account created! Please sign in.</div>
    <% } else if ("loggedOut".equals(pm)) { %><div class="alert alert-success">Logged out successfully.</div>
    <% } else if ("resetSuccess".equals(pm)) { %><div class="alert alert-success">Password reset! Sign in below.</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" placeholder="you@example.com" required autofocus>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Your password" required>
      </div>
      <button type="submit" class="btn btn-primary btn-full btn-lg" style="margin-top:4px">Sign In</button>
    </form>

    <div style="text-align:center;margin-top:12px">
      <a href="${pageContext.request.contextPath}/forgot" style="font-size:13px;color:var(--text3)">Forgot password?</a>
    </div>
    <div class="auth-switch">New here? <a href="${pageContext.request.contextPath}/register">Create account</a></div>

    <%-- Admin note (small, discreet) --%>
    <p style="text-align:center;margin-top:16px;font-size:11.5px;color:var(--text3)">
      Admin? Use your admin email &amp; password to sign in.
    </p>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
