<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var t=localStorage.getItem('lf_theme')||'light';document.documentElement.setAttribute('data-theme',t);})()</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Learnify — AI Study Platform</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    /* ── LANDING ONLY STYLES ── */
    .lp-nav {
      position:sticky; top:0; z-index:100; height:54px;
      background:var(--surface); border-bottom:1px solid var(--border);
      display:flex; align-items:center; padding:0 24px;
    }
    .lp-nav-inner { display:flex; align-items:center; justify-content:space-between; width:100%; max-width:1100px; margin:0 auto; }
    .lp-logo { display:flex; align-items:center; gap:8px; font-size:16px; font-weight:700; color:var(--text); text-decoration:none; }
    .lp-logo-icon { width:28px; height:28px; border-radius:6px; background:var(--accent); display:flex; align-items:center; justify-content:center; }
    .lp-logo-icon svg { width:15px; height:15px; }
    .lp-nav-links { display:flex; align-items:center; gap:6px; }
    .lp-link { font-size:13.5px; color:var(--text2); padding:6px 12px; border-radius:6px; text-decoration:none; }
    .lp-link:hover { background:var(--bg2); color:var(--text); }
    .lp-btn-login { font-size:13.5px; color:var(--text); padding:6px 14px; border-radius:6px; border:1px solid var(--border); text-decoration:none; }
    .lp-btn-login:hover { border-color:var(--accent); }
    .lp-btn-cta { font-size:13.5px; font-weight:600; color:#fff; background:var(--accent); padding:7px 16px; border-radius:6px; text-decoration:none; }
    .lp-btn-cta:hover { opacity:0.9; }

    /* Hero */
    .hero { padding:80px 24px 60px; text-align:center; background:var(--bg); }
    .hero-inner { max-width:680px; margin:0 auto; }
    .hero-tag {
      display:inline-flex; align-items:center; gap:6px;
      font-size:12px; font-weight:600; color:var(--accent);
      background:var(--accent-bg); border:1px solid var(--accent-border);
      padding:4px 12px; border-radius:20px; margin-bottom:20px;
    }
    .hero-dot { width:6px; height:6px; border-radius:50%; background:var(--accent); display:inline-block; }
    .hero h1 { font-size:clamp(32px,5vw,52px); font-weight:700; color:var(--text); letter-spacing:-0.03em; line-height:1.15; margin-bottom:16px; }
    .hero h1 span { color:var(--accent); }
    .hero p { font-size:16px; color:var(--text2); margin-bottom:28px; line-height:1.6; }
    .hero-btns { display:flex; gap:10px; justify-content:center; flex-wrap:wrap; }

    /* Mock window */
    .mock-window {
      margin:48px auto 0; max-width:700px;
      background:var(--surface); border:1px solid var(--border);
      border-radius:10px; overflow:hidden;
      box-shadow:0 4px 24px rgba(0,0,0,0.08);
    }
    [data-theme="dark"] .mock-window { box-shadow:0 4px 24px rgba(0,0,0,0.4); }
    .mw-bar {
      background:var(--bg2); border-bottom:1px solid var(--border);
      padding:10px 14px; display:flex; align-items:center; gap:8px;
    }
    .mw-dot { width:10px; height:10px; border-radius:50%; }
    .mw-title { font-size:12px; color:var(--text3); margin-left:6px; font-family:monospace; }
    .mw-body { padding:16px; display:flex; flex-direction:column; gap:10px; }
    .mw-upload {
      border:2px dashed var(--border2); border-radius:8px;
      padding:20px; text-align:center; background:var(--bg2);
    }
    .mw-upload-icon { font-size:24px; margin-bottom:6px; }
    .mw-upload-txt { font-size:13px; font-weight:500; color:var(--text2); }
    .mw-file {
      display:flex; align-items:center; justify-content:space-between;
      padding:10px 12px; background:var(--bg2); border:1px solid var(--border);
      border-radius:7px; gap:10px;
    }
    .mw-file-left { display:flex; align-items:center; gap:8px; }
    .mw-ext { font-size:9px; font-weight:700; padding:2px 6px; border-radius:4px; text-transform:uppercase; }
    .mw-ext-pdf { background:#fee2e2; color:#dc2626; }
    .mw-ext-txt { background:#dbeafe; color:#2563eb; }
    .mw-fname { font-size:13px; font-weight:500; color:var(--text); }
    .mw-btns { display:flex; gap:5px; }
    .mw-btn {
      font-size:11px; font-weight:500; padding:3px 9px; border-radius:5px;
      border:1px solid var(--border); background:var(--surface); color:var(--text2);
    }

    /* Container */
    .lp-container { max-width:1100px; margin:0 auto; padding:0 24px; }

    /* Section common */
    .lp-section { padding:64px 24px; }
    .lp-section-gray { background:var(--bg2); border-top:1px solid var(--border); border-bottom:1px solid var(--border); }
    .section-tag { display:flex; justify-content:center; margin-bottom:14px; }
    .section-chip {
      font-size:11px; font-weight:600; color:var(--accent);
      background:var(--accent-bg); border:1px solid var(--accent-border);
      padding:3px 12px; border-radius:20px;
    }
    .section-title { font-size:clamp(22px,3vw,32px); font-weight:700; color:var(--text); text-align:center; margin-bottom:10px; }
    .section-sub { font-size:14.5px; color:var(--text2); text-align:center; max-width:480px; margin:0 auto 40px; }

    /* Features */
    .features-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:16px; }
    .feat-card {
      background:var(--surface); border:1px solid var(--border);
      border-radius:8px; padding:22px; transition:border-color 0.15s;
    }
    .feat-card:hover { border-color:var(--accent); }
    .feat-icon {
      width:40px; height:40px; border-radius:8px; display:flex;
      align-items:center; justify-content:center; margin-bottom:14px; font-size:20px;
    }
    .feat-icon-green { background:var(--accent-bg); border:1px solid var(--accent-border); }
    .feat-icon-amber { background:#fffbeb; border:1px solid #fde68a; }
    .feat-icon-purple { background:#f5f3ff; border:1px solid #ddd6fe; }
    [data-theme="dark"] .feat-icon-amber  { background:rgba(245,158,11,0.1);  border-color:rgba(245,158,11,0.2); }
    [data-theme="dark"] .feat-icon-purple { background:rgba(139,92,246,0.1);  border-color:rgba(139,92,246,0.2); }
    .feat-card h3 { font-size:15px; font-weight:600; color:var(--text); margin-bottom:7px; }
    .feat-card p  { font-size:13.5px; color:var(--text2); line-height:1.6; }

    /* Steps */
    .steps-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:20px; }
    .step-card { text-align:center; padding:24px 16px; }
    .step-num {
      width:40px; height:40px; border-radius:50%;
      background:var(--accent); color:#fff;
      font-size:15px; font-weight:700;
      display:flex; align-items:center; justify-content:center;
      margin:0 auto 14px;
    }
    .step-card h3 { font-size:15px; font-weight:600; color:var(--text); margin-bottom:7px; }
    .step-card p  { font-size:13.5px; color:var(--text2); line-height:1.6; }

    /* Pricing */
    .pricing-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:20px; max-width:640px; margin:0 auto; }
    .price-card {
      background:var(--surface); border:1px solid var(--border);
      border-radius:8px; padding:28px; position:relative;
    }
    .price-card.popular { border-color:var(--accent); border-width:2px; }
    .popular-tag {
      position:absolute; top:-11px; left:50%; transform:translateX(-50%);
      background:var(--accent); color:#fff; font-size:11px; font-weight:700;
      padding:2px 12px; border-radius:20px; white-space:nowrap;
    }
    .price-name { font-size:14px; font-weight:600; color:var(--text2); margin-bottom:8px; }
    .price-amt  { font-size:36px; font-weight:700; color:var(--text); letter-spacing:-0.03em; margin-bottom:4px; }
    .price-amt span { font-size:15px; font-weight:400; color:var(--text3); }
    .price-period { font-size:12px; color:var(--text3); margin-bottom:20px; }
    .price-features { list-style:none; display:flex; flex-direction:column; gap:9px; margin-bottom:22px; }
    .price-features li { font-size:13.5px; color:var(--text2); display:flex; align-items:center; gap:8px; }
    .price-features li::before { content:"✓"; color:var(--accent); font-weight:700; font-size:13px; }

    /* FAQ */
    .faq-wrap { max-width:640px; margin:0 auto; display:flex; flex-direction:column; gap:8px; }
    .faq-item { background:var(--surface); border:1px solid var(--border); border-radius:8px; overflow:hidden; }
    .faq-q {
      width:100%; text-align:left; padding:14px 16px;
      font-size:14px; font-weight:500; color:var(--text);
      background:none; border:none; cursor:pointer;
      display:flex; justify-content:space-between; align-items:center;
      font-family:inherit;
    }
    .faq-q:hover { background:var(--bg2); }
    .faq-icon { font-size:18px; color:var(--text3); transition:transform 0.2s; flex-shrink:0; }
    .faq-q.open .faq-icon { transform:rotate(45deg); }
    .faq-a { display:none; padding:0 16px 14px; font-size:13.5px; color:var(--text2); line-height:1.6; }
    .faq-a.open { display:block; }

    /* CTA Banner */
    .cta-section {
      padding:64px 24px; text-align:center;
      background:var(--accent-bg); border-top:1px solid var(--accent-border);
    }
    .cta-section h2 { font-size:clamp(22px,3vw,30px); font-weight:700; color:var(--text); margin-bottom:10px; }
    .cta-section p  { font-size:14.5px; color:var(--text2); margin-bottom:24px; }

    /* Footer */
    .lp-footer {
      background:var(--bg2); border-top:1px solid var(--border);
      padding:20px 24px; text-align:center;
    }
    .footer-inner { max-width:1100px; margin:0 auto; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px; }
    .footer-logo { display:flex; align-items:center; gap:7px; font-size:14px; font-weight:700; color:var(--text); }
    .footer-links { display:flex; gap:16px; }
    .footer-links a { font-size:13px; color:var(--text3); text-decoration:none; }
    .footer-links a:hover { color:var(--text); }
    .footer-copy { font-size:12px; color:var(--text3); }

    @media(max-width:600px) {
      .lp-link { display:none; }
      .hero { padding:50px 16px 40px; }
      .lp-section { padding:44px 16px; }
      .footer-inner { flex-direction:column; text-align:center; }
    }
  </style>
</head>
<body>

<!-- NAV -->
<nav class="lp-nav">
  <div class="lp-nav-inner">
    <a class="lp-logo" href="#">
      <div class="lp-logo-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
      Learnify
    </a>
    <div class="lp-nav-links">
      <button class="theme-toggle-btn" onclick="toggleTheme()" style="margin-right:4px">🌙</button>
      <a href="#features"    class="lp-link">Features</a>
      <a href="#how-it-works" class="lp-link">How it Works</a>
      <a href="#pricing"     class="lp-link">Pricing</a>
      <a href="${pageContext.request.contextPath}/login"    class="lp-btn-login">Login</a>
      <a href="${pageContext.request.contextPath}/register" class="lp-btn-cta">Get Started</a>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="hero">
  <div class="hero-inner">
    <div class="hero-tag"><span class="hero-dot"></span> AI-Powered Learning</div>
    <h1>Study <span>Smarter</span>,<br>Not Harder.</h1>
    <p>Turn your notes into summaries, flashcards and quizzes in seconds. Powered by Gemini AI.</p>
    <div class="hero-btns">
      <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">Get Started Free</a>
      <a href="#how-it-works" class="btn btn-secondary btn-lg">See How It Works</a>
    </div>
  </div>

  <!-- Mock window -->
  <div class="mock-window">
    <div class="mw-bar">
      <span class="mw-dot" style="background:#ff5f56"></span>
      <span class="mw-dot" style="background:#ffbd2e"></span>
      <span class="mw-dot" style="background:#27c93f"></span>
      <span class="mw-title">learnify — Dashboard</span>
    </div>
    <div class="mw-body">
      <div class="mw-upload">
        <div class="mw-upload-icon">📂</div>
        <div class="mw-upload-txt">Drop your PDF or TXT file here</div>
      </div>
      <div class="mw-file">
        <div class="mw-file-left">
          <span class="mw-ext mw-ext-pdf">PDF</span>
          <span class="mw-fname">Organic_Chemistry_Ch4.pdf</span>
        </div>
        <div class="mw-btns">
          <span class="mw-btn">📄 Summary</span>
          <span class="mw-btn">🃏 Flashcards</span>
          <span class="mw-btn">❓ Quiz</span>
        </div>
      </div>
      <div class="mw-file">
        <div class="mw-file-left">
          <span class="mw-ext mw-ext-txt">TXT</span>
          <span class="mw-fname">Lecture_Notes_Week3.txt</span>
        </div>
        <div class="mw-btns">
          <span class="mw-btn">📄 Summary</span>
          <span class="mw-btn">🃏 Flashcards</span>
          <span class="mw-btn">❓ Quiz</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section id="features" class="lp-section">
  <div class="lp-container">
    <div class="section-tag"><span class="section-chip">✦ Features</span></div>
    <h2 class="section-title">Everything you need to ace your exams</h2>
    <p class="section-sub">Upload once, get three powerful study tools automatically.</p>
    <div class="features-grid">
      <div class="feat-card">
        <div class="feat-icon feat-icon-green">📄</div>
        <h3>AI Summaries</h3>
        <p>Turn 20-page PDFs into clear bullet-point summaries. Get the key points fast.</p>
      </div>
      <div class="feat-card">
        <div class="feat-icon feat-icon-amber">🃏</div>
        <h3>Smart Flashcards</h3>
        <p>Auto-generated Q&A cards for active recall. Tap to flip, study at your own pace.</p>
      </div>
      <div class="feat-card">
        <div class="feat-icon feat-icon-purple">❓</div>
        <h3>Practice Quizzes</h3>
        <p>AI-generated MCQs from your material. Get instant feedback and track your score.</p>
      </div>
    </div>
  </div>
</section>

<!-- HOW IT WORKS -->
<section id="how-it-works" class="lp-section lp-section-gray">
  <div class="lp-container">
    <div class="section-tag"><span class="section-chip">✦ Process</span></div>
    <h2 class="section-title">Three simple steps</h2>
    <p class="section-sub">No setup, no configuration. Just upload and learn.</p>
    <div class="steps-grid">
      <div class="step-card">
        <div class="step-num">1</div>
        <h3>Upload Your Notes</h3>
        <p>Drag and drop your PDF or TXT file. Supports lecture notes, textbooks and study guides.</p>
      </div>
      <div class="step-card">
        <div class="step-num">2</div>
        <h3>AI Processes It</h3>
        <p>Gemini AI reads your content and identifies key concepts, definitions and topics.</p>
      </div>
      <div class="step-card">
        <div class="step-num">3</div>
        <h3>Start Learning</h3>
        <p>Get summaries, flashcards and quizzes instantly made from your own material.</p>
      </div>
    </div>
  </div>
</section>


<!-- FAQ -->
<section class="lp-section lp-section-gray">
  <div class="lp-container">
    <div class="section-tag"><span class="section-chip">✦ FAQ</span></div>
    <h2 class="section-title">Common questions</h2>
    <div class="faq-wrap">
      <div class="faq-item">
        <button class="faq-q" onclick="toggleFaq(this)">Is it really free? <span class="faq-icon">+</span></button>
        <div class="faq-a">Yes! The free plan is free forever with 5 uploads per month. No credit card required.</div>
      </div>
      <div class="faq-item">
        <button class="faq-q" onclick="toggleFaq(this)">What file types are supported? <span class="faq-icon">+</span></button>
        <div class="faq-a">We support PDF, TXT, JPG, PNG and WEBP files. More formats coming soon.</div>
      </div>
      <div class="faq-item">
        <button class="faq-q" onclick="toggleFaq(this)">How accurate is the AI? <span class="faq-icon">+</span></button>
        <div class="faq-a">Learnify uses Gemini AI which produces highly accurate results. Best results with clear, well-formatted documents.</div>
      </div>
      <div class="faq-item">
        <button class="faq-q" onclick="toggleFaq(this)">Is my data safe? <span class="faq-icon">+</span></button>
        <div class="faq-a">All uploaded files are stored securely and only used to generate your study materials. We never share your content.</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cta-section">
  <h2>Ready to study smarter?</h2>
  <p>Join thousands of students already using Learnify.</p>
  <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">Create Free Account</a>
</section>

<!-- FOOTER -->
<footer class="lp-footer">
  <div class="footer-inner">
    <div class="footer-logo">
      <svg width="18" height="18" viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="#16a34a"/></svg>
      Learnify
    </div>
    <div class="footer-links">
      <a href="#">Privacy</a>
      <a href="#">Terms</a>
      <a href="#">Contact</a>
    </div>
    <div class="footer-copy">&copy; 2025 Learnify. All rights reserved.</div>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
<script>
function toggleFaq(btn) {
  var answer = btn.nextElementSibling;
  var isOpen = btn.classList.contains('open');
  document.querySelectorAll('.faq-q').forEach(function(b) {
    b.classList.remove('open');
    b.nextElementSibling.classList.remove('open');
  });
  if (!isOpen) {
    btn.classList.add('open');
    answer.classList.add('open');
  }
}
</script>
</body>
</html>
