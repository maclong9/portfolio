---
title: Introduction to WebUI
description: An introduction to WebUI, a Swift library for rendering HTML, CSS, and JavaScript.
published: April 15, 2025
---

# Introduction to WebUI

**Published:** April 15, 2025

## What is WebUI?

WebUI is a rendering library for HTML, CSS, and JavaScript, built entirely in Swift. 

It offers a convenient way to create user interfaces with a syntax similar to SwiftUI, resulting in clean, efficient, and maintainable code.

## Why I Built WebUI

As a frequent user of Swift for backend development, thanks to the [Swift on Server](https://www.swift.org/documentation/server/) workgroup, I often found myself server-side rendering HTML within Swift to maintain a unified codebase, avoiding a decoupled frontend. This led me to explore domain-specific languages (DSLs) for writing HTML in Swift, such as [Elementary](https://github.com/sliemeobn/elementary). While Elementary was a solid option, its syntax didn’t fully meet my needs, prompting me to create [WebUI](https://github.com/maclong9/web-ui).

## Creating a Web Document

WebUI’s core functionality is generating web pages. You define a document with metadata and content, passed as a closure containing WebUI elements.

```swift
import Foundation
import WebUI

let document = Document(
  metadata: Metadata(
    site: "Awesome Site",
    title: "Some Page",
    titleSeparator: "-",
    description: "This is my awesome page",
    image: "/og.png",
    author: "Your Name",
    keywords: ["swift", "webui"],
    twitter: "username",
    locale: .en,
    type: .website
  )
) {
  Header { "Hello, World!" }
  Main {
    Heading(level: .h1) { "This is my awesome page." }
    List {
      Item { "Item 1" }
      Item { "Item 2" }
    }
    Link(to: "https://github.com/maclong9/web-ui", newTab: true) { "WebUI Repository" }
  }
}

let html = document.render()
```

This code renders the following HTML. Currently, styles are managed with TailwindCSS, though this may evolve in future updates. Metadata is rendered in the `<head>` tag, and closure content appears within the `<body>` tags.

```HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Some Page - Awesome Site</title>
    <meta property="og:title" content="Some Page - Awesome Site" />
    <meta name="description" content="This is my awesome page" />
    <meta property="og:description" content="This is my awesome page" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta property="og:image" content="/og.png" />
    <meta name="author" content="Your Name" />
    <meta property="og:type" content="website" />
    <meta name="twitter:creator" content="@username" />
    <meta name="keywords" content="swift, webui" />
    <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
    <style type="text/tailwindcss">
      @theme {
        --breakpoint-xs: 30rem;
        --breakpoint-3xl: 120rem;
        --breakpoint-4xl: 160rem;
      }
    </style>
  </head>
  <body>
    <header>Hello, World!</header>
    <main>
      <h1>This is my awesome page.</h1>
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
      </ul>
      <a
        href="https://github.com/maclong9/web-ui"
        target="_blank"
        rel="noreferrer"
      >
        WebUI Repository
      </a>
    </main>
  </body>
</html>
```

## Adding Styles

Styles in WebUI follow a modifier pattern inspired by SwiftUI. Below is an example of a styled div with a heading. The container has a light background by default and a dark background when `prefers-color-scheme: dark` is active, with typography styles applied to the heading.

```swift
let styledContent = Stack {
  Heading(level: .h1) { "Hello, world!" }
    .font(size: .xl, weight: .bold, decoration: .underline)
}
.background(color: .neutral(._100))
.background(color: .neutral(._950), on: .dark)
```

## Generating a Simple Static Site

### Creating a Layout Component

WebUI components are defined as structs conforming to the `HTML` protocol.

```swift
struct LayoutOne: HTML {
  let children: [any HTML]

  init(@HTMLBuilder children: @escaping () -> [any HTML]) {
    self.children = children()
  }

  public func render() -> String {
    Stack {
      Header {
        Link(to: "/") { "Site Title" }
        Navigation {
          Link(to: "https://github.com/maclong9", newTab: true) { "GitHub" }
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        children.map { $0.render() }.joined()
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .custom("95vw"))
      .frame(maxWidth: .character(64), on: .sm)
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          Link(to: "/") { "Site Title" }
        }
      }
      .font(size: .sm, color: .zinc(._400, opacity: 0.9))
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._200))
    .background(color: .zinc(._950))
    .flex(direction: .column)
    .render()
  }
}
```

This creates a reusable layout with a header, main content area, and footer.

### Generating the Website

To generate a static site, run the build step to create an `.output` directory in the current working directory. If using Xcode, set a custom working directory in your scheme.

```swift
public struct StaticSite: Sendable {
  var staticRoutes: [Document] {
    [
      Document(
        path: "index",
        metadata: .init(
          title: "Home",
          description: "Welcome to the home page."
        ),
        content: {
          LayoutOne {
            Heading(level: .h1) { "Home Page" }
            Link(to: "/about") { "Go to About" }
          }
        }
      ),
      Document(
        path: "about",
        metadata: .init(
          title: "About",
          description: "Learn more about us."
        ),
        content: {
          LayoutOne {
            Heading(level: .h1) { "About Page" }
            Link(to: "/") { "Go to Home" }
          }
        }
      )
    ]
  }

  func main() async throws {
    try Application(routes: staticRoutes).build(publicDirectory: "Sources/StaticSite/Public")
  }
}
```

The `.output` directory will contain:

```text
.output/
  index.html
  about.html
```

You can specify a public directory to be copied to `.output/public`. For example, to include an image, place it in `Sources/StaticSite/Public` and reference it as:

```swift
Image(source: "public/image.jpg", description: "An image for web rendering")
```

Ensure the `Public` directory is added as a resource in your target:

```swift
targets: [
  .executableTarget(
    name: "TargetName",
    dependencies: [
      .product(name: "WebUI", package: "web-ui")
    ],
    resources: [
      .copy("Public")
    ]
  ),
]
```

## Conclusion

This introduction covers the basics of WebUI, a library I created to streamline web development in Swift. While still evolving, WebUI has been a valuable learning experience in Swift and web technologies. Explore this sites [source code](https://github.com/maclong9/portfolio) to see how a production site using WebUI is built or learn more about the library [here](https://github.com/maclong9/web-ui). 

Thank you for reading!
