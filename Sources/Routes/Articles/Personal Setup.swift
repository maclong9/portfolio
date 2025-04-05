import Foundation
import WebUI

struct PersonalSetup: HTML {
  func render() -> String {
    Article {
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
              "Vim is my text editor of choice, prized for its speed, flexibility, and extensive customization options. Its lightweight design accelerates my coding workflow, while its vibrant community provides invaluable support for troubleshooting and optimization. Pre-installed on macOS and widely available across server environments, Vim ensures I have a consistent, reliable editing experience wherever I work."
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
}
