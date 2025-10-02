import Foundation
import WebUI

struct DynamicAlbum: Document {
  let album: AlbumResponse

  var path: String? { "photos/\(album.slug)" }

  var metadata: Metadata {
    Metadata(
      from: Application().metadata,
      title: album.name,
      description: "Photo album: \(album.name)"
    )
  }

  var body: some Markup {
    Layout(
      path: "photos/\(album.slug)",
      title: "\(album.name) - Photos - Mac Long",
      description: "Photo album: \(album.name)",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Photos", url: "/photos"),
        Breadcrumb(title: album.name, url: "/photos/\(album.slug)"),
      ]
    ) {
      Stack(classes: ["max-w-4xl", "mx-auto"]) {
        // Album Header with Inline Filters
        Stack(classes: ["mb-8"]) {
          Heading(.largeTitle, album.name, classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])

          Stack(classes: ["flex", "items-center", "justify-between", "flex-wrap", "gap-4"]) {
            // Left side: Date and photo count with camera icon
            Stack(classes: ["flex", "items-center", "gap-4", "text-sm"]) {
              if let date = album.date {
                Stack(classes: ["flex", "items-center", "gap-2"]) {
                  Icon(name: "calendar", classes: ["w-4", "h-4"])
                  Time(datetime: date.ISO8601Format()) {
                    DateFormatter.articleDate.string(from: date)
                  }
                }
              }

              Stack(classes: ["flex", "items-center", "gap-2"]) {
                Icon(name: "camera", classes: ["w-4", "h-4"])
                Text(
                  "\(album.photos.count) photo\(album.photos.count == 1 ? "" : "s")",
                  id: "photo-count"
                )
              }
            }

            // Right side: Filter buttons
            Stack(classes: ["flex", "items-center", "gap-2"]) {
              // Location filter button
              if !getUniqueLocations().isEmpty {
                MarkupString(content: """
                  <div class="filter-dropdown-container relative">
                    <button onclick="toggleFilterDropdown('location')"
                            class="filter-icon-btn w-10 h-10 rounded-full bg-white/50 dark:bg-zinc-800/50 backdrop-blur-xl border border-white/50 dark:border-white/10 shadow-sm hover:shadow-md hover:bg-white/70 dark:hover:bg-zinc-800/70 transition-all duration-200 flex items-center justify-center cursor-pointer hover:-translate-y-0.5 active:translate-y-0">
                      <i data-lucide="map-pin" class="w-4 h-4"></i>
                    </button>
                    <div id="location-dropdown" class="filter-dropdown hidden absolute top-12 right-0 w-56 bg-white/90 dark:bg-zinc-800/90 backdrop-blur-2xl rounded-2xl shadow-2xl border border-white/50 dark:border-white/10 overflow-hidden z-50">
                      <div class="p-3 border-b border-zinc-200/50 dark:border-zinc-700/50">
                        <div class="text-xs font-semibold text-zinc-600 dark:text-zinc-400">Location</div>
                      </div>
                      <div class="max-h-64 overflow-y-auto">
                        <button onclick="selectFilter('location', '')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="location" data-filter-value="">All locations</button>
                        \(getUniqueLocations().map { "<button onclick=\"selectFilter('location', '\($0)')\" class=\"filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors\" data-filter-type=\"location\" data-filter-value=\"\($0)\">\($0)</button>" }.joined())
                      </div>
                    </div>
                  </div>
                  """)
              }

              // Camera filter button
              if !getUniqueCameras().isEmpty {
                MarkupString(content: """
                  <div class="filter-dropdown-container relative">
                    <button onclick="toggleFilterDropdown('camera')"
                            class="filter-icon-btn w-10 h-10 rounded-full bg-white/50 dark:bg-zinc-800/50 backdrop-blur-xl border border-white/50 dark:border-white/10 shadow-sm hover:shadow-md hover:bg-white/70 dark:hover:bg-zinc-800/70 transition-all duration-200 flex items-center justify-center cursor-pointer hover:-translate-y-0.5 active:translate-y-0">
                      <i data-lucide="aperture" class="w-4 h-4"></i>
                    </button>
                    <div id="camera-dropdown" class="filter-dropdown hidden absolute top-12 right-0 w-56 bg-white/90 dark:bg-zinc-800/90 backdrop-blur-2xl rounded-2xl shadow-2xl border border-white/50 dark:border-white/10 overflow-hidden z-50">
                      <div class="p-3 border-b border-zinc-200/50 dark:border-zinc-700/50">
                        <div class="text-xs font-semibold text-zinc-600 dark:text-zinc-400">Camera</div>
                      </div>
                      <div class="max-h-64 overflow-y-auto">
                        <button onclick="selectFilter('camera', '')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="camera" data-filter-value="">All cameras</button>
                        \(getUniqueCameras().map { "<button onclick=\"selectFilter('camera', '\($0)')\" class=\"filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors\" data-filter-type=\"camera\" data-filter-value=\"\($0)\">\($0)</button>" }.joined())
                      </div>
                    </div>
                  </div>
                  """)
              }

              // GPS filter button
              MarkupString(content: """
                <div class="filter-dropdown-container relative">
                  <button onclick="toggleFilterDropdown('gps')"
                          class="filter-icon-btn w-10 h-10 rounded-full bg-white/50 dark:bg-zinc-800/50 backdrop-blur-xl border border-white/50 dark:border-white/10 shadow-sm hover:shadow-md hover:bg-white/70 dark:hover:bg-zinc-800/70 transition-all duration-200 flex items-center justify-center cursor-pointer hover:-translate-y-0.5 active:translate-y-0">
                    <i data-lucide="map" class="w-4 h-4"></i>
                  </button>
                  <div id="gps-dropdown" class="filter-dropdown hidden absolute top-12 right-0 w-56 bg-white/90 dark:bg-zinc-800/90 backdrop-blur-2xl rounded-2xl shadow-2xl border border-white/50 dark:border-white/10 overflow-hidden z-50">
                    <div class="p-3 border-b border-zinc-200/50 dark:border-zinc-700/50">
                      <div class="text-xs font-semibold text-zinc-600 dark:text-zinc-400">GPS Data</div>
                    </div>
                    <div class="max-h-64 overflow-y-auto">
                      <button onclick="selectFilter('gps', '')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="gps" data-filter-value="">All photos</button>
                      <button onclick="selectFilter('gps', 'true')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="gps" data-filter-value="true">With location</button>
                      <button onclick="selectFilter('gps', 'false')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="gps" data-filter-value="false">Without location</button>
                    </div>
                  </div>
                </div>
                """)

              // Keywords filter button
              if !getUniqueKeywords().isEmpty {
                MarkupString(content: """
                  <div class="filter-dropdown-container relative">
                    <button onclick="toggleFilterDropdown('keyword')"
                            class="filter-icon-btn w-10 h-10 rounded-full bg-white/50 dark:bg-zinc-800/50 backdrop-blur-xl border border-white/50 dark:border-white/10 shadow-sm hover:shadow-md hover:bg-white/70 dark:hover:bg-zinc-800/70 transition-all duration-200 flex items-center justify-center cursor-pointer hover:-translate-y-0.5 active:translate-y-0">
                      <i data-lucide="tag" class="w-4 h-4"></i>
                    </button>
                    <div id="keyword-dropdown" class="filter-dropdown hidden absolute top-12 right-0 w-56 bg-white/90 dark:bg-zinc-800/90 backdrop-blur-2xl rounded-2xl shadow-2xl border border-white/50 dark:border-white/10 overflow-hidden z-50">
                      <div class="p-3 border-b border-zinc-200/50 dark:border-zinc-700/50">
                        <div class="text-xs font-semibold text-zinc-600 dark:text-zinc-400">Keywords</div>
                      </div>
                      <div class="max-h-64 overflow-y-auto">
                        <button onclick="selectFilter('keyword', '')" class="filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors" data-filter-type="keyword" data-filter-value="">All keywords</button>
                        \(getUniqueKeywords().map { "<button onclick=\"selectFilter('keyword', '\($0)')\" class=\"filter-option w-full text-left px-3 py-2 text-sm hover:bg-zinc-100/50 dark:hover:bg-zinc-700/50 transition-colors\" data-filter-type=\"keyword\" data-filter-value=\"\($0)\">\($0)</button>" }.joined())
                      </div>
                    </div>
                  </div>
                  """)
              }

              // Reset filter button
              MarkupString(content: """
                <button onclick="resetFilters()"
                        class="px-4 py-2 text-sm font-medium text-zinc-700 dark:text-zinc-300 bg-white/60 dark:bg-zinc-800/60 hover:bg-white/80 dark:hover:bg-zinc-800/80 backdrop-blur-xl rounded-full shadow-sm shadow-black/5 border border-white/50 dark:border-white/10 transition-all duration-200 cursor-pointer hover:-translate-y-0.5 active:translate-y-0">
                  Reset
                </button>
                """)
            }
          }
        }

        // Photo Grid with container
        Stack(classes: ["p-8", "bg-gradient-to-br", "from-zinc-50/70", "to-white/70", "dark:from-zinc-900/70", "dark:to-zinc-800/70", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm", "mb-12"]) {
          Stack(
            id: "photo-grid",
            classes: [
              "grid", "grid-cols-1", "sm:grid-cols-2", "md:grid-cols-3", "gap-4",
            ]
          ) {
            for (index, photo) in album.photos.enumerated() {
              MarkupString(content: """
                <div class="group relative overflow-hidden rounded-2xl aspect-square bg-gradient-to-br from-zinc-100 to-zinc-50 dark:from-zinc-800 dark:to-zinc-900 shadow-md hover:shadow-2xl hover:shadow-teal-500/10 dark:hover:shadow-teal-400/10 transition-all duration-500 ease-out reveal-card photo-item border border-zinc-200/50 dark:border-zinc-700/50 hover:scale-[1.02] cursor-pointer"
                     data-photo-index="\(index)"
                     data-location="\(photo.metadata.locationName ?? "")"
                     data-camera="\(photo.metadata.camera ?? "")"
                     data-has-location="\(photo.metadata.hasLocation ? "true" : "false")"
                     data-keywords="\(photo.metadata.keywords.joined(separator: ","))"
                     onclick="openLightbox(\(index))">
                  <div class="relative w-full h-full">
                    <img src="\(photo.webPath)" alt="\(photo.altText)" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700 ease-out" loading="lazy" />
                    \(photo.caption != nil ? """
                    <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent backdrop-blur-sm p-4 flex items-end opacity-0 group-hover:opacity-100 transition-all duration-500">
                      <span class="text-white text-sm font-medium leading-relaxed line-clamp-3 drop-shadow-lg">\(photo.caption!)</span>
                    </div>
                    """ : "")
                  </div>
                </div>
                """)
            }
          }
        }

        // Back button
        Stack(classes: ["text-center", "mt-8"]) {
          Link(
            "← Back to Photos",
            to: "/photos",
            classes: [
              "inline-flex", "items-center", "gap-2",
              "text-teal-600", "dark:text-teal-400",
              "hover:text-teal-700", "dark:hover:text-teal-300",
              "transition-colors",
            ]
          )
        }

        // Lightbox Modal
        createLightboxModal()

        // Styles and Scripts
        createStyles()
        createScripts()
      }
    }
  }

  // Helper method to create lightbox modal
  private func createLightboxModal() -> some Markup {
    MarkupString(content: """
      <div id="lightbox-modal" class="hidden fixed inset-0 bg-black/95 z-50 flex items-center justify-center">
        <!-- Close button -->
        <button onclick="closeLightbox()" class="absolute top-6 right-6 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-xl border border-white/20 transition-all duration-200 flex items-center justify-center z-50">
          <i data-lucide="x" class="w-6 h-6 text-white"></i>
        </button>

        <!-- Metadata toggle button -->
        <button onclick="toggleMetadata()" class="absolute top-6 right-24 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-xl border border-white/20 transition-all duration-200 flex items-center justify-center z-50">
          <i data-lucide="info" class="w-6 h-6 text-white"></i>
        </button>

        <!-- Main content area -->
        <div class="flex items-center justify-center w-full h-full p-6">
          <!-- Navigation: Previous -->
          <button onclick="navigateLightbox(-1)" class="absolute left-6 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-xl border border-white/20 transition-all duration-200 flex items-center justify-center">
            <i data-lucide="chevron-left" class="w-6 h-6 text-white"></i>
          </button>

          <!-- Image container -->
          <div class="max-w-5xl max-h-full flex items-center justify-center">
            <img id="lightbox-image" src="" alt="" class="max-w-full max-h-[80vh] object-contain rounded-2xl" />
          </div>

          <!-- Navigation: Next -->
          <button onclick="navigateLightbox(1)" class="absolute right-6 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-xl border border-white/20 transition-all duration-200 flex items-center justify-center">
            <i data-lucide="chevron-right" class="w-6 h-6 text-white"></i>
          </button>
        </div>

        <!-- Thumbnails strip at bottom -->
        <div id="lightbox-thumbnails" class="absolute bottom-6 left-1/2 -translate-x-1/2 flex gap-2 max-w-4xl overflow-x-auto px-6"></div>

        <!-- Metadata panel (hidden by default) -->
        <div id="metadata-panel" class="hidden absolute top-6 right-6 md:top-6 md:right-6 left-6 md:left-auto bottom-6 md:bottom-auto md:w-96 w-auto max-h-[calc(100vh-3rem)] md:max-h-[calc(100vh-3rem)] max-w-md mx-auto md:mx-0 bg-white/90 dark:bg-zinc-900/90 backdrop-blur-2xl overflow-y-auto shadow-2xl rounded-2xl border border-white/50 dark:border-white/10">
          <div class="p-6">
            <div class="flex items-center justify-between mb-6">
              <h3 class="text-xl font-bold">Photo Info</h3>
              <button onclick="toggleMetadata()" class="w-8 h-8 rounded-full hover:bg-zinc-100 dark:hover:bg-zinc-800 flex items-center justify-center transition-colors">
                <i data-lucide="x" class="w-5 h-5"></i>
              </button>
            </div>

            <div id="metadata-content" class="space-y-6"></div>
          </div>
        </div>
      </div>
      """)
  }

  // Helper method to create custom styles
  private func createStyles() -> some Markup {
    MarkupString(content: """
      <style>
        /* Jelly animation for dropdowns */
        @keyframes jellyIn {
          0% {
            opacity: 0;
            transform: scale(0.8) translateY(-10px);
          }
          50% {
            transform: scale(1.05) translateY(0);
          }
          70% {
            transform: scale(0.95);
          }
          100% {
            opacity: 1;
            transform: scale(1) translateY(0);
          }
        }

        .filter-dropdown.active {
          display: block;
          animation: jellyIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        /* Smooth scrolling for thumbnails */
        #lightbox-thumbnails::-webkit-scrollbar {
          height: 6px;
        }

        #lightbox-thumbnails::-webkit-scrollbar-track {
          background: rgba(255, 255, 255, 0.1);
          border-radius: 3px;
        }

        #lightbox-thumbnails::-webkit-scrollbar-thumb {
          background: rgba(255, 255, 255, 0.3);
          border-radius: 3px;
        }

        #lightbox-thumbnails::-webkit-scrollbar-thumb:hover {
          background: rgba(255, 255, 255, 0.5);
        }

        /* Selected filter option styling */
        .filter-option.selected {
          background: rgba(20, 184, 166, 0.15) !important;
          color: rgb(20, 184, 166);
          font-weight: 600;
        }

        .dark .filter-option.selected {
          background: rgba(20, 184, 166, 0.2) !important;
          color: rgb(94, 234, 212);
        }

        /* Metadata panel jelly animation */
        #metadata-panel.active {
          display: block;
          animation: jellyIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        /* Map styling - minimal grayscale */
        .map-container iframe {
          opacity: 0.8;
        }
      </style>
      """)
  }

  // Helper method to create JavaScript functionality
  private func createScripts() -> some Markup {
    let photosJSON = album.photos.map { photo in
      let locationJSON: String
      if let location = photo.metadata.location {
        locationJSON = "{\"lat\": \(location.latitude), \"lng\": \(location.longitude)}"
      } else {
        locationJSON = "null"
      }

      let keywordsJSON = photo.metadata.keywords.map { "\"\($0)\"" }.joined(separator: ", ")

      return """
      {
        "src": "\(photo.webPath)",
        "alt": "\(photo.altText)",
        "caption": \(photo.caption != nil ? "\"\(photo.caption!)\"" : "null"),
        "metadata": {
          "camera": \(photo.metadata.camera != nil ? "\"\(photo.metadata.camera!)\"" : "null"),
          "lens": \(photo.metadata.lens != nil ? "\"\(photo.metadata.lens!)\"" : "null"),
          "focalLength": \(photo.metadata.focalLength != nil ? "\(photo.metadata.focalLength!)" : "null"),
          "aperture": \(photo.metadata.aperture != nil ? "\(photo.metadata.aperture!)" : "null"),
          "shutterSpeed": \(photo.metadata.shutterSpeed != nil ? "\(photo.metadata.shutterSpeed!)" : "null"),
          "iso": \(photo.metadata.iso != nil ? "\(photo.metadata.iso!)" : "null"),
          "dateTaken": \(photo.metadata.dateTaken != nil ? "\"\(photo.metadata.dateTaken!.ISO8601Format())\"" : "null"),
          "location": \(locationJSON),
          "locationName": \(photo.metadata.locationName != nil ? "\"\(photo.metadata.locationName!)\"" : "null"),
          "keywords": [\(keywordsJSON)],
          "isRaw": \(photo.metadata.isRaw),
          "width": \(photo.metadata.width != nil ? "\(photo.metadata.width!)" : "null"),
          "height": \(photo.metadata.height != nil ? "\(photo.metadata.height!)" : "null"),
          "fileSize": \(photo.metadata.fileSize != nil ? "\"\(photo.metadata.formattedFileSize!)\"" : "null")
        }
      }
      """
    }.joined(separator: ",\n")

    return Script(placement: .body) {
      """
      (function() {
        const photos = [\(photosJSON)];
        let currentPhotoIndex = 0;
        let activeFilters = {
          location: '',
          camera: '',
          gps: '',
          keyword: ''
        };

        // Filter dropdown toggle with jelly animation
        window.toggleFilterDropdown = function(type) {
          const dropdown = document.getElementById(`${type}-dropdown`);
          const allDropdowns = document.querySelectorAll('.filter-dropdown');

          // Close all other dropdowns
          allDropdowns.forEach(d => {
            if (d !== dropdown) {
              d.classList.remove('active');
              d.classList.add('hidden');
            }
          });

          // Toggle current dropdown
          if (dropdown.classList.contains('hidden')) {
            dropdown.classList.remove('hidden');
            dropdown.classList.add('active');
          } else {
            dropdown.classList.remove('active');
            setTimeout(() => dropdown.classList.add('hidden'), 200);
          }
        };

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
          if (!e.target.closest('.filter-dropdown-container')) {
            document.querySelectorAll('.filter-dropdown').forEach(d => {
              d.classList.remove('active');
              d.classList.add('hidden');
            });
          }
        });

        // Select filter
        window.selectFilter = function(type, value) {
          activeFilters[type] = value;

          // Update selected state on filter options
          document.querySelectorAll(`[data-filter-type="${type}"]`).forEach(btn => {
            if (btn.dataset.filterValue === value) {
              btn.classList.add('selected');
            } else {
              btn.classList.remove('selected');
            }
          });

          applyFilters();
          toggleFilterDropdown(type);
        };

        // Apply filters
        function applyFilters() {
          const photoItems = document.querySelectorAll('.photo-item');
          let visibleCount = 0;

          photoItems.forEach(item => {
            let show = true;

            if (activeFilters.location && item.dataset.location !== activeFilters.location) {
              show = false;
            }

            if (activeFilters.camera && item.dataset.camera !== activeFilters.camera) {
              show = false;
            }

            if (activeFilters.gps && item.dataset.hasLocation !== activeFilters.gps) {
              show = false;
            }

            if (activeFilters.keyword) {
              const keywords = item.dataset.keywords ? item.dataset.keywords.split(',') : [];
              if (!keywords.includes(activeFilters.keyword)) {
                show = false;
              }
            }

            if (show) {
              item.style.display = '';
              visibleCount++;
            } else {
              item.style.display = 'none';
            }
          });

          const countEl = document.getElementById('photo-count');
          if (countEl) {
            countEl.textContent = `${visibleCount} photo${visibleCount === 1 ? '' : 's'}`;
          }
        }

        // Reset filters
        window.resetFilters = function() {
          activeFilters = {
            location: '',
            camera: '',
            gps: '',
            keyword: ''
          };

          // Reset all selected states
          document.querySelectorAll('.filter-option').forEach(btn => {
            if (btn.dataset.filterValue === '') {
              btn.classList.add('selected');
            } else {
              btn.classList.remove('selected');
            }
          });

          applyFilters();
        };

        // Lightbox functions
        window.openLightbox = function(index) {
          currentPhotoIndex = index;
          const modal = document.getElementById('lightbox-modal');
          modal.classList.remove('hidden');
          document.body.style.overflow = 'hidden';
          updateLightboxImage();
          updateThumbnails();
        };

        window.closeLightbox = function() {
          const modal = document.getElementById('lightbox-modal');
          modal.classList.add('hidden');
          document.body.style.overflow = '';
          document.getElementById('metadata-panel').classList.add('hidden');
        };

        window.navigateLightbox = function(direction) {
          currentPhotoIndex = (currentPhotoIndex + direction + photos.length) % photos.length;
          updateLightboxImage();
          updateThumbnails();
        };

        function updateLightboxImage() {
          const photo = photos[currentPhotoIndex];
          document.getElementById('lightbox-image').src = photo.src;
          document.getElementById('lightbox-image').alt = photo.alt;
          updateMetadataPanel();
        }

        function updateThumbnails() {
          const container = document.getElementById('lightbox-thumbnails');
          container.innerHTML = '';

          // Show 5 thumbnails: 2 before, current, 2 after
          const start = Math.max(0, currentPhotoIndex - 2);
          const end = Math.min(photos.length, currentPhotoIndex + 3);

          for (let i = start; i < end; i++) {
            const thumb = document.createElement('div');
            thumb.className = `w-16 h-16 rounded-lg overflow-hidden cursor-pointer transition-all ${i === currentPhotoIndex ? 'ring-2 ring-white opacity-100 scale-110' : 'opacity-50 hover:opacity-100'}`;
            thumb.onclick = () => {
              currentPhotoIndex = i;
              updateLightboxImage();
              updateThumbnails();
            };

            const img = document.createElement('img');
            img.src = photos[i].src;
            img.alt = photos[i].alt;
            img.className = 'w-full h-full object-cover';
            thumb.appendChild(img);

            container.appendChild(thumb);
          }
        }

        window.toggleMetadata = function() {
          const panel = document.getElementById('metadata-panel');

          if (panel.classList.contains('hidden')) {
            // Show panel with jelly animation
            panel.classList.remove('hidden');
            panel.classList.add('active');
            updateMetadataPanel();
            if (typeof lucide !== 'undefined') {
              lucide.createIcons();
            }
          } else {
            // Hide panel
            panel.classList.remove('active');
            setTimeout(() => panel.classList.add('hidden'), 200);
          }
        };

        function updateMetadataPanel() {
          const photo = photos[currentPhotoIndex];
          const content = document.getElementById('metadata-content');

          let html = '';

          // Caption
          if (photo.caption) {
            html += `
              <div>
                <div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Caption</div>
                <div class="text-sm">${photo.caption}</div>
              </div>
            `;
          }

          // Keywords (show after caption)
          if (photo.metadata.keywords && photo.metadata.keywords.length > 0) {
            html += `
              <div>
                <div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Keywords</div>
                <div class="flex flex-wrap gap-2">
                  ${photo.metadata.keywords.map(k => `<a href="/photos/all?keyword=${encodeURIComponent(k)}" class="px-2 py-1 bg-blue-50 dark:bg-blue-950/30 text-blue-700 dark:text-blue-300 text-xs rounded-full hover:bg-blue-100 dark:hover:bg-blue-950/50 transition-colors cursor-pointer">${k}</a>`).join('')}
                </div>
              </div>
            `;
          }

          // Camera info
          if (photo.metadata.camera) {
            html += `
              <div>
                <div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Camera</div>
                <div class="text-sm">${photo.metadata.camera}</div>
                ${photo.metadata.lens ? `<div class="text-xs text-zinc-500 mt-1">${photo.metadata.lens}</div>` : ''}
              </div>
            `;
          }

          // Shooting parameters
          if (photo.metadata.focalLength || photo.metadata.aperture || photo.metadata.shutterSpeed || photo.metadata.iso) {
            html += '<div><div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Settings</div><div class="grid grid-cols-2 gap-2 text-sm">';

            if (photo.metadata.focalLength) html += `<div><span class="text-zinc-500">Focal:</span> ${photo.metadata.focalLength}mm</div>`;
            if (photo.metadata.aperture) html += `<div><span class="text-zinc-500">Aperture:</span> f/${photo.metadata.aperture}</div>`;
            if (photo.metadata.shutterSpeed) html += `<div><span class="text-zinc-500">Shutter:</span> 1/${Math.round(1/photo.metadata.shutterSpeed)}s</div>`;
            if (photo.metadata.iso) html += `<div><span class="text-zinc-500">ISO:</span> ${photo.metadata.iso}</div>`;

            html += '</div></div>';
          }

          // Image info
          if (photo.metadata.width || photo.metadata.fileSize) {
            html += '<div><div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Image Info</div><div class="space-y-1 text-sm">';

            if (photo.metadata.width && photo.metadata.height) {
              html += `<div><span class="text-zinc-500">Size:</span> ${photo.metadata.width} × ${photo.metadata.height}</div>`;
            }

            if (photo.metadata.fileSize) {
              html += `<div><span class="text-zinc-500">File:</span> ${photo.metadata.fileSize}</div>`;
            }

            // RAW indicator
            html += `
              <div class="flex items-center gap-2 mt-2">
                <div class="px-2 py-1 rounded text-xs font-semibold ${photo.metadata.isRaw ? 'bg-teal-500 text-white' : 'bg-zinc-200 dark:bg-zinc-700 text-zinc-500'}">
                  RAW
                </div>
              </div>
            `;

            html += '</div></div>';
          }

          // Location with map
          if (photo.metadata.location) {
            html += `
              <div>
                <div class="text-sm font-semibold text-zinc-600 dark:text-zinc-400 mb-2">Location</div>
                <div class="text-sm mb-3">${photo.metadata.locationName || 'Unknown location'}</div>
                <div class="w-full h-48 bg-zinc-100 dark:bg-zinc-800 rounded-lg overflow-hidden map-container">
                  <iframe
                    width="100%"
                    height="100%"
                    frameborder="0"
                    scrolling="no"
                    marginheight="0"
                    marginwidth="0"
                    src="https://www.openstreetmap.org/export/embed.html?bbox=${photo.metadata.location.lng-0.01},${photo.metadata.location.lat-0.01},${photo.metadata.location.lng+0.01},${photo.metadata.location.lat+0.01}&layer=mapnik&marker=${photo.metadata.location.lat},${photo.metadata.location.lng}"
                    style="filter: grayscale(100%) contrast(1.1) brightness(1.1);"
                  ></iframe>
                </div>
              </div>
            `;
          }

          content.innerHTML = html;
        }

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
          const modal = document.getElementById('lightbox-modal');
          if (!modal.classList.contains('hidden')) {
            if (e.key === 'Escape') closeLightbox();
            else if (e.key === 'ArrowLeft') navigateLightbox(-1);
            else if (e.key === 'ArrowRight') navigateLightbox(1);
            else if (e.key === 'i' || e.key === 'I') toggleMetadata();
          }
        });

        // Initialize selected states on page load
        document.addEventListener('DOMContentLoaded', function() {
          // Set all "All" options as selected by default
          document.querySelectorAll('.filter-option').forEach(btn => {
            if (btn.dataset.filterValue === '') {
              btn.classList.add('selected');
            }
          });
        });
      })();
      """
    }
  }

  // Helper methods to get unique metadata values
  private func getUniqueLocations() -> [String] {
    Array(Set(album.photos.compactMap { $0.metadata.locationName })).sorted()
  }

  private func getUniqueCameras() -> [String] {
    Array(Set(album.photos.compactMap { $0.metadata.camera })).sorted()
  }

  private func getUniqueKeywords() -> [String] {
    Array(Set(album.photos.flatMap { $0.metadata.keywords })).sorted()
  }
}
