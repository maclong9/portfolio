import WebUI

public struct Icon: Element {
  let name: String
  let classes: [String]?
  let data: [String: String]?

  public init(name: String, classes: [String]? = nil, data: [String: String]? = nil) {
    self.name = name
    self.classes = classes
    self.data = data
  }

  public var body: some Markup {
    let classString = classes?.joined(separator: " ") ?? "w-5 h-5"
    let dataAttributes = data?.map { " \($0.key)=\"\($0.value)\"" }.joined() ?? ""
    return """
      <i data-lucide="\(name)"\(dataAttributes) class="\(classString)"></i>
      """
  }
}
