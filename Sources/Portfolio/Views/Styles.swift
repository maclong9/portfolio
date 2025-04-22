import WebUI

extension Link {
  public func styled() -> Element {
    self.cursor(.pointer)
      .transition(property: .colors)
      .font(weight: .bold)
      .font(color: .teal(._600), on: .hover)
  }
}

extension Element {
  public func spaced() -> Element {
    self.margins(.vertical)
  }
}

extension Heading {
  public func styled(size: TextSize) -> Element {
    self
      .font(size: size, weight: .bold, tracking: .tight, wrapping: .balance, color: .zinc(._950))
      .font(color: .zinc(._100), on: .dark)
  }
}

let typographyStyles = """
  :root {
    --text-color: oklch(27.4% 0.006 286.033);
    --link-color: oklch(70.4% 0.14 182.503);
    --hover-color: oklch(0.8 0.078 188.216);
    --border-color: oklch(0.46 0 0);

    @media (prefers-color-scheme: dark) {
      --text-color: oklch(98.5% 0 0);
    }
  }

  a {
    &:where(:not(h1 a, h2 a, h3 a, h4 a, h5 a, h6 a, pre a, header a, footer a)) {
      cursor: pointer;
      transition: color 0.2s ease-in-out;

      &:link,
      &:visited {
        color: var(--link-color);
      }

      &:hover {
        color: var(--hover-color);
      }
    }

    &.source {
      display: none;
    }

    p code &,
    li code &,
    p & {
      border-bottom: 1px dotted var(--text-color);
      font-weight: normal;
    }
  }

  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  b,
  strong {
    font-family:
      system-ui,
      -apple-system,
      BlinkMacSystemFont,
      "Segoe UI",
      Roboto,
      Oxygen,
      Ubuntu,
      Cantarell,
      "Open Sans",
      "Helvetica Neue",
      sans-serif;
    font-weight: bold;
    color: var(--text-color);
  }

  h1 {
    font-size: 2.5rem;
    line-height: 2.25rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  h2 {
    font-size: 1.75rem;
    line-height: 1.75rem;
    margin-top: 1.5rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  h3 {
    font-size: 1.5rem;
    line-height: 1.5rem;
    margin-top: 1.5rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  h4 {
    font-size: 1.25rem;
    line-height: 1.25rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  h5 {
    font-size: 1.125rem;
    line-height: 1.125rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  h6 {
    font-size: 1rem;
    line-height: 1rem;
    margin-bottom: 0.25rem;
    letter-spacing: -0.02em;
  }

  p {
    font-family: ui-serif;
    margin: 1rem 0;

    & code {
      font-family: monospace;
      font-weight: bold;
    }
  }

  ul {
    list-style: disc;
    margin-left: 2rem;

    & li {
      margin-bottom: 1rem;

      & p {
        margin: 0;
        width: 100%;
        box-sizing: border-box;
      }
    }
  }

  blockquote {
    font-style: italic;
  }

  pre {
    background-color: oklch(0.2 0 0);
    font-size: 0.8rem;
    line-height: 1.25rem;
    padding: 1rem;
    margin: 1rem auto;
    border-radius: 8px;
    border: 1px solid var(--border-color);
    overflow-x: auto;

    & code {
      color: oklch(0.85 0 0);
      text-shadow: none;
      font-family:
        ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono",
        "Courier New", monospace;
      display: block;
      white-space: pre;

      & a:not(.xs) {
        border-bottom: 1px dotted var(--text-color);
      }

      &.hljs {
        color: var(--text-color);
      }

      .hljs-comment,
      .hljs-quote {
        color: oklch(60% 0.03 250);
        font-style: italic;
      }

      .hljs-keyword,
      .hljs-selector-tag,
      .hljs-literal,
      .hljs-section,
      .hljs-link {
        color: oklch(74% 0.14 353.93);
      }

      .hljs-title,
      .hljs-name,
      .hljs-variable {
        color: oklch(79% 0.0844 302.64);
      }

      .hljs-string,
      .hljs-doctag,
      .hljs-attr {
        color: oklch(75% 0.15 20);
      }

      .hljs-number,
      .hljs-meta,
      .hljs-built_in,
      .hljs-builtin-name,
      .hljs-symbol {
        color: oklch(75% 0.15 90);
      }

      .hljs-type {
        color: oklch(69% 0.0752 225.02);
      }

      .hljs-attribute {
        color: oklch(65% 0.05 245);
      }

      .hljs-regexp {
        color: oklch(75% 0.2 40);
      }

      .hljs-subst {
        color: var(--text-color);
      }

      .hljs-emphasis {
        font-style: italic;
      }

      .hljs-strong {
        font-weight: bold;
      }
    }
  }

  """
