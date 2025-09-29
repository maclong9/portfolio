import WebUI

struct RandomBackground: Element {
  public var body: some Markup {
    Stack {
      Script(
        content: {
          """
          // Random background selector
          (function() {
              function selectRandomBackground() {
                  // Generate random number (0 or 1) for 50/50 chance
                  const useParticles = Math.random() < 0.5;
                  
                  if (useParticles) {
                      // Create particle network
                      const particleContainer = document.createElement('div');
                      particleContainer.className = 'particle-bg';
                      particleContainer.style.cssText = `
                          position: absolute;
                          top: 0;
                          left: 0;
                          width: 100%;
                          height: 100%;
                          overflow: hidden;
                          opacity: 0.8;
                          z-index: -1;
                      `;
                      document.querySelector('.random-background').appendChild(particleContainer);
                      
                      // Initialize particle network (adapted from ParticleNetwork.swift)
                      initParticleNetwork();
                  } else {
                      // Create game of life
                      const gameContainer = document.createElement('div');
                      gameContainer.className = 'game-of-life-bg';
                      gameContainer.style.cssText = `
                          position: absolute;
                          top: 0;
                          left: 0;
                          width: 100%;
                          height: 100%;
                          overflow: hidden;
                          opacity: 0.8;
                          z-index: -1;
                      `;
                      document.querySelector('.random-background').appendChild(gameContainer);
                      
                      // Initialize game of life (adapted from GameOfLife.swift)
                      initGameOfLife();
                  }
              }

              function initParticleNetwork() {
                  const container = document.querySelector('.particle-bg');
                  if (!container) return;

                  // Prevent multiple initializations
                  if (container.dataset.initialized) return;
                  container.dataset.initialized = 'true';

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

                  // Optimized animation state
                  let isVisible = true;
                  let animationId = null;
                  let lastConnectionUpdate = 0;
                  const connectionUpdateInterval = 100; // Update connections every 100ms instead of every frame

                  // Create particles with positions
                  const particles = [];
                  const numParticles = 24;
                  let animationStartTime = Date.now();

                  // Object pool for line elements to avoid constant DOM creation/destruction
                  const linePool = [];
                  let activeLinesCount = 0;

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

                  // Helper function to get or create a line element from pool
                  function getLineFromPool() {
                      if (linePool.length > activeLinesCount) {
                          const line = linePool[activeLinesCount];
                          line.style.display = '';
                          return line;
                      } else {
                          const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                          line.setAttribute('stroke', 'rgba(20, 184, 166, 0.25)');
                          line.setAttribute('stroke-width', '1');
                          svg.appendChild(line);
                          linePool.push(line);
                          return line;
                      }
                  }

                  // Helper function to hide unused lines
                  function hideUnusedLines() {
                      for (let i = activeLinesCount; i < linePool.length; i++) {
                          linePool[i].style.display = 'none';
                      }
                  }

                  // Optimized connection calculation (reduced frequency)
                  function updateConnections(timestamp, width, height) {
                      activeLinesCount = 0;
                      
                      for (let i = 0; i < particles.length; i++) {
                          for (let j = i + 1; j < particles.length; j++) {
                              const p1 = particles[i];
                              const p2 = particles[j];
                              const dx = p1.x - p2.x;
                              const dy = p1.y - p2.y;
                              const distance = Math.sqrt(dx * dx + dy * dy);

                              if (distance < 30) {
                                  const line = getLineFromPool();
                                  const actualX1 = (p1.x / 100) * width;
                                  const actualY1 = (p1.y / 100) * height;
                                  const actualX2 = (p2.x / 100) * width;
                                  const actualY2 = (p2.y / 100) * height;

                                  line.setAttribute('x1', actualX1);
                                  line.setAttribute('y1', actualY1);
                                  line.setAttribute('x2', actualX2);
                                  line.setAttribute('y2', actualY2);
                                  line.setAttribute('opacity', (1 - distance / 30) * 0.7);
                                  activeLinesCount++;
                              }
                          }
                      }
                      
                      hideUnusedLines();
                  }

                  // Visibility detection for performance optimization
                  const observer = new IntersectionObserver((entries) => {
                      isVisible = entries[0].isIntersecting;
                      if (!isVisible && animationId) {
                          cancelAnimationFrame(animationId);
                          animationId = null;
                      } else if (isVisible && !animationId) {
                          animate();
                      }
                  }, { threshold: 0.1 });
                  
                  observer.observe(container);

                  // Optimized animation function
                  const animate = (timestamp) => {
                      if (!isVisible) return;

                      const containerRect = container.getBoundingClientRect();
                      const width = containerRect.width;
                      const height = containerRect.height;
                      const currentTime = Date.now();
                      const elapsed = currentTime - animationStartTime;

                      // Update particle positions (this runs at 60fps)
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

                          // Update visual position (60fps - light operation)
                          const actualX = (particle.x / 100) * width;
                          const actualY = (particle.y / 100) * height;
                          particle.element.setAttribute('cx', actualX);
                          particle.element.setAttribute('cy', actualY);
                      });

                      // Update connections only every 100ms instead of every frame
                      if (timestamp - lastConnectionUpdate > connectionUpdateInterval) {
                          updateConnections(timestamp, width, height);
                          lastConnectionUpdate = timestamp;
                      }

                      animationId = requestAnimationFrame(animate);
                  };

                  // Start animation
                  animate();
              }

              function initGameOfLife() {
                  const container = document.querySelector('.game-of-life-bg');
                  if (!container) return;

                  // Prevent multiple initializations
                  if (container.dataset.initialized) return;
                  container.dataset.initialized = 'true';

                  // Clear existing content
                  container.innerHTML = '';

                  // Add a slight delay to ensure container is properly sized
                  setTimeout(() => { createGameOfLife(container); }, 100);
              }

              function createGameOfLife(container) {
                  if (!container) return;

                  // Create canvas element for Game of Life
                  const canvas = document.createElement('canvas');
                  const ctx = canvas.getContext('2d');
                  if (!ctx) return;
                  
                  canvas.style.cssText = `
                      position: absolute;
                      top: 0;
                      left: 0;
                      width: 100%;
                      height: 100%;
                      pointer-events: none;
                      z-index: -1;
                  `;

                  container.appendChild(canvas);

                  // Game state
                  let isVisible = true;
                  let animationId = null;
                  let lastUpdate = 0;
                  const updateInterval = 150; // Update every 150ms
                  
                  let cellSize = 8;
                  let cols = 0;
                  let rows = 0;
                  let grid = [];
                  let nextGrid = [];

                  // Initialize grid with random cells
                  function initializeGrid() {
                      const rect = container.getBoundingClientRect();
                      canvas.width = rect.width;
                      canvas.height = rect.height;
                      
                      cols = Math.floor(canvas.width / cellSize);
                      rows = Math.floor(canvas.height / cellSize);
                      
                      // Bail out if there’s no space yet (prevents neighbor errors)
                      if (cols <= 0 || rows <= 0) return;
                      
                      grid = [];
                      nextGrid = [];
                      
                      // 1) Fully initialize grids first
                      for (let i = 0; i < rows; i++) {
                          grid[i] = [];
                          nextGrid[i] = [];
                          for (let j = 0; j < cols; j++) {
                              let alive = false;
                              if (Math.random() < 0.15) { // Lower density for better patterns
                                  alive = true;
                              }
                              grid[i][j] = alive ? 1 : 0;
                              nextGrid[i][j] = 0;
                          }
                      }
                      
                      // 2) Sprinkle gliders after the grid exists
                      for (let i = 0; i < rows; i++) {
                          for (let j = 0; j < cols; j++) {
                              if (Math.random() < 0.01) {
                                  createGlider(i, j);
                              }
                          }
                      }
                  }

                  // Create a glider pattern at position (row, col)
                  function createGlider(row, col) {
                      const gliderPattern = [
                          [0, 1, 0],
                          [0, 0, 1],
                          [1, 1, 1]
                      ];
                      
                      for (let i = 0; i < gliderPattern.length; i++) {
                          for (let j = 0; j < gliderPattern[i].length; j++) {
                              const r = row + i;
                              const c = col + j;
                              if (r >= 0 && r < rows && c >= 0 && c < cols) {
                                  grid[r][c] = gliderPattern[i][j];
                              }
                          }
                      }
                  }

                  // Count living neighbors
                  function countNeighbors(row, col) {
                      let count = 0;
                      for (let i = -1; i <= 1; i++) {
                          for (let j = -1; j <= 1; j++) {
                              if (i === 0 && j === 0) continue;
                              
                              const newRow = (row + i + rows) % rows; // Wrap around
                              const newCol = (col + j + cols) % cols; // Wrap around
                              count += grid[newRow][newCol];
                          }
                      }
                      return count;
                  }

                  // Update grid according to Game of Life rules
                  function updateGrid() {
                      if (cols <= 0 || rows <= 0) return;
                      for (let i = 0; i < rows; i++) {
                          for (let j = 0; j < cols; j++) {
                              const neighbors = countNeighbors(i, j);
                              const currentCell = grid[i][j];
                              
                              if (currentCell === 1) {
                                  if (neighbors < 2 || neighbors > 3) {
                                      nextGrid[i][j] = 0;
                                  } else {
                                      nextGrid[i][j] = 1;
                                  }
                              } else {
                                  if (neighbors === 3) {
                                      nextGrid[i][j] = 1;
                                  } else {
                                      nextGrid[i][j] = 0;
                                  }
                              }
                          }
                      }
                      
                      // Swap grids
                      [grid, nextGrid] = [nextGrid, grid];
                  }

                  // Draw the grid
                  function drawGrid() {
                      if (!ctx || cols <= 0 || rows <= 0) return;
                      ctx.clearRect(0, 0, canvas.width, canvas.height);
                      
                      for (let i = 0; i < rows; i++) {
                          for (let j = 0; j < cols; j++) {
                              if (grid[i][j] === 1) {
                                  const x = j * cellSize;
                                  const y = i * cellSize;
                                  
                                  // Use teal color to match the particle network
                                  ctx.fillStyle = 'rgba(20, 184, 166, 0.6)';
                                  ctx.fillRect(x, y, cellSize - 1, cellSize - 1);
                              }
                          }
                      }
                  }

                  // Periodically inject new random cells to keep it interesting
                  function injectRandomCells() {
                      if (Math.random() < 0.1) { // 10% chance every update cycle
                          for (let i = 0; i < 3; i++) { // Add a few random cells
                              const row = Math.floor(Math.random() * rows);
                              const col = Math.floor(Math.random() * cols);
                              grid[row][col] = 1;
                          }
                      }
                      
                      // Occasionally add a glider
                      if (Math.random() < 0.05) {
                          const row = Math.floor(Math.random() * (rows - 3));
                          const col = Math.floor(Math.random() * (cols - 3));
                          createGlider(row, col);
                      }
                  }

                  // Visibility detection for performance optimization
                  const observer = new IntersectionObserver((entries) => {
                      isVisible = entries[0].isIntersecting;
                      if (!isVisible && animationId) {
                          cancelAnimationFrame(animationId);
                          animationId = null;
                      } else if (isVisible && !animationId) {
                          animate();
                      }
                  }, { threshold: 0.1 });
                  
                  observer.observe(container);

                  // Animation loop
                  const animate = (timestamp) => {
                      if (!isVisible) return;

                      if (timestamp - lastUpdate >= updateInterval) {
                          updateGrid();
                          injectRandomCells();
                          drawGrid();
                          lastUpdate = timestamp;
                      }

                      animationId = requestAnimationFrame(animate);
                  };

                  // Handle window resize
                  const handleResize = () => {
                      initializeGrid();
                  };
                  
                  window.addEventListener('resize', handleResize);

                  // Initialize and start
                  initializeGrid();
                  animate();
              }

              // Initialize random background selection when DOM is ready
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', selectRandomBackground);
              } else {
                  selectRandomBackground();
              }
          })();
          """
        }
      )
      Stack(classes: ["random-background"])
        .overflow(.hidden)
        .position(.absolute, at: .all, offset: 0)
        .frame(width: .constant(.full), height: .constant(.full))
        .opacity(80)
    }
  }
}
