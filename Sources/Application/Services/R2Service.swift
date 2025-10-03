import Foundation

public enum R2Service {
    private static let bucketName = "portfolio-media"

    /// Upload a photo to R2 storage if it doesn't already exist
    public static func uploadPhotoIfNeeded(localPath: String, remotePath: String) throws {
        let fileURL = URL(fileURLWithPath: localPath)

        guard FileManager.default.fileExists(atPath: localPath) else {
            print("⚠️  File not found: \(localPath)")
            return
        }

        // Check if file already exists in R2
        if fileExistsInR2(remotePath: remotePath) {
            print("⏭️  Skipping \(remotePath) (already exists in R2)")
            return
        }

        // Upload to R2 using wrangler
        print("📤 Uploading \(remotePath) to R2...")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = [
            "-c",
            "wrangler r2 object put '\(bucketName)/\(remotePath)' --file='\(localPath)' --content-type='\(contentType(for: fileURL))' --remote"
        ]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus == 0 {
            print("✓ Uploaded \(remotePath)")
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            print("⨉ Failed to upload \(remotePath): \(output)")
        }
    }

    /// Check if a file exists in R2
    private static func fileExistsInR2(remotePath: String) -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = [
            "-c",
            "wrangler r2 object get '\(bucketName)/\(remotePath)' --pipe --remote > /dev/null 2>&1"
        ]

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }

    /// Get MIME type for file
    private static func contentType(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "heic":
            return "image/heic"
        case "webp":
            return "image/webp"
        case "dng", "cr2", "cr3", "nef", "arw":
            return "image/x-raw"
        default:
            return "application/octet-stream"
        }
    }

    /// Upload all photos from an album directory
    public static func uploadAlbum(albumPath: String, albumName: String) throws {
        let albumURL = URL(fileURLWithPath: albumPath)
        let photos = try FileManager.default.contentsOfDirectory(
            at: albumURL,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )

        let supportedExtensions = ["jpg", "jpeg", "png", "gif", "heic", "webp", "dng", "cr2", "cr3", "nef", "arw"]
        let photoFiles = photos.filter { supportedExtensions.contains($0.pathExtension.lowercased()) }

        print("\n📁 Processing album: \(albumName) (\(photoFiles.count) photos)")

        for photo in photoFiles {
            let remotePath = "photos/\(albumName)/\(photo.lastPathComponent)"
            try uploadPhotoIfNeeded(localPath: photo.path, remotePath: remotePath)
        }
    }
}
