import Foundation
import WebUI

@main
struct Application: Website {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Software Engineer",
            titleSeparator: " | ",
            description:
                "Swift, TypeScript, React and TailwindCSS developer crafting clean code and efficient forward-thinking solutions",
            image: "/public/images/og.jpg",
            author: "Mac Long",
            keywords: [
                "software engineer", "swift developer", "react developer", "typescript", "tailwindcss",
                "frontend development", "skateboarding", "punk rock", "web development", "iOS development",
            ],
            locale: .en,
            type: .website,
            favicons: [
                Favicon(
                    "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='48' height='48' viewBox='0 0 16 16'><text x='0' y='14'>👨‍💻</text></svg>"
                )
            ],
            structuredData: .person(
                name: "Mac Long",
                givenName: "Mac",
                familyName: "Long",
                image: "https://avatars.githubusercontent.com/u/115668288?v=4",
                jobTitle: "Software Engineer",
                email: "hello@maclong.uk",
                webAddress: "https://maclong.uk",
                birthDate: ISO8601DateFormatter().date(from: "1995-10-19"),
                sameAs: [
                    "https://github.com/maclong9",
                    "https://orcid.org/0009-0002-4180-3822",
                ]
            )
        )
    }

    @WebsiteRouteBuilder
    var routes: [any Document] {
        get throws {
            Home()
            Missing()
        }
    }

    var baseURL: String? {
        "https://maclong.uk"
    }

    static func main() async throws {
        do {
            let application = Application()
            try application.build(to: URL(filePath: ".output/dist"))

            // Copy wrangler.toml to the dist directory
            let sourceWrangler = URL(filePath: "wrangler.toml")
            let destWrangler = URL(filePath: ".output/wrangler.toml")

            if FileManager.default.fileExists(atPath: sourceWrangler.path) {
                if FileManager.default.fileExists(atPath: destWrangler.path()) {
                    try FileManager.default.removeItem(atPath: destWrangler.path())
                }
                try FileManager.default.copyItem(at: sourceWrangler, to: destWrangler)
                print("✓ wrangler.toml copied to output directory")
            }

            print("✓ Application built successfully.")
        } catch {
            print("⨉ Failed to build application: \(error)")
        }
    }
}
