<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.learnify.entity.StudyFile" %>
<%@ page import="com.learnify.entity.Summary" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var s=localStorage.getItem("learnify_theme")||"dark";document.documentElement.setAttribute("data-theme",s);})();</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <%
    StudyFile sf = (StudyFile) request.getAttribute("file");
    String fname = (sf != null) ? sf.getFileName() : "File";
  %>
  <title>Summary — <%= fname %></title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .result-nav{position:sticky;top:0;background:var(--surface);backdrop-filter:blur(14px);border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;padding:0 32px;height:54px;z-index:100}
    .rn-logo{display:flex;align-items:center;gap:9px;font-size:15px;font-weight:700;color:var(--text);text-decoration:none;letter-spacing:-.02em}
    .rl-icon{width:26px;height:26px;background:var(--accent);border-radius:7px;display:flex;align-items:center;justify-content:center}
    .result-main{max-width:860px;margin:40px auto;padding:0 24px 80px}
    .result-hero{text-align:center;margin-bottom:36px}
    .result-file-badge{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-family:var(--mono);font-weight:600;color:var(--accent-light);background:var(--accent-dim);border:1px solid rgba(34,197,94,.25);padding:4px 12px;border-radius:20px;margin-bottom:14px;text-transform:uppercase;letter-spacing:.05em}
    .result-title{font-size:26px;font-weight:700;color:var(--text);letter-spacing:-.03em;word-break:break-all}
    .result-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-lg);padding:32px;margin-bottom:20px;position:relative;overflow:hidden}
    .result-card::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%;background:var(--accent)}
    .rc-label{font-size:10px;font-family:var(--mono);font-weight:600;color:var(--accent-light);letter-spacing:.08em;text-transform:uppercase;margin-bottom:14px;display:block}
    .rc-short{font-size:17px;color:var(--text2);line-height:1.65;font-style:italic}
    .rc-long{font-size:14px;color:var(--text2);white-space:pre-line;line-height:1.75}
    .rc-long li,.rc-long-line{padding:4px 0}
    .rc-actions{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
    .tool-tabs{display:flex;gap:8px;margin-bottom:28px;background:var(--bg3);border:1px solid var(--border);border-radius:10px;padding:4px}
    .tool-tab{flex:1;text-align:center;padding:8px;border-radius:7px;font-size:13px;font-weight:500;color:var(--text3);text-decoration:none;transition:all .18s}
    .tool-tab.active{background:var(--accent);color:#fff}
    .tool-tab:hover:not(.active){color:var(--text);background:var(--surface)}
    #pageLoader{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center}
    .loader-spin{width:40px;height:40px;border:3px solid rgba(34,197,94,0.2);border-top-color:var(--accent);border-radius:50%;animation:spin .8s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
    .loader-msg{margin-top:14px;font-size:14px;color:var(--text2);font-weight:500}
  </style>
</head>
<body style="background:var(--bg);color:var(--text);min-height:100vh">

<div id="pageLoader" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center;">
  <div class="loader-spin"></div>
  <p class="loader-msg" id="loaderMsg">Loading...</p>
</div>

<nav class="result-nav">
  <a href="${pageContext.request.contextPath}/dashboard" class="rn-logo">
    <div class="rl-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
  <div style="display:flex;gap:8px;align-items:center">
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('🃏 Loading flashcards...')">🃏 Flashcards</a>
      <a href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('❓ Generating quiz...')">❓ Quiz</a>
    <% } %>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost btn-sm">← Dashboard</a>
    <button class="theme-toggle-btn" onclick="window.learnifyTheme.toggle()" title="Toggle theme">🌙</button>
  </div>
</nav>

<main class="result-main">
  <div class="result-hero">
    <div class="result-file-badge">📄 Document Analyzed</div>
    <h1 class="result-title"><%= fname %></h1>
  </div>

  <% if (sf != null) { %>
  <div class="tool-tabs">
    <span class="tool-tab active">📄 Summary</span>
    <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('🃏 Loading flashcards...')">🃏 Flashcards</a>
    <a href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('❓ Generating quiz...')">❓ Quiz</a>
  </div>
  <% } %>

  <%
    Summary summary = (Summary) request.getAttribute("summary");
    if (summary != null) {
  %>
    <div class="result-card" style="background:var(--surface)">
      <span class="rc-label">Quick Overview</span>
      <div class="rc-short">"<%= summary.getSummaryShort() != null ? summary.getSummaryShort() : "No overview available." %>"</div>
    </div>

    <div class="result-card">
      <div class="rc-actions">
        <span class="rc-label" style="margin-bottom:0">Detailed Summary</span>
        <% if (sf != null) { %>
          <a href="${pageContext.request.contextPath}/summary/regenerate/<%= sf.getId() %>"
             class="btn btn-secondary btn-sm"
             onclick="return confirmRegen()">↻ Regenerate</a>
        <% } %>
      </div>
      <div class="rc-long"><%= summary.getSummaryLong() != null ? summary.getSummaryLong() : "No summary available." %></div>
    </div>

  <% } else { %>
    <div class="result-card" style="text-align:center;padding:48px">
      <div style="font-size:36px;margin-bottom:12px">⚠️</div>
      <h3 style="margin-bottom:8px;color:var(--text)">Summary could not be generated</h3>
      <p style="color:var(--text2);margin-bottom:20px">Please try again.</p>
      <% if (sf != null) { %>
        <a href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>" class="btn btn-primary" onclick="showLoader('📄 Generating summary...')">Try Again</a>
      <% } %>
    </div>
  <% } %>

  <div style="margin-top:24px;padding-top:20px;border-top:1px solid var(--border);display:flex;justify-content:center;gap:10px">
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">← Back to Dashboard</a>
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="btn btn-primary" onclick="showLoader('🃏 Loading flashcards...')">Study Flashcards →</a>
    <% } %>
  </div>
</main>

<script>
function showLoader(msg) {
  document.getElementById('loaderMsg').textContent = msg || 'Loading...';
  document.getElementById('pageLoader').style.display = 'flex';
}
function confirmRegen() {
  if (confirm('AI will re-read your file and replace the current summary. Continue?')) {
    showLoader('📄 Regenerating summary...');
    return true;
  }
  return false;
}
</script>

  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
