import Foundation
import WebUI

struct ExampleArticle: HTML {
  func render() -> String {
    ArticleLayout(
      date: Date(), title: "Hello, World!", description: "A great example post", image: "/posts/example.jpg"
    ) {

    }.render()
  }
}
