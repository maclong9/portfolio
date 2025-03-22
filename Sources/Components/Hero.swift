import Foundation
import WebUI

struct Hero: HTML {
  struct Avatar {
    let src: String
    let description: String
  }

  struct Social {
    let icon: String
    let url: String
  }

  let image: Avatar?
  let heading: String
  let text: String
  let socials: [Social]?

  init(
    image: Avatar? = nil,
    heading: String,
    text: String,
    socials: [Social]? = nil
  ) {
    self.image = image
    self.heading = heading
    self.text = text
    self.socials = socials
  }

  func render() -> String {
    Section {
      if let image {
        Image(sources: [image.src], description: image.description)
      }
      Heading(level: .one) { heading }
      Text { text }
      if let socials {
        Navigation {
          for social in socials {
            Link(to: social.url, newTab: true) { social.icon }
          }
        }
      }
    }.render()
  }
}
