---
title: Introduction to WebUI
description: An introduction to WebUI, a Swift library for rendering HTML, CSS, and JavaScript.
published: April 15, 2025
---

## What is WebUI?

It offers a convenient way to create user interfaces with a syntax similar to SwiftUI, resulting in clean, efficient, and maintainable code.

## Why I Built WebUI

As a frequent user of Swift for backend development, thanks to the [Swift on Server workgroup](https://www.swift.org/documentation/server/), I often opted for server-side rendering of HTML within Swift to maintain a unified codebase, avoiding the complexity of a decoupled frontend. However, this approach typically involved embedding HTML templates as strings within Swift code, which introduced several challenges.

For example, consider a typical setup using [Hummingbird](https://github.com/hummingbird-project/hummingbird), a Swift web framework, to render a dynamic homepage. Below is a simplified implementation of an `HTML` response generator that wraps HTML content, a `HomeView` struct for rendering the page's content, and a route handler to serve the page:

```swift
import Hummingbird

/// Type wrapping HTML code. 
/// Will convert to HBResponse that includes the correct content-type header
struct HTML: ResponseGenerator {
  let title: String
  let description: String
  let isLoggedIn: Bool?
  let content: String

  init(
    title: String,
    description: String =
      "Take control of your life with this wonderful todo list application.",
    isLoggedIn: Bool? = false,
    content: String
  ) {
    self.title = title
    self.description = description
    self.isLoggedIn = isLoggedIn
    self.content = content
  }

  public func response(from request: Request, context: some RequestContext) throws -> Response {
    .init(
      status: .ok,
      headers: [.contentType: "text/html"],
      body: .init(
        byteBuffer: ByteBuffer(
          string: LayoutView(
            title: title,
            description: description,
            isLoggedIn: isLoggedIn ?? false,
            content: content
          )
          .render()
        )
      )
    )
  }
}

/// A view that renders the marketing landing page of the application.
///
/// Displays the main value proposition, feature highlights, and appropriate call-to-action
/// buttons based on user authentication state.
///
/// - Parameters:
///    - isLoggedIn: Whether a user is currently authenticated, affecting which CTAs are shown
struct HomeView {
  let isLoggedIn: Bool

  init(isLoggedIn: Bool = false) {
    self.isLoggedIn = isLoggedIn
  }

  func render() -> String {
    """
    <section class="grid hero">
      <div class="background"></div>
      <div class="text">
        <h1>
          Take Control of
          <span class="gradient-highlight">Your Life</span>
        </h1>
        <p>
          With this wonderful application, designed to make your life easier while
          staying out of the way. Take the first step in your new journey.
        </p>
        \(ActionButtons(isLoggedIn: isLoggedIn).render())
      </div>
      <img src="images/hero.svg" />
    </section>
    """
  }
}

/// Renders the home page with dynamic content based on auth status
///
/// - Parameters:
///   - request: The incoming HTTP request
///   - context: The application context
/// - Returns: The rendered HTML page
/// - Note: Content varies based on whether user is authenticated
@Sendable func home(request: Request, context: Context) async throws -> HTML {
  HTML(
    title: "Home",
    isLoggedIn: request.cookies["SESSION_ID"] != nil,
    content: HomeView(
      isLoggedIn: request.cookies["SESSION_ID"] != nil
    ).render()
  )
}
```

In this setup, the `HomeView` struct generates HTML as a string, which is then passed to the `HTML` response generator to create an HTTP response. The route handler (`home`) checks for a session cookie to determine the user's authentication status and renders the page accordingly. While functional, this approach has significant drawbacks. Storing HTML in strings sacrifices Swift's type safety, making it impossible for the compiler to catch errors in HTML structure or attribute usage at compile time. For instance, a typo in a tag name or an unclosed tag would only be caught at runtime, often resulting in malformed HTML that's difficult to debug. Additionally, embedding HTML strings means losing access to Swift's powerful language features, like autocompletion, refactoring tools, and syntax highlighting, which hinders productivity and increases the likelihood of errors. Maintaining and scaling such code becomes cumbersome, especially for complex interfaces with dynamic content.

Frustrated by these limitations, I explored domain-specific languages (DSLs) for writing HTML in Swift, such as [Elementary](https://github.com/sliemeobn/elementary). While Elementary provided a more structured approach by allowing HTML to be expressed in Swift's native syntax, its ergonomics and flexibility didn't fully align with my vision for a seamless and expressive developer experience. This prompted me to create WebUI, a custom solution designed to combine the benefits of type-safe, Swift-native HTML rendering with a syntax that feels intuitive and familiar to [SwiftUI](https://developer.apple.com/xcode/swiftui/).

Another goal of the project was to make it hard to write bad applications. All of the metadata generation is handled by the library, as well as the base HTML document structure. This allows you to focus on the content and just building the user interface.

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

```html
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
import WebUI

let styledContent = Stack {
  Heading(level: .h1) { "Hello, world!" }
    .font(size: .xl4, weight: .bold)
}
.background(color: .zinc(._200))
.background(color: .zinc(._950), on: .dark)
```

## Generating a Simple Static Site

### Creating a Layout Component

WebUI components are defined as structs conforming to the `HTML` protocol.

```swift
import WebUI

struct Layout: HTML {
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
      .frame(maxWidth: .fixed(180), on: .sm)
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Link(to: "/") { "Site Title" }
        }
      }
      .font(size: .sm, color: .zinc(._600, opacity: 0.9))
      .font(color: .zinc(._400, opacity: 0.9), on: .dark)
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._800))
    .background(color: .zinc(._200))
    .font(color: .zinc(._200), on: .dark)
    .background(color: .zinc(._950), on: .dark)
    .flex(direction: .column)
    .render()
  }
}
```

### Generating the Website

To generate a static site, run the build step to create an `.output` directory in the current working directory. If using Xcode, set a custom working directory in your scheme.

```swift
import WebUI

public struct StaticSite {
  var staticRoutes: [Document] {
    [
      Document(
        path: "index",
        metadata: .init(
          site: "Mac Long",
          title: "Home",
          description: "Welcome to the home page.",
          image: "/public/og.jpg",
          author: "Mac Long",
          type: .website
        ),
        head: "<link rel=\"icon\" href=\"public/icon.svg\" type=\"image/svg+xml\" />",
        content: {
          Layout {
            Heading(level: .h1) { "Home Page" }
            Link(to: "/about") { "Go to About" }
          }
        }
      ),
      Document(
        path: "about",
        metadata: .init(
          site: "Mac Long",
          title: "About",
          description: "Learn more about us.",
          image: "/public/og.jpg",
          author: "Mac Long",
          type: .website
        ),
        head: "<link rel=\"icon\" href=\"public/icon.svg\" type=\"image/svg+xml\" />",
        content: {
          Layout {
            Heading(level: .h1) { "About Page" }
            Link(to: "/") { "Go to Home" }
          }
        }
      )
    ]
  }

  func main() async throws {
    try Application(routes: staticRoutes).build(assetsPath: "Sources/StaticSite/Public")
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

This introduction covers the basics of WebUI, a library I created to streamline web development in Swift. While still evolving, WebUI has been a valuable learning experience in Swift and web technologies. Explore this sites [source code](https://github.com/maclong9) to see how a production site using WebUI is built or learn more about the library [here](https://github.com/maclong9/web-ui). 
