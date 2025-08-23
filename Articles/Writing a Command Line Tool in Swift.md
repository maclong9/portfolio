---
title: Writing a Command Line Tool in Swift
description: A concise guide to creating a CLI tool in Swift using the Swift Package Manager.
published: April 29, 2025
---

This guide demonstrates how to create a simplified version of the UNIX `ls` command using Swift. The `ls` command is chosen for its simplicity and familiarity, making it an ideal example for building a command-line tool.

## Overview

The `ls` command lists files in the current or specified directory, aiding navigation within a file system. Example output:

```text
Desktop  Documents  Library  Music  Public Developer  Downloads  Movies  Pictures
```

## Creating the Tool

Initialize a new Swift Package Manager project:

```sh
mkdir ls-clone
cd ls-clone
swift package init --name LsClone --type executable
```

This generates the project structure. Open it in your preferred editor or run `open Package.swift` to use Xcode.

## Adding Dependencies

The tool uses [Swift Argument Parser](https://github.com/apple/swift-argument-parser) for handling command-line flags and options. Update `Package.swift`:

```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "LsClone",
    products: [
        .executable(name: "lsc", targets: ["lsc"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "lsc",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
```

> The tool is named `lsc` (ls clone), but you may rename it as desired.

## Implementation

This guide implements a minimal `ls` clone that:
1. Lists files in the current or specified directory.
2. Supports a flag to include hidden files.

### Steps

Define the main entry point using `ParsableCommand`:

```swift
import ArgumentParser
import Foundation

@main
struct Lsc: ParsableCommand {
    // Configuration and logic here
}
```

Add a flag and argument for user input. The `all` flag supports `-a` or `--all` due to the `.shortAndLong` name parameter and is set to a default value of false. The `paths` argument accepts a collection of directory paths:

```swift
@Flag(name: .shortAndLong, help: "Display all files, including hidden.") var all = false
@Argument(help: "Directories to list.") var paths: [String] = []
```

Implement the `run` function:

```swift
func run() throws {
    let fm = FileManager.default
    let locations = paths.isEmpty ? [fm.currentDirectoryPath] : paths
    
    for path in locations {
        let url = URL(fileURLWithPath: path)
        let items = try fm.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: all ? [] : [.skipsHiddenFiles]
        )
        for item in items {
            print(item.lastPathComponent)
        }
    }
}
```

## Complete Code

```swift
// Sources/lsc/main.swift
import ArgumentParser
import Foundation

@main
struct Lsc: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Display all files, including hidden.") var all = false
    @Argument(help: "Directories to list.") var paths: [String] = []
    
    func run() throws {
        let fm = FileManager.default
        let locations = paths.isEmpty ? [fm.currentDirectoryPath] : paths
        
        for path in locations {
            let url = URL(fileURLWithPath: path)
            let items = try fm.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: all ? [] : [.skipsHiddenFiles]
            )
            for item in items {
                print(item.lastPathComponent)
            }
        }
    }
}
```

Run the tool with `swift run lsc` or `swift run lsc -a`.

**Example Output:**

```text
Tests
Package.resolved
Package.swift
Sources
```

**With `-a` Flag:**

```text
.build
Tests
Package.resolved
.gitignore
Package.swift
Sources
```

Build a release version for distribution with `swift build -c release`, producing an executable at `.build/arm64-apple-macosx/release/lsc`. For cross-platform builds, refer to the [Swift Build System](https://www.swift.org/documentation/server/guides/building.html) or [Static Linux SDK](https://www.swift.org/documentation/articles/static-linux-getting-started.html).

## Testing

It is good practice to include tests to ensure reliability. Below is a sample test suite that verifies the tool's output:

```swift
// Tests/LsCloneTests.swift
import Foundation
import Testing
@testable import lsc

@Suite("LsClone Tests")
struct LscTestSuite {
    @Test("List Current Directory")
    func testListCurrentDirectory() throws {
        let output = try captureOutput {
            try Lsc.parse([]).run()
        }
        #expect(output.contains("Package.swift"))
    }
    
    @Test("List Hidden Files")
    func testListHiddenFiles() throws {
        let output = try captureOutput {
            try Lsc.parse(["-a"]).run()
        }
        #expect(output.contains(".gitignore"))
    }
    
    func captureOutput(_ closure: () throws -> Void) throws -> String {
        let pipe = Pipe()
        let original = dup(STDOUT_FILENO) 
        defer { dup2(original, STDOUT_FILENO); close(original) }
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        try pipe.fileHandleForWriting.close()
        try closure()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(decoding: data, as: UTF8.self)
    }
}
```

Run tests with `swift test`.

**Example Test Output:**

```text
Test Suite 'All tests' started at 2025-04-29 10:38:20.741
Test Suite 'LscTestSuite' started
Test Case 'List Current Directory' passed
Test Case 'List Hidden Files' passed
Test Suite 'All tests' passed
Executed 2 tests, with 0 failures in 0.002 seconds
```

## Beyond CLI Tools: Building Web Applications with Swift

While Swift excels at command line tools, it's also powerful for web development. This very website you're reading is built using Swift with the [WebUI framework](https://github.com/maclong9/web-ui), demonstrating Swift's versatility beyond mobile apps.

### Static Site Generation with Swift

The portfolio site uses a custom Swift static site generator built on WebUI, which provides:

**Declarative Component Architecture**
```swift
struct Layout: Element {
    let title: String
    let content: () -> some Markup
    
    var body: some Markup {
        HTML {
            Head {
                Title(title)
                // Meta tags, stylesheets, etc.
            }
            Body {
                Header()
                Main { content() }  
                Footer()
            }
        }
    }
}
```

**Type-Safe HTML Generation**
```swift
struct ArticleCard: Element {
    let article: ArticleResponse
    
    var body: some Markup {
        Link(to: "/posts/\(article.slug)") {
            Card {
                Stack(classes: ["flex", "flex-col"]) {
                    Heading(.subtitle, article.title)
                    Text(article.description)
                    Text("\(article.readTime) • \(article.publishedDate)")
                }
            }
        }
    }
}
```

**Markdown Processing with WebUIMarkdown**
```swift
public enum ArticlesService {
    public static func fetchAllArticles() throws -> [ArticleResponse] {
        let fileURLs = try fetchMarkdownFiles(from: "Articles")
        return try fileURLs.map { url in
            let content = try String(contentsOf: url, encoding: .utf8)
            let parsed = try WebUIMarkdown().parseMarkdown(content)
            return ArticleResponse(id: url.lastPathComponent, parsed: parsed)
        }
    }
}
```

### Build and Deployment Pipeline

The Swift-based build system:

1. **Compiles Swift code** into a static site generator executable
2. **Processes Markdown articles** with frontmatter metadata extraction
3. **Generates HTML files** with TailwindCSS styling and progressive enhancement
4. **Deploys to Cloudflare Pages** with automatic builds on Git push

```bash
# Build the site generator
swift build -c release

# Generate the static site  
swift run

# Output ready for deployment in .output/dist/
```

### Performance Benefits

Using Swift for static site generation provides:
- **Compile-time safety**: Type checking prevents runtime errors
- **Performance**: Native compilation yields fast build times
- **Maintainability**: Familiar Swift syntax for iOS developers
- **Integration**: Seamless use of Swift Package Manager dependencies

The combination of Swift's type safety, WebUI's declarative syntax, and native performance creates a pleasant development experience for content-focused websites.

## Conclusion

Swift is an excellent language for writing command line tools in a concise and efficient manner. From simple utilities like `ls` clones to complex web applications and static site generators, Swift's versatility shines across domains.

If you'd like to see a more extensive CLI implementation, check out my tool `sls` at [List](https://github.com/maclong9/list). And for web development examples, explore the [WebUI framework](https://github.com/maclong9/web-ui) that powers this very site.
