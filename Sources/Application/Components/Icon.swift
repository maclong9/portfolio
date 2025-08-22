import WebUI

public struct Icon: Element {
    let name: String
    let width: Int? = 5
    let height: Int? = 5

    public var body: some Markup {
        """
        <i data-lucide="\(name)" class="w-\(width ?? 5) h-\(height ?? 5)"></i>
        """
    }
}
