import Foundation
import WebUI

struct MoonArticle: HTML {
  func render() -> String {
    Fragment {
      Text { "Hello, World!" }
    }.render()
  }
}
