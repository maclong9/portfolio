import WebUI

extension Element {
  public func spaced() -> Element {
    self
      .margins(.vertical)
  }
}

extension Anchor {
  public func styled(bold: Bool = false) -> Element {
    self
      .cursor(.pointer)
      .transition(property: .colors, duration: 300)
      .font(weight: bold ? .bold : .normal)
      .font(color: .teal(._600), on: .hover)
  }
}


extension Heading {
  public func styled(size: TextSize) -> Element {
    self
      .font(size: size, weight: .bold, tracking: .tight, color: .zinc(._100))
  }
}
