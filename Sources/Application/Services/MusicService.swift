import Foundation

// MARK: - Models

public struct Song: Codable {
  public let id: String
  public let title: String
  public let artist: String
  public let album: String
  public let duration: Int  // in seconds
  public let url: String

  public init(id: String, title: String, artist: String, album: String, duration: Int, url: String) {
    self.id = id
    self.title = title
    self.artist = artist
    self.album = album
    self.duration = duration
    self.url = url
  }
}

public struct Album: Codable {
  public let id: String
  public let title: String
  public let artist: String
  public let songCount: Int
  public let songs: [Song]

  public init(id: String, title: String, artist: String, songCount: Int, songs: [Song]) {
    self.id = id
    self.title = title
    self.artist = artist
    self.songCount = songCount
    self.songs = songs
  }
}

public struct Artist: Codable {
  public let id: String
  public let name: String
  public let songCount: Int
  public let albums: [String]

  public init(id: String, name: String, songCount: Int, albums: [String]) {
    self.id = id
    self.name = name
    self.songCount = songCount
    self.albums = albums
  }
}

// MARK: - Service

public enum MusicService {
  private static let supportedAudioExtensions = ["mp3", "wav", "m4a", "ogg", "flac"]

  /// Fetch all songs from the audio directory
  public static func fetchAllSongs(from directoryPath: String = "Public/audio") throws -> [Song] {
    let fileManager = FileManager.default

    // Check if directory exists
    guard fileManager.fileExists(atPath: directoryPath) else {
      return []
    }

    let contents = try fileManager.contentsOfDirectory(atPath: directoryPath)

    var songs: [Song] = []

    for file in contents {
      let fileExtension = (file as NSString).pathExtension.lowercased()

      guard supportedAudioExtensions.contains(fileExtension) else {
        continue
      }

      let fileName = (file as NSString).deletingPathExtension
      let url = "/audio/\(file)"

      // For now, use filename as title and unknown artist
      // In the future, this could parse ID3 tags or use metadata
      let song = Song(
        id: fileName,
        title: fileName.replacingOccurrences(of: "-", with: " ").capitalized,
        artist: "Unknown Artist",
        album: "Untitled",
        duration: 0,  // Could be extracted from metadata
        url: url
      )

      songs.append(song)
    }

    return songs.sorted { $0.title < $1.title }
  }

  /// Fetch all albums
  public static func fetchAllAlbums(from directoryPath: String = "Public/audio") throws -> [Album] {
    let songs = try fetchAllSongs(from: directoryPath)

    // Group songs by album
    var albumDict: [String: [Song]] = [:]

    for song in songs {
      if albumDict[song.album] == nil {
        albumDict[song.album] = []
      }
      albumDict[song.album]?.append(song)
    }

    // Create Album objects
    var albums: [Album] = []

    for (albumTitle, albumSongs) in albumDict {
      let artistName = albumSongs.first?.artist ?? "Unknown Artist"
      let album = Album(
        id: albumTitle.lowercased().replacingOccurrences(of: " ", with: "-"),
        title: albumTitle,
        artist: artistName,
        songCount: albumSongs.count,
        songs: albumSongs
      )
      albums.append(album)
    }

    return albums.sorted { $0.title < $1.title }
  }

  /// Fetch all artists
  public static func fetchAllArtists(from directoryPath: String = "Public/audio") throws -> [Artist] {
    let songs = try fetchAllSongs(from: directoryPath)

    // Group songs by artist
    var artistDict: [String: [Song]] = [:]

    for song in songs {
      if artistDict[song.artist] == nil {
        artistDict[song.artist] = []
      }
      artistDict[song.artist]?.append(song)
    }

    // Create Artist objects
    var artists: [Artist] = []

    for (artistName, artistSongs) in artistDict {
      let albumNames = Set(artistSongs.map { $0.album })
      let artist = Artist(
        id: artistName.lowercased().replacingOccurrences(of: " ", with: "-"),
        name: artistName,
        songCount: artistSongs.count,
        albums: Array(albumNames)
      )
      artists.append(artist)
    }

    return artists.sorted { $0.name < $1.name }
  }

  /// Get sample data for demonstration when no audio files exist
  public static func getSampleData() -> (songs: [Song], albums: [Album], artists: [Artist]) {
    let songs = [
      Song(
        id: "sample-1",
        title: "Morning Coffee",
        artist: "Lo-Fi Collective",
        album: "Chill Vibes",
        duration: 180,
        url: "/audio/sample-1.mp3"
      ),
      Song(
        id: "sample-2",
        title: "Sunset Dreams",
        artist: "Lo-Fi Collective",
        album: "Chill Vibes",
        duration: 210,
        url: "/audio/sample-2.mp3"
      ),
      Song(
        id: "sample-3",
        title: "Rainy Day",
        artist: "Ambient Waves",
        album: "Nature Sounds",
        duration: 240,
        url: "/audio/sample-3.mp3"
      ),
    ]

    let albums = [
      Album(
        id: "chill-vibes",
        title: "Chill Vibes",
        artist: "Lo-Fi Collective",
        songCount: 2,
        songs: Array(songs[0...1])
      ),
      Album(
        id: "nature-sounds",
        title: "Nature Sounds",
        artist: "Ambient Waves",
        songCount: 1,
        songs: [songs[2]]
      ),
    ]

    let artists = [
      Artist(
        id: "lo-fi-collective",
        name: "Lo-Fi Collective",
        songCount: 2,
        albums: ["Chill Vibes"]
      ),
      Artist(
        id: "ambient-waves",
        name: "Ambient Waves",
        songCount: 1,
        albums: ["Nature Sounds"]
      ),
    ]

    return (songs, albums, artists)
  }
}
