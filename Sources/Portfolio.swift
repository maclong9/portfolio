import WebUI

@main
struct Portfolio {
  static func main() async throws {
    do {
      let app = Application(
        routes: [
          Document(
            path: "index",
            metadata: .init(
              title: "Home",
              description:
                "Mac Long is a Software Engineer, crafting intutive solutions using modern technologies."
            ),
            content: { Home() }
          ),
          Document(
            path: "projects",
            metadata: .init(
              title: "Projects",
              description:
                "A collection of open source projects Mac Long has worked on in the past."
            ),
            content: { Projects() }
          ),
          Document(
            path: "blog",
            metadata: .init(
              title: "Blog",
              description:
                "Thoughts and musings on software development, by Mac Long."
            ),
            content: { Articles() }
          ),
        ]
      )

      try app.build()
    } catch {
      print("Build failed with error: \(error)")
      throw error
    }
  }
}
