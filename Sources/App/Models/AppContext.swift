import SwiftHtml

struct LayoutContext {
  let title: String
  let description: String
  let url: String
  var type: String = "website"
  var image: String = "og.webp"
  var theme: String = "#000"
  let body: Tag
}

struct Skill {
  let name: String
  let description: String
  let icon: String
}

struct Project {
  let name: String
  let summary: String
  let tag: String
  let url: String
  var new: Bool = false
  var hidden: Bool = false
}

struct HomeProps {
  let skills: [Skill]
  let projects: [Project]
}
