import WebUI

struct GameOfLife: Element {
  public var body: some Markup {
    Stack {
      Stack(classes: ["game-of-life-bg"])
        .overflow(.hidden)
        .position(.absolute, at: .all, offset: 0)
        .frame(width: .constant(.full), height: .constant(.full))
        .opacity(80)
      Script(
        content: {
          """
          // Conway's Game of Life implementation
          (function() {
              function initGameOfLife() {
                  const container = document.querySelector('.game-of-life-bg');
                  if (!container) return;

                  // Prevent multiple initializations
                  if (container.dataset.initialized) return;
                  container.dataset.initialized = 'true';

                  // Clear existing content
                  container.innerHTML = '';


                  // Add a longer delay to ensure container is properly sized and visible
                  setTimeout(() => { 
                      const rect = container.getBoundingClientRect();
                      if (rect.width > 0 && rect.height > 0) {
                          createGameOfLife(container); 
                      } else {
                          // Try again with more delay if no dimensions yet
                          setTimeout(() => { createGameOfLife(container); }, 500);
                      }
                  }, 250);
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
                      
                      
                      if (cols <= 0 || rows <= 0) return;
                      
                      grid = [];
                      nextGrid = [];
                      
                      for (let i = 0; i < rows; i++) {
                          grid[i] = [];
                          nextGrid[i] = [];
                          for (let j = 0; j < cols; j++) {
                              // Create interesting patterns with clusters
                              let alive = false;
                              if (Math.random() < 0.25) { // Increased density for better visibility
                                  alive = true;
                              }
                              // Create some glider patterns occasionally
                              if (Math.random() < 0.01) {
                                  createGlider(i, j);
                              }
                              grid[i][j] = alive ? 1 : 0;
                              nextGrid[i][j] = 0;
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
                      for (let i = 0; i < rows; i++) {
                          for (let j = 0; j < cols; j++) {
                              const neighbors = countNeighbors(i, j);
                              const currentCell = grid[i][j];
                              
                              if (currentCell === 1) {
                                  // Living cell
                                  if (neighbors < 2 || neighbors > 3) {
                                      nextGrid[i][j] = 0; // Dies
                                  } else {
                                      nextGrid[i][j] = 1; // Survives
                                  }
                              } else {
                                  // Dead cell
                                  if (neighbors === 3) {
                                      nextGrid[i][j] = 1; // Born
                                  } else {
                                      nextGrid[i][j] = 0; // Stays dead
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
                      
                      let liveCells = 0;
                      
                      for (let i = 0; i < rows; i++) {
                          for (let j = 0; j < cols; j++) {
                              if (grid[i][j] === 1) {
                                  const x = j * cellSize;
                                  const y = i * cellSize;
                                  
                                  // Use multiple teal shades like the rest of the site
                                  const tealColors = [
                                      'rgba(20, 184, 166, 0.8)',   // teal-500
                                      'rgba(13, 148, 136, 0.7)',   // teal-600 
                                      'rgba(15, 118, 110, 0.6)',   // teal-700
                                      'rgba(45, 212, 191, 0.5)',   // teal-400
                                  ];
                                  
                                  // Use a subtle variation based on position for visual interest
                                  const colorIndex = (i + j) % tealColors.length;
                                  ctx.fillStyle = tealColors[colorIndex];
                                  ctx.fillRect(x, y, cellSize - 1, cellSize - 1);
                                  
                                  liveCells++;
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
                  const animate = (timestamp = 0) => {
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

                  // Cleanup function
                  return () => {
                      if (animationId) {
                          cancelAnimationFrame(animationId);
                      }
                      observer.disconnect();
                      window.removeEventListener('resize', handleResize);
                  };
              }

              // Initialize when DOM is ready
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', initGameOfLife);
              } else {
                  initGameOfLife();
              }
          })();
          """
        }
      )
    }
  }
}