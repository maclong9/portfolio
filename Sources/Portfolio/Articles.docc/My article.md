# My article

**Published:** April 15, 2025

This is a simple article that demonstrates how to use snippets in documentation.

> Note: I will leave this article here but hidden as an example of how to create various types of snippets using the Swift package manager.

**Benefits**

- Syntax highlighting
- Hover information
- Type safety and completion

## Example Snippets

**Simple Snippet:**
@Snippet(path: "Portfolio/Snippets/My article/SnippetsExample_I")

--- 

**Snippet with Hide and Show**
@Snippet(path: "Portfolio/Snippets/My article/SnippetsExample_II")

--- 

**Snippet with Slices:**

1. First declare the function:
@Snippet(path: "Portfolio/Snippets/My article/SnippetsExample_III", slice: DECLARATION)

2. Then call it:
@Snippet(path: "Portfolio/Snippets/My article/SnippetsExample_III", slice: USAGE)

**Snippet with Caption:**
@Snippet(path: "Portfolio/Snippets/My article/SnippetsExample_IV")
