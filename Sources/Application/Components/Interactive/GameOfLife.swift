import WebUI

struct GameOfLife: Element {
  public var body: some Markup {
    Stack {
      Stack(classes: ["game-of-life-bg", "pointer-events-none", "z-0"])
        .overflow(.hidden)
        .position(.absolute, at: .all, offset: 0)
        .frame(width: .constant(.full), height: .constant(.full))
        .opacity(80)
      Script(
        content: {
          """
          // Conway's Game of Life implementation
          (function() {
              // Check for prefers-reduced-motion
              const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

              if (prefersReducedMotion) {
                  // Don't initialize Game of Life if user prefers reduced motion
                  const container = document.querySelector('.game-of-life-bg');
                  if (container) {
                      container.style.display = 'none';
                  }
                  return;
              }

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
                      z-index: 0;
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
                  let cellAge = []; // Track age of each cell

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
                      cellAge = [];

                      // Initialize empty grids first
                      for (let i = 0; i < rows; i++) {
                          grid[i] = [];
                          nextGrid[i] = [];
                          cellAge[i] = [];
                          for (let j = 0; j < cols; j++) {
                              grid[i][j] = 0;
                              nextGrid[i][j] = 0;
                              cellAge[i][j] = 0;
                          }
                      }

                      // Start with a small cluster in the center for organic growth
                      const centerRow = Math.floor(rows / 2);
                      const centerCol = Math.floor(cols / 2);

                      // Add a few small patterns to seed the growth
                      // R-pentomino pattern (creates complex long-term evolution)
                      if (centerRow > 1 && centerCol > 1) {
                          grid[centerRow][centerCol + 1] = 1;
                          grid[centerRow][centerCol + 2] = 1;
                          grid[centerRow + 1][centerCol] = 1;
                          grid[centerRow + 1][centerCol + 1] = 1;
                          grid[centerRow + 2][centerCol + 1] = 1;
                      }

                      // Add a glider in a corner
                      if (rows > 10 && cols > 10) {
                          createGlider(5, 5);
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
                                      cellAge[i][j] = 0;
                                  } else {
                                      nextGrid[i][j] = 1; // Survives
                                      cellAge[i][j] = Math.min(cellAge[i][j] + 1, 10); // Cap age at 10
                                  }
                              } else {
                                  // Dead cell
                                  if (neighbors === 3) {
                                      nextGrid[i][j] = 1; // Born
                                      cellAge[i][j] = 1; // New cell starts at age 1
                                  } else {
                                      nextGrid[i][j] = 0; // Stays dead
                                      cellAge[i][j] = 0;
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

                                  // Color based on cell age - younger cells are brighter/lighter
                                  const age = cellAge[i][j];
                                  const ageNormalized = age / 10; // Normalize to 0-1

                                  // Interpolate between teal-400 (young) and teal-700 (old)
                                  const r = Math.floor(45 - (45 - 15) * ageNormalized);
                                  const g = Math.floor(212 - (212 - 118) * ageNormalized);
                                  const b = Math.floor(191 - (191 - 110) * ageNormalized);
                                  const alpha = 0.9 - (ageNormalized * 0.3); // Fade older cells slightly

                                  ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${alpha})`;
                                  ctx.fillRect(x, y, cellSize - 1, cellSize - 1);

                                  liveCells++;
                              }
                          }
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
