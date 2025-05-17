import WebUI

extension Link {
    func styled(weight: Weight = .bold) -> Element {
        self
            .cursor(.pointer)
            .transition(of: .colors)
            .font(weight: weight, family: "system-ui")
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
