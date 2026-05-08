// Apply theme INSTANTLY before page renders (no flash)
(function() {
  var t = localStorage.getItem('lf_theme') || 'light';
  document.documentElement.setAttribute('data-theme', t);
})();

function toggleTheme() {
  var html  = document.documentElement;
  var curr  = html.getAttribute('data-theme') || 'light';
  var next  = curr === 'light' ? 'dark' : 'light';
  html.setAttribute('data-theme', next);
  localStorage.setItem('lf_theme', next);
  updateToggleBtn();
}

function updateToggleBtn() {
  var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
  document.querySelectorAll('.theme-toggle-btn').forEach(function(b) {
    b.textContent = isDark ? '☀️' : '🌙';
    b.title = isDark ? 'Switch to Light' : 'Switch to Dark';
  });
}

// Update icon once DOM is ready
document.addEventListener('DOMContentLoaded', updateToggleBtn);

// Expose globally so onclick="toggleTheme()" works
window.toggleTheme = toggleTheme;
window.learnifyTheme = { toggle: toggleTheme };

// showLoader helper used across pages
window.showLoader = function(msg) {
  var el = document.getElementById('pageLoader');
  if (el) { el.style.display = 'flex'; }
  var txt = document.getElementById('loaderMsg');
  if (txt) txt.textContent = msg || 'Loading...';
};
