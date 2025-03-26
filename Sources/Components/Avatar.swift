import WebUI

struct Avatar: HTML {
  func render() -> String {
    Image(
      sources: ["/avatar.png"],
      description: "Mac Long's Avatar"
    )
    .frame(width: .fixed(32), height: .fixed(32))
    .border(width: 1, edges: .all, radius: (side: .all, size: .full))
    .padding(.horizontal, length: 3)
    .render()
  }
}
