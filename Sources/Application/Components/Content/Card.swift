import Foundation
import WebUI

public struct Card: Element {
  public let title: String
  public let description: String
  public let tags: [String]

  public let linkURL: String?
  public let linkText: String?
  public let newTab: Bool

  public let emoji: String?
  public let imageURL: String?
  public let photoStackURLs: [String]?
  public let photoStackId: String?
  public let publishedDate: Date?
  public let readTime: String?

  public init(
    title: String,
    description: String,
    tags: [String] = [],
    linkURL: String? = nil,
    linkText: String? = nil,
    newTab: Bool = false,
    emoji: String? = nil,
    imageURL: String? = nil,
    photoStackURLs: [String]? = nil,
    photoStackId: String? = nil,
    publishedDate: Date? = nil,
    readTime: String? = nil
  ) {
    self.title = title
    self.description = description
    self.tags = tags
    self.linkURL = linkURL
    self.linkText = linkText
    self.newTab = newTab
    self.emoji = emoji
    self.imageURL = imageURL
    self.photoStackURLs = photoStackURLs
    self.photoStackId = photoStackId
    self.publishedDate = publishedDate
    self.readTime = readTime
  }

  public var body: some Markup {
    let cardContent = Stack(classes: [
      "flex", "flex-col",
      "bg-white/70", "dark:bg-zinc-800/70",
      "backdrop-blur-xl", "backdrop-saturate-150",
      "rounded-2xl",
      "shadow-lg", "shadow-zinc-200/50", "dark:shadow-zinc-950/50",
      "border", "border-white/20", "dark:border-zinc-700/50",
      "overflow-hidden",
      "hover:shadow-md", "hover:shadow-teal-500/15",
      "dark:hover:shadow-teal-400/15",
      "hover:scale-[1.02]",
      "transition-shadow", "duration-[800ms]", "ease-in-out",
      "transition-transform", "duration-300", "ease-out",
      "cursor-pointer", "card", "reveal-card",
      "group-[.masonry-small]/masonry:min-h-[180px]",
      "group-[.masonry-medium]/masonry:min-h-[200px]",
      "min-h-[220px]",
    ]) {

      // Cover image or photo stack if provided
      if let photoStackURLs = photoStackURLs, let photoStackId = photoStackId, !photoStackURLs.isEmpty {
        AnimatedPhotoStack(photos: photoStackURLs, albumId: photoStackId)
      } else if let imageURL = imageURL {
        Image(
          source: imageURL,
          description: title,
          classes: [
            "w-full", "h-48", "object-cover",
            "transition-transform", "duration-300",
            "group-hover:scale-105",
          ]
        )
      }

      // Content section with padding
      Stack(classes: ["flex", "flex-col", "flex-1", "p-6"]) {
        // Header row: emoji + read time
        Stack(classes: ["flex", "items-start", "justify-between", "mb-4"]) {
          if let emoji {
            Stack(classes: [
              "w-12", "h-12",
              "bg-teal-50/80", "dark:bg-teal-950/50",
              "backdrop-blur-sm",
              "rounded-xl",
              "flex", "items-center", "justify-center",
              "border", "border-teal-200/50", "dark:border-teal-800/50",
            ]) {
              Text(emoji, classes: ["text-2xl"])
            }
          }

          // Read time in top-right
          if let readTime = readTime {
            Text(
              readTime,
              classes: [
                "px-2.5", "py-1", "text-xs", "font-medium",
                "bg-zinc-100/80", "dark:bg-zinc-700/80",
                "backdrop-blur-sm",
                "rounded-full",
                "border", "border-zinc-200/50", "dark:border-zinc-600/50",
              ]
            )
          }
        }

        // Main content: title, date, description
        Stack(classes: ["flex", "flex-col"]) {
          Heading(
            .headline,
            title,
            classes: [
              "text-lg", "font-semibold", "mb-2", "transition-colors",
            ]
          )

          // Published date below title
          if let date = publishedDate {
            Time(
              datetime: date.ISO8601Format(),
              classes: [
                "text-xs", "text-zinc-500/70", "dark:text-zinc-500/70", "mb-3",
              ]
            ) {
              DateFormatter.articleDate.string(from: date)
            }
          }

          // Keywords after date
          if !tags.isEmpty {
            Stack(classes: ["flex", "flex-wrap", "gap-2", "mb-3"]) {
              for tag in tags {
                Text(
                  tag,
                  classes: [
                    "px-2.5", "py-1", "text-xs", "font-medium",
                    "bg-zinc-100/80", "dark:bg-zinc-700/80",
                    "backdrop-blur-sm",
                    "rounded-full",
                    "border", "border-zinc-200/50", "dark:border-zinc-600/50",
                  ]
                )
              }
            }
          }

          // Summary/description
          if !description.isEmpty {
            Text(
              description,
              classes: [
                "text-sm", "flex-1", "mb-4",
              ]
            )
          }

          // Footer: link text
          Stack(classes: ["mt-auto", "pt-6"]) {
            if let linkText {
              Text(
                linkText + " →",
                classes: [
                  "text-sm", "font-semibold",
                  "text-teal-600", "dark:text-teal-400",
                  "self-end",
                  "px-4", "py-2",
                  "bg-teal-50/80", "dark:bg-teal-950/30",
                  "backdrop-blur-sm",
                  "rounded-full",
                  "border", "border-teal-200/50", "dark:border-teal-800/50",
                ]
              )
            }
          }
        }
      }
    }

    if let url = linkURL {
      return AnyMarkup(
        Link(to: url, newTab: newTab) {
          cardContent
        }
      )
    } else {
      return AnyMarkup(cardContent)
    }
  }
}
