import Foundation
import WebUI

struct Uses: HTML {
  func render() -> String {
    Fragment {
      Hero(
        heading: "Software I use, gadgets I love, and other things I recommend.",
        text:
          "I get asked a lot about the things I use to build software, stay productive, or buy to fool myself into thinking I’m being productive when I’m really just procrastinating. Here’s a big list of all of my favorite stuff."
      )
      Section {
        List {  // for loop of article
        }
      }
    }.render()
  }
}
