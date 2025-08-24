import Foundation
import Testing
import WebUI
@testable import Application

@Suite("Application Integration Tests")
struct ApplicationIntegrationTests {
    
    @Test("Application routes generation")
    func testApplicationRoutesGeneration() async throws {
        let app = Application()
        
        // This should not throw even if individual articles fail
        let routes = try app.routes
        
        // Should have at least the static routes
        #expect(routes.count >= 5) // Home, Posts, Tools, BarreScales, SchengenTracker, Missing
        
        // Verify we have the expected static routes by checking types
        let routeTypes = routes.map { String(describing: type(of: $0)) }
        #expect(routeTypes.contains("Home"))
        #expect(routeTypes.contains("Posts"))
        #expect(routeTypes.contains("Tools"))
        #expect(routeTypes.contains("Missing"))
    }
    
    @Test("Application metadata is properly configured")
    func testApplicationMetadata() async throws {
        let app = Application()
        let metadata = app.metadata
        
        #expect(metadata.site == "Mac Long")
        #expect(metadata.title == "Software Engineer")
        #expect(metadata.titleSeparator == " | ")
        #expect(!(metadata.description?.isEmpty ?? true))
        #expect(metadata.author == "Mac Long")
        #expect(!(metadata.keywords?.isEmpty ?? true))
        #expect(metadata.locale == .en)
        #expect(metadata.type == .website)
        
        // Check structured data
        if let structuredData = metadata.structuredData {
            #expect(structuredData.type == .person)
            let data = structuredData.retrieveStructuredDataDictionary()
            #expect(data["name"] as? String == "Mac Long")
            #expect(data["givenName"] as? String == "Mac")
            #expect(data["familyName"] as? String == "Long")
            #expect(data["jobTitle"] as? String == "Software Engineer")
            #expect(data["email"] as? String == "hello@maclong.uk")
        } else {
            Issue.record("Expected structured data to be present")
        }
    }
    
    @Test("Base URL is configured")
    func testBaseURLConfiguration() async throws {
        let app = Application()
        
        #expect(app.baseURL == "https://maclong.uk")
    }
}