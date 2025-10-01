import Foundation
import WebUI

public struct LayoutHeader: Element {
  let breadcrumbs: [Breadcrumb]?
  let toolControls: MarkupContentBuilder?
  let hidePostsLink: Bool
  let emoji: String?
  let icon: String?

  public init(
    breadcrumbs: [Breadcrumb]? = nil,
    toolControls: MarkupContentBuilder? = nil,
    hidePostsLink: Bool = false,
    emoji: String? = nil,
    icon: String? = nil
  ) {
    self.breadcrumbs = breadcrumbs
    self.toolControls = toolControls
    self.hidePostsLink = hidePostsLink
    self.emoji = emoji
    self.icon = icon
  }

  public var body: some Markup {
    Stack {
      Header(
        id: "main-header",
        classes: [
          "fixed", "top-0", "left-0", "right-0",
          "bg-white/70", "dark:bg-zinc-900/70",
          "backdrop-blur-xl", "backdrop-saturate-150",
          "border-b",
          "border-white/20", "dark:border-zinc-800/50",
          "px-4", "py-6", "z-30",
          "transition-transform", "duration-300", "ease-in-out",
          "shadow-sm", "shadow-zinc-200/50", "dark:shadow-zinc-950/50",
        ]
      ) {
        Stack(classes: ["max-w-4xl", "mx-auto", "flex", "items-center", "justify-between"]) {
          Stack(classes: ["flex", "items-center", "justify-between", "w-full"]) {
            // Navigation or site title
            if let breadcrumbs = breadcrumbs {
              // Mobile breadcrumbs
              Navigation(classes: ["md:hidden", "flex", "items-center", "space-x-1", "text-sm"]) {
                for (index, crumb) in breadcrumbs.prefix(2).enumerated() {
                  if index == 1 && breadcrumbs.count > 2 {
                    Link(
                      crumb.title,
                      to: crumb.url,
                      classes: [
                        "text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600",
                        "dark:hover:text-teal-400", "transition-colors", "cursor-pointer",
                      ]
                    )
                    Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                  } else if index == breadcrumbs.count - 1 {
                    Text(
                      crumb.title,
                      classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"]
                    )
                  } else {
                    Link(
                      crumb.title,
                      to: crumb.url,
                      classes: [
                        "text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600",
                        "dark:hover:text-teal-400", "transition-colors", "cursor-pointer",
                      ]
                    )
                    Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                  }
                }

                if breadcrumbs.count > 2 {
                  if let emoji = emoji {
                    Text(
                      emoji,
                      classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium", "text-lg"]
                    )
                  } else if let icon = icon {
                    Text(
                      icon,
                      classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium", "text-lg"]
                    )
                  } else {
                    Text(
                      breadcrumbs[2].title,
                      classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium", "text-lg"]
                    )
                  }
                }
              }

              // Desktop breadcrumbs
              Navigation(classes: ["hidden", "md:flex", "items-center", "space-x-1", "text-sm"]) {
                for (index, crumb) in breadcrumbs.enumerated() {
                  if index == breadcrumbs.count - 1 {
                    Text(
                      crumb.title,
                      classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"]
                    )
                  } else {
                    Link(
                      crumb.title,
                      to: crumb.url,
                      classes: [
                        "text-zinc-600", "dark:text-zinc-400", "hover:text-teal-600",
                        "dark:hover:text-teal-400", "transition-colors", "cursor-pointer",
                      ]
                    )
                    Text("/", classes: ["text-zinc-400", "dark:text-zinc-600"])
                  }
                }
              }
            } else {
              Text("Mac Long", classes: ["text-zinc-900", "dark:text-zinc-100", "font-medium"])
            }

            Stack(classes: ["flex", "items-center", "space-x-6"]) {
              Stack(classes: ["flex", "items-center", "space-x-2"]) {
                // Tool controls if provided
                if let toolControls = toolControls {
                  MarkupString(content: toolControls().map { $0.render() }.joined())
                  // Separator (hide on mobile)
                  Stack(classes: [
                    "hidden", "md:block", "w-px", "h-6", "bg-gray-300", "dark:bg-zinc-600",
                  ])
                }

                // Mobile hamburger button
                Stack(classes: ["md:hidden"]) {
                  Button(
                    onClick: "toggleSlideMenu('mobile-menu-container')",
                    id: "mobile-menu-button",
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "Menu"
                  ) {
                    Icon(name: "chevron-left", classes: ["w-5", "h-5"])
                  }
                }

                // Desktop navigation icons
                Stack(classes: ["hidden", "md:flex", "items-center", "space-x-2"]) {
                  Link(
                    to: "/posts",
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "Posts"
                  ) {
                    Icon(name: "file-text", classes: ["w-5", "h-5"])
                  }

                  Link(
                    to: "/photos",
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "Photos"
                  ) {
                    Icon(name: "image", classes: ["w-5", "h-5"])
                  }

                  // Separator between navigation and site controls
                  Stack(classes: [
                    "w-px", "h-6", "bg-zinc-300/50", "dark:bg-zinc-600/50",
                  ])

                  Link(
                    to: "mailto:hello@maclong.uk",
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "Email"
                  ) {
                    Icon(name: "mail", classes: ["w-5", "h-5"])
                  }

                  Link(
                    to: "https://github.com/maclong9",
                    newTab: true,
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "View GitHub Profile"
                  ) {
                    Icon(name: "github", classes: ["w-5", "h-5"])
                  }

                  ThemeDropdown()
                }
              }
            }
          }
        }
      }
      // .scrollHeader(threshold: 10, showOnTop: true, duration: 300) // Temporarily disabled
    }
  }
}
