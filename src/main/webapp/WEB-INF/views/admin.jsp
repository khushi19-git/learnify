<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.learnify.entity.User,com.learnify.entity.StudyFile,java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <script>(function(){var t=localStorage.getItem('lf_theme')||'light';document.documentElement.setAttribute('data-theme',t);})()</script>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Admin Panel — Learnify</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<%
  User admin    = (User) session.getAttribute("user");
  String aName  = admin != null ? admin.getName() : "Admin";
  String aIni   = aName.length() >= 2 ? aName.substring(0,2).toUpperCase() : aName.toUpperCase();
  int    aId    = admin != null ? admin.getId() : -1;
  Long totalUsers    = (Long) request.getAttribute("totalUsers");
  Long totalFiles    = (Long) request.getAttribute("totalFiles");
  Long verifiedUsers = (Long) request.getAttribute("verifiedUsers");
  List<User>      allUsers = (List<User>)      request.getAttribute("allUsers");
  List<StudyFile> allFiles = (List<StudyFile>) request.getAttribute("allFiles");
  long unverified = (totalUsers!=null && verifiedUsers!=null) ? totalUsers - verifiedUsers : 0;
%>
<body class="app-layout">

<div id="pageLoader"><div class="loader-spin"></div><p id="loaderMsg">Loading...</p></div>

<!-- NAV -->
<nav class="app-nav">
  <div class="app-nav-inner">
    <div class="app-logo">
      <div class="al-icon"><svg viewBox="0 0 16 16" fill="none"><path d="M8 2L13.5 5.25V10.75L8 14L2.5 10.75V5.25L8 2Z" fill="white"/></svg></div>
      Learnify
      <span style="font-size:10px;font-weight:700;background:#fef9c3;color:#a16207;border:1px solid #fde68a;padding:2px 8px;border-radius:20px;margin-left:6px">ADMIN</span>
    </div>
    <div class="app-nav-right">
      <button class="theme-toggle-btn" onclick="toggleTheme()">🌙</button>
      <div class="user-chip">
        <div class="uc-av"><%= aIni %></div>
        <span class="uc-name"><%= aName %></span>
      </div>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary btn-sm">← Dashboard</a>
      <a href="${pageContext.request.contextPath}/logout"    class="btn btn-ghost btn-sm">Logout</a>
    </div>
  </div>
</nav>

<div class="app-body">

  <!-- SIDEBAR -->
  <aside class="app-sidebar">
    <span class="sidebar-section">Navigation</span>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/dashboard">
      <svg viewBox="0 0 16 16" fill="none"><rect x="1" y="1" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="1" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/><rect x="1" y="9" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/><rect x="9" y="9" width="6" height="6" rx="1" stroke="currentColor" stroke-width="1.3" opacity=".4"/></svg>
      Dashboard
    </a>
    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin">
      <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M2 14c0-3 2.7-5 6-5s6 2 6 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>
      Admin Panel
    </a>
    <span class="sidebar-section" style="margin-top:12px">Stats</span>
    <div style="padding:0 14px;font-size:12.5px;color:var(--text2);display:flex;flex-direction:column;gap:7px">
      <div style="display:flex;justify-content:space-between"><span>Users</span><strong style="color:var(--accent)"><%= totalUsers!=null?totalUsers:0 %></strong></div>
      <div style="display:flex;justify-content:space-between"><span>Files</span><strong style="color:var(--accent)"><%= totalFiles!=null?totalFiles:0 %></strong></div>
      <div style="display:flex;justify-content:space-between"><span>Verified</span><strong style="color:var(--accent)"><%= verifiedUsers!=null?verifiedUsers:0 %></strong></div>
    </div>
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
       if ("userDeleted".equals(msg))   { %><div class="alert alert-success">✓ User deleted.</div><%
       } else if ("fileDeleted".equals(msg)) { %><div class="alert alert-success">✓ File deleted.</div><%
       } else if ("cannotDeleteSelf".equals(msg)) { %><div class="alert alert-error">✕ Cannot delete your own account.</div><%
       } %>

    <!-- BANNER -->
    <div class="welcome-banner">
      <div class="wb-title">⚙️ Admin Panel</div>
      <div class="wb-sub">Manage all users and uploaded files on the platform.</div>
    </div>

    <!-- STATS -->
    <div class="admin-stats-row">
      <div class="admin-stat"><div class="as-icon">👥</div><div class="as-val"><%= totalUsers!=null?totalUsers:0 %></div><div class="as-label">Total Users</div></div>
      <div class="admin-stat"><div class="as-icon">✅</div><div class="as-val"><%= verifiedUsers!=null?verifiedUsers:0 %></div><div class="as-label">Verified</div></div>
      <div class="admin-stat"><div class="as-icon">⏳</div><div class="as-val"><%= unverified %></div><div class="as-label">Unverified</div></div>
      <div class="admin-stat"><div class="as-icon">📁</div><div class="as-val"><%= totalFiles!=null?totalFiles:0 %></div><div class="as-label">Total Files</div></div>
    </div>

    <!-- USERS TABLE -->
    <div class="admin-table-card">
      <div class="atc-head">
        <span class="atc-title">👥 All Users</span>
        <input class="tbl-search" type="text" placeholder="Search users..." oninput="filterTable('usersTable',this.value)">
      </div>
      <% if (allUsers == null || allUsers.isEmpty()) { %>
        <div class="empty-state2"><div class="es-icon">👥</div><p>No users found.</p></div>
      <% } else { %>
      <div style="overflow-x:auto">
        <table class="admin-table" id="usersTable">
          <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Role</th><th>Verified</th><th>Joined</th><th>Action</th></tr></thead>
          <tbody>
            <% int i=1; for (User usr : allUsers) {
                 String ini = usr.getName().length()>=2 ? usr.getName().substring(0,2).toUpperCase() : usr.getName().toUpperCase(); %>
            <tr>
              <td class="row-num"><%= String.format("%02d",i++) %></td>
              <td><div class="user-cell"><div class="user-av"><%= ini %></div><strong style="font-size:13.5px"><%= usr.getName() %></strong></div></td>
              <td style="font-size:12.5px;color:var(--text2)"><%= usr.getEmail() %></td>
              <td><span class="<%= usr.isAdmin() ? "badge-admin" : "badge-user" %>"><%= usr.getRole() %></span></td>
              <td style="font-size:13px;color:<%= usr.getVerified()==1?"var(--green)":"var(--text3)" %>">
                <%= usr.getVerified()==1 ? "✓ Yes" : "✗ No" %>
              </td>
              <td class="date-cell"><%= usr.getCreatedAt()!=null?usr.getCreatedAt().toString().replace("T"," ").substring(0,10):"—" %></td>
              <td>
                <% if (usr.getId() != aId) { %>
                  <a href="${pageContext.request.contextPath}/admin/delete-user/<%= usr.getId() %>"
                     class="btn btn-danger btn-sm"
                     onclick="return confirm('Delete <%= usr.getName() %>? This removes all their data.')">Delete</a>
                <% } else { %>
                  <span style="font-size:11px;color:var(--text3)">You</span>
                <% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% } %>
    </div>

    <!-- FILES TABLE -->
    <div class="admin-table-card">
      <div class="atc-head">
        <span class="atc-title">📁 All Files</span>
        <input class="tbl-search" type="text" placeholder="Search files..." oninput="filterTable('filesTable',this.value)">
      </div>
      <% if (allFiles == null || allFiles.isEmpty()) { %>
        <div class="empty-state2"><div class="es-icon">📁</div><p>No files uploaded yet.</p></div>
      <% } else { %>
      <div style="overflow-x:auto">
        <table class="admin-table" id="filesTable">
          <thead><tr><th>#</th><th>File Name</th><th>Owner</th><th>Date</th><th>Action</th></tr></thead>
          <tbody>
            <% int j=1; for (StudyFile sf : allFiles) {
                 String fn = sf.getFileName()!=null?sf.getFileName().toLowerCase():"";
                 String ext2 = fn.endsWith(".pdf")?"PDF":fn.endsWith(".txt")?"TXT":fn.matches(".*\\.(jpg|jpeg|png|webp)")?"IMG":"FILE";
                 String ec2  = "PDF".equals(ext2)?"ext-pdf":"TXT".equals(ext2)?"ext-txt":"ext-img";
            %>
            <tr>
              <td class="row-num"><%= String.format("%02d",j++) %></td>
              <td><div class="file-icon-wrap"><span class="ext-tag <%= ec2 %>"><%= ext2 %></span><span class="file-name"><%= sf.getFileName() %></span></div></td>
              <td style="font-size:13px;color:var(--text2)"><%= sf.getUser()!=null?sf.getUser().getName():"Unknown" %></td>
              <td class="date-cell"><%= sf.getUploadDate()!=null?sf.getUploadDate().toString().replace("T"," ").substring(0,16):"—" %></td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/delete-file/<%= sf.getId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this file?')">Delete</a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% } %>
    </div>

  </main>
</div>

<footer class="app-footer">&copy; 2025 <span>Learnify</span> — Admin</footer>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
<script>
function filterTable(id, q) {
  q = q.toLowerCase();
  document.getElementById(id).querySelectorAll('tbody tr').forEach(function(r) {
    r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
}
</script>
</body>
</html>
