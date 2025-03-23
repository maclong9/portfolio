import Foundation
import WebUI

struct ExampleArticle: HTML {
  func render() -> String {
    Fragment {
      Text { "Hello, World!" }
    }.render()
  }
}
