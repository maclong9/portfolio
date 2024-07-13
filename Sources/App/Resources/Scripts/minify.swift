import Foundation
import Logging

func readFile(_ path: String) -> String? {
  return try? String(contentsOfFile: path, encoding: .utf8)
}

func minifyCSS(_ css: String) -> String {
  return css.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    .replacingOccurrences(of: "\\s*([{}:;,])\\s*", with: "$1", options: .regularExpression)
    .replacingOccurrences(of: ";}", with: "}")
    .trimmingCharacters(in: .whitespacesAndNewlines)
}

func minifyJS(_ js: String) -> String {
  return js.replacingOccurrences(of: "//.*", with: "", options: .regularExpression)
    .replacingOccurrences(of: "/\\*[\\s\\S]*?\\*/", with: "", options: .regularExpression)
    .replacingOccurrences(of: ";\\s*([)}])\\s*([a-zA-Z_$])", with: ";$1;$2", options: .regularExpression)
    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    .replacingOccurrences(of: "\\s*([{}():;,=+*/<>!&|])\\s*", with: "$1", options: .regularExpression)
    .replacingOccurrences(of: "-(\\d)", with: "- $1", options: .regularExpression)
    .replacingOccurrences(of: ";}}", with: "}}")
    .replacingOccurrences(of: "}([a-zA-Z_$])", with: "};$1", options: .regularExpression)
    .trimmingCharacters(in: .whitespacesAndNewlines)
}

func getFiles(in directory: String, withExtension ext: String) -> [String] {
  let fileManager = FileManager.default
  guard let enumerator = fileManager.enumerator(atPath: directory) else { return [] }
  
  return enumerator.compactMap { (element) -> String? in
    guard let path = element as? String, path.hasSuffix(".\(ext)") else { return nil }
    return (directory as NSString).appendingPathComponent(path)
  }
}

func minifyFiles(_ logger: Logger) throws {
  let resourcesPath = "Sources/App/Resources"
  let publicPath = "Public"
  let cssDirectory = "\(resourcesPath)/Styles"
  let jsDirectory = "\(resourcesPath)/Scripts"
  
  let cssFiles = getFiles(in: cssDirectory, withExtension: "css")
  let jsFiles = getFiles(in: jsDirectory, withExtension: "js")
  
  var concatenatedCSS = ""
  for file in cssFiles {
    logger.trace("Processing CSS file: \(file)")
    if let content = readFile(file) {
      concatenatedCSS += content + "\n"
    } else {
      logger.warning("Error reading CSS file: \(file)")
    }
  }
  
  let minifiedCSS = minifyCSS(concatenatedCSS)
  
  do {
    try minifiedCSS.write(toFile: "\(publicPath)/styles.min.css", atomically: true, encoding: .utf8)
    logger.notice("CSS Processed and written to Public/styles.min.css")
  } catch {
    logger.error("Error writing CSS output file: \(error)")
  }
  
  var concatenatedJS = ""
  for file in jsFiles {
    logger.trace("Processing JS file: \(file)")
    if let content = readFile(file) {
      concatenatedJS += content + "\n"
    } else {
      logger.warning("Error reading JS file: \(file)")
    }
  }
  
  let minifiedJS = minifyJS(concatenatedJS)
  
  do {
    try minifiedJS.write(toFile: "\(publicPath)/main.min.js", atomically: true, encoding: .utf8)
    logger.notice("JS Processed and written to Public/scripts.min.js")
  } catch {
    logger.error("Error writing JS output file: \(error)")
  }
}
