# Introduction to WebUI

**Published:** April 15, 2025

1. [What is WebUI?](#what-is-webui)
2. [Why Did I Build It?](#why-did-i-build-it)
3. [Creating a Web Document](#creating-a-web-document)
4. [Adding Styles](#adding-styles)
5. [Generating a Simple Static Site](#generating-a-simple-static-site)
   1. [Creating a Layout Component](#creating-a-layout-component)
	 2. [Generating the Website](#generating-the-website)
6. [Conclusion](#conclusion)

## What is WebUI?

WebUI is an HTML, CSS and JS rendering library built entirely in Swift, it's a convenient way to write simple user interface code with a syntax that is similar to SwiftUI this results in code that is clean, efficient and easy to maintain.

## Why Did I Build It?

Swift is a lovely language that I have been using to write backend code more frequently, thanks to the [Swift On Server](https://www.swift.org/documentation/server/) Workgroup. I noticed I was having to server side render a fair amount of HTML in strings as I wanted to keep my code in the same language instead of having a decoupled frontend. This led me down the path of testing a variety of DSL's for writing HTML in Swift such as [Elementary](https://github.com/sliemeobn/elementary). While this was a great option, I found the syntax to be not quite what I was looking for and opted to build [WebUI](https://github.com/maclong9/web-ui).

## Creating a Web Document

The most basic functionality of WebUI is to generate a web page, you do this by defining a document with a metadata structure and the content to be nested in the document structure, this is passed in the form of a closure with other WebUI elements.

@Snippet(path: "Snippets/Introduction to WebUI/Document")

The above code renders to the HTML seen below, as you can see at the time of writing styles are handled via TailwindCSS although this may change in the future if I decide it will be a useful change. The metadata is rendered into the `<head>` tag and then the closure content is rendered inside of the HTML document's `<body>` tags.

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

Adding styles is a simple task, following a modifier style pattern similar to SwiftUI. Below is an example of a simple div containing a heading, the container has a light background normally and a dark background on `prefers-color-scheme: dark`, and there are some simple typograhpy styles applied to the heading.

@Snippet(path: "Snippets/Introduction to WebUI/Styles")

## Generating a Simple Static Site

### Creating a Layout Component

@Snippet(path: "Snippets/Introduction to WebUI/Static", slice: LAYOUT)

This allows you to create reusable patterns that can be used throughout your WebUI documents, as you can see above I have generated a simple Layout with a header, main and footer.

### Generating the Website

Next we can run the build step to generate a `.output` directory in the current working directory, you will need to set a custom working directory in your Xcode scheme if you are running this from Xcode and not the terminal.

@Snippet(path: "Snippets/Introduction to WebUI/Static", slice: STATIC)

The `.output` directory will follow a pattern like below after the build is completed:

```text
.output/
  index.html
  about.html
```

You are also able to specifiy a public directory that will be copied to `.output/public` with any files nested inside, this means if you wanted to create an image in this example you could place the file inside of `Sources/Static Site/Public` and then reference it in the code like so:

@Snippet(path: "Snippets/Introduction to WebUI/Static", slice: IMAGE)

Make sure you add the `Public` directory as a resource within your target:

@Snippet(path: "Snippets/Introduction to WebUI/Static", slice: RESOURCE)

## Conclusion

This is a simple introduction to a new library that I have created, it is not complete and has a lot of features and improvements to be made. That having been said I did enjoy working on this and learned a lot about Swift and web development technologies in the process. If you would like to see an example of a production site utilising WebUI you can take a look at the [source code](https://github.com/maclong9/portfolio) for this site and to learn more about WebUI in general [check here](https://github.com/maclong9/web-ui), thank you for reading.
