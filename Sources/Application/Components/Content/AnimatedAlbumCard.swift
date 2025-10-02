import Foundation
import WebUI

public struct AnimatedAlbumCard: Element {
  let album: AlbumResponse

  public init(album: AlbumResponse) {
    self.album = album
  }

  public var body: some Markup {
    let coverPhotos = album.randomCoverPhotos
    let photoCount = "\(album.photos.count) photo\(album.photos.count == 1 ? "" : "s")"

    let cardContent = Link(to: "/photos/\(album.slug)", newTab: false) {
      Stack(classes: [
        "flex", "flex-col", "justify-center",
        "bg-gradient-to-br", "from-white", "to-zinc-50",
        "dark:from-zinc-800", "dark:to-zinc-900",
        "rounded-2xl",
        "shadow-lg", "hover:shadow-md",
        "hover:shadow-teal-500/15", "dark:hover:shadow-teal-400/15",
        "border", "border-zinc-200/50", "dark:border-zinc-700/50",
        "p-6",
        "transition-shadow", "duration-[800ms]", "ease-in-out",
        "transition-transform", "duration-300", "ease-out",
        "cursor-pointer", "card", "reveal-card",
        "min-h-[280px]",
        "hover:scale-[1.02]",
        "backdrop-blur-xl",
        "relative",
        "overflow-hidden",
      ]) {
        // Animated background with rotating photos
        Stack(
          classes: [
            "absolute", "inset-0", "overflow-hidden",
            "rounded-2xl", "opacity-20", "dark:opacity-10",
          ],
          data: ["album-id": album.slug]
        ) {
          for (index, photo) in coverPhotos.enumerated() {
            Stack(
              classes: [
                "absolute", "inset-0",
                "bg-cover", "bg-center",
                "transition-opacity", "duration-1000",
                "album-cover-image",
              ],
              data: [
                "image-index": String(index),
                "album-id": album.slug,
              ]
            ) {
              MarkupString(
                content: """
                  <div class="w-full h-full" style="background-image: url('\(photo.webPath)'); background-size: cover; background-position: center;"></div>
                  """
              )
            }
          }
        }

        // Content overlay
        Stack(classes: ["relative", "z-10"]) {
          // Header row: date + tags
          Stack(classes: ["flex", "items-start", "justify-between", "mb-4"]) {
            if let date = album.date {
              Time(
                datetime: date.ISO8601Format(),
                classes: [
                  "text-sm", "text-zinc-600/90", "dark:text-zinc-400/90",
                  "font-medium",
                  "px-3", "py-1.5",
                  "bg-white/80", "dark:bg-zinc-800/80",
                  "backdrop-blur-sm",
                  "rounded-full",
                  "border", "border-zinc-200/50", "dark:border-zinc-700/50",
                ]
              ) {
                DateFormatter.articleDate.string(from: date)
              }
            }

            if !photoCount.isEmpty {
              Text(
                photoCount,
                classes: [
                  "px-3", "py-1.5", "text-xs",
                  "bg-teal-50/80", "dark:bg-teal-950/50",
                  "text-teal-700", "dark:text-teal-300",
                  "backdrop-blur-sm",
                  "rounded-full",
                  "font-semibold",
                  "border", "border-teal-200/50", "dark:border-teal-800/50",
                ]
              )
            }
          }

          // Main content: title
          Stack(classes: ["flex", "flex-col", "flex-1", "justify-center"]) {
            Heading(
              .headline,
              album.name,
              classes: [
                "text-2xl", "font-bold", "mb-3",
                "text-zinc-900", "dark:text-zinc-100",
                "transition-colors",
                "drop-shadow-sm",
              ]
            )

            // Footer: link text
            Stack(classes: ["mt-auto", "pt-4"]) {
              Text(
                "View album →",
                classes: [
                  "text-sm", "font-semibold",
                  "text-teal-600", "dark:text-teal-400",
                  "self-start",
                  "px-4", "py-2",
                  "bg-teal-50/80", "dark:bg-teal-950/30",
                  "backdrop-blur-sm",
                  "rounded-full",
                  "border", "border-teal-200/50", "dark:border-teal-800/50",
                  "transition-all", "duration-200",
                ]
              )
            }
          }
        }

        // JavaScript for image rotation
        Script(placement: .body) {
          """
          (function() {
            const albumId = '\(album.slug)';
            const images = document.querySelectorAll(`[data-album-id="${albumId}"].album-cover-image`);

            if (images.length <= 1) return;

            let currentIndex = 0;

            // Show first image
            images[0].style.opacity = '1';

            // Rotate images
            setInterval(() => {
              images[currentIndex].style.opacity = '0';
              currentIndex = (currentIndex + 1) % images.length;
              images[currentIndex].style.opacity = '1';
            }, 3000); // Change every 3 seconds
          })();
          """
        }
      }
    }

    return AnyMarkup(cardContent)
  }
}
