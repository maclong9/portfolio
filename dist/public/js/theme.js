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

// Mobile menu functions (class-based for smooth transitions)
// Define immediately so inline onclick handlers can use them
window.toggleSlideMenu = function(containerId) {
  const container = document.getElementById(containerId);
  const overlay = document.querySelector('#mobile-menu-overlay');
  if (!container || !overlay) return;

  const isOpen = container.dataset.mobileMenuOpen === 'true';
  if (isOpen) {
    // Close menu: remove active class, then hide after animation
    overlay.classList.remove('active');
    setTimeout(() => {
      overlay.classList.add('hidden');
    }, 400); // match jelly animation duration
    container.dataset.mobileMenuOpen = 'false';
    overlay.dataset.mobileMenu = 'closed';
  } else {
    // Open menu: show with jelly animation
    overlay.classList.remove('hidden');
    overlay.classList.add('active');
    container.dataset.mobileMenuOpen = 'true';
    overlay.dataset.mobileMenu = 'open';
  }
};

window.closeSlideMenu = function(containerId) {
  const container = document.getElementById(containerId);
  const overlay = document.querySelector('#mobile-menu-overlay');
  if (!container || !overlay) return;

  overlay.classList.remove('active');
  overlay.classList.add('hidden');
  container.dataset.mobileMenuOpen = 'false';
  overlay.dataset.mobileMenu = 'closed';
};

// Like functionality for posts
window.handleLike = async function() {
  try {
    // Extract post slug from URL path
    const pathParts = window.location.pathname.split('/').filter(Boolean);
    const postSlug = pathParts[pathParts.length - 1].replace('.html', '');

    if (!postSlug) {
      console.error('Could not determine post slug');
      return;
    }

    // Check if user has already liked this post
    const likedPosts = JSON.parse(localStorage.getItem('likedPosts') || '[]');
    const hasLiked = likedPosts.includes(postSlug);
    const action = hasLiked ? 'unlike' : 'like';

    // Make API request to toggle like
    const response = await fetch(`/api/likes/${postSlug}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ action })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    // Update localStorage
    if (action === 'like') {
      likedPosts.push(postSlug);
    } else {
      const index = likedPosts.indexOf(postSlug);
      if (index > -1) {
        likedPosts.splice(index, 1);
      }
    }
    localStorage.setItem('likedPosts', JSON.stringify(likedPosts));

    // Update UI
    const likeButton = document.querySelector('[data-like-button]');
    const likeIcon = document.querySelector('[data-like-icon]');
    const likeCount = document.querySelector('[data-like-count]');

    if (likeIcon) {
      if (action === 'like') {
        likeIcon.classList.add('fill-red-500', 'text-red-500');
      } else {
        likeIcon.classList.remove('fill-red-500', 'text-red-500');
      }
    }

    if (likeCount) {
      likeCount.textContent = data.likes;
    }
  } catch (error) {
    console.error('Failed to toggle like:', error);
  }
};

// Initialize like button state on page load
window.initializeLikeButton = function() {
  const pathParts = window.location.pathname.split('/').filter(Boolean);
  const postSlug = pathParts[pathParts.length - 1].replace('.html', '');

  if (!postSlug) return;

  // Check if user has liked this post
  const likedPosts = JSON.parse(localStorage.getItem('likedPosts') || '[]');
  const hasLiked = likedPosts.includes(postSlug);

  // Update icon state
  const likeIcon = document.querySelector('[data-like-icon]');
  if (likeIcon && hasLiked) {
    likeIcon.classList.add('fill-red-500', 'text-red-500');
  }

  // Fetch and display current like count
  fetch(`/api/likes/${postSlug}`)
    .then(response => response.json())
    .then(data => {
      const likeCount = document.querySelector('[data-like-count]');
      if (likeCount) {
        likeCount.textContent = data.likes;
      }
    })
    .catch(error => console.error('Failed to fetch like count:', error));
};

// Set up event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  // Initialize like button if on a post page
  if (window.initializeLikeButton) {
    window.initializeLikeButton();
  }

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

  // Close menu when clicking outside of it
  document.addEventListener('click', function(e) {
    const container = document.getElementById('mobile-menu-container');
    const overlay = document.querySelector('#mobile-menu-overlay');
    const button = document.getElementById('mobile-menu-button');
    if (!container || !overlay) return;

    const isOpen = container.dataset.mobileMenuOpen === 'true';
    // Check if click is outside overlay and not on the button
    const clickedOutside = !overlay.contains(e.target) && !button.contains(e.target);

    if (isOpen && clickedOutside) {
      window.closeSlideMenu('mobile-menu-container');
    }
  });
});