import Vapor
import Redis

public extension Request {
    var templates: TemplateRenderer { .init(self) }
}

public func configure(_ app: Application) async throws {
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  app.redis.configuration = try RedisConfiguration(hostname: "localhost")
  try routes(app)
}
