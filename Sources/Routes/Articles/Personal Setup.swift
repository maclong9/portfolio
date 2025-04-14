import Foundation
import WebUI

struct PersonalSetup: HTML {
  func render() -> String {
    Article {
      Section {
        Header {
          Heading(level: .two) { "Introduction" }.styled(size: .xl3)
          Text {
            "This is a collection of tools and software that I find indispensable for my daily work as a software engineer. A couple of notes on things I have chosen not to go into detail about: I use Terminal.app from Apple for my terminal emulator, it's simple effective and doesn't need to be configured. I also utilise the standard Apple Calendar, Notes and Reminders apps for my personal productivity, they do an excellent job of keeping me organised and on track."
          }
        }
      }

      Section {
        Header {
          Heading(level: .two) { "Workstation" }.styled(size: .xl3)
        }
        Main {
          Stack {
            Heading(level: .three) { "14\" MacBook Pro, M3 Pro, 18GB RAM" }.styled(size: .lg)
            Text {
              "This powerhouse serves as the cornerstone of my professional setup. Whether I’m tackling web development, building native applications, or occasionally editing video, the M3 Pro delivers exceptional performance with remarkable efficiency. Video rendering tasks are completed swiftly, usually without even triggering the cooling fans. The only instance I’ve noticed fan activity was while maxing out the graphics settings in Lies of P. I prefer the MacBook’s integrated trackpad and keyboard over external peripherals, finding them precise and ergonomic for my needs—no additional monitors, mice, or keyboards required. The speakers are also wonderful, providing clear and immersive audio."
            }
          }.spaced()
        }
      }.spaced()

      Section {
        Header {
          Heading(level: .two) { "Development Tools" }.styled(size: .xl3)
        }
        Main {
          Stack {
            Heading(level: .three) { "Vim" }.styled(size: .lg)
            Text {
              "Vim is my text editor of choice, prized for its speed, flexibility, and extensive customization options. Its lightweight design accelerates my coding workflow. Pre-installed on macOS and widely available across server environments, Vim ensures I have a consistent, reliable editing experience wherever I work–especially since I started focusing on using it without any plugins."
            }
          }.spaced()
          Stack {
            Heading(level: .three) { "Deno" }.styled(size: .lg)
            Text {
              "When working with TypeScript I rely on Deno as my primary runtime environment. Its emphasis on security, performance, and built-in tooling—such as formatting, linting, and testing—streamlines my development process significantly. I opt to use the Fresh framework, which integrates seamlessly with Deno to provide a modern, efficient stack for delivering high-quality web applications."
            }
          }.spaced()
        }
      }.spaced()
    }.render()
  }

  static var document: Document {
    let title = "Personal Setup"
    let slug = title.slugified()
    let description =
      "Over the years, I’ve refined my workflow to maximize efficiency and enjoyment. In this article I go over some of the choices."
    let date = ISO8601DateFormatter().date(from: "2025-03-31T09:00:00Z") ?? Date()
    let image = "/portfolio/public/articles/\(slug).jpeg"

    return createArticleDocument(
      slug: slug,
      title: title,
      description: description,
      date: date,
      image: image,
      content: PersonalSetup()
    )
  }
}
