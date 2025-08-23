import WebUI

struct NavigationLinks: Element {
  public var body: some Markup {

    Navigation(classes: ["flex", "items-center", "space-x-2"]) {
      // Posts link
      Link(
        to: "/posts",
        classes: [
          "p-2", "text-zinc-500", "hover:text-zinc-700",
          "dark:text-zinc-400", "dark:hover:text-zinc-200",
          "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
          "transition-colors", "cursor-pointer",
        ]
      ) { Icon(name: "file-text") }

      // Email link
      Link(
        to: "mailto:hello@maclong.uk",
        classes: [
          "p-2", "text-zinc-500", "hover:text-zinc-700",
          "dark:text-zinc-400", "dark:hover:text-zinc-200",
          "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
          "transition-colors", "cursor-pointer",
        ]
      ) { Icon(name: "mail") }

      // GitHub link
      Link(
        to: "https://github.com/maclong9",
        newTab: true,
        classes: [
          "p-2", "text-zinc-500", "hover:text-zinc-700",
          "dark:text-zinc-400", "dark:hover:text-zinc-200",
          "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
          "transition-colors", "cursor-pointer",
        ]
      ) { Icon(name: "github") }
    }
  }
}
