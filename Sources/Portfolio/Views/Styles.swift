import WebUI

let temporaryLinkStyles = "cursor-pointer transition-colors duration-300 hover:text-teal-600"

extension Element {
  public func spaced() -> Element {
    self
      .margins(.vertical)
  }
}

extension Heading {
  public func styled(size: TextSize) -> Element {
    self
      .font(size: size, weight: .bold, tracking: .tight, wrapping: .balance, color: .zinc(._100))
  }
}

let typographyStyles = """
    :root {
      --text-color: oklch(98.5% 0 0);
      --link-color: oklch(70.4% 0.14 182.503); 
      --hover-color: oklch(0.8 0.078 188.216);
      --border-color: oklch(21% 0.006 285.885);
    }

    a {
      &:where(:not(h1 a, h2 a, h3 a, h4 a, h5 a, h6 a, pre a, header a, footer a)) {
        &:link { color: var(--link-color); }
        &:hover { color: var(--hover-color); }
      }

      &.source { display: none; }

      :where(p code &, li code &) {
        font-weight: normal;
        border-bottom: 1px dotted var(--text-color);
      }
    }

    h1, h2, h3, h4, h5, h6, b, strong {
      font-family: system-ui;
      font-weight: bold;
      color: var(--text-color);
    }
    h1 { font-size: 2.5rem; line-height: 2.25rem; margin-bottom: 0.25rem; }
    h2 { font-size: 1.75rem; line-height: 1.75rem; margin-top: 1.5rem; margin-bottom: 0.25rem; }
    h3 { font-size: 1.5rem; line-height: 1.5rem; margin-top: 1.5rem; margin-bottom: 0.25rem; }
    h4 { font-size: 1.25rem; line-height: 1.25rem; margin-bottom: 0.25rem; }
    h5 { font-size: 1.125rem; line-height: 1.125rem; margin-bottom: 0.25rem; }
    h6 { font-size: 1rem; line-height: 1rem; margin-bottom: 0.25rem; }

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
        
        & p { margin: 0; }
      }
    }
  
    blockquote {
      font-style: italic;
    }

    /* Code Formatting */
    pre {
      font-size: 0.8rem;
      line-height: 1.25rem;
      padding: 1rem;
      margin: 1rem auto;
      border-radius: 8px;
      border: 2px solid var(--border-color);

      & code {
        color: oklch(0.85 0.00 0);
        text-shadow: none;
        font-family: monospace;
        display: block;
        overflow-x: auto;
        white-space: pre;

        & a:not(a.xs) { border-bottom: 1px dotted var(--text-color); }
        & .xk { color: oklch(0.74 0.1431 353.93); }
        & .xt { color: oklch(0.79 0.0844 302.64); }
        & .xv { color: oklch(80% 0.15 300); }
        & .xn { color: oklch(0.75 0.15 90); }
        & .xs { color: oklch(0.75 0.15 20); }
        & .xc, &.xd { color: oklch(0.65 0.05 245); }
        & .xr { color: oklch(0.75 0.20 40); }
      }
    }
  """
