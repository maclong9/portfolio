import Foundation
import WebUI

public struct MobileMenu: Element {
  let hidePostsLink: Bool

  public init(hidePostsLink: Bool = false) {
    self.hidePostsLink = hidePostsLink
  }

  public var body: some Markup {
    Stack {
      Stack(
        id: "mobile-menu-container",
        data: ["mobile-menu-open": "false"]
      ) {
        Stack(
          id: "mobile-menu-overlay",
          classes: [
            "fixed", "inset-y-0", "right-0", "w-64", "bg-white", "dark:bg-zinc-800",
            "border-l", "border-zinc-200", "dark:border-zinc-700", "px-6", "py-8", "shadow-xl",
            "transform", "translate-x-full", "transition-transform", "duration-300", "ease-out", "z-100", "hidden",
          ],
          data: ["mobile-menu": "closed"]
        ) {
          Stack(classes: ["flex", "flex-col", "space-y-3"]) {
            Stack(classes: ["flex", "items-center", "justify-between", "mb-4"]) {
              Text("Navigation", classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100"])
              Button(
                id: "mobile-menu-close",
                classes: [
                  "p-1", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200",
                ],
                label: "Close menu",
                data: ["slide-menu-close": ""]
              ) {
                Icon(name: "x", classes: ["w-5", "h-5"])
              }
            }

            if !hidePostsLink {
              Link(
                to: "/posts",
                classes: [
                  "flex", "items-center", "space-x-3", "p-3", "text-zinc-600", "dark:text-zinc-400",
                  "hover:text-teal-600", "dark:hover:text-teal-400", "hover:bg-zinc-50",
                  "dark:hover:bg-zinc-700", "rounded-lg", "transition-colors", "cursor-pointer",
                ],
                data: ["mobile-menu-link": "posts"]
              ) {
                Icon(name: "file-text", classes: ["w-5", "h-5"])
                Text("Posts")
              }
            }

            Link(
              to: "mailto:hello@maclong.uk",
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-600", "dark:text-zinc-400",
                "hover:text-teal-600", "dark:hover:text-teal-400", "hover:bg-zinc-50",
                "dark:hover:bg-zinc-700", "rounded-lg", "transition-colors", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "email"]
            ) {
              Icon(name: "mail", classes: ["w-5", "h-5"])
              Text("Email")
            }

            Link(
              to: "https://github.com/maclong9",
              newTab: true,
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-600", "dark:text-zinc-400",
                "hover:text-teal-600", "dark:hover:text-teal-400", "hover:bg-zinc-50",
                "dark:hover:bg-zinc-700", "rounded-lg", "transition-colors", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "github"]
            ) {
              Icon(name: "github", classes: ["w-5", "h-5"])
              Text("GitHub")
            }

            // Theme Selection in Mobile Menu
            Stack(classes: ["border-t", "border-zinc-200", "dark:border-zinc-700", "pt-4"]) {
              Text("Theme", classes: ["text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300", "mb-3"])
              Stack(classes: ["space-y-1"]) {
                Button(
                  onClick: "if (window.setTheme) window.setTheme('system'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-system-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-lg",
                    "text-sm", "transition-colors", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
                  ],
                  data: ["theme-option": "system"]
                ) {
                  Stack(classes: ["flex", "items-center", "space-x-3"]) {
                    Icon(name: "monitor", classes: ["w-4", "h-4"])
                    Text("System")
                  }
                }

                Button(
                  onClick: "if (window.setTheme) window.setTheme('light'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-light-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-lg",
                    "text-sm", "transition-colors", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
                  ],
                  data: ["theme-option": "light"]
                ) {
                  Stack(classes: ["flex", "items-center", "space-x-3"]) {
                    Icon(name: "sun", classes: ["w-4", "h-4"])
                    Text("Light")
                  }
                }

                Button(
                  onClick: "if (window.setTheme) window.setTheme('dark'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-dark-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-lg",
                    "text-sm", "transition-colors", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-300", "hover:bg-zinc-50", "dark:hover:bg-zinc-700",
                  ],
                  data: ["theme-option": "dark"]
                ) {
                  Stack(classes: ["flex", "items-center", "space-x-3"]) {
                    Icon(name: "moon", classes: ["w-4", "h-4"])
                    Text("Dark")
                  }
                }
              }
            }
          }
        }
      }
      .slideMenu(
        overlayId: "mobile-menu-overlay",
        from: .fromRight,
        duration: 300,
        toggleButtonSelector: "#mobile-menu-button"
      )
    }
  }
}
