import Foundation
import WebUI

struct Projects: HTML {
  func render() -> String {
    Fragment {
      Hero(
        heading: "A small collection of projects I've worked on.",
        text:
          "I’ve worked on tons of little projects over the years but these are the ones that I’m most proud of. Many of them are open-source, so if you see something that piques your interest, check out the code and contribute if you have ideas for how it can be improved."
      )

      Section {
        List {  // for loop of projects
        }
      }
    }.render()
  }
}
