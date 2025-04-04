import WebUI

struct Link: HTML {
  let href: String
  let label: String?
  let newTab: Bool
  let full: Bool

  init(to href: String, label: String? = nil, newTab: Bool = false, full: Bool = false) {
    self.href = href
    self.label = label
    self.newTab = newTab
    self.full = full
  }

  func render() -> String {
    let anchor = Anchor(to: href, newTab: newTab) { label ?? "" }
      .cursor(.pointer)
      .transition(property: .colors, duration: 300)
      .font(color: .teal(._600), on: .hover)

    if full {
      return Stack {
        anchor.render()
        Stack().position(.absolute, edges: .all)
      }.render()
    }

    return anchor.render()
  }
}
