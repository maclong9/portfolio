import Redis
import SwiftHtml
import Vapor

func routes(_ app: Application) throws {
  stylesheet.addModules([HomeStyles])
  
  app.get { req -> Response in
    return req.templates.renderHtml(
      LayoutView(
        .init(
          title: "Mac  | Software Engineer",
          description: "Passionate software engineer creating innovative solutions.",
          body: HomeView(
            .init(
              skills: skills,
              projects: projects
            )
          ).build()
        ),
        stylesheet.render()
      )
    )
  }
}
