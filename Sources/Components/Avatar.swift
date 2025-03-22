import WebUI

struct Avatar: HTML {
  func render() -> String {
    Image(
      sources: ["/avatar.png"],
      description: "Mac Long's Avatar"
    ).render()
  }
}
