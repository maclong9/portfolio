import Foundation
import WebUI

@main
actor Application {
    static let metadata = Metadata(
        site: "Mac Long",
        title: "Software Engineer",
        titleSeperator: " | ",
        description:
            "Swift, TypeScript, React and TailwindCSS developer crafting clean code and efficient forward-thinking solutions",
        image: "/public/og.jpg",
        author: "Mac Long",
        keywords: [
            "software engineer", "swift developer", "react developer", "typescript", "tailwindcss",
            "frontend development", "skateboarding", "punk rock", "web development", "iOS development",
        ],
        locale: .en,
        type: .website,
        favicons: [Favicon("https://fav.farm/🖥")],
        structuredData: .person(
            name: "Mac Long",
            givenName: "Mac",
            familyName: "Long",
            image: "https://avatars.githubusercontent.com/u/115668288?v=4",
            jobTitle: "Software Engineer",
            email: "hello@maclong.uk",
            url: "https://maclong.uk",
            birthDate: ISO8601DateFormatter().date(from: "1995-10-19"),
            sameAs: ["https://github.com/maclong9", "https://orcid.org/0009-0002-4180-3822"]
        )
    )

    let robotsRules: [RobotsRule] = [
        RobotsRule(userAgent: "*", allow: ["/"])
    ]

    static func main() async {
        do {
            let articles = try ArticleService.fetchAllArticles()

            let routes = [
                Home(articles: articles).document,
                Projects().document,
                Notes().document,
                Missing().document,
            ]

            try Website(
                metadata: metadata,
                routes: routes + articles.map(\.document),
                baseURL: "https://maclong.uk",
                generateSitemap: true,
            ).build()

            let fm = FileManager.default
            try fm.copyItem(at: URL(filePath: "Sources/Functions")!, to: URL(filePath: ".output/functions")!)
        } catch {
            print("Failed to build application: \(error)")
        }
    }
}
