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
            // Article header
            Stack(classes: ["max-w-2xl", "mx-auto", "mb-8", "pt-8"]) {
                // Article metadata
                Stack(classes: ["text-sm", "text-zinc-500", "dark:text-zinc-400", "mb-2"]) {
                    buildMetadataText()
                }
                
                // Article title
                Heading(.largeTitle, article.title, classes: ["text-3xl", "md:text-4xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                
                // Article description
                Text(article.description, classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400"])
            }
            
            // Article content
            Stack(classes: ["max-w-2xl", "mx-auto", "prose"]) {
                contentHTML
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