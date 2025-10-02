import Foundation
import WebUI

struct ArticleLayout: Markup {
    let article: ArticleResponse
    let contentHTML: String
    
    init(article: ArticleResponse, contentHTML: String) {
        self.article = article
        self.contentHTML = contentHTML
    }
    
    var body: some Markup {
        Article {
            // Article header with liquid glass styling
            Stack(classes: ["max-w-2xl", "mx-auto", "mb-12", "pt-8"]) {
                // Article metadata with inline layout
                Stack(classes: ["flex", "items-center", "gap-3", "text-sm", "text-zinc-600", "dark:text-zinc-400", "mb-6", "flex-wrap"]) {
                    if let publishedDate = article.publishedDate {
                        Stack(classes: ["flex", "items-center", "gap-2"]) {
                            Icon(name: "calendar", classes: ["w-4", "h-4"])
                            Time(datetime: publishedDate.ISO8601Format()) {
                                DateFormatter.articleDate.string(from: publishedDate)
                            }
                        }
                    }

                    if let readTime = article.readTime {
                        Stack(classes: ["flex", "items-center", "gap-2"]) {
                            Icon(name: "clock", classes: ["w-4", "h-4"])
                            Text(readTime)
                        }
                    }
                }

                // Article title
                Heading(.largeTitle, article.title, classes: ["text-3xl", "md:text-4xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-6"])

                // Article description with refined styling
                Stack(classes: ["p-6", "bg-white/50", "dark:bg-zinc-800/50", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm"]) {
                    Text(article.description, classes: ["text-lg", "text-zinc-700", "dark:text-zinc-300", "leading-relaxed"])
                }
            }

            // Article content - WebUIMarkdown provides HTML escaping for text content
            // Raw HTML in markdown is preserved, which is appropriate for trusted content
            Stack(classes: ["max-w-2xl", "mx-auto", "prose", "prose-lg"]) {
                contentHTML
            }

            // Back to posts link
            Stack(classes: ["max-w-2xl", "mx-auto", "mt-12", "pt-8", "border-t", "border-zinc-200", "dark:border-zinc-800"]) {
                Link(
                    "← Back to Posts",
                    to: "/posts",
                    classes: [
                        "inline-flex", "items-center", "gap-2",
                        "text-teal-600", "dark:text-teal-400",
                        "hover:text-teal-700", "dark:hover:text-teal-300",
                        "transition-colors",
                    ]
                )
            }

            // Script to handle blockquote attributions
            Script(content: {
                """
                // Style blockquote attributions
                document.addEventListener('DOMContentLoaded', function() {
                    const blockquotes = document.querySelectorAll('.prose blockquote');
                    blockquotes.forEach(blockquote => {
                        const paragraphs = blockquote.querySelectorAll('p');
                        paragraphs.forEach(p => {
                            const text = p.textContent.trim();
                            if (text.startsWith('—') || text.startsWith('- ')) {
                                p.classList.add('attribution');
                            }
                        });
                    });
                });
                """
            })
        }
    }
    
    private func buildMetadataText() -> some Markup {
        var metadataItems: [String] = []
        
        if let publishedDate = article.publishedDate {
            metadataItems.append(DateFormatter.articleDate.string(from: publishedDate))
        }
        
        if let readTime = article.readTime {
            metadataItems.append(readTime)
        }
        
        return Text(metadataItems.joined(separator: " • "))
    }
}

extension DateFormatter {
    static let articleDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
}