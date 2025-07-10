import Foundation

/// CloudFunctions management for the application
///
/// This class handles fetching cloud function scripts from a remote URL and
/// updating the local middleware file used by the application.
struct CloudFunctions {
  /// The URL to fetch the scripts from
  static let middlewareURLs = [
    "_middleware": URL(string: "https://static.maclong.uk/middleware.js")!
  ]

  /// Fetches the middleware script from the remote URL and updates the local file
  ///
  /// This method uses async/await for better performance and code readability
  static func fetchAndUpdate() async {
    do {
      for (key, value) in middlewareURLs {
        // Create URL request
        let request = URLRequest(url: value)

        // Perform the async network request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check if we received a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
          print("Error: Invalid response")
          return
        }

        // Check if the status code indicates success
        guard (200...299).contains(httpResponse.statusCode) else {
          print("HTTP error: \(httpResponse.statusCode)")
          return
        }

        // Ensure we have data and can convert it to a string
        guard let content = String(data: data, encoding: .utf8) else {
          print("Error: Could not decode data")
          return
        }

        // Write the content to the output file
        try FileManager.default.createDirectory(
          at: URL(fileURLWithPath: ".output/functions"),
          withIntermediateDirectories: true
        )
        try content.write(
          to: URL(fileURLWithPath: ".output/functions/\(key).js"),
          atomically: true,
          encoding: .utf8
        )
      }
    } catch {
      print("Failed to update cloud functions: \(error)")
    }
  }
}
