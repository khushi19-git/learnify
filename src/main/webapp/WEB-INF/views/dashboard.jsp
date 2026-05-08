<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.learnify.entity.StudyFile,com.learnify.entity.History,com.learnify.entity.User,java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var t=localStorage.getItem('lf_theme')||'light';document.documentElement.setAttribute('data-theme',t);})()</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — Learnify</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<%
  User u       = (User) session.getAttribute("user");
  String uName = u != null ? u.getName() : "User";
  String uIni  = uName.length() >= 2 ? uName.substring(0,2).toUpperCase() : uName.toUpperCase();
  List<StudyFile> files   = (List<StudyFile>) request.getAttribute("files");
  List<History>   history = (List<History>)   request.getAttribute("history");
  int fileCount = files   != null ? files.size()   : 0;
  int histCount = history != null ? history.size() : 0;
%>
<body class="app-layout">

<!-- LOADER -->
<div id="pageLoader"><div class="loader-spin"></div><p id="loaderMsg">Loading...</p></div>

<!-- NAV -->
<nav class="app-nav">
  <div class="app-nav-inner">
    <div class="app-logo">
      <div class="al-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
      Learnify
    </div>
    <div class="app-nav-right">
      <button class="theme-toggle-btn" onclick="toggleTheme()">🌙</button>
      <div class="user-chip">
        <div class="uc-av"><%= uIni %></div>
        <span class="uc-name"><%= uName %></span>
      </div>
      <% if (u != null && u.isAdmin()) { %>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary btn-sm">⚙️ Admin</a>
      <% } %>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Logout</a>
    </div>
  </div>
</nav>

<div class="app-body">

  <!-- SIDEBAR -->
  <aside class="app-sidebar">
    <span class="sidebar-section">Main</span>
    <a class="sidebar-link active" href="${pageContext.request.contextPath}/dashboard">
      <svg viewBox="0 0 16 16" fill="none"><rect x="1" y="1" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="1" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/><rect x="1" y="9" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/><rect x="9" y="9" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/></svg>
      Dashboard
    </a>
    <% if (u != null && u.isAdmin()) { %>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin">
      <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M2 14c0-3 2.7-5 6-5s6 2 6 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
      Admin Panel
    </a>
    <% } %>

    <% if (files != null && !files.isEmpty()) {
         StudyFile first = files.get(0); %>
    <span class="sidebar-section">AI Tools</span>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/summary/<%= first.getId() %>" onclick="showLoader('Generating summary...')">
      <svg viewBox="0 0 16 16" fill="none"><path d="M3 2h7l3 3v9a1 1 0 01-1 1H3a1 1 0 01-1-1V3a1 1 0 011-1z" stroke="currentColor" stroke-width="1.3"/><path d="M5 6h6M5 9h4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
      Summary
    </a>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/flashcards/<%= first.getId() %>" onclick="showLoader('Loading flashcards...')">
      <svg viewBox="0 0 16 16" fill="none"><rect x="1" y="3" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.3"/><path d="M5 8h6" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
      Flashcards
    </a>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/quiz/<%= first.getId() %>" onclick="showLoader('Loading quiz...')">
      <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.3"/><path d="M6.5 6a1.5 1.5 0 013 .5c0 1-1.5 1.5-1.5 2.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><circle cx="8" cy="11.5" r=".5" fill="currentColor"/></svg>
      Quiz
    </a>
    <% } %>

    <div class="sidebar-spacer"></div>
    <hr class="sidebar-divider">
    <a class="sidebar-link danger" href="${pageContext.request.contextPath}/logout">
      <svg viewBox="0 0 16 16" fill="none"><path d="M10 3l4 4-4 4M14 7H6" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/><path d="M6 2H3a1 1 0 00-1 1v10a1 1 0 001 1h3" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
      Logout
    </a>
  </aside>

  <!-- MAIN -->
  <main class="app-main">

    <!-- ALERTS -->
    <% String msg = request.getParameter("msg");
       if ("uploaded".equals(msg)) { %><div class="alert alert-success">✓ File uploaded successfully.</div>
    <% } else if ("deleted".equals(msg)) { %><div class="alert alert-success">✓ File deleted.</div>
    <% } else if ("error".equals(msg)) { %><div class="alert alert-error">✕ Upload failed. Please try again.</div>
    <% } else if ("wrongType".equals(msg)) { %><div class="alert alert-error">✕ Unsupported file type.</div>
    <% } else if ("noaccess".equals(msg)) { %><div class="alert alert-error">✕ Admin access required.</div>
    <% } %>

    <!-- WELCOME -->
    <div class="welcome-banner">
      <div class="wb-title">👋 Hello, <%= uName %>!</div>
      <div class="wb-sub">Upload a file to generate AI summaries, flashcards and quizzes.</div>
    </div>

    <!-- STATS -->
    <div class="stat-row-grid">
      <div class="stat-card2">
        <div class="sc-label">📁 Files</div>
        <div class="sc-val"><%= fileCount %></div>
        <div class="sc-sub">Uploaded files</div>
      </div>
      <div class="stat-card2">
        <div class="sc-label">⚡ Activity</div>
        <div class="sc-val"><%= histCount %></div>
        <div class="sc-sub">AI sessions</div>
      </div>
      <div class="stat-card2">
        <div class="sc-label">🎓 Role</div>
        <div class="sc-val" style="font-size:16px;padding-top:6px"><%= u != null && u.isAdmin() ? "Admin" : "Student" %></div>
        <div class="sc-sub" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%= u != null ? u.getEmail() : "" %></div>
      </div>
    </div>

    <!-- UPLOAD -->
    <div class="section-card2">
      <div class="sc-head">
        <div class="sc-head-title">
          <svg viewBox="0 0 16 16" fill="none"><path d="M8 2v8M5 5l3-3 3 3" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/><path d="M2 12v1a1 1 0 001 1h10a1 1 0 001-1v-1" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
          Upload File
        </div>
        <span class="sc-head-badge">PDF · TXT · JPG · PNG</span>
      </div>
      <div class="sc-body">
        <form id="uploadForm" action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
          <div class="upload-zone" onclick="document.getElementById('fileInput').click()" id="dropZone">
            <div class="uz-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"><path d="M12 15V3m0 0l-4 4m4-4l4 4"/><path d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2"/></svg>
            </div>
            <div class="uz-title" id="dropLabel">Click to browse or drag a file here</div>
            <div class="uz-sub">PDF, TXT, JPG, PNG, WEBP supported</div>
            <input type="file" id="fileInput" name="file" class="file-input-hidden"
                   accept=".pdf,.txt,.jpg,.jpeg,.png,.webp" onchange="onFileSelect(this)">
          </div>
          <div id="fileBar" style="display:none;margin-top:10px;padding:10px 14px;background:var(--bg2);border:1px solid var(--border);border-radius:var(--radius);display:none;align-items:center;justify-content:space-between;gap:10px">
            <span id="fileBarName" style="font-size:13px;font-weight:500;color:var(--text)"></span>
            <button type="submit" class="btn btn-primary btn-sm" onclick="showLoader('Uploading...')">Upload</button>
          </div>
        </form>
      </div>
    </div>

    <!-- FILES -->
    <div class="section-card2">
      <div class="sc-head">
        <div class="sc-head-title">
          <svg viewBox="0 0 16 16" fill="none"><path d="M3 2h7l3 3v9a1 1 0 01-1 1H3a1 1 0 01-1-1V3a1 1 0 011-1z" stroke="currentColor" stroke-width="1.3"/></svg>
          My Files
        </div>
        <span class="sc-head-badge"><%= fileCount %> file<%= fileCount != 1 ? "s" : "" %></span>
      </div>

      <% if (files == null || files.isEmpty()) { %>
        <div class="empty-state2"><div class="es-icon">📂</div><p>No files yet. Upload one above!</p></div>
      <% } else { %>
        <div style="overflow-x:auto">
          <table class="files-table">
            <thead>
              <tr><th>#</th><th>File</th><th>Uploaded</th><th>AI Tools</th><th></th></tr>
            </thead>
            <tbody>
              <% int n=1; for (StudyFile sf : files) {
                   String fn = sf.getFileName() != null ? sf.getFileName().toLowerCase() : "";
                   String ext = fn.endsWith(".pdf") ? "PDF" : fn.endsWith(".txt") ? "TXT"
                     : fn.matches(".*\\.(jpg|jpeg|png|webp)") ? "IMG" : "FILE";
                   String extCls = "pdf".equals(ext.toLowerCase()) ? "ext-pdf"
                     : "txt".equals(ext.toLowerCase()) ? "ext-txt" : "ext-img";
              %>
              <tr>
                <td class="row-num"><%= String.format("%02d",n++) %></td>
                <td>
                  <div class="file-icon-wrap">
                    <span class="ext-tag <%= extCls %>"><%= ext %></span>
                    <span class="file-name"><%= sf.getFileName() %></span>
                  </div>
                </td>
                <td class="date-cell"><%= sf.getUploadDate()!=null?sf.getUploadDate().toString().replace("T"," ").substring(0,16):"—" %></td>
                <td>
                  <div class="ai-actions">
                    <a class="btn-tool" href="${pageContext.request.contextPath}/summary/<%= sf.getId() %>"    onclick="showLoader('Generating summary...')">📄 Summary</a>
                    <a class="btn-tool" href="${pageContext.request.contextPath}/flashcards/<%= sf.getId() %>" onclick="showLoader('Loading flashcards...')">🃏 Flashcards</a>
                    <a class="btn-tool" href="${pageContext.request.contextPath}/quiz/<%= sf.getId() %>"       onclick="showLoader('Loading quiz...')">❓ Quiz</a>
                  </div>
                </td>
                <td>
                  <a class="btn-del" href="${pageContext.request.contextPath}/delete/<%= sf.getId() %>"
                     title="Delete" onclick="return confirm('Delete <%= sf.getFileName() %>?')">
                    <svg viewBox="0 0 16 16" fill="none"><path d="M3 4h10M6 4V2h4v2M5 4v9a1 1 0 001 1h4a1 1 0 001-1V4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
                  </a>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

    <!-- ACTIVITY -->
    <% if (history != null && !history.isEmpty()) { %>
    <div class="section-card2">
      <div class="sc-head">
        <div class="sc-head-title">
          <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.3"/><path d="M8 5v3.5l2 1.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
          Activity Log
        </div>
        <span class="sc-head-badge"><%= histCount %> entries</span>
      </div>
      <div class="sc-body">
        <% for (History h : history) {
             String act = h.getActivity() != null ? h.getActivity() : "";
             String icon = act.toLowerCase().contains("upload") ? "📤"
               : act.toLowerCase().contains("summary")   ? "📄"
               : act.toLowerCase().contains("flashcard") ? "🃏"
               : act.toLowerCase().contains("quiz")      ? "❓"
               : act.toLowerCase().contains("login")     ? "🔐"
               : act.toLowerCase().contains("delete")    ? "🗑️" : "📌";
             String timeStr = h.getActivityDate()!=null
               ? h.getActivityDate().toString().replace("T"," ").substring(0,16) : "";
        %>
          <div class="activity-row">
            <div class="activity-icon-wrap"><%= icon %></div>
            <div class="activity-content">
              <div class="activity-text"><%= act %></div>
              <div class="activity-time"><%= timeStr %></div>
            </div>
          </div>
        <% } %>
      </div>
    </div>
    <% } %>

  </main>
</div>

<footer class="app-footer">&copy; 2025 <span>Learnify</span></footer>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
<script>
function onFileSelect(input) {
  if (!input.files || !input.files[0]) return;
  document.getElementById('fileBarName').textContent = input.files[0].name;
  var bar = document.getElementById('fileBar');
  bar.style.display = 'flex';
  document.getElementById('dropLabel').textContent = 'File selected ✓';
}
// Drag & drop
var dz = document.getElementById('dropZone');
dz.addEventListener('dragover',  function(e){ e.preventDefault(); dz.style.borderColor='var(--accent)'; });
dz.addEventListener('dragleave', function(){ dz.style.borderColor=''; });
dz.addEventListener('drop', function(e){
  e.preventDefault(); dz.style.borderColor='';
  var fi = document.getElementById('fileInput');
  fi.files = e.dataTransfer.files; onFileSelect(fi);
});
</script>
</body>
</html>
