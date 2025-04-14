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
  /* Headings */
  h1, h2, h3, h4, h5, h6 {
    color: oklch(96.7% 0.001 286.375);
  }

  h1 {
    font-size: 2.5rem; /* 40px */
    font-weight: 700;  /* Bold */
    line-height: 1.2;  /* 120% */
    margin-block-start: 2.5rem;
    margin-block-end: 1.25rem;
  }

  h2 {
    font-size: 2rem;   /* 32px */
    font-weight: 600;  /* Semi-bold */
    line-height: 1.3;  /* 130% */
    margin-block-start: 2rem;
    margin-block-end: 1rem;
  }

  h3 {
    font-size: 1.5rem; /* 24px */
    font-weight: 600;  /* Semi-bold */
    line-height: 1.4;  /* 140% */
    margin-block-start: 1.5rem;
    margin-block-end: 0.75rem;
  }

  h4 {
    font-size: 1.25rem; /* 20px */
    font-weight: 500;   /* Medium */
    line-height: 1.5;   /* 150% */
    margin-block-start: 1.25rem;
    margin-block-end: 0.625rem;
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
    margin-block-end: 0.4375rem;
  }

  /* Text Markers */
  strong, b {
    font-weight: 700;  /* Bold */
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
  """
