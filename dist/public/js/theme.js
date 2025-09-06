// Prevent FOUC by setting theme immediately
(function () {
  const savedTheme = localStorage.getItem('theme') || 'system';
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

  let actualTheme = 'light';
  if (savedTheme === 'dark') {
    actualTheme = 'dark';
  } else if (savedTheme === 'system') {
    actualTheme = systemPrefersDark ? 'dark' : 'light';
  }

  document.documentElement.setAttribute('data-theme', actualTheme);
})();