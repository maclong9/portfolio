import Foundation
import WebUI

public struct AnimatedPhotoStack: Element {
  public let photos: [String]
  public let albumId: String

  public init(photos: [String], albumId: String) {
    self.photos = photos
    self.albumId = albumId
  }

  public var body: some Markup {
    Stack(
      id: "photo-stack-\(albumId)",
      classes: [
        "relative",
        "w-full",
        "h-48",
        "flex",
        "items-center",
        "justify-center",
        "overflow-visible"
      ],
      data: [
        "photo-stack": "true",
        "photos": photos.joined(separator: ",")
      ]
    ) {
      // Render up to 5 photos in the stack
      for (index, photoURL) in photos.prefix(5).enumerated() {
        Image(
          source: photoURL,
          description: "Album photo \(index + 1)",
          classes: [
            "absolute",
            "w-64", "h-40",
            "group-[.masonry-medium]/masonry:w-32", "group-[.masonry-medium]/masonry:h-32",
            "group-[.masonry-small]/masonry:w-32", "group-[.masonry-small]/masonry:h-32",
            "object-cover",
            "rounded-xl",
            "shadow-lg",
            "photo-stack-item",
            "transition-all",
            "duration-700",
            "ease-out"
          ],
          data: [
            "stack-index": String(index)
          ]
        )
      }
    }
  }
}
