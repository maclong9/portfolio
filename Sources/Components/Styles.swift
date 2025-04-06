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
