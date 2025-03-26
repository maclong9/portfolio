import Foundation
import WebUI

struct Uses: HTML {
  func render() -> String {
    RootLayout {
      Article {
        Hero(
          heading: "Software, Gadgets, and Recommendations for Productivity and Enjoyment",
          text:
            "Over the years, I’ve refined my workflow to maximize efficiency and satisfaction in my professional endeavors. Below, I’ve curated a selection of tools, hardware, and resources that I rely on daily to stay productive and engaged. While I frequently leverage macOS’s built-in applications—like Terminal, Notes and Reminders—for their simplicity and seamless integration, they’re straightforward enough not to warrant detailed discussion here. For Swift development, I turn to Xcode, which offers a robust suite of features tailored to the language."
        )
        Section {
          Aside {
            Heading(level: .two) { "Workstation" }
          }
          Main {
            List {
              Item {
                Heading(level: .three) { "14\" MacBook Pro, M3 Pro, 18GB RAM" }
                Text {
                  "This powerhouse serves as the cornerstone of my professional setup. Whether I’m tackling web development, building native applications, or occasionally editing video, the M3 Pro delivers exceptional performance with remarkable efficiency. Rendering tasks are completed swiftly, usually without even triggering the cooling fans. The only instance I’ve noticed fan activity was while pushing the limits of graphical performance in Lies of P at maximum settings. I prefer the MacBook’s integrated trackpad and keyboard over external peripherals, finding them precise and ergonomic for my needs—no additional monitors, mice, or keyboards required."
                }
              }
            }
          }
        }

        Section {
          Aside {
            Heading(level: .two) { "Development Tools" }
          }
          Main {
            List {
              Item {
                Heading(level: .three) { "Vim" }
                Text {
                  "Vim is my text editor of choice, prized for its speed, flexibility, and extensive customization options. Its lightweight design accelerates my coding workflow, while its vibrant community provides invaluable support for troubleshooting and optimization. Pre-installed on macOS and widely available across server environments, Vim ensures I have a consistent, reliable editing experience wherever I work."
                }
              }
              Item {
                Heading(level: .three) { "Deno" }
                Text {
                  "When working with TypeScript I rely on Deno as my primary runtime environment. Its emphasis on security, performance, and built-in tooling—such as formatting, linting, and testing—streamlines my development process significantly. I opt to use the Fresh framework, which integrates seamlessly with Deno to provide a modern, efficient stack for delivering high-quality web applications."
                }
              }
            }
          }
        }
      }
    }.render()
  }
}
