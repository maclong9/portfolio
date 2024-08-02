import Vapor
import SwiftSgml

public protocol TemplateRepresentable {
  @TagBuilder
  func render(_ req: Request) -> Tag
}

public struct TemplateRenderer {
  var req: Request
  
  init(_ req: Request) {
    self.req = req
  }
  
  public func renderHtml(_ template: TemplateRepresentable) -> Response {
    let doc = Document(.html) { template.render(req) }
    let body = DocumentRenderer(minify: true).render(doc)
    return Response(status: .ok, headers: ["content-type": "text/html"], body: .init(string: body))
  }
}

protocol TagRepresentable {
    @TagBuilder
    func build() -> Tag
}
