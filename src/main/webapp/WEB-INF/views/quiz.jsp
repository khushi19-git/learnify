<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.learnify.entity.StudyFile" %>
<%@ page import="com.learnify.entity.Quiz" %>
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
  <title>Quiz — <%= fname %></title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .result-nav{position:sticky;top:0;background:var(--surface);backdrop-filter:blur(14px);border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;padding:0 32px;height:54px;z-index:100}
    .rn-logo{display:flex;align-items:center;gap:9px;font-size:15px;font-weight:700;color:var(--text);text-decoration:none;letter-spacing:-.02em}
    .rl-icon{width:26px;height:26px;background:var(--accent);border-radius:7px;display:flex;align-items:center;justify-content:center}
    .result-main{max-width:800px;margin:36px auto;padding:0 24px 100px}
    .tool-tabs{display:flex;gap:8px;margin-bottom:24px;background:var(--bg3);border:1px solid var(--border);border-radius:10px;padding:4px}
    .tool-tab{flex:1;text-align:center;padding:8px;border-radius:7px;font-size:13px;font-weight:500;color:var(--text3);text-decoration:none;transition:all .18s}
    .tool-tab.active{background:var(--accent);color:#fff}
    .tool-tab:hover:not(.active){color:var(--text);background:var(--surface)}
    /* Score bar */
    .quiz-score-bar{position:sticky;top:54px;z-index:90;background:var(--bg2);border-bottom:1px solid var(--border);padding:10px 24px;display:flex;justify-content:space-between;align-items:center}
    .qsb-left{font-size:13px;color:var(--text2)}
    .qsb-left strong{color:var(--text);font-weight:600}
    .score-pill{background:var(--accent-dim);border:1px solid rgba(34,197,94,.3);color:var(--accent-light);font-family:var(--mono);font-weight:700;font-size:14px;padding:5px 16px;border-radius:20px}
    /* Quiz card */
    .quiz-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-lg);padding:28px;margin-bottom:18px;transition:box-shadow .2s}
    .quiz-card:hover{box-shadow:0 4px 20px rgba(0,0,0,.3)}
    .q-num{font-size:10px;font-family:var(--mono);font-weight:600;color:var(--accent-light);letter-spacing:.08em;text-transform:uppercase;margin-bottom:10px;display:block}
    .q-text{font-size:17px;font-weight:600;color:var(--text);line-height:1.45;margin-bottom:20px}
    /* Options */
    .options-grid{display:flex;flex-direction:column;gap:10px}
    .q-option{background:var(--bg3);border:1.5px solid var(--border);border-radius:10px;padding:13px 16px;text-align:left;font-size:14px;font-weight:500;color:var(--text2);display:flex;align-items:center;gap:12px;transition:all .18s;cursor:pointer}
    .q-option:hover:not(:disabled){background:var(--surface);border-color:var(--accent);color:var(--text);transform:translateX(4px)}
    .opt-letter{width:28px;height:28px;border-radius:7px;background:var(--surface);border:1px solid var(--border2);display:flex;align-items:center;justify-content:center;font-family:var(--mono);font-size:11px;font-weight:700;color:var(--text3);flex-shrink:0}
    /* States */
    .q-option.correct{background:rgba(34,197,94,.1)!important;border-color:var(--accent)!important;color:#86efac!important}
    .q-option.correct .opt-letter{background:var(--accent);color:#fff;border-color:var(--accent)}
    .q-option.wrong{background:rgba(239,68,68,.1)!important;border-color:#ef4444!important;color:#fca5a5!important}
    .q-option.wrong .opt-letter{background:#ef4444;color:#fff;border-color:#ef4444}
    .feedback-text{margin-top:12px;font-size:13px;font-weight:600;display:none;padding:8px 12px;border-radius:8px}
    .feedback-text.ok{background:rgba(34,197,94,.08);color:#4ade80;border:1px solid rgba(34,197,94,.2)}
    .feedback-text.bad{background:rgba(239,68,68,.08);color:#f87171;border:1px solid rgba(239,68,68,.2)}
    /* Result card */
    .result-card{text-align:center;background:var(--surface);border:1px solid rgba(34,197,94,.3);border-radius:var(--radius-xl);padding:48px;display:none;animation:zoomIn .4s cubic-bezier(.175,.885,.32,1.275)}
    @keyframes zoomIn{from{opacity:0;transform:scale(.85)}to{opacity:1;transform:scale(1)}}
    .result-score{font-size:56px;font-weight:800;color:var(--accent-light);letter-spacing:-.04em;line-height:1;margin:16px 0}
    .result-msg{font-size:15px;color:var(--text2);margin-bottom:24px}
    /* Loader */
    #pageLoader{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center}
    .loader-spin{width:40px;height:40px;border:3px solid rgba(34,197,94,0.2);border-top-color:var(--accent);border-radius:50%;animation:spin .8s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
  </style>
</head>
<body style="background:var(--bg);color:var(--text);min-height:100vh;padding-bottom:60px">

<div id="pageLoader" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;flex-direction:column;align-items:center;justify-content:center;">
  <div class="loader-spin"></div>
  <p style="margin-top:14px;font-size:14px;color:var(--text2);font-weight:500" id="loaderMsg">Processing Quiz...</p>
</div>

<nav class="result-nav">
  <a href="${pageContext.request.contextPath}/dashboard" class="rn-logo">
    <div class="rl-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
    Learnify
  </a>
  <div style="display:flex;gap:8px;align-items:center">
    <% if (sf != null) { %>
      <a href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('📄 Loading summary...')">📄 Summary</a>
      <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="btn btn-secondary btn-sm" onclick="showLoader('🃏 Loading flashcards...')">🃏 Flashcards</a>
    <% } %>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost btn-sm">← Dashboard</a>
    <button class="theme-toggle-btn" onclick="window.learnifyTheme.toggle()" title="Toggle theme">🌙</button>
  </div>
</nav>

<%
  List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
  int totalCount = (quizzes != null) ? quizzes.size() : 0;
%>

<div class="quiz-score-bar" id="scoreBar">
  <div class="qsb-left"><strong><%= fname %></strong> &nbsp;·&nbsp; <%= totalCount %> Questions</div>
  <div class="score-pill">Score: <span id="score">0</span> / <%= totalCount %></div>
</div>

<main class="result-main">

  <% if (sf != null) { %>
  <div class="tool-tabs">
    <a href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('📄 Loading summary...')">📄 Summary</a>
    <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="tool-tab" onclick="showLoader('🃏 Loading flashcards...')">🃏 Flashcards</a>
    <span class="tool-tab active">❓ Quiz</span>
  </div>
  <% } %>

  <div id="quizContainer">
    <%
      if (quizzes != null) {
        int qIdx = 0;
        String[] labels = {"A", "B", "C", "D"};
        for (Quiz q : quizzes) {
          String[] opts = q.getOptions() != null ? q.getOptions().split("\\|") : new String[]{};
          String correctIdxStr = q.getCorrectAnswer() != null ? q.getCorrectAnswer().trim() : "0";
          int correctIdx = 0;
          try { correctIdx = Integer.parseInt(correctIdxStr); } catch (Exception ignored) {}
          String correctText = (opts.length > correctIdx) ? opts[correctIdx].trim() : "";
    %>
    <div class="quiz-card" id="card-<%= qIdx %>">
      <span class="q-num">Question <%= qIdx + 1 %> of <%= totalCount %></span>
      <div class="q-text"><%= q.getQuestion() %></div>
      <div class="options-grid">
        <% for (int i = 0; i < opts.length && i < 4; i++) { %>
          <button class="q-option"
                  onclick="handleSelection(this, <%= correctIdx %>, '<%= correctText.replace("'","\\'" ).replace("\"","&quot;") %>', <%= qIdx %>)"
                  data-index="<%= i %>">
            <span class="opt-letter"><%= labels[i] %></span>
            <%= opts[i].trim() %>
          </button>
        <% } %>
      </div>
      <div id="feedback-<%= qIdx %>" class="feedback-text"></div>
    </div>
    <% qIdx++; } } %>
  </div>

  <!-- RESULT CARD -->
  <div id="resultCard" class="result-card">
    <div style="font-size:48px">🎉</div>
    <h2 style="font-size:24px;font-weight:700;color:var(--text);margin-top:12px">Quiz Completed!</h2>
    <div class="result-score"><span id="finalScore">0</span><span style="font-size:28px;color:var(--text2);font-weight:400"> / <%= totalCount %></span></div>
    <div class="result-msg" id="resultMsg">Great job!</div>
    <div style="display:flex;gap:10px;justify-content:center;flex-wrap:wrap">
      <button onclick="window.location.reload()" class="btn btn-secondary">↻ Try Again</button>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">← Dashboard</a>
      <% if (sf != null) { %>
        <a href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" class="btn btn-secondary" onclick="showLoader('🃏 Loading flashcards...')">Study Flashcards</a>
      <% } %>
    </div>
  </div>

  <div id="finishRow" style="text-align:center;margin-top:24px">
    <button class="btn btn-primary" style="padding:13px 36px;font-size:15px" onclick="showFinalResult()">
      Finish & See Result
    </button>
  </div>

</main>

<script>
var score = 0;
var answered = new Set();
var total = <%= totalCount %>;

function handleSelection(btn, correctIdx, correctText, qIdx) {
  if (answered.has(qIdx)) return;
  answered.add(qIdx);

  var selectedIdx = parseInt(btn.getAttribute('data-index'));
  var parent = btn.parentElement;
  var feedback = document.getElementById('feedback-' + qIdx);

  parent.querySelectorAll('.q-option').forEach(function(opt) {
    opt.disabled = true;
    if (parseInt(opt.getAttribute('data-index')) === correctIdx) {
      opt.classList.add('correct');
    }
  });

  if (selectedIdx === correctIdx) {
    score++;
    document.getElementById('score').textContent = score;
    feedback.textContent = '✓ Correct!';
    feedback.className = 'feedback-text ok';
  } else {
    btn.classList.add('wrong');
    feedback.textContent = '✕ Incorrect. Correct answer: ' + correctText;
    feedback.className = 'feedback-text bad';
  }
  feedback.style.display = 'block';

  // Auto-scroll to next unanswered
  setTimeout(function() {
    var cards = document.querySelectorAll('.quiz-card');
    for (var i = qIdx + 1; i < cards.length; i++) {
      if (!answered.has(i)) {
        cards[i].scrollIntoView({ behavior: 'smooth', block: 'center' });
        break;
      }
    }
  }, 600);
}

function showFinalResult() {
  var pct = total > 0 ? Math.round((score / total) * 100) : 0;
  var msg = pct >= 80 ? '🌟 Excellent! You mastered this topic!'
          : pct >= 60 ? '👍 Good job! Keep practicing.'
          : '📚 Keep studying, you\'ll improve!';

  document.getElementById('quizContainer').style.display = 'none';
  document.getElementById('finishRow').style.display = 'none';
  document.getElementById('scoreBar').style.display = 'none';
  document.getElementById('finalScore').textContent = score;
  document.getElementById('resultMsg').textContent = msg;
  document.getElementById('resultCard').style.display = 'block';
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function showLoader(msg) {
  document.getElementById('loaderMsg').textContent = msg || 'Loading...';
  document.getElementById('pageLoader').style.display = 'flex';
}
</script>

  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
