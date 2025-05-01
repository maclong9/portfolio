import WebUI

extension Link {
  public func styled() -> Element {
    self.cursor(.pointer)
      .transition(property: .colors)
      .font(weight: .bold)
      .font(color: .teal(._600), on: .hover)
  }
}

extension Heading {
  public func styled(size: TextSize) -> Element {
    self
      .font(
        size: size,
        weight: .bold,
        tracking: .tight,
        wrapping: .balance,
        color: .zinc(._950),
        family: "system-ui"
      )
      .font(color: .zinc(._100), on: .dark)
  }
}