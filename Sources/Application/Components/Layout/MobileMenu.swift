import Foundation
import WebUI

public struct MobileMenu: Element {
  let hidePostsLink: Bool

  public init(hidePostsLink: Bool = false) {
    self.hidePostsLink = hidePostsLink
  }

  public var body: some Markup {
    Stack {
      // Jelly animation styles
      MarkupString(
        content: """
          <style>
            @keyframes jellyIn {
              0% {
                opacity: 0;
                transform: scale(0.8) translateY(-10px);
              }
              50% {
                transform: scale(1.05) translateY(0);
              }
              70% {
                transform: scale(0.95);
              }
              100% {
                opacity: 1;
                transform: scale(1) translateY(0);
              }
            }

            #mobile-menu-overlay.active {
              display: block;
              animation: jellyIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            }
          </style>
          """
      )

      Stack(
        id: "mobile-menu-container",
        data: ["mobile-menu-open": "false"]
      ) {
        Stack(
          id: "mobile-menu-overlay",
          classes: [
            "fixed", "top-[85px]", "right-4", "w-80", "max-w-[calc(100vw-2rem)]",
            "max-h-[calc(100vh-6rem)]", "overflow-y-auto",
            "bg-white/95", "dark:bg-zinc-900/95",
            "backdrop-blur-2xl", "backdrop-saturate-150",
            "border", "border-white/50", "dark:border-white/10",
            "px-6", "py-6",
            "shadow-2xl",
            "rounded-2xl",
            "z-50", "hidden",
          ],
          data: ["mobile-menu": "closed"]
        ) {
          Stack(classes: ["flex", "flex-col", "space-y-3"]) {
            Stack(classes: ["flex", "items-center", "justify-between", "mb-4"]) {
              Text("Navigation", classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100"])
              Button(
                onClick: "closeSlideMenu('mobile-menu-container')",
                id: "mobile-menu-close",
                classes: [
                  "p-1", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200",
                  "cursor-pointer",
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
                  "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                  "hover:text-teal-600", "dark:hover:text-teal-400",
                  "rounded-xl", "transition-all", "cursor-pointer",
                ],
                data: ["mobile-menu-link": "posts"]
              ) {
                Icon(name: "file-text", classes: ["w-5", "h-5"])
                Text("Posts")
              }
            }

            Link(
              to: "/photos",
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "rounded-xl", "transition-all", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "photos"]
            ) {
              Icon(name: "image", classes: ["w-5", "h-5"])
              Text("Photos")
            }

            Link(
              to: "/music",
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "rounded-xl", "transition-all", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "music"]
            ) {
              Icon(name: "music", classes: ["w-5", "h-5"])
              Text("Music")
            }

            Link(
              to: "/tools",
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "rounded-xl", "transition-all", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "tools"]
            ) {
              Icon(name: "wrench", classes: ["w-5", "h-5"])
              Text("Tools")
            }

            Link(
              to: "mailto:hello@maclong.uk",
              classes: [
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "rounded-xl", "transition-all", "cursor-pointer",
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
                "flex", "items-center", "space-x-3", "p-3", "text-zinc-700", "dark:text-zinc-200",
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "rounded-xl", "transition-all", "cursor-pointer",
              ],
              data: ["mobile-menu-link": "github"]
            ) {
              Icon(name: "github", classes: ["w-5", "h-5"])
              Text("GitHub")
            }

            // Theme Selection in Mobile Menu
            Stack(classes: ["border-t", "border-white/20", "dark:border-zinc-700/50", "pt-4", "mt-2"]) {
              Text("Theme", classes: ["text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300", "mb-3"])
              Stack(classes: ["space-y-1"]) {
                Button(
                  onClick:
                    "if (window.setTheme) window.setTheme('system'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-system-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-xl",
                    "text-sm", "transition-all", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-200",
                  ],
                  data: ["theme-option": "system"]
                ) {
                  Stack(classes: ["flex", "items-center", "space-x-3"]) {
                    Icon(name: "monitor", classes: ["w-4", "h-4"])
                    Text("System")
                  }
                }

                Button(
                  onClick:
                    "if (window.setTheme) window.setTheme('light'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-light-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-xl",
                    "text-sm", "transition-all", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-200",
                  ],
                  data: ["theme-option": "light"]
                ) {
                  Stack(classes: ["flex", "items-center", "space-x-3"]) {
                    Icon(name: "sun", classes: ["w-4", "h-4"])
                    Text("Light")
                  }
                }

                Button(
                  onClick:
                    "if (window.setTheme) window.setTheme('dark'); window.closeSlideMenu('mobile-menu-container')",
                  id: "theme-dark-mobile",
                  classes: [
                    "w-full", "flex", "items-center", "space-x-3", "px-3", "py-2", "rounded-xl",
                    "text-sm", "transition-all", "cursor-pointer",
                    "text-zinc-700", "dark:text-zinc-200",
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
      // .slideMenu(
      //   overlayId: "mobile-menu-overlay",
      //   from: .fromRight,
      //   duration: 300,
      //   toggleButtonSelector: "#mobile-menu-button"
      // ) // Temporarily disabled
    }
  }
}
