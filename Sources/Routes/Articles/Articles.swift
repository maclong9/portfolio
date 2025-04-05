import Foundation
import WebUI

struct ArticleData {
  let slug: String
  let title: String
  let description: String
  let date: Date
  let content: any HTML

  init(slug: String, title: String, description: String, date: String, content: any HTML) {
    self.slug = slug
    self.title = title
    self.description = description
    let formatter = ISO8601DateFormatter()
    self.date = formatter.date(from: date) ?? Date()
    self.content = content
  }
}

let articles: [ArticleData] = [
  ArticleData(
    slug: "personal-setup",
    title: "Personal Setup",
    description:
      "Over the years, I’ve refined my workflow to maximize efficiency and enjoyment. In this article I go over some of the choices.",
    date: "2025-03-31T09:00:00Z",
    content: PersonalSetup()
  )
]
