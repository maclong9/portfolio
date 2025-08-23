import Foundation
import WebUI

public struct CardCollection: Element {
  let cards: [Card]

  public var body: some Markup {
    Stack(classes: ["grid", "md:grid-cols-2", "gap-6", "max-w-4xl", "mx-auto", "auto-rows-min"]) {
      for card in cards { card }
      Script(
        placement: .body,
        content: {
          """
          // Card scroll animations - exact port from portfolio-archive
          (function() {
              // Skip if already initialized globally
              if (window.cardAnimationsInitialized) return;
              window.cardAnimationsInitialized = true;

              let lastScrollTop = 0;
              let scrollVelocity = 0;
              let isScrollingFast = false;
              let scrollTimeout;

              // Track scroll velocity
              window.addEventListener('scroll', () => {
                  const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop;
                  scrollVelocity = Math.abs(currentScrollTop - lastScrollTop);
                  lastScrollTop = currentScrollTop;

                  // Consider fast scrolling if velocity > 20px per frame
                  isScrollingFast = scrollVelocity > 20;

                  clearTimeout(scrollTimeout);
                  scrollTimeout = setTimeout(() => {
                      isScrollingFast = false;
                      scrollVelocity = 0;
                  }, 150);
              }, { passive: true });

              const observerOptions = {
                  threshold: 0.25,
                  rootMargin: '0px 0px 100px 0px'
              };

              const observer = new IntersectionObserver((entries) => {
                  entries.forEach((entry) => {
                      if (entry.isIntersecting) {
                          const card = entry.target;

                          // Apply dynamic animation based on scroll speed
                          if (isScrollingFast || scrollVelocity > 50) {
                              // Fast scroll: instant or very quick animation
                              card.style.transition = 'opacity 0.15s ease-out, transform 0.15s ease-out';
                              card.style.transitionDelay = '0s';
                          } else if (scrollVelocity > 15) {
                              // Medium scroll: faster animation
                              card.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out';
                              const baseDelay = parseFloat(card.dataset.originalDelay || '0');
                              card.style.transitionDelay = `${baseDelay * 0.5}s`;
                          }
                          // Slow scroll keeps original timing

                          card.classList.add('in-view');
                      }
                  });
              }, observerOptions);

              // Shared scroll animations utility - exactly like portfolio-archive
              function initCardScrollAnimations(gridSelectors = null) {
                  if (gridSelectors) {
                      let cardIndex = 0; // Global index across all grids for staggered animation
                      gridSelectors.forEach(selector => {
                          const grid = document.querySelector(selector);
                          if (grid && grid.children) {
                              Array.from(grid.children).forEach((card) => {
                                  if (!card.classList.contains('reveal-card')) {
                                      card.classList.add('reveal-card');
                                  }
                                  const originalDelay = cardIndex * 0.1;
                                  card.style.transitionDelay = `${originalDelay}s`;
                                  card.dataset.originalDelay = originalDelay.toString();
                                  observer.observe(card);
                                  cardIndex++;
                              });
                          }
                      });

                      // Also catch any existing .reveal-card elements not in the specified grids
                      const existingCards = document.querySelectorAll('.reveal-card');
                      existingCards.forEach((card) => {
                          if (!card.dataset.originalDelay) {
                              const originalDelay = cardIndex * 0.1;
                              card.style.transitionDelay = `${originalDelay}s`;
                              card.dataset.originalDelay = originalDelay.toString();
                              observer.observe(card);
                              cardIndex++;
                          }
                      });
                  } else {
                      // Default behavior: observe all existing .reveal-card elements
                      const cards = document.querySelectorAll('.reveal-card');
                      cards.forEach((card, index) => {
                          const originalDelay = index * 0.1;
                          card.style.transitionDelay = `${originalDelay}s`;
                          card.dataset.originalDelay = originalDelay.toString();
                          observer.observe(card);
                      });
                  }
              }

              // Make the utility globally available
              window.initCardScrollAnimations = initCardScrollAnimations;

              // Auto-initialize for current grid
              function initCurrentGrid() {
                  // Find the current grid (parent of this script)
                  const currentScript = document.currentScript || document.scripts[document.scripts.length - 1];
                  const currentGrid = currentScript.closest('.grid');
                  
                  if (currentGrid) {
                      // Give other scripts time to add their grids too
                      setTimeout(() => {
                          const allGrids = document.querySelectorAll('.grid');
                          const gridSelectors = Array.from(allGrids).map((grid, index) => {
                              if (!grid.id) grid.id = `auto-grid-${index}`;
                              return `#${grid.id}`;
                          });
                          initCardScrollAnimations(gridSelectors);
                      }, 200);
                  } else {
                      // Fallback to default behavior
                      setTimeout(() => initCardScrollAnimations(), 200);
                  }
              }

              // Initialize when DOM is ready
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', initCurrentGrid);
              } else {
                  initCurrentGrid();
              }
          })();
          """
        }
      )
    }
  }
}
