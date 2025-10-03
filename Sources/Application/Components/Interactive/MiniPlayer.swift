import Foundation
import WebUI

public struct MiniPlayer: Element {
  public init() {}

  public var body: some Markup {
    MarkupString(content: renderMiniPlayer())
  }

  private func renderMiniPlayer() -> String {
    """
    <div id="mini-player" class="fixed bottom-4 left-4 z-50 bg-white/95 dark:bg-zinc-900/95 backdrop-blur-xl backdrop-saturate-150 border border-zinc-200 dark:border-zinc-800 rounded-lg shadow-lg hidden transition-all duration-300">
      <div id="mini-player-collapsed" class="w-14 h-14 cursor-pointer relative" onclick="toggleMiniPlayer()">
        <div class="w-full h-full rounded-lg bg-gradient-to-br from-teal-400 to-blue-500 flex items-center justify-center">
          <i data-lucide="disc" class="w-6 h-6 text-white/70"></i>
        </div>
        <div class="absolute top-1 right-1 w-2 h-2 bg-teal-500 rounded-full animate-pulse"></div>
      </div>

      <div id="mini-player-expanded" class="hidden p-3 space-y-2 w-72">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-semibold text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">Now Playing</span>
          <button onclick="toggleMiniPlayer()" class="p-1 text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors" aria-label="Collapse">
            <i data-lucide="chevron-down" class="w-4 h-4"></i>
          </button>
        </div>

        <div class="flex items-center gap-3">
          <div class="w-12 h-12 rounded-lg bg-gradient-to-br from-teal-400 to-blue-500 flex items-center justify-center flex-shrink-0">
            <i data-lucide="disc" class="w-5 h-5 text-white/70"></i>
          </div>
          <div class="flex-1 min-w-0">
            <div id="mini-player-title" class="font-medium text-zinc-900 dark:text-zinc-100 truncate text-sm"></div>
            <div id="mini-player-artist" class="text-xs text-zinc-600 dark:text-zinc-400 truncate"></div>
          </div>
        </div>

        <div class="flex items-center justify-center gap-2 pt-2">
          <button onclick="previousTrack()" class="p-2 text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors" aria-label="Previous">
            <i data-lucide="skip-back" class="w-4 h-4"></i>
          </button>
          <button onclick="togglePlayPause()" id="mini-play-pause-btn" class="p-2 bg-teal-500 hover:bg-teal-600 text-white rounded-full transition-colors" aria-label="Play/Pause">
            <i data-lucide="play" id="mini-play-pause-icon" class="w-5 h-5"></i>
          </button>
          <button onclick="nextTrack()" class="p-2 text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors" aria-label="Next">
            <i data-lucide="skip-forward" class="w-4 h-4"></i>
          </button>
          <button onclick="closeMiniPlayer()" class="p-2 text-zinc-600 hover:text-red-600 dark:text-zinc-400 dark:hover:text-red-400 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors" aria-label="Stop">
            <i data-lucide="x" class="w-4 h-4"></i>
          </button>
        </div>

        <a href="/music" class="block text-center text-xs text-teal-600 dark:text-teal-400 hover:text-teal-700 dark:hover:text-teal-300 transition-colors pt-2 border-t border-zinc-200 dark:border-zinc-700">Open Music</a>
      </div>
    </div>

    <script>
      function toggleMiniPlayer() {
        const collapsed = document.getElementById('mini-player-collapsed');
        const expanded = document.getElementById('mini-player-expanded');

        if (collapsed && expanded) {
          collapsed.classList.toggle('hidden');
          expanded.classList.toggle('hidden');
        }
      }

      function closeMiniPlayer() {
        const miniPlayer = document.getElementById('mini-player');
        if (audioPlayer) {
          audioPlayer.pause();
          audioPlayer.src = '';
        }
        if (miniPlayer) {
          miniPlayer.classList.add('hidden');
        }
        // Also hide the now playing bar if on music page
        const nowPlayingBar = document.getElementById('now-playing-bar');
        if (nowPlayingBar) {
          nowPlayingBar.classList.add('hidden');
        }
      }

      // Sync mini player with main player
      function updateMiniPlayer(title, artist, isPlaying) {
        const miniPlayerTitle = document.getElementById('mini-player-title');
        const miniPlayerArtist = document.getElementById('mini-player-artist');
        const miniPlayer = document.getElementById('mini-player');
        const miniPlayPauseIcon = document.getElementById('mini-play-pause-icon');

        if (miniPlayerTitle) miniPlayerTitle.textContent = title;
        if (miniPlayerArtist) miniPlayerArtist.textContent = artist;

        // Show mini player on non-music pages
        if (miniPlayer && !window.location.pathname.includes('/music')) {
          miniPlayer.classList.remove('hidden');
        }

        // Update play/pause icon
        if (miniPlayPauseIcon) {
          miniPlayPauseIcon.setAttribute('data-lucide', isPlaying ? 'pause' : 'play');
          if (typeof lucide !== 'undefined') {
            lucide.createIcons();
          }
        }
      }
    </script>
    """
  }
}
