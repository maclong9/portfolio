import WebUI

struct ParticleNetwork: Element {
  public var body: some Markup {
    Stack {
      Stack(classes: [
        "particle-bg", "overflow-hidden", "inset-0", "w-full", "h-full", "opacity-80",
        "absolute",
      ])
      Script(
        content: {
          """
          // Particle network animation - colocated with ParticleNetwork component
          (function() {
              function initParticleNetwork() {
                  const container = document.querySelector('.particle-bg');
                  if (!container) return;

                  // Clear existing animations
                  container.innerHTML = '';

                  // Add a slight delay to ensure container is properly sized
                  setTimeout(() => { createParticleNetwork(container); }, 100);
              }

              function createParticleNetwork(container) {
                  if (!container) return;

                  // Create SVG element for connected particle network
                  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
                  svg.style.cssText = `
                      position: absolute;
                      top: 0;
                      left: 0;
                      width: 100%;
                      height: 100%;
                      pointer-events: none;
                      z-index: -1;
                  `;

                  container.appendChild(svg);

                  // Create particles with positions
                  const particles = [];
                  const numParticles = 24;
                  let animationStartTime = Date.now();

                  // Create particles with better distribution
                  for (let i = 0; i < numParticles; i++) {
                      let x, y;

                      // Distribute particles across regions
                      if (i < numParticles * 0.25) {
                          x = 5 + Math.random() * 30;
                          y = 10 + Math.random() * 80;
                      } else if (i < numParticles * 0.5) {
                          x = 25 + Math.random() * 30;
                          y = 15 + Math.random() * 70;
                      } else if (i < numParticles * 0.75) {
                          x = 45 + Math.random() * 30;
                          y = 20 + Math.random() * 60;
                      } else {
                          x = 65 + Math.random() * 30;
                          y = 10 + Math.random() * 80;
                      }

                      const particle = {
                          x: x,
                          y: y,
                          baseX: x,
                          baseY: y,
                          vx: (Math.random() - 0.5) * 0.03,
                          vy: (Math.random() - 0.5) * 0.03,
                          size: Math.random() * 2 + 1.5,
                          driftSpeed: 0.008 + Math.random() * 0.012,
                          driftAngle: Math.random() * Math.PI * 2,
                          region: Math.floor(i / (numParticles / 4)),
                      };

                      particles.push(particle);

                      // Create visual particle
                      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                      circle.setAttribute('r', particle.size);
                      circle.setAttribute('fill', 'rgba(20, 184, 166, 0.5)');
                      circle.setAttribute('opacity', '0.6');
                      particle.element = circle;
                      svg.appendChild(circle);
                  }

                  // Animation function
                  const animate = () => {
                      const containerRect = container.getBoundingClientRect();
                      const width = containerRect.width;
                      const height = containerRect.height;
                      const currentTime = Date.now();
                      const elapsed = currentTime - animationStartTime;

                      // Clear existing lines
                      const lines = svg.querySelectorAll('line');
                      lines.forEach((line) => line.remove());

                      // Update particle positions
                      particles.forEach((particle) => {
                          if (elapsed < 3000) {
                              // Initial settling phase
                              particle.x += particle.vx;
                              particle.y += particle.vy;

                              particle.vx *= 0.995;
                              particle.vy *= 0.995;

                              // Bounce off edges
                              if (particle.x <= 2) {
                                  particle.vx = Math.abs(particle.vx) * 0.3;
                                  particle.x = 2;
                              }
                              if (particle.x >= 98) {
                                  particle.vx = -Math.abs(particle.vx) * 0.3;
                                  particle.x = 98;
                              }
                              if (particle.y <= 2) {
                                  particle.vy = Math.abs(particle.vy) * 0.3;
                                  particle.y = 2;
                              }
                              if (particle.y >= 98) {
                                  particle.vy = -Math.abs(particle.vy) * 0.3;
                                  particle.y = 98;
                              }
                          } else {
                              // Continuous gentle movement
                              particle.driftAngle += (Math.random() - 0.5) * 0.02;

                              const driftX = Math.cos(particle.driftAngle) * particle.driftSpeed;
                              const driftY = Math.sin(particle.driftAngle) * particle.driftSpeed;

                              const returnForceX = (particle.baseX - particle.x) * 0.002;
                              const returnForceY = (particle.baseY - particle.y) * 0.002;

                              particle.x += driftX + returnForceX;
                              particle.y += driftY + returnForceY;

                              // Keep within bounds
                              if (particle.x <= 2) {
                                  particle.x = 2;
                                  particle.driftAngle = Math.abs(particle.driftAngle);
                              }
                              if (particle.x >= 98) {
                                  particle.x = 98;
                                  particle.driftAngle = Math.PI - Math.abs(particle.driftAngle);
                              }
                              if (particle.y <= 2) {
                                  particle.y = 2;
                                  particle.driftAngle = -Math.abs(particle.driftAngle);
                              }
                              if (particle.y >= 98) {
                                  particle.y = 98;
                                  particle.driftAngle = Math.PI + Math.abs(particle.driftAngle);
                              }
                          }

                          // Update visual position
                          const actualX = (particle.x / 100) * width;
                          const actualY = (particle.y / 100) * height;
                          particle.element.setAttribute('cx', actualX);
                          particle.element.setAttribute('cy', actualY);
                      });

                      // Draw connections between nearby particles
                      for (let i = 0; i < particles.length; i++) {
                          for (let j = i + 1; j < particles.length; j++) {
                              const p1 = particles[i];
                              const p2 = particles[j];
                              const distance = Math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2);

                              if (distance < 30) {
                                  const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                                  const actualX1 = (p1.x / 100) * width;
                                  const actualY1 = (p1.y / 100) * height;
                                  const actualX2 = (p2.x / 100) * width;
                                  const actualY2 = (p2.y / 100) * height;

                                  line.setAttribute('x1', actualX1);
                                  line.setAttribute('y1', actualY1);
                                  line.setAttribute('x2', actualX2);
                                  line.setAttribute('y2', actualY2);
                                  line.setAttribute('stroke', 'rgba(20, 184, 166, 0.25)');
                                  line.setAttribute('stroke-width', '1');
                                  line.setAttribute('opacity', (1 - distance / 30) * 0.7);
                                  svg.appendChild(line);
                              }
                          }
                      }

                      requestAnimationFrame(animate);
                  };

                  // Start animation
                  animate();
              }

              // Initialize when DOM is ready
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', initParticleNetwork);
              } else {
                  initParticleNetwork();
              }
          })();
          """
        }
      )
    }
  }
}
