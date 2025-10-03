import Foundation
import WebUI

/// Masonry-style card layout: first card full width, next 2 half width, then 3 per row
public struct MasonryCardLayout: Element {
  let cards: [Card]

  public init(cards: [Card]) {
    self.cards = cards
  }

  public var body: some Markup {
    Stack(classes: ["space-y-8", "group/masonry"]) {
      // First card: full width
      if cards.count > 0 {
        Stack(classes: ["mb-4"]) {
          cards[0]
        }
      }

      // Next 2 cards: half width
      if cards.count > 1 {
        Stack(classes: ["grid", "md:grid-cols-2", "gap-8", "group/masonry", "masonry-medium"]) {
          if cards.count > 1 {
            cards[1]
          }
          if cards.count > 2 {
            cards[2]
          }
        }
      }

      // Remaining cards: 3 per row, smaller size
      if cards.count > 3 {
        Stack(classes: ["grid", "md:grid-cols-3", "gap-6", "group/masonry", "masonry-small"]) {
          for card in cards.dropFirst(3) {
            card
          }
        }
      }

      // Combined animations script
      Script(
        placement: .body,
        content: {
          """
          // Card scroll animations
          (function() {
              if (window.cardAnimationsInitialized) return;
              window.cardAnimationsInitialized = true;

              // Check for prefers-reduced-motion
              const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

              if (prefersReducedMotion) {
                  // Skip animations if user prefers reduced motion
                  const cards = document.querySelectorAll('.reveal-card');
                  cards.forEach(card => {
                      card.classList.add('in-view');
                      card.style.opacity = '1';
                      card.style.transform = 'none';
                  });
                  return;
              }

              let lastScrollTop = 0;
              let scrollVelocity = 0;
              let isScrollingFast = false;
              let scrollTimeout;

              window.addEventListener('scroll', () => {
                  const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop;
                  scrollVelocity = Math.abs(currentScrollTop - lastScrollTop);
                  lastScrollTop = currentScrollTop;
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
                          if (isScrollingFast || scrollVelocity > 50) {
                              card.style.transition = 'opacity 0.15s ease-out, transform 0.15s ease-out';
                              card.style.transitionDelay = '0s';
                          } else if (scrollVelocity > 15) {
                              card.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out';
                              const baseDelay = parseFloat(card.dataset.originalDelay || '0');
                              card.style.transitionDelay = `${baseDelay * 0.5}s`;
                          }
                          card.classList.add('in-view');
                      }
                  });
              }, observerOptions);

              const cards = document.querySelectorAll('.reveal-card');
              cards.forEach((card, index) => {
                  const originalDelay = index * 0.1;
                  card.style.transitionDelay = `${originalDelay}s`;
                  card.dataset.originalDelay = originalDelay.toString();
                  observer.observe(card);
              });
          })();

          // Animated photo stack
          (function() {
              if (window.photoStackInitialized) return;
              window.photoStackInitialized = true;

              // Random number between min and max
              function random(min, max) {
                  return Math.random() * (max - min) + min;
              }

              // Initialize all photo stacks
              function initPhotoStacks() {
                  const stacks = document.querySelectorAll('[data-photo-stack]');

                  stacks.forEach(stack => {
                      const photos = stack.querySelectorAll('.photo-stack-item');
                      if (photos.length === 0) return;

                      // Initialize positions with random rotations
                      // Use smaller angles for wider photos (w-64)
                      const isWidePhoto = photos[0].offsetWidth > 150;
                      const maxRotation = isWidePhoto ? 8 : 15;

                      photos.forEach((photo, index) => {
                          const rotation = random(-maxRotation, maxRotation);
                          const zIndex = photos.length - index;

                          photo.style.zIndex = zIndex;
                          photo.style.transform = `rotate(${rotation}deg) translateY(${index * 2}px)`;
                      });

                      // Start animation cycle
                      let currentIndex = 0;

                      setInterval(() => {
                          const topPhoto = photos[currentIndex % photos.length];
                          const nextIndex = (currentIndex + 1) % photos.length;

                          // Random direction: left or right
                          const direction = Math.random() > 0.5 ? 1 : -1;
                          const xOffset = direction * 200;

                          // Get current rotation from the top photo
                          const currentRotation = parseFloat(topPhoto.style.transform.match(/rotate\\(([^)]+)\\)/)?.[1] || 0);

                          // Animate top photo swiping away
                          topPhoto.style.transition = 'transform 0.7175s ease-out, opacity 0.7175s ease-out';
                          topPhoto.style.transform = `translateX(${xOffset}px) rotate(${currentRotation * 1.5}deg)`;
                          topPhoto.style.opacity = '0';

                          // After swipe animation completes, reset and fade in at back
                          setTimeout(() => {
                              // Prepare the new rotation for the back
                              const rotation = random(-maxRotation, maxRotation);

                              // Update z-indices so the swiped photo will appear at the back
                              photos.forEach((photo, index) => {
                                  const adjustedIndex = (index - nextIndex + photos.length) % photos.length;
                                  photo.style.zIndex = photos.length - adjustedIndex;
                              });

                              // Move swiped photo to back position instantly (no transition)
                              topPhoto.style.transition = 'none';
                              topPhoto.style.zIndex = '1';
                              topPhoto.style.transform = `rotate(${rotation}deg) translateY(${(photos.length - 1) * 2}px)`;
                              topPhoto.style.opacity = '0';

                              // Force reflow
                              topPhoto.offsetHeight;

                              // Fade in at the back
                              topPhoto.style.transition = 'opacity 0.7175s ease-in';
                              topPhoto.style.opacity = '1';
                          }, 718); // Start halfway through the swipe

                          currentIndex = nextIndex;
                      }, 1538);
                  });
              }

              // Wait for images to load
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', initPhotoStacks);
              } else {
                  initPhotoStacks();
              }
          })();
          """
        }
      )
    }
  }
}
