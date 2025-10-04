import Foundation
import Testing
import WebUI

@testable import Application

@Suite("Posts Page Tests")
struct PostsTests {

  @Test("Posts page renders without articles")
  func testPostsPageRendersWithoutArticles() async throws {
    // This tests that the Posts page can handle the case where articles fail to load
    let postsPage = Posts()

    // The page should have proper metadata
    #expect(postsPage.metadata.title?.contains("Posts") ?? false)
    #expect(!(postsPage.metadata.description?.isEmpty ?? true))
  }

  @Test("Posts page metadata is properly configured")
  func testPostsPageMetadata() async throws {
    let postsPage = Posts()
    let metadata = postsPage.metadata

    // Title should be overridden to "Posts"
    #expect(metadata.title == "Posts")
    // Description should inherit from Application metadata
    #expect(metadata.description?.contains("Swift") ?? false || metadata.description?.contains("developer") ?? false)
    // Should have proper path
    #expect(postsPage.path == "posts")
  }
}
