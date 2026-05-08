<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.learnify.entity.StudyFile" %>
<%@ page import="com.learnify.entity.Flashcard" %>
<%@ page import="java.util.List" %>
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
  <title>Flashcards — <%= fname %></title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .result-nav{position:sticky;top:0;background:var(--surface);backdrop-filter:blur(14px);border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;padding:0 32px;height:54px;z-index:100}
    .rn-logo{display:flex;align-items:center;gap:9px;font-size:15px;font-weight:700;color:var(--text);text-decoration:none;letter-spacing:-.02em}
    .rl-icon{width:26px;height:26px;background:var(--accent);border-radius:7px;display:flex;align-items:center;justify-content:center}
    .result-main{max-width:1100px;margin:40px auto;padding:0 24px 80px}
    .result-hero{text-align:center;margin-bottom:36px}
    .result-file-badge{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-family:var(--mono);font-weight:600;color:var(--accent-light);background:var(--accent-dim);border:1px solid rgba(34,197,94,.25);padding:4px 12px;border-radius:20px;margin-bottom:14px;text-transform:uppercase;letter-spacing:.05em}
    .result-title{font-size:26px;font-weight:700;color:var(--text);letter-spacing:-.03em}
    .tool-tabs{display:flex;gap:8px;margin-bottom:28px;background:var(--bg3);border:1px solid var(--border);border-radius:10px;padding:4px;max-width:500px;margin-left:auto;margin-right:auto}
    .tool-tab{flex:1;text-align:center;padding:8px;border-radius:7px;font-size:13px;font-weight:500;color:var(--text3);text-decoration:none;transition:all .18s}
    .tool-tab.active{background:var(--accent);color:#fff}
    .tool-tab:hover:not(.active){color:var(--text);background:var(--surface)}
    /* FLASHCARD 3D */
    .fc-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(290px,1fr));gap:20px;perspective:1200px}
    .flashcard{height:200px;cursor:pointer;position:relative;transform-style:preserve-3d;transition:transform .55s cubic-bezier(.4,0,.2,1)}
    .flashcard.flipped{transform:rotateY(180deg)}
    .card-face{position:absolute;width:100%;height:100%;backface-visibility:hidden;border-radius:var(--radius-lg);padding:28px;display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;box-sizing:border-box}
    .card-front{background:var(--surface);border:1px solid var(--border);border-bottom:3px solid var(--accent)}
    .card-back{background:var(--accent-bg);border:1px solid var(--accent-border);transform:rotateY(180deg)}
    .cf-label{font-size:9px;font-family:var(--mono);font-weight:600;letter-spacing:.1em;text-transform:uppercase;margin-bottom:12px;opacity:.5}
    .cf-label.front{color:var(--accent-light)}
    .cf-label.back{color:var(--accent-light)}
    .card-question{font-size:15px;font-weight:600;color:var(--text);line-height:1.45}
    .card-answer{font-size:14px;color:var(--accent-light);line-height:1.5}
    .tap-hint{position:absolute;bottom:14px;font-size:10px;font-family:var(--mono);opacity:.35;color:var(--accent-light)}
    /* Counter bar */
    .fc-bar{display:flex;align-items:center;justify-content:space-between;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:12px 18px;margin-bottom:20px}
    .fc-count{font-size:13px;color:var(--text2);font-family:var(--mono)}
    .fc-count span{color:var(--accent-light);font-weight:600}
    /* Progress dots */
    .fc-dots{display:flex;gap:5px;flex-wrap:wrap;max-width:300px}
    .fc-dot{width:8px;height:8px;border-radius:50%;background:var(--border2);transition:background .2s}
    .fc-dot.seen{background:var(--accent)}
    /* Loader */
    #pageLoader{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center}
    .loader-spin{width:40px;height:40px;border:3px solid rgba(34,197,94,0.2);border-top-color:var(--accent);border-radius:50%;animation:spin .8s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
  </style>
</head>
<body style="background:var(--bg);color:var(--text);min-height:100vh">

<div id="pageLoader" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center;">
  <div class="loader-spin"></div>
  <p style="margin-top:14px;font-size:14px;color:var(--text2);font-weight:500" id="loaderMsg">Loading...</p>
</div>

<nav class="result-nav">
  <a href="${pageContext.request.contextPath}/dashboard" class="rn-logo">
    <div class="rl-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
  <div style="display:flex;gap:8px;align-items:center">
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('📄 Loading summary...')">📄 Summary</a>
      <a href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('❓ Generating quiz...')">❓ Quiz</a>
    <% } %>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost btn-sm">← Dashboard</a>
    <button class="theme-toggle-btn" onclick="window.learnifyTheme.toggle()" title="Toggle theme">🌙</button>
  </div>
</nav>

<main class="result-main">
  <div class="result-hero">
    <div class="result-file-badge">🃏 Active Recall Mode</div>
    <h1 class="result-title"><%= fname %></h1>
    <p style="color:var(--text2);font-size:14px;margin-top:6px">Tap any card to reveal the answer</p>
  </div>

  <% if (sf != null) { %>
  <div class="tool-tabs">
    <a href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('📄 Loading summary...')">📄 Summary</a>
    <span class="tool-tab active">🃏 Flashcards</span>
    <a href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('❓ Generating quiz...')">❓ Quiz</a>
  </div>
  <% } %>

  <%
    List<Flashcard> flashcards = (List<Flashcard>) request.getAttribute("flashcards");
    int cardCount = (flashcards != null) ? flashcards.size() : 0;
  %>

  <div class="fc-bar">
    <div class="fc-count">Total: <span><%= cardCount %> Cards</span></div>
    <div class="fc-dots" id="dotContainer"></div>
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>"
         class="btn btn-secondary btn-sm"
         onclick="return confirmRegen()">↻ Regenerate</a>
    <% } %>
  </div>

  <div class="fc-grid">
    <% if (flashcards != null) {
       int i = 1;
       for (Flashcard card : flashcards) { %>
      <div class="flashcard" onclick="flipCard(this, <%= i-1 %>)">
        <div class="card-face card-front">
          <span class="cf-label front">Card #<%= i %> · Question</span>
          <div class="card-question"><%= card.getQuestion() %></div>
          <div class="tap-hint">TAP TO FLIP</div>
        </div>
        <div class="card-face card-back">
          <span class="cf-label back">Answer</span>
          <div class="card-answer"><%= card.getAnswer() %></div>
          <div class="tap-hint" style="color:var(--accent-light)">TAP TO RETURN</div>
        </div>
      </div>
    <% i++; } } %>
  </div>

  <div style="margin-top:28px;padding-top:20px;border-top:1px solid var(--border);display:flex;justify-content:center;gap:10px">
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">← Back to Dashboard</a>
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>" class="btn btn-primary" onclick="showLoader('❓ Generating quiz...')">Take Quiz →</a>
    <% } %>
  </div>
</main>

<script>
var seenCards = new Set();
var total = <%= cardCount %>;

// Build progress dots
var dotContainer = document.getElementById('dotContainer');
for (var i = 0; i < total; i++) {
  var dot = document.createElement('div');
  dot.className = 'fc-dot';
  dot.id = 'dot-' + i;
  dotContainer.appendChild(dot);
}

function flipCard(el, idx) {
  el.classList.toggle('flipped');
  if (!seenCards.has(idx)) {
    seenCards.add(idx);
    var dot = document.getElementById('dot-' + idx);
    if (dot) dot.classList.add('seen');
  }
}

function showLoader(msg) {
  document.getElementById('loaderMsg').textContent = msg || 'Loading...';
  document.getElementById('pageLoader').style.display = 'flex';
}

function confirmRegen() {
  if (confirm('Regenerate all flashcards? Current cards will be replaced.')) {
    showLoader('🃏 Regenerating flashcards...');
    return true;
  }
  return false;
}
</script>

  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
