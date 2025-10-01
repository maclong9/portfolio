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
      return try PhotosService.fetchAllAlbums().sorted { (lhs, rhs) in
        // Sort by date descending (newest first)
        guard let lhsDate = lhs.date,
              let rhsDate = rhs.date else {
          return false
        }
        return lhsDate > rhsDate
      }
    } catch {
      print("Error loading albums: \(error)")
      return []
    }
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
      Stack(classes: ["max-w-4xl", "mx-auto"]) {
        // Page Header
        Stack(classes: ["text-center", "mb-12"]) {
          Heading(.largeTitle, "Photos", classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])
          Text(
            "Photo albums from travels and life.",
            classes: ["text-lg", "max-w-2xl", "mx-auto"]
          )
        }

        // Albums List
        if albums.isEmpty {
          Stack(classes: ["text-center", "py-12"]) {
            Icon(name: "image", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
            Heading(.headline, "No albums yet", classes: ["text-lg", "font-semibold", "mb-2"])
            Text("Check back soon for photo albums!", classes: ["opacity-75"])
          }
        } else {
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
