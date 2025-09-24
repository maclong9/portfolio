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

// Mobile menu functions
window.toggleSlideMenu = function(containerId) {
  const container = document.getElementById(containerId);
  const overlay = document.querySelector('#mobile-menu-overlay');
  
  if (!container || !overlay) return;
  
  const isOpen = container.dataset.mobileMenuOpen === 'true';
  
  if (isOpen) {
    // Close menu
    overlay.style.transform = 'translateX(100%)';
    setTimeout(() => {
      overlay.classList.add('hidden');
    }, 300);
    container.dataset.mobileMenuOpen = 'false';
    overlay.dataset.mobileMenu = 'closed';
  } else {
    // Open menu
    overlay.classList.remove('hidden');
    setTimeout(() => {
      overlay.style.transform = 'translateX(0)';
    }, 10);
    container.dataset.mobileMenuOpen = 'true';
    overlay.dataset.mobileMenu = 'open';
  }
};

window.closeSlideMenu = function(containerId) {
  const container = document.getElementById(containerId);
  const overlay = document.querySelector('#mobile-menu-overlay');
  
  if (!container || !overlay) return;
  
  // Close menu
  overlay.style.transform = 'translateX(100%)';
  setTimeout(() => {
    overlay.classList.add('hidden');
  }, 300);
  container.dataset.mobileMenuOpen = 'false';
  overlay.dataset.mobileMenu = 'closed';
};

// Close menu when clicking on mobile menu links
document.addEventListener('click', function(e) {
  if (e.target.closest('[data-mobile-menu-link]')) {
    window.closeSlideMenu('mobile-menu-container');
  }
});

// Close menu button functionality
document.addEventListener('click', function(e) {
  if (e.target.closest('[data-slide-menu-close]')) {
    window.closeSlideMenu('mobile-menu-container');
  }
});