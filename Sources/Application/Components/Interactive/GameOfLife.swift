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
            (function () {
              const prefersReducedMotion = window.matchMedia(
                "(prefers-reduced-motion: reduce)",
              ).matches;
              if (prefersReducedMotion) {
                const container = document.querySelector(".game-of-life-bg");
                if (container) container.style.display = "none";
                return;
              }
            
              function initGameOfLife() {
                const container = document.querySelector(".game-of-life-bg");
                if (!container) return;
                if (container.dataset.initialized) return;
                container.dataset.initialized = "true";
                container.innerHTML = "";
            
                setTimeout(() => {
                  const rect = container.getBoundingClientRect();
                  if (rect.width > 0 && rect.height > 0) {
                    createGameOfLife(container);
                  } else {
                    setTimeout(() => {
                      createGameOfLife(container);
                    }, 500);
                  }
                }, 250);
              }
            
              function createGameOfLife(container) {
                if (!container) return;
            
                const canvas = document.createElement("canvas");
                const ctx = canvas.getContext("2d");
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
            
                let isVisible = true;
                let animationId = null;
                let lastUpdate = 0;
                const updateInterval = 150;
            
                let cellSize = 8;
                let cols = 0;
                let rows = 0;
                let grid = [];
                let nextGrid = [];
                let cellAge = [];
            
                // Helpers for pattern seeding
                function placePattern(pattern, row, col) {
                  for (let i = 0; i < pattern.length; i++) {
                    for (let j = 0; j < pattern[i].length; j++) {
                      if (pattern[i][j] === 1) {
                        const r = row + i;
                        const c = col + j;
                        if (r >= 0 && r < rows && c >= 0 && c < cols) {
                          grid[r][c] = 1;
                          cellAge[r][c] = 1;
                        }
                      }
                    }
                  }
                }
            
                const patterns = [
                  // Glider
                  [
                    [0, 1, 0],
                    [0, 0, 1],
                    [1, 1, 1],
                  ],
                  // Blinker
                  [[1, 1, 1]],
                  // Toad
                  [
                    [0, 1, 1, 1],
                    [1, 1, 1, 0],
                  ],
                  // R-pentomino
                  [
                    [0, 1, 1],
                    [1, 1, 0],
                    [0, 1, 0],
                  ],
                  // Lightweight spaceship (LWSS)
                  [
                    [0, 1, 1, 1, 1],
                    [1, 0, 0, 0, 1],
                    [0, 0, 0, 0, 1],
                    [1, 0, 0, 1, 0],
                  ],
                ];
            
                // Initialize grid with patterns
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
            
                  // Pick 1–5 seeds from known life-friendly patterns
                  const clusterCount = Math.floor(Math.random() * 5) + 1;
                  for (let c = 0; c < clusterCount; c++) {
                    let pattern;
                    if (Math.random() < 0.1) {
                      // 10% chance: always a LWSS
                      pattern = patterns[4]; // LWSS
                    } else {
                      // Otherwise: random from other life-friendly seeds
                      pattern = patterns[Math.floor(Math.random() * 4)];
                    }
                    const row = Math.floor(Math.random() * (rows - pattern.length));
                    const col = Math.floor(Math.random() * (cols - pattern[0].length));
                    placePattern(pattern, row, col);
                  }
            
                  // Add a sprinkle of random noise (low chance)
                  for (let i = 0; i < rows; i++) {
                    for (let j = 0; j < cols; j++) {
                      if (Math.random() < 0.005) {
                        // 0.5% chance alive
                        grid[i][j] = 1;
                        cellAge[i][j] = 1;
                      }
                    }
                  }
                }
            
                function countNeighbors(row, col) {
                  let count = 0;
                  for (let i = -1; i <= 1; i++) {
                    for (let j = -1; j <= 1; j++) {
                      if (i === 0 && j === 0) continue;
                      const newRow = (row + i + rows) % rows;
                      const newCol = (col + j + cols) % cols;
                      count += grid[newRow][newCol];
                    }
                  }
                  return count;
                }
            
                function updateGrid() {
                  for (let i = 0; i < rows; i++) {
                    for (let j = 0; j < cols; j++) {
                      const neighbors = countNeighbors(i, j);
                      const currentCell = grid[i][j];
            
                      if (currentCell === 1) {
                        if (neighbors < 2 || neighbors > 3) {
                          nextGrid[i][j] = 0;
                          cellAge[i][j] = 0;
                        } else {
                          nextGrid[i][j] = 1;
                          cellAge[i][j] = Math.min(cellAge[i][j] + 1, 10);
                        }
                      } else {
                        if (neighbors === 3) {
                          nextGrid[i][j] = 1;
                          cellAge[i][j] = 1;
                        } else {
                          nextGrid[i][j] = 0;
                          cellAge[i][j] = 0;
                        }
                      }
                    }
                  }
                  [grid, nextGrid] = [nextGrid, grid];
                }
            
                function drawGrid() {
                  if (!ctx || cols <= 0 || rows <= 0) return;
                  ctx.clearRect(0, 0, canvas.width, canvas.height);
            
                  for (let i = 0; i < rows; i++) {
                    for (let j = 0; j < cols; j++) {
                      if (grid[i][j] === 1) {
                        const x = j * cellSize;
                        const y = i * cellSize;
                        const age = cellAge[i][j];
                        const ageNormalized = age / 10;
            
                        const r = Math.floor(45 - (45 - 15) * ageNormalized);
                        const g = Math.floor(212 - (212 - 118) * ageNormalized);
                        const b = Math.floor(191 - (191 - 110) * ageNormalized);
                        const alpha = 0.9 - ageNormalized * 0.3;
            
                        ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${alpha})`;
                        ctx.fillRect(x, y, cellSize - 1, cellSize - 1);
                      }
                    }
                  }
                }
            
                const observer = new IntersectionObserver(
                  (entries) => {
                    isVisible = entries[0].isIntersecting;
                    if (!isVisible && animationId) {
                      cancelAnimationFrame(animationId);
                      animationId = null;
                    } else if (isVisible && !animationId) {
                      animate();
                    }
                  },
                  { threshold: 0.1 },
                );
                observer.observe(container);
            
                const animate = (timestamp = 0) => {
                  if (!isVisible) return;
                  if (timestamp - lastUpdate >= updateInterval) {
                    updateGrid();
                    drawGrid();
                    lastUpdate = timestamp;
                  }
                  animationId = requestAnimationFrame(animate);
                };
            
                const handleResize = () => {
                  initializeGrid();
                };
                window.addEventListener("resize", handleResize);
            
                initializeGrid();
                animate();
            
                return () => {
                  if (animationId) cancelAnimationFrame(animationId);
                  observer.disconnect();
                  window.removeEventListener("resize", handleResize);
                };
              }
            
              if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", initGameOfLife);
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

