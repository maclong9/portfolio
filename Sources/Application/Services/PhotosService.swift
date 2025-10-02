import Foundation
import WebUI
import ImageIO
import CoreLocation

/// Security-related errors for photo processing
enum PhotoSecurityError: Error, LocalizedError {
    case untrustedSource(String)

    var errorDescription: String? {
        switch self {
        case .untrustedSource(let path):
            return "Attempted to process photo from untrusted source: \(path)"
        }
    }
}

public enum PhotosService {
    private static let supportedImageExtensions = ["jpg", "jpeg", "png", "gif", "heic", "webp"]

    public static func fetchAllAlbums(
        from directoryPath: String = "Photos"
    ) throws -> [AlbumResponse] {
        let albumURLs = try fetchAlbumDirectories(from: directoryPath)
        return albumURLs.compactMap { url in
            do {
                return try createAlbumResponse(from: url, basePath: directoryPath)
            } catch {
                print("⚠️  Warning: Failed to process album '\(url.lastPathComponent)': \(error.localizedDescription)")
                return nil
            }
        }
    }

    public static func fetchAllAlbumsWithAll(
        from directoryPath: String = "Photos"
    ) throws -> [AlbumResponse] {
        var albums = try fetchAllAlbums(from: directoryPath)

        // Create "All" album that combines all photos
        let allPhotos = albums.flatMap { $0.photos }
        if !allPhotos.isEmpty {
            let allAlbum = AlbumResponse(
                id: "all",
                name: "All Photos",
                coverPhoto: allPhotos.first,
                photos: allPhotos,
                date: allPhotos.compactMap { $0.creationDate }.min()
            )
            albums.insert(allAlbum, at: 0)
        }

        return albums
    }

    public static func getUniqueLocations(from albums: [AlbumResponse]) -> [String] {
        let locations = albums.flatMap { album in
            album.photos.compactMap { $0.metadata.locationName }
        }
        return Array(Set(locations)).sorted()
    }

    public static func getUniqueCameras(from albums: [AlbumResponse]) -> [String] {
        let cameras = albums.flatMap { album in
            album.photos.compactMap { $0.metadata.camera }
        }
        return Array(Set(cameras)).sorted()
    }

    public static func getDateRange(from albums: [AlbumResponse]) -> (min: Date?, max: Date?) {
        let dates = albums.flatMap { album in
            album.photos.compactMap { $0.metadata.dateTaken }
        }
        return (dates.min(), dates.max())
    }

    private static func fetchAlbumDirectories(from directoryPath: String) throws -> [URL] {
        let baseURL = URL(fileURLWithPath: directoryPath)

        // Check if Photos directory exists
        guard FileManager.default.fileExists(atPath: directoryPath) else {
            print("⚠️  Photos directory not found at '\(directoryPath)'")
            return []
        }

        return try FileManager.default.contentsOfDirectory(
            at: baseURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        ).filter { url in
            var isDirectory: ObjCBool = false
            FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
            return isDirectory.boolValue
        }
    }

    private static func createAlbumResponse(from url: URL, basePath: String) throws -> AlbumResponse {
        // Validate that this is from a trusted source (our Photos directory)
        let trustedBasePath = URL(fileURLWithPath: basePath).standardized
        guard url.standardized.path.hasPrefix(trustedBasePath.path) else {
            throw PhotoSecurityError.untrustedSource(url.path)
        }

        // Get all photos in the album directory
        let photoURLs = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.contentModificationDateKey, .creationDateKey],
            options: .skipsHiddenFiles
        ).filter { fileURL in
            supportedImageExtensions.contains(fileURL.pathExtension.lowercased())
        }.sorted { url1, url2 in
            // Sort by filename (natural ordering)
            url1.lastPathComponent.localizedStandardCompare(url2.lastPathComponent) == .orderedAscending
        }

        // Create photo responses with metadata
        let photos = photoURLs.compactMap { photoURL -> PhotoResponse? in
            let metadata = extractPhotoMetadata(from: photoURL)
            // Build relative path: AlbumName/filename.jpg
            let albumName = url.lastPathComponent
            let relativePath = "\(albumName)/\(photoURL.lastPathComponent)"

            return PhotoResponse(
                id: photoURL.deletingPathExtension().lastPathComponent,
                fileName: photoURL.lastPathComponent,
                path: photoURL.path,
                relativePath: relativePath,
                metadata: metadata
            )
        }

        // Get album date from the oldest photo's creation date
        let albumDate = photos.compactMap { $0.creationDate }.min()

        return AlbumResponse(
            id: url.lastPathComponent,
            name: url.lastPathComponent,
            coverPhoto: photos.first,
            photos: photos,
            date: albumDate
        )
    }

    private static func extractPhotoMetadata(from url: URL) -> PhotoMetadata {
        // Check if file is RAW
        let rawExtensions = ["dng", "cr2", "cr3", "nef", "arw", "orf", "rw2", "raw"]
        let isRaw = rawExtensions.contains(url.pathExtension.lowercased())

        // Get file size
        let fileSize = (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize

        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
            // Fallback to file metadata if EXIF extraction fails
            let fileDate = (try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey]))?.creationDate
            return PhotoMetadata(
                caption: nil,
                dateTaken: fileDate,
                location: nil,
                camera: nil,
                lens: nil,
                focalLength: nil,
                aperture: nil,
                shutterSpeed: nil,
                iso: nil,
                keywords: [],
                isRaw: isRaw,
                width: nil,
                height: nil,
                fileSize: fileSize
            )
        }

        // Extract EXIF data
        let exif = properties[kCGImagePropertyExifDictionary as String] as? [String: Any]
        let tiff = properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any]
        let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any]
        let iptc = properties[kCGImagePropertyIPTCDictionary as String] as? [String: Any]

        // Extract caption from IPTC or EXIF
        let caption = (iptc?[kCGImagePropertyIPTCCaptionAbstract as String] as? String)
            ?? (exif?[kCGImagePropertyExifUserComment as String] as? String)
            ?? (tiff?[kCGImagePropertyTIFFImageDescription as String] as? String)

        // Extract date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        let dateString = exif?[kCGImagePropertyExifDateTimeOriginal as String] as? String
            ?? exif?[kCGImagePropertyExifDateTimeDigitized as String] as? String
            ?? tiff?[kCGImagePropertyTIFFDateTime as String] as? String
        let dateTaken = dateString.flatMap { dateFormatter.date(from: $0) }

        // Extract location from GPS
        var location: CLLocationCoordinate2D?
        if let gps = gps,
           let latitude = gps[kCGImagePropertyGPSLatitude as String] as? Double,
           let longitude = gps[kCGImagePropertyGPSLongitude as String] as? Double,
           let latRef = gps[kCGImagePropertyGPSLatitudeRef as String] as? String,
           let lonRef = gps[kCGImagePropertyGPSLongitudeRef as String] as? String {
            let lat = latRef == "S" ? -latitude : latitude
            let lon = lonRef == "W" ? -longitude : longitude
            location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }

        // Extract camera info
        let cameraMake = tiff?[kCGImagePropertyTIFFMake as String] as? String
        let cameraModel = tiff?[kCGImagePropertyTIFFModel as String] as? String
        let camera = [cameraMake, cameraModel].compactMap { $0 }.joined(separator: " ")

        // Extract lens
        let lens = exif?[kCGImagePropertyExifLensModel as String] as? String

        // Extract shooting parameters
        let focalLength = exif?[kCGImagePropertyExifFocalLength as String] as? Double
        let aperture = exif?[kCGImagePropertyExifFNumber as String] as? Double
        let shutterSpeed = exif?[kCGImagePropertyExifExposureTime as String] as? Double
        let iso = exif?[kCGImagePropertyExifISOSpeedRatings as String] as? [Int]

        // Extract keywords from IPTC
        let keywords = (iptc?[kCGImagePropertyIPTCKeywords as String] as? [String]) ?? []

        // Extract image dimensions
        let width = properties[kCGImagePropertyPixelWidth as String] as? Int
        let height = properties[kCGImagePropertyPixelHeight as String] as? Int

        return PhotoMetadata(
            caption: caption,
            dateTaken: dateTaken,
            location: location,
            camera: camera.isEmpty ? nil : camera,
            lens: lens,
            focalLength: focalLength,
            aperture: aperture,
            shutterSpeed: shutterSpeed,
            iso: iso?.first,
            keywords: keywords,
            isRaw: isRaw,
            width: width,
            height: height,
            fileSize: fileSize
        )
    }

}

// MARK: - Photo Filter
public struct PhotoFilter {
    public let location: String?
    public let camera: String?
    public let dateFrom: Date?
    public let dateTo: Date?
    public let hasLocation: Bool?

    public init(
        location: String? = nil,
        camera: String? = nil,
        dateFrom: Date? = nil,
        dateTo: Date? = nil,
        hasLocation: Bool? = nil
    ) {
        self.location = location
        self.camera = camera
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.hasLocation = hasLocation
    }

    public var isActive: Bool {
        location != nil || camera != nil || dateFrom != nil || dateTo != nil || hasLocation != nil
    }
}

// MARK: - Album Response
public struct AlbumResponse: Identifiable {
    public let id: String
    public let name: String
    public let coverPhoto: PhotoResponse?
    public let photos: [PhotoResponse]
    public let date: Date?
    public let slug: String

    public init(
        id: String,
        name: String,
        coverPhoto: PhotoResponse?,
        photos: [PhotoResponse],
        date: Date?
    ) {
        self.id = id
        self.name = name
        self.coverPhoto = coverPhoto
        self.photos = photos
        self.date = date
        self.slug = id.lowercased().replacingOccurrences(of: " ", with: "-")
    }

    // Filter photos based on criteria
    public func filtered(by filter: PhotoFilter) -> AlbumResponse {
        guard filter.isActive else { return self }

        let filteredPhotos = photos.filter { photo in
            // Filter by location
            if let filterLocation = filter.location,
               photo.metadata.locationName != filterLocation {
                return false
            }

            // Filter by camera
            if let filterCamera = filter.camera,
               photo.metadata.camera != filterCamera {
                return false
            }

            // Filter by has location
            if let hasLocation = filter.hasLocation,
               photo.metadata.hasLocation != hasLocation {
                return false
            }

            // Filter by date range
            if let dateTaken = photo.metadata.dateTaken {
                if let dateFrom = filter.dateFrom, dateTaken < dateFrom {
                    return false
                }
                if let dateTo = filter.dateTo, dateTaken > dateTo {
                    return false
                }
            } else if filter.dateFrom != nil || filter.dateTo != nil {
                return false
            }

            return true
        }

        return AlbumResponse(
            id: id,
            name: name,
            coverPhoto: filteredPhotos.first,
            photos: filteredPhotos,
            date: date
        )
    }

    // Get random photos for animated cover (up to 5)
    public var randomCoverPhotos: [PhotoResponse] {
        let count = min(5, photos.count)
        guard count > 0 else { return [] }

        // Use seeded random for consistent order per album
        var generator = SeededRandomNumberGenerator(seed: UInt64(abs(slug.hashValue)))
        return photos.shuffled(using: &generator).prefix(count).map { $0 }
    }

    // Convert to Card component
    public func toCard() -> Card {
        let photoCount = "\(photos.count) photo\(photos.count == 1 ? "" : "s")"
        return Card(
            title: name,
            description: "",
            tags: [photoCount],
            linkURL: "/photos/\(slug)",
            linkText: "View album",
            newTab: false,
            publishedDate: date
        )
    }
}

// Seeded random number generator for consistent shuffling
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

// MARK: - Photo Metadata
public struct PhotoMetadata {
    public let caption: String?
    public let dateTaken: Date?
    public let location: CLLocationCoordinate2D?
    public let camera: String?
    public let lens: String?
    public let focalLength: Double?
    public let aperture: Double?
    public let shutterSpeed: Double?
    public let iso: Int?
    public let keywords: [String]
    public let isRaw: Bool
    public let width: Int?
    public let height: Int?
    public let fileSize: Int?

    public var locationName: String? {
        guard let location = location else { return nil }
        // In a production app, you'd reverse geocode this
        // For now, return coordinates
        return String(format: "%.4f, %.4f", location.latitude, location.longitude)
    }

    public var hasLocation: Bool {
        location != nil
    }

    public var formattedFileSize: String? {
        guard let size = fileSize else { return nil }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

// MARK: - Photo Response
public struct PhotoResponse: Identifiable {
    public let id: String
    public let fileName: String
    public let path: String
    public let relativePath: String
    public let metadata: PhotoMetadata

    public var creationDate: Date? {
        metadata.dateTaken
    }

    public var caption: String? {
        metadata.caption
    }

    public var webPath: String {
        // URL-encode the path to handle spaces and special characters
        let encodedPath = relativePath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? relativePath
        return "/public/photos/\(encodedPath)"
    }

    public var altText: String {
        metadata.caption ?? fileName
    }
}
