import Foundation
import WebUI

struct Uses: HTML {
  func render() -> String {
    RootLayout {
      Hero(
        heading: "Software I use, gadgets I love, and other things I recommend.",
        text:
          "I have spent a fair amount of time improving my work process, and I've compiled a list of the things I use to stay productive and enjoy my work."
      )
      Section {
        List {  // for loop of article
        }
      }
    }.render()
  }
}
