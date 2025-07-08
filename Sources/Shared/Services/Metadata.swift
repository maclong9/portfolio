import Foundation
import WebUI

public struct PersonalData {
    public static var metadata: Metadata {
        Metadata(
            site: "Mac Long",
            title: "Software Engineer",
            titleSeparator: " | ",
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
                webAddress: "https://maclong.uk",
                birthDate: ISO8601DateFormatter().date(from: "1995-10-19"),
                sameAs: ["https://github.com/maclong9", "https://orcid.org/0009-0002-4180-3822"]
            )
        )
    }
}
