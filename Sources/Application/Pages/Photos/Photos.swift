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
      ],
      pageHeader: albums.isEmpty ? nil : .collection(
        name: "Photos",
        description: "Photo albums from travels and life"
      )
    ) {
      if albums.isEmpty {
        EmptyState(
          iconName: "camera",
          title: "No albums yet",
          message: "Check back soon for photo albums!"
        )
      } else {
        MasonryCardLayout(
          cards: albums.map { album in
            Card(
              title: album.name,
              description: "\(album.photos.count) photo\(album.photos.count == 1 ? "" : "s")",
              linkURL: "/photos/\(album.slug)",
              linkText: "View album",
              imageURL: album.coverPhoto?.webPath
            )
          }
        )
      }
    }
  }
}
