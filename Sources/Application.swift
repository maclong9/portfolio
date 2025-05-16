import Foundation
import WebUI

@main
actor Application {
    static let metadata = Metadata(
        site: "Mac Long",
        title: "Software Engineer",
        titleSeperator: " | ",
        description:
            "Swift, TypeScript, React and TailwindCSS developer crafting clean code and efficient, forward-thinking solutions",
        image: "/public/og.jpg",
        author: "Mac Long",
        keywords: [
            "software engineer",
            "swift developer",
            "react developer",
            "typescript",
            "tailwindcss",
            "frontend development",
            "skateboarding",
            "punk rock",
            "web development",
            "iOS development",
        ],
        locale: .en,
        type: .website,
        favicons: [Favicon("https://fav.farm/🖥")],
        structuredData: .organization(
            name: "Mac Long",
            logo: "https://maclong.uk/public/og.jpg",
            url: "https://maclong.uk",
            contactPoint: [
                "contactType": "Professional Inquiries",
                "email": "hello@maclong.uk",
            ],
            sameAs: ["https://github.com/maclong9"]
        )
    )

    let robotsRules: [RobotsRule] = [
        RobotsRule(userAgent: "*", allow: ["/"])
    ]

    static let routes = [
        Home().document,
        Projects().document,
    ]

    static func main() async {
        do {
            try Website(
                metadata: metadata,
                routes: routes,
                baseURL: "maclong.uk",
                generateSitemap: true,
            ).build()
        } catch {
            print("Failed to build application: \(error)")
        }
    }
}
