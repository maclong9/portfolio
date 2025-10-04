import Foundation
import WebUI

struct Modal: Markup {
  let id: String
  let title: String
  let onClose: String
  let content: () -> any Markup

  init(id: String, title: String, onClose: String = "hideModal()", @MarkupBuilder content: @escaping () -> any Markup) {
    self.id = id
    self.title = title
    self.onClose = onClose
    self.content = content
  }

  var body: some Markup {
    MarkupString(
      content: """
            <div id="\(id)" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50 hidden" onclick="\(onClose)">
                <div class="bg-white dark:bg-zinc-800 rounded-lg max-w-2xl w-full p-6" onclick="event.stopPropagation()">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-xl font-semibold text-zinc-900 dark:text-zinc-100">\(title)</h3>
                        <button onclick="\(onClose)" class="text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200">
                            <i data-lucide="x" class="w-6 h-6"></i>
                        </button>
                    </div>
                    <div class="text-zinc-700 dark:text-zinc-300">
                        \(renderContent())
                    </div>
                </div>
            </div>
        """
    )
  }

  private func renderContent() -> String {
    // Since we can't directly render Markup to string in this context,
    // we'll need to handle the content differently
    ""
  }
}

// Alternative approach using MarkupString directly for better control
struct InfoModal: Markup {
  let id: String
  let title: String
  let onClose: String
  let content: String

  init(id: String, title: String, onClose: String = "hideModal()", content: String) {
    self.id = id
    self.title = title
    self.onClose = onClose
    self.content = content
  }

  var body: some Markup {
    Stack(
      id: id,
      classes: [
        "fixed", "inset-0", "bg-black/60", "backdrop-blur-sm", "flex", "items-center",
        "justify-center", "p-4", "z-50", "hidden",
      ],
      data: ["onclick": onClose]
    ) {
      Stack(
        classes: [
          "bg-white", "dark:bg-zinc-800", "rounded-lg", "max-w-2xl", "w-full", "p-6",
        ],
        data: ["onclick": "event.stopPropagation()"]
      ) {
        Stack(classes: ["flex", "items-center", "justify-between", "mb-4"]) {
          Heading(.title, title, classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100"])
          Button(
            onClick: onClose,
            classes: [
              "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200",
            ]
          ) {
            Icon(name: "x", classes: ["w-6", "h-6"])
          }
        }
        Stack(classes: ["text-zinc-700", "dark:text-zinc-300", "space-y-4"]) {
          MarkupString(content: content)
        }
      }
    }
  }
}

// Specialized modal for sharing functionality (used by SchengenTracker)
struct ShareModal: Markup {
  let id: String
  let onClose: String

  init(id: String = "share-modal", onClose: String = "hideShare()") {
    self.id = id
    self.onClose = onClose
  }

  var body: some Markup {
    Stack(
      id: id,
      classes: [
        "fixed", "inset-0", "bg-black/60", "backdrop-blur-sm", "flex", "items-center",
        "justify-center", "p-4", "z-50", "hidden",
      ],
      data: ["onclick": onClose]
    ) {
      Stack(
        classes: [
          "bg-white", "dark:bg-zinc-800", "rounded-lg", "max-w-md", "w-full", "p-6",
        ],
        data: ["onclick": "event.stopPropagation()"]
      ) {
        Stack(classes: ["flex", "items-center", "justify-between", "mb-4"]) {
          Heading(
            .title,
            "Share Your Data",
            classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100"]
          )
          Button(
            onClick: onClose,
            classes: [
              "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400", "dark:hover:text-zinc-200",
            ]
          ) {
            Icon(name: "x", classes: ["w-6", "h-6"])
          }
        }
        Text(
          "Share your visit history with family, friends, or advisors",
          classes: ["text-zinc-600", "dark:text-zinc-400", "text-sm", "mb-4"]
        )
        Stack(classes: ["space-y-3"]) {
          Button(
            onClick: "shareNatively()",
            classes: [
              "w-full", "bg-teal-600", "hover:bg-teal-700", "dark:bg-teal-500",
              "dark:hover:bg-teal-600", "text-white", "px-4", "py-3", "rounded-lg",
              "transition-colors", "flex", "items-center", "justify-center", "gap-2", "font-medium",
            ]
          ) {
            Icon(name: "share-2", classes: ["w-4", "h-4"])
            Text("Share")
          }
          Button(
            onClick: "generateShareUrl()",
            classes: [
              "w-full", "bg-zinc-600", "hover:bg-gray-700", "dark:bg-gray-500",
              "dark:hover:bg-zinc-600", "text-white", "px-4", "py-3", "rounded-lg",
              "transition-colors", "font-medium",
            ]
          ) {
            Text("Generate Link")
          }
          Stack(
            id: "share-url-container",
            classes: ["space-y-2", "hidden"]
          ) {
            Stack(classes: ["flex", "items-center", "gap-2"]) {
              MarkupString(
                content:
                  "<input type=\"text\" id=\"share-url-input\" readonly class=\"flex-1 p-2 border border-zinc-300 dark:border-zinc-600 bg-gray-50 dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded text-sm font-mono\">"
              )
              Button(
                onClick: "copyToClipboard()",
                id: "copy-btn",
                classes: [
                  "bg-zinc-600", "hover:bg-gray-700", "dark:bg-gray-500", "dark:hover:bg-zinc-600",
                  "text-white", "px-3", "py-2", "rounded", "transition-colors",
                  "flex", "items-center", "gap-1",
                ]
              ) {
                Icon(name: "copy", classes: ["w-3.5", "h-3.5"])
                Text("Copy")
              }
            }
          }
        }
      }
    }
  }
}
