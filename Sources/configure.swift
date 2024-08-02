import Vapor

public extension Request {
    var templates: TemplateRenderer { .init(self) }
}

public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    try routes(app)
}
