import WebUI

struct ParticleNetwork: Element {
    public var body: some Markup {
        Stack(classes: [
            "particle-bg", "overflow-hidden", "inset-0", "w-full", "h-full", "opacity-80",
            "absolute",
        ])
    }
}
