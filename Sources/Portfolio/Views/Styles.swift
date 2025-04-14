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
      section {
        box-sizing: border-box; /* Include padding/margins in width */
        margin-inline: auto; /* Center within parent */
        max-width: 90vw;

        @media(min-width: 640px) {
          max-width: 64ch; /* Match main's max-width */
        }
      }

      ul {
        display: block;
        list-style-type: disc;
        padding: 0 0 0 40px;
      }

      /* Headings */
      h1, h2, h3, h4, h5, h6 {
        color: oklch(96.7% 0.001 286.375);
      }

      h1 {
        font-size: 2.5rem; /* 40px */
        font-weight: 700;  /* Bold */
        line-height: 1.2;  /* 120% */
        margin-block-start: 2.5rem;
        margin-block-end: 0.5rem;
      }

      h2 {
        font-size: 2rem;   /* 32px */
        font-weight: 600;  /* Semi-bold */
        line-height: 1.3;  /* 130% */
        margin-block-start: 2rem;
        margin-block-end: 0.5rem;
      }

      h3 {
        font-size: 1.5rem; /* 24px */
        font-weight: 600;  /* Semi-bold */
        line-height: 1.4;  /* 140% */
        margin-block-start: 1.5rem;
        margin-block-end: 0.5rem;
      }

      h4 {
        font-size: 1.25rem; /* 20px */
        font-weight: 500;   /* Medium */
        line-height: 1.5;   /* 150% */
        margin-block-start: 1.25rem;
        margin-block-end: 0.5rem;
      }

      h5 {
        font-size: 1rem;   /* 16px */
        font-weight: 500;  /* Medium */
        line-height: 1.5;  /* 150% */
        margin-block-start: 1rem;
        margin-block-end: 0.5rem;
      }

      h6 {
        font-size: 0.875rem; /* 14px */
        font-weight: 500;    /* Medium */
        line-height: 1.6;    /* 160% */
        margin-block-start: 0.875rem;
        margin-block-end: 0.5rem;
      }

      /* Text Markers */
      strong, b {
        font-weight: 700;  /* Bold */
      }
  
      a.source {
        margin-block-end: 1rem;
        display: block; 
      }
  
      em, i {
        font-style: italic;
        font-weight: 400;  /* Regular */
      }

      small {
        font-size: 0.875rem; /* 14px */
        font-weight: 400;    /* Regular */
        line-height: 1.4;    /* 140% */
      }

      blockquote {
        font-size: 1.125rem; /* 18px */
        font-weight: 400;    /* Regular */
        line-height: 1.5;    /* 150% */
        margin-block-start: 1.5rem;
        margin-block-end: 1.5rem;
        margin-inline-start: 2rem;
        margin-inline-end: 2rem;
      }

      /* Code Formatting */
      pre {
        background: oklch(25% 0.01 280); /* Dark gray-blue, like Xcode's editor background */
        border-radius: 0.5rem; /* Smooth rounding */
        box-shadow: 0 4px 8px oklch(0% 0 0 / 0.2); /* Subtle shadow for depth */
        padding: 1rem;
        margin-block-start: .4rem;
        margin-block-end: .4rem;
        margin-inline: 0;
        max-width: 64ch; /* Match main's max-width */
        overflow-x: auto; /* Horizontal scroll for long code */
        font-size: 0.875rem; /* 14px, readable */
        line-height: 1.5; /* Comfortable line spacing */
        white-space: pre; /* Preserve whitespace and line breaks */
        box-sizing: border-box; /* Ensure padding doesn't cause overflow */
      }

      code {
        font-family: "SF Mono", "Menlo", "Consolas", monospace; /* Xcode-like monospaced font */
        background: transparent; /* No extra background inside pre */
        color: oklch(90% 0.02 280); /* Light gray for default text, like Xcode's plain text */
        white-space: pre; /* Ensure token spacing is preserved */
        margin: 0 .2px;
      }

      /* Inline code */
      :not(pre) > code {
        background: oklch(30% 0.01 280); /* Slightly lighter than pre for contrast */
        border-radius: 0.25rem;
        padding: 0.2rem 0.4rem;
        white-space: normal; /* Inline code doesn't need pre formatting */
      }

      /* Syntax Highlighting (Xcode-inspired) */
      code .xa { color: oklch(70% 0.15 30); } /* Attribute: Orange */
      code .xb { color: oklch(75% 0.12 320); } /* Binding: Pinkish-purple */
      code .xc { color: oklch(60% 0.05 140); } /* Comment: Green-gray */
      code .xr { color: oklch(80% 0.14 340); } /* Directive: Bright pink */
      code .xd { color: oklch(60% 0.05 140); } /* Doccomment: Same as comment */
      code .xv { color: oklch(90% 0.02 280); } /* Identifier: Default light gray */
      code .xj { color: oklch(65% 0.13 50); } /* Interpolation: Yellow-orange */
      code .xk { color: oklch(80% 0.15 300); } /* Keyword: Purple */
      code .xl { color: oklch(75% 0.12 320); } /* Label: Same as binding */
      code .xn { color: oklch(70% 0.12 100); } /* Literal number: Teal */
      code .xs { color: oklch(75% 0.14 20); } /* Literal string: Red-orange */
      code .xm { color: oklch(80% 0.14 340); } /* Magic: Same as directive */
      code .xo { color: oklch(85% 0.05 280); } /* Operator: Slightly brighter gray */
      code .xp { color: oklch(70% 0.12 200); } /* Pseudo: Cyan */
      code .xy { color: oklch(80% 0.12 260); } /* Actor: Blue */
      code .xz { color: oklch(80% 0.12 260); } /* Class: Same as actor */
      code .xt { color: oklch(80% 0.12 260); } /* Type: Same as actor */
      code .xu { color: oklch(80% 0.12 260); } /* Typealias: Same as actor */
      code .xi { color: transparent; } /* Indent: No color, spacing handled by pre */  
  """
