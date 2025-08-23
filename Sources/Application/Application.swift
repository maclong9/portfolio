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
      image: "/public/og.jpg",
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
      Posts()
      Tools()
      BarreScales()
      SchengenTracker()
      Missing()
    }
  }

  var baseURL: String? {
    "https://maclong.uk"
  }

  var head: String? {
    """
    <style type="text/tailwindcss">
        @custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
        
        /* Hero animations */
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes avatarFadeIn {
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        /* Progressive Reveal for Cards */
        .reveal-card {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }
        
        .reveal-card.in-view {
            opacity: 1;
            transform: translateY(0);
        }
        
        .reveal-card:nth-child(1) { transition-delay: 0.1s; }
        .reveal-card:nth-child(2) { transition-delay: 0.2s; }
        .reveal-card:nth-child(3) { transition-delay: 0.3s; }
        .reveal-card:nth-child(4) { transition-delay: 0.4s; }
        .reveal-card:nth-child(5) { transition-delay: 0.5s; }
        .reveal-card:nth-child(6) { transition-delay: 0.6s; }
        
        /* Hero element animations */
        .hero-avatar {
            animation: avatarFadeIn 0.8s ease-out;
        }
        
        .hero-name {
            animation: slideUp 0.6s ease-out 0.1s both;
        }
        
        .hero-description {
            animation: slideUp 0.6s ease-out 0.3s both;
        }
        
        /* Accessibility: Hide animations on reduced motion preference */
        @media (prefers-reduced-motion: reduce) {
            .reveal-card,
            .hero-avatar,
            .hero-name, 
            .hero-description {
                animation: none !important;
                transition: none !important;
                opacity: 1 !important;
                transform: none !important;
            }
        }
    </style>
    """
  }

  var scripts: [Script]? {
    [
      Script(
        placement: .head,
        content: {
          """
          // Prevent FOUC by setting theme immediately
          (function () {
            const savedTheme = localStorage.getItem('theme') || 'system';
            const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

            let actualTheme = 'light';
            if (savedTheme === 'dark') {
              actualTheme = 'dark';
            } else if (savedTheme === 'system') {
              actualTheme = systemPrefersDark ? 'dark' : 'light';
            }

            document.documentElement.setAttribute('data-theme', actualTheme);
          })();
          """
        }
      ),
      Script(placement: .body) { "lucide.createIcons();" },
    ]
  }

  static func main() async throws {
    do {
      let application = Application()
      try application.build(to: URL(filePath: ".output/dist"))

      // Copy required files to output directory root
      let filesToCopy = ["wrangler.toml", "index.js"]

      for fileName in filesToCopy {
        let sourceFile = URL(filePath: fileName)
        let destFile = URL(filePath: ".output/\(fileName)")

        if FileManager.default.fileExists(atPath: sourceFile.path) {
          if FileManager.default.fileExists(atPath: destFile.path()) {
            try FileManager.default.removeItem(atPath: destFile.path())
          }
          try FileManager.default.copyItem(at: sourceFile, to: destFile)
          print("✓ \(fileName) copied to output directory")
        }
      }

      print("✓ Application built successfully.")
    } catch {
      print("⨉ Failed to build application: \(error)")
    }
  }
}
