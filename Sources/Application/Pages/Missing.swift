import Foundation
import WebUI

struct Missing: Document {
  var metadata: Metadata {
    Metadata(
      site: "Mac Long",
      title: "404 - Page Not Found",
      description: "Whoops, unfortunately that page either no longer or never existed in the first place."
    )
  }

  var path: String? { "404" }

  var body: some Markup {
    Layout(
      path: "404",
      title: metadata.title ?? "",
      description: metadata.description ?? ""
    ) {
      Stack(classes: [
        "flex", "flex-col", "items-center", "justify-center", "text-center", "px-4",
      ]) {

        Heading(.largeTitle, "404", classes: ["text-9xl", "font-extrabold", "mb-4"])

        Text(
          "Page Not Found",
          classes: ["text-3xl", "md:text-4xl", "font-semibold", "mb-6"]
        )

        Text(
          metadata.description ?? "",
          classes: ["mb-8", "max-w-md", "text-balance"]
        )

        Link(
          "Head back home?",
          to: "/",
          classes: [
            "font-semibold", "py-3", "px-6", "transition", "duration-200", "underline",
          ]
        )
      }
    }
  }
}
