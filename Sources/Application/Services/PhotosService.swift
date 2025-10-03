import Foundation
import WebUI
import ImageIO
import CoreLocation
#if canImport(Contacts)
import Contacts
#endif

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

    // Cache for reverse geocoding to avoid repeated API calls for same locations
    private static let geocodingCacheLock = NSLock()
    private nonisolated(unsafe) static var geocodingCache: [String: String] = [:]

    private static func reverseGeocode(_ coordinate: CLLocationCoordinate2D) -> String? {
        let cacheKey = String(format: "%.4f,%.4f", coordinate.latitude, coordinate.longitude)

        // Check cache first
        geocodingCacheLock.lock()
        let cached = geocodingCache[cacheKey]
        geocodingCacheLock.unlock()

        if let cached = cached {
            return cached
        }

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        var result: String?
        let semaphore = DispatchSemaphore(value: 0)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            defer { semaphore.signal() }

            guard error == nil, let placemark = placemarks?.first else {
                return
            }

            // Build a nice location string from available data
            var components: [String] = []

            // Add specific location name if available
            if let name = placemark.name, !name.isEmpty {
                components.append(name)
            }

            // Add locality (city)
            if let locality = placemark.locality, !locality.isEmpty {
                if components.isEmpty || !components.contains(locality) {
                    components.append(locality)
                }
            }

            // Add administrative area (state/province)
            if let area = placemark.administrativeArea, !area.isEmpty {
                if components.count < 2 {
                    components.append(area)
                }
            }

            // Add country
            if let country = placemark.country, !country.isEmpty {
                if components.count < 2 {
                    components.append(country)
                }
            }

            result = components.joined(separator: ", ")
        }

        // Wait for geocoding to complete (with timeout)
        _ = semaphore.wait(timeout: .now() + 5.0)

        // Cache the result
        if let name = result {
            geocodingCacheLock.lock()
            geocodingCache[cacheKey] = name
            geocodingCacheLock.unlock()
        }

        return result
    }

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

    /// Export album metadata to JSON file
    public static func exportAlbumsMetadata(_ albums: [AlbumResponse], to outputPath: String) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(albums)
        let url = URL(fileURLWithPath: outputPath)
        try data.write(to: url)

        print("✓ Exported metadata for \(albums.count) albums to \(outputPath)")
    }

    /// Import album metadata from JSON file
    public static func importAlbumsMetadata(from inputPath: String) throws -> [AlbumResponse] {
        let url = URL(fileURLWithPath: inputPath)
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let albums = try decoder.decode([AlbumResponse].self, from: data)
        print("✓ Imported metadata for \(albums.count) albums from \(inputPath)")

        return albums
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
                locationName: nil,
                camera: nil,
                lens: nil,
                focalLength: nil,
                aperture: nil,
                shutterSpeed: nil,
                iso: nil,
                keywords: [],
                isRaw: false,
                width: nil,
                height: nil,
                fileSize: fileSize
            )
        }

        // Check if file is actually RAW by checking the image type from metadata
        let rawExtensions = ["dng", "cr2", "cr3", "nef", "arw", "orf", "rw2", "raw"]
        let extensionIsRaw = rawExtensions.contains(url.pathExtension.lowercased())

        // Also check the actual image format type from CGImageSource
        let imageType = CGImageSourceGetType(imageSource) as String?
        let typeIsRaw = imageType?.contains("raw") ?? false ||
                       imageType?.contains("dng") ?? false ||
                       imageType?.contains("cr2") ?? false ||
                       imageType?.contains("nef") ?? false

        let isRaw = extensionIsRaw || typeIsRaw

        // Extract EXIF data
        let exif = properties[kCGImagePropertyExifDictionary as String] as? [String: Any]
        let tiff = properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any]
        let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any]
        let iptc = properties[kCGImagePropertyIPTCDictionary as String] as? [String: Any]

        // Extract caption from IPTC or EXIF
        let caption = (iptc?[kCGImagePropertyIPTCCaptionAbstract as String] as? String)
            ?? (exif?[kCGImagePropertyExifUserComment as String] as? String)
            ?? (tiff?[kCGImagePropertyTIFFImageDescription as String] as? String)

        // Extract date from EXIF, fallback to file creation date if not available
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        let dateString = exif?[kCGImagePropertyExifDateTimeOriginal as String] as? String
            ?? exif?[kCGImagePropertyExifDateTimeDigitized as String] as? String
            ?? tiff?[kCGImagePropertyTIFFDateTime as String] as? String
        let exifDate = dateString.flatMap { dateFormatter.date(from: $0) }

        // Fallback to file creation or modification date if EXIF date is not available
        let fileDate = (try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey]))?.creationDate
            ?? (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
        let dateTaken = exifDate ?? fileDate

        // Extract location from GPS
        var location: CLLocationCoordinate2D?
        var locationName: String?
        if let gps = gps,
           let latitude = gps[kCGImagePropertyGPSLatitude as String] as? Double,
           let longitude = gps[kCGImagePropertyGPSLongitude as String] as? Double,
           let latRef = gps[kCGImagePropertyGPSLatitudeRef as String] as? String,
           let lonRef = gps[kCGImagePropertyGPSLongitudeRef as String] as? String {
            let lat = latRef == "S" ? -latitude : latitude
            let lon = lonRef == "W" ? -longitude : longitude
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            location = coordinate

            // Reverse geocode to get location name
            locationName = reverseGeocode(coordinate)
            if locationName == nil {
                // Fallback to coordinates if reverse geocoding fails
                locationName = String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
            }
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
            locationName: locationName,
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
public struct AlbumResponse: Identifiable, Codable {
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
public struct PhotoMetadata: Codable {
    public let caption: String?
    public let dateTaken: Date?
    public let latitude: Double?
    public let longitude: Double?
    public let locationName: String?
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

    public var location: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    public var hasLocation: Bool {
        latitude != nil && longitude != nil
    }

    public var formattedFileSize: String? {
        guard let size = fileSize else { return nil }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }

    init(caption: String?, dateTaken: Date?, location: CLLocationCoordinate2D?, locationName: String?, camera: String?, lens: String?, focalLength: Double?, aperture: Double?, shutterSpeed: Double?, iso: Int?, keywords: [String], isRaw: Bool, width: Int?, height: Int?, fileSize: Int?) {
        self.caption = caption
        self.dateTaken = dateTaken
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.locationName = locationName
        self.camera = camera
        self.lens = lens
        self.focalLength = focalLength
        self.aperture = aperture
        self.shutterSpeed = shutterSpeed
        self.iso = iso
        self.keywords = keywords
        self.isRaw = isRaw
        self.width = width
        self.height = height
        self.fileSize = fileSize
    }
}

// MARK: - Photo Response
public struct PhotoResponse: Identifiable, Codable {
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
        // Serve photos from R2 storage via worker
        "/media/photos/\(relativePath)"
    }

    public var altText: String {
        metadata.caption ?? fileName
    }
}
