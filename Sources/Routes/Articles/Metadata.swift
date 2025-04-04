import Foundation
import WebUI

struct ArticleMetadata {
  let slug: String
  let title: String
  let description: String
  let date: Date
  let content: HTML

  init(
    slug: String,
    title: String,
    description: String,
    date: String,
    content: HTML
  ) {
    self.slug = slug
    self.title = title
    self.description = description
    self.date = ISO8601DateFormatter().date(from: date) ?? Date()
    self.content = content
  }
}
