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
      Stack(classes: ["max-w-6xl", "mx-auto"]) {
        // Album Header
        Stack(classes: ["mb-8"]) {
          Heading(.largeTitle, album.name, classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])

          Stack(classes: ["flex", "items-center", "gap-4", "text-sm", "mb-4"]) {
            if let date = album.date {
              Stack(classes: ["flex", "items-center", "gap-2"]) {
                Icon(name: "calendar", classes: ["w-4", "h-4"])
                Time(datetime: date.ISO8601Format()) {
                  DateFormatter.articleDate.string(from: date)
                }
              }
            }

            Stack(classes: ["flex", "items-center", "gap-2"]) {
              Icon(name: "image", classes: ["w-4", "h-4"])
              Text(
                "\(album.photos.count) photo\(album.photos.count == 1 ? "" : "s")",
                id: "photo-count"
              )
            }
          }
        }

        // Filter Panel - Apple-inspired glassmorphism
        Stack(classes: [
          "mb-8", "p-6",
          "bg-white/70", "dark:bg-zinc-900/70",
          "backdrop-blur-xl", "backdrop-saturate-150",
          "rounded-2xl",
          "shadow-lg", "shadow-zinc-200/50", "dark:shadow-zinc-950/50",
          "border", "border-white/20", "dark:border-zinc-800/50",
        ]) {
          Stack(classes: ["flex", "items-center", "justify-between", "mb-6"]) {
            Heading(.headline, "Filters", classes: ["text-xl", "font-semibold"])
            Button(
              onClick: "resetFilters()",
              classes: [
                "px-4", "py-2",
                "text-sm", "font-medium",
                "text-teal-600", "dark:text-teal-400",
                "bg-teal-50/80", "dark:bg-teal-950/30",
                "hover:bg-teal-100/80", "dark:hover:bg-teal-900/40",
                "rounded-full",
                "transition-all", "duration-200",
                "cursor-pointer",
                "backdrop-blur-sm",
              ],
              label: "Reset"
            ) {
              Text("Reset all")
            }
          }

          Stack(classes: ["grid", "grid-cols-1", "md:grid-cols-3", "gap-6"]) {
            // Location filter
            if !getUniqueLocations().isEmpty {
              Stack(classes: ["flex", "flex-col", "gap-3"]) {
                Label(for: "filter-location") {
                  Text("Location", classes: ["text-sm", "font-semibold", "text-zinc-700", "dark:text-zinc-300"])
                }
                MarkupString(
                  content:
                    """
                    <select id="filter-location" onchange="applyFilters()" class="w-full px-4 py-3 rounded-xl bg-white/80 dark:bg-zinc-800/80 backdrop-blur-sm border border-zinc-200/50 dark:border-zinc-700/50 text-sm font-medium shadow-sm hover:shadow-md transition-all duration-200 cursor-pointer focus:outline-none focus:ring-2 focus:ring-teal-500/50 focus:border-teal-500/50">
                      <option value="">All locations</option>
                      \(getUniqueLocations().map { "<option value=\"\($0)\">\($0)</option>" }.joined())
                    </select>
                    """
                )
              }
            }

            // Camera filter
            if !getUniqueCameras().isEmpty {
              Stack(classes: ["flex", "flex-col", "gap-3"]) {
                Label(for: "filter-camera") {
                  Text("Camera", classes: ["text-sm", "font-semibold", "text-zinc-700", "dark:text-zinc-300"])
                }
                MarkupString(
                  content:
                    """
                    <select id="filter-camera" onchange="applyFilters()" class="w-full px-4 py-3 rounded-xl bg-white/80 dark:bg-zinc-800/80 backdrop-blur-sm border border-zinc-200/50 dark:border-zinc-700/50 text-sm font-medium shadow-sm hover:shadow-md transition-all duration-200 cursor-pointer focus:outline-none focus:ring-2 focus:ring-teal-500/50 focus:border-teal-500/50">
                      <option value="">All cameras</option>
                      \(getUniqueCameras().map { "<option value=\"\($0)\">\($0)</option>" }.joined())
                    </select>
                    """
                )
              }
            }

            // Has location filter
            Stack(classes: ["flex", "flex-col", "gap-3"]) {
              Label(for: "filter-has-location") {
                Text("GPS Data", classes: ["text-sm", "font-semibold", "text-zinc-700", "dark:text-zinc-300"])
              }
              MarkupString(
                content:
                  """
                  <select id="filter-has-location" onchange="applyFilters()" class="w-full px-4 py-3 rounded-xl bg-white/80 dark:bg-zinc-800/80 backdrop-blur-sm border border-zinc-200/50 dark:border-zinc-700/50 text-sm font-medium shadow-sm hover:shadow-md transition-all duration-200 cursor-pointer focus:outline-none focus:ring-2 focus:ring-teal-500/50 focus:border-teal-500/50">
                    <option value="">All photos</option>
                    <option value="true">With location</option>
                    <option value="false">Without location</option>
                  </select>
                  """
              )
            }
          }
        }

        // Photo Grid
        Stack(
          id: "photo-grid",
          classes: [
            "grid", "grid-cols-1", "sm:grid-cols-2", "md:grid-cols-3", "gap-4", "mb-12",
          ]
        ) {
          for photo in album.photos {
            Link(
              to: photo.webPath,
              newTab: true,
              classes: [
                "group", "relative", "overflow-hidden",
                "rounded-2xl",
                "aspect-square",
                "bg-gradient-to-br", "from-zinc-100", "to-zinc-50",
                "dark:from-zinc-800", "dark:to-zinc-900",
                "shadow-md", "hover:shadow-2xl",
                "hover:shadow-teal-500/10", "dark:hover:shadow-teal-400/10",
                "transition-all", "duration-500", "ease-out",
                "reveal-card", "photo-item",
                "border", "border-zinc-200/50", "dark:border-zinc-700/50",
                "hover:scale-[1.02]",
              ],
              data: [
                "location": photo.metadata.locationName ?? "",
                "camera": photo.metadata.camera ?? "",
                "has-location": photo.metadata.hasLocation ? "true" : "false",
              ]
            ) {
              Stack(classes: ["relative", "w-full", "h-full"]) {
                Image(
                  source: photo.webPath,
                  description: photo.altText,
                  classes: [
                    "w-full", "h-full", "object-cover",
                    "group-hover:scale-110",
                    "transition-transform", "duration-700", "ease-out",
                  ]
                )

                // Show metadata overlay on hover with glassmorphism
                if let caption = photo.caption {
                  Stack(classes: [
                    "absolute", "inset-0",
                    "bg-gradient-to-t", "from-black/90", "via-black/40", "to-transparent",
                    "backdrop-blur-sm",
                    "p-4", "flex", "items-end",
                    "opacity-0", "group-hover:opacity-100",
                    "transition-all", "duration-500",
                  ]) {
                    Text(
                      caption,
                      classes: [
                        "text-white", "text-sm", "font-medium", "leading-relaxed",
                        "line-clamp-3",
                        "drop-shadow-lg",
                      ]
                    )
                  }
                }
              }
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

        // Filter JavaScript
        Script(placement: .body) {
          """
          (function() {
            function applyFilters() {
              const locationFilter = document.getElementById('filter-location')?.value || '';
              const cameraFilter = document.getElementById('filter-camera')?.value || '';
              const hasLocationFilter = document.getElementById('filter-has-location')?.value || '';

              const photos = document.querySelectorAll('.photo-item');
              let visibleCount = 0;

              photos.forEach(photo => {
                let show = true;

                // Filter by location
                if (locationFilter && photo.dataset.location !== locationFilter) {
                  show = false;
                }

                // Filter by camera
                if (cameraFilter && photo.dataset.camera !== cameraFilter) {
                  show = false;
                }

                // Filter by has location
                if (hasLocationFilter && photo.dataset.hasLocation !== hasLocationFilter) {
                  show = false;
                }

                if (show) {
                  photo.style.display = '';
                  visibleCount++;
                } else {
                  photo.style.display = 'none';
                }
              });

              // Update count
              const countEl = document.getElementById('photo-count');
              if (countEl) {
                countEl.textContent = `${visibleCount} photo${visibleCount === 1 ? '' : 's'}`;
              }
            }

            function resetFilters() {
              const locationFilter = document.getElementById('filter-location');
              const cameraFilter = document.getElementById('filter-camera');
              const hasLocationFilter = document.getElementById('filter-has-location');

              if (locationFilter) locationFilter.value = '';
              if (cameraFilter) cameraFilter.value = '';
              if (hasLocationFilter) hasLocationFilter.value = '';

              applyFilters();
            }

            // Make functions globally available
            window.applyFilters = applyFilters;
            window.resetFilters = resetFilters;
          })();
          """
        }
      }
    }
  }

  // Helper methods to get unique metadata values
  private func getUniqueLocations() -> [String] {
    Array(Set(album.photos.compactMap { $0.metadata.locationName })).sorted()
  }

  private func getUniqueCameras() -> [String] {
    Array(Set(album.photos.compactMap { $0.metadata.camera })).sorted()
  }
}
