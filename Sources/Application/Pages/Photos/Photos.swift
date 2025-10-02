import Foundation
import WebUI

struct Photos: Document {
  var path: String? { "photos" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Photos")
  }

  // Load albums to display under photos
  private var albums: [AlbumResponse] {
    do {
      let allAlbums = try PhotosService.fetchAllAlbumsWithAll().sorted { (lhs, rhs) in
        // Keep "All" album first
        if lhs.id == "all" { return true }
        if rhs.id == "all" { return false }

        // Sort rest by date descending (newest first)
        guard let lhsDate = lhs.date,
              let rhsDate = rhs.date else {
          return false
        }
        return lhsDate > rhsDate
      }

      return allAlbums
    } catch {
      print("Error loading albums: \(error)")
      return []
    }
  }

  // Calculate total photo count across all albums (excluding "All" album to avoid duplication)
  private var totalPhotoCount: Int {
    albums.filter { $0.id != "all" }.reduce(0) { $0 + $1.photos.count }
  }

  var body: some Markup {
    Layout(
      path: "photos",
      title: "Photos - Mac Long",
      description: "Photo albums from travels and life",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Photos", url: "/photos"),
      ]
    ) {
      if albums.isEmpty {
        Stack(classes: ["max-w-4xl", "mx-auto", "text-center", "py-12", "bg-white/50", "dark:bg-zinc-800/50", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm"]) {
          Icon(name: "camera", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
          Heading(.headline, "No albums yet", classes: ["text-lg", "font-semibold", "mb-2"])
          Text("Check back soon for photo albums!", classes: ["opacity-75"])
        }
      } else {
        StandardPageLayout(
          title: "Photos",
          iconName: "camera",
          count: totalPhotoCount,
          countLabel: "photo",
          description: "Photo albums from travels and life."
        ) {
          Stack(classes: ["grid", "md:grid-cols-2", "gap-6", "max-w-4xl", "mx-auto", "auto-rows-min"]) {
            for album in albums {
              AnimatedAlbumCard(album: album)
            }
          }
        }
      }
    }
  }
}
