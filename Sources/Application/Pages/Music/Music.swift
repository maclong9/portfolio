import Foundation
import WebUI

struct Music: Document {
  var path: String? { "music" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Music")
  }

  // Load music data
  private var musicData: (songs: [Song], albums: [Album], artists: [Artist]) {
    // Try to load real data, fall back to sample data
    do {
      let songs = try MusicService.fetchAllSongs()
      let albums = try MusicService.fetchAllAlbums()
      let artists = try MusicService.fetchAllArtists()

      // If no music files found, use sample data
      if songs.isEmpty {
        return MusicService.getSampleData()
      }

      return (songs, albums, artists)
    } catch {
      return MusicService.getSampleData()
    }
  }

  var body: some Markup {
    BodyWrapper(classes: [
      "bg-zinc-50", "dark:bg-zinc-900", "text-zinc-900", "dark:text-zinc-100",
      "transition-colors", "duration-300", "h-screen", "overflow-hidden",
    ]) {
      // Mobile Menu
      MobileMenu()

      Stack(classes: ["h-screen", "flex", "flex-col"]) {
        // Header
        LayoutHeader(
          breadcrumbs: [
            Breadcrumb(title: "Mac Long", url: "/"),
            Breadcrumb(title: "Music", url: "/music"),
          ],
          emoji: nil
        )

        // Main content area with sidebar and queue
        Stack(classes: ["flex-1", "flex", "pt-24", "overflow-hidden"]) {
          // Left Sidebar (desktop only)
          Stack(classes: [
            "w-64", "bg-white/60", "dark:bg-zinc-900/60",
            "backdrop-blur-xl", "backdrop-saturate-150",
            "border", "border-zinc-200/50", "dark:border-zinc-700/50",
            "rounded-2xl", "shadow-xl",
            "overflow-y-auto", "hidden", "md:block",
            "ml-4", "my-4", "h-[calc(100vh-10rem)]",
          ]) {
            // Sidebar navigation
            Stack(classes: ["p-4", "space-y-6"]) {
              // Library section
              Stack(classes: ["space-y-2"]) {
                Text(
                  "Library",
                  classes: [
                    "text-xs", "font-semibold", "text-zinc-500",
                    "dark:text-zinc-400", "uppercase", "tracking-wider", "px-3",
                  ]
                )

                MarkupString(
                  content: """
                    <button onclick="switchView('songs')" class="flex items-center gap-3 px-3 py-2 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-lg transition-colors cursor-pointer w-full text-left nav-link" data-view="songs">
                      <i data-lucide="music" class="w-5 h-5"></i>
                      <span>Songs</span>
                    </button>

                    <button onclick="switchView('artists')" class="flex items-center gap-3 px-3 py-2 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-lg transition-colors cursor-pointer w-full text-left nav-link" data-view="artists">
                      <i data-lucide="user" class="w-5 h-5"></i>
                      <span>Artists</span>
                    </button>

                    <button onclick="switchView('albums')" class="flex items-center gap-3 px-3 py-2 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-lg transition-colors cursor-pointer w-full text-left nav-link bg-zinc-100 dark:bg-zinc-800" data-view="albums">
                      <i data-lucide="disc" class="w-5 h-5"></i>
                      <span>Albums</span>
                    </button>
                    """
                )
              }
            }
          }

          // Main content area
          Stack(id: "main-content", classes: ["flex-1", "overflow-y-auto", "pb-32", "md:pb-24"]) {
            Stack(classes: ["p-6", "max-w-6xl", "mx-auto"]) {

              // Albums View
              Stack(id: "view-albums", classes: ["mb-8", "music-view"]) {
                Heading(
                  .title,
                  "Albums",
                  classes: [
                    "text-2xl", "font-bold", "mb-4",
                    "text-zinc-900", "dark:text-zinc-100",
                  ]
                )

                // Album grid
                Stack(classes: ["grid", "grid-cols-1", "md:grid-cols-2", "lg:grid-cols-3", "gap-4"]) {
                  // Generate album cards
                  if musicData.albums.isEmpty {
                    Stack(classes: [
                      "p-8", "text-center", "text-zinc-500", "dark:text-zinc-400",
                      "bg-white/50", "dark:bg-zinc-800/50", "rounded-lg", "border",
                      "border-zinc-200", "dark:border-zinc-700", "col-span-full",
                    ]) {
                      Icon(name: "disc", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                      Text("No albums available", classes: ["text-sm"])
                    }
                  } else {
                    for album in musicData.albums {
                      let gradients = [
                        "from-teal-400 to-blue-500",
                        "from-purple-400 to-pink-500",
                        "from-orange-400 to-red-500",
                        "from-green-400 to-cyan-500",
                        "from-indigo-400 to-purple-500",
                      ]
                      let gradient = gradients[abs(album.id.hashValue) % gradients.count]

                      MarkupString(
                        content: """
                          <div class="bg-white/80 dark:bg-zinc-800/80 backdrop-blur-xl backdrop-saturate-150 rounded-lg p-4 border border-zinc-200 dark:border-zinc-700 hover:shadow-lg transition-all cursor-pointer" onclick="showAlbum('\(album.id)')">
                            <div class="aspect-square bg-gradient-to-br \(gradient) rounded-lg mb-3 flex items-center justify-center">
                              <i data-lucide="disc" class="w-16 h-16 text-white/70"></i>
                            </div>
                            <div class="font-semibold text-zinc-900 dark:text-zinc-100 mb-1">\(album.title)</div>
                            <div class="text-sm text-zinc-600 dark:text-zinc-400">\(album.artist)</div>
                            <div class="text-xs text-zinc-500 dark:text-zinc-500">\(album.songCount) song\(album.songCount == 1 ? "" : "s")</div>
                          </div>
                          """
                      )
                    }
                  }
                }
              }

              // Album Detail Views (one for each album)
              for album in musicData.albums {
                let gradients = [
                  "from-teal-400 to-blue-500",
                  "from-purple-400 to-pink-500",
                  "from-orange-400 to-red-500",
                  "from-green-400 to-cyan-500",
                  "from-indigo-400 to-purple-500",
                ]
                let gradient = gradients[abs(album.id.hashValue) % gradients.count]

                Stack(id: "view-album-\(album.id)", classes: ["mb-8", "music-view", "hidden"]) {
                  MarkupString(
                    content: """
                      <button onclick="switchView('albums')" class="inline-flex items-center gap-2 text-teal-600 dark:text-teal-400 hover:text-teal-700 dark:hover:text-teal-300 transition-colors mb-4">
                        <i data-lucide="arrow-left" class="w-4 h-4"></i>
                        Back to Albums
                      </button>

                      <div class="flex flex-col items-center gap-4 mb-6">
                        <!-- Album cover -->
                        <div class="w-48 h-48 bg-gradient-to-br \(gradient) rounded-lg flex items-center justify-center flex-shrink-0">
                          <i data-lucide="disc" class="w-24 h-24 text-white/70"></i>
                        </div>

                        <!-- Album info -->
                        <div class="flex flex-col items-center text-center gap-1">
                          <h2 class="text-2xl font-bold text-zinc-900 dark:text-zinc-100">\(album.title)</h2>
                          <p class="text-base text-zinc-600 dark:text-zinc-400">\(album.artist)</p>
                          <p class="text-sm text-zinc-500 dark:text-zinc-500">\(album.songCount) song\(album.songCount == 1 ? "" : "s")</p>
                        </div>
                      </div>
                      """
                  )

                  // Album songs
                  Heading(
                    .title,
                    "Songs",
                    classes: [
                      "text-xl", "font-semibold", "mb-3",
                      "text-zinc-900", "dark:text-zinc-100",
                    ]
                  )

                  Stack(classes: ["space-y-2"]) {
                    if album.songs.isEmpty {
                      Stack(classes: [
                        "p-8", "text-center", "text-zinc-500", "dark:text-zinc-400",
                        "bg-white/50", "dark:bg-zinc-800/50", "rounded-lg", "border",
                        "border-zinc-200", "dark:border-zinc-700",
                      ]) {
                        Icon(name: "music", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                        Text("No songs available", classes: ["text-sm"])
                      }
                    } else {
                      for song in album.songs {
                        MarkupString(
                          content: """
                            <div class="flex items-center gap-3 p-3 bg-white/50 dark:bg-zinc-800/50 rounded-lg border border-zinc-200 dark:border-zinc-700 hover:bg-white/80 dark:hover:bg-zinc-800/80 transition-all cursor-pointer group">
                              <button onclick="playTrack('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))')" class="p-2 bg-teal-500 text-white rounded-lg hover:bg-teal-600 transition-colors">
                                <i data-lucide="play" class="w-4 h-4"></i>
                              </button>
                              <div class="flex-1">
                                <p class="font-medium text-zinc-900 dark:text-zinc-100">\(song.title)</p>
                                <p class="text-sm text-zinc-600 dark:text-zinc-400">\(song.artist)</p>
                              </div>
                              <button onclick="addToQueue('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))'); event.stopPropagation();" class="p-2 text-zinc-600 dark:text-zinc-400 hover:text-teal-500 dark:hover:text-teal-400 transition-colors opacity-0 group-hover:opacity-100">
                                <i data-lucide="plus" class="w-4 h-4"></i>
                              </button>
                            </div>
                            """
                        )
                      }
                    }
                  }
                }
              }

              // Songs View
              Stack(id: "view-songs", classes: ["mb-8", "music-view", "hidden"]) {
                Heading(
                  .title,
                  "Songs",
                  classes: [
                    "text-2xl", "font-bold", "mb-4",
                    "text-zinc-900", "dark:text-zinc-100",
                  ]
                )

                // Song list
                Stack(classes: ["space-y-2"]) {
                  if musicData.songs.isEmpty {
                    Stack(classes: [
                      "p-8", "text-center", "text-zinc-500", "dark:text-zinc-400",
                      "bg-white/50", "dark:bg-zinc-800/50", "rounded-lg", "border",
                      "border-zinc-200", "dark:border-zinc-700",
                    ]) {
                      Icon(name: "music", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                      Text("No songs available", classes: ["text-sm"])
                    }
                  } else {
                    for song in musicData.songs {
                      MarkupString(
                        content: """
                          <div class="flex items-center gap-3 p-3 bg-white/50 dark:bg-zinc-800/50 rounded-lg border border-zinc-200 dark:border-zinc-700 hover:bg-white/80 dark:hover:bg-zinc-800/80 transition-all cursor-pointer group">
                            <button onclick="playTrack('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))')" class="p-2 bg-teal-500 text-white rounded-lg hover:bg-teal-600 transition-colors">
                              <i data-lucide="play" class="w-4 h-4"></i>
                            </button>
                            <div class="flex-1">
                              <p class="font-medium text-zinc-900 dark:text-zinc-100">\(song.title)</p>
                              <p class="text-sm text-zinc-600 dark:text-zinc-400">\(song.artist) • \(song.album)</p>
                            </div>
                            <button onclick="addToQueue('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))'); event.stopPropagation();" class="p-2 text-zinc-600 dark:text-zinc-400 hover:text-teal-500 dark:hover:text-teal-400 transition-colors opacity-0 group-hover:opacity-100">
                              <i data-lucide="plus" class="w-4 h-4"></i>
                            </button>
                          </div>
                          """
                      )
                    }
                  }
                }
              }

              // Artists View
              Stack(id: "view-artists", classes: ["mb-8", "music-view", "hidden"]) {
                Heading(
                  .title,
                  "Artists",
                  classes: [
                    "text-2xl", "font-bold", "mb-4",
                    "text-zinc-900", "dark:text-zinc-100",
                  ]
                )

                // Artist grid
                Stack(classes: ["grid", "grid-cols-1", "md:grid-cols-2", "lg:grid-cols-3", "gap-4"]) {
                  if musicData.artists.isEmpty {
                    Stack(classes: [
                      "p-8", "text-center", "text-zinc-500", "dark:text-zinc-400",
                      "bg-white/50", "dark:bg-zinc-800/50", "rounded-lg", "border",
                      "border-zinc-200", "dark:border-zinc-700", "col-span-full",
                    ]) {
                      Icon(name: "user", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                      Text("No artists available", classes: ["text-sm"])
                    }
                  } else {
                    for artist in musicData.artists {
                      let gradients = [
                        "from-teal-400 to-blue-500",
                        "from-purple-400 to-pink-500",
                        "from-orange-400 to-red-500",
                        "from-green-400 to-cyan-500",
                        "from-indigo-400 to-purple-500",
                      ]
                      let gradient = gradients[abs(artist.id.hashValue) % gradients.count]

                      MarkupString(
                        content: """
                          <div class="bg-white/80 dark:bg-zinc-800/80 backdrop-blur-xl backdrop-saturate-150 rounded-lg p-4 border border-zinc-200 dark:border-zinc-700 hover:shadow-lg transition-all cursor-pointer" onclick="showArtist('\(artist.id)')">
                            <div class="aspect-square bg-gradient-to-br \(gradient) rounded-full mb-3 flex items-center justify-center">
                              <i data-lucide="user" class="w-16 h-16 text-white/70"></i>
                            </div>
                            <div class="text-center">
                              <div class="font-semibold text-zinc-900 dark:text-zinc-100 mb-1">\(artist.name)</div>
                              <div class="text-sm text-zinc-600 dark:text-zinc-400">\(artist.songCount) song\(artist.songCount == 1 ? "" : "s")</div>
                              <div class="text-xs text-zinc-500 dark:text-zinc-500">\(artist.albums.count) album\(artist.albums.count == 1 ? "" : "s")</div>
                            </div>
                          </div>
                          """
                      )
                    }
                  }
                }
              }

              // Artist Detail Views (one for each artist)
              for artist in musicData.artists {
                let gradients = [
                  "from-teal-400 to-blue-500",
                  "from-purple-400 to-pink-500",
                  "from-orange-400 to-red-500",
                  "from-green-400 to-cyan-500",
                  "from-indigo-400 to-purple-500",
                ]
                let gradient = gradients[abs(artist.id.hashValue) % gradients.count]

                // Get all songs by this artist
                let artistSongs = musicData.songs.filter { $0.artist == artist.name }
                let artistAlbums = musicData.albums.filter { $0.artist == artist.name }

                Stack(id: "view-artist-\(artist.id)", classes: ["mb-8", "music-view", "hidden"]) {
                  MarkupString(
                    content: """
                      <button onclick="switchView('artists')" class="inline-flex items-center gap-2 text-teal-600 dark:text-teal-400 hover:text-teal-700 dark:hover:text-teal-300 transition-colors mb-4">
                        <i data-lucide="arrow-left" class="w-4 h-4"></i>
                        Back to Artists
                      </button>

                      <div class="flex flex-col items-center gap-4 mb-6">
                        <!-- Artist avatar -->
                        <div class="w-48 h-48 bg-gradient-to-br \(gradient) rounded-full flex items-center justify-center flex-shrink-0">
                          <i data-lucide="user" class="w-24 h-24 text-white/70"></i>
                        </div>

                        <!-- Artist info -->
                        <div class="flex flex-col items-center text-center gap-1">
                          <h2 class="text-2xl font-bold text-zinc-900 dark:text-zinc-100">\(artist.name)</h2>
                          <p class="text-base text-zinc-600 dark:text-zinc-400">\(artist.songCount) song\(artist.songCount == 1 ? "" : "s") • \(artist.albums.count) album\(artist.albums.count == 1 ? "" : "s")</p>
                        </div>
                      </div>
                      """
                  )

                  // Albums section
                  if !artistAlbums.isEmpty {
                    Heading(
                      .title,
                      "Albums",
                      classes: [
                        "text-xl", "font-semibold", "mb-3",
                        "text-zinc-900", "dark:text-zinc-100",
                      ]
                    )

                    Stack(classes: ["grid", "grid-cols-1", "md:grid-cols-2", "lg:grid-cols-3", "gap-4", "mb-6"]) {
                      for album in artistAlbums {
                        MarkupString(
                          content: """
                            <div class="bg-white/80 dark:bg-zinc-800/80 backdrop-blur-xl backdrop-saturate-150 rounded-lg p-4 border border-zinc-200 dark:border-zinc-700 hover:shadow-lg transition-all cursor-pointer" onclick="showAlbum('\(album.id)')">
                              <div class="aspect-square bg-gradient-to-br \(gradient) rounded-lg mb-3 flex items-center justify-center">
                                <i data-lucide="disc" class="w-12 h-12 text-white/70"></i>
                              </div>
                              <div class="font-semibold text-zinc-900 dark:text-zinc-100 mb-1">\(album.title)</div>
                              <div class="text-sm text-zinc-600 dark:text-zinc-400">\(album.songCount) song\(album.songCount == 1 ? "" : "s")</div>
                            </div>
                            """
                        )
                      }
                    }
                  }

                  // Songs section
                  Heading(
                    .title,
                    "All Songs",
                    classes: [
                      "text-xl", "font-semibold", "mb-3",
                      "text-zinc-900", "dark:text-zinc-100",
                    ]
                  )

                  Stack(classes: ["space-y-2"]) {
                    if artistSongs.isEmpty {
                      Stack(classes: [
                        "p-8", "text-center", "text-zinc-500", "dark:text-zinc-400",
                        "bg-white/50", "dark:bg-zinc-800/50", "rounded-lg", "border",
                        "border-zinc-200", "dark:border-zinc-700",
                      ]) {
                        Icon(name: "music", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                        Text("No songs available", classes: ["text-sm"])
                      }
                    } else {
                      for song in artistSongs {
                        MarkupString(
                          content: """
                            <div class="flex items-center gap-3 p-3 bg-white/50 dark:bg-zinc-800/50 rounded-lg border border-zinc-200 dark:border-zinc-700 hover:bg-white/80 dark:hover:bg-zinc-800/80 transition-all cursor-pointer group">
                              <button onclick="playTrack('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))')" class="p-2 bg-teal-500 text-white rounded-lg hover:bg-teal-600 transition-colors">
                                <i data-lucide="play" class="w-4 h-4"></i>
                              </button>
                              <div class="flex-1">
                                <p class="font-medium text-zinc-900 dark:text-zinc-100">\(song.title)</p>
                                <p class="text-sm text-zinc-600 dark:text-zinc-400">\(song.album)</p>
                              </div>
                              <button onclick="addToQueue('\(song.url)', '\(song.title.replacingOccurrences(of: "'", with: "\\'"))', '\(song.artist.replacingOccurrences(of: "'", with: "\\'"))'); event.stopPropagation();" class="p-2 text-zinc-600 dark:text-zinc-400 hover:text-teal-500 dark:hover:text-teal-400 transition-colors opacity-0 group-hover:opacity-100">
                                <i data-lucide="plus" class="w-4 h-4"></i>
                              </button>
                            </div>
                            """
                        )
                      }
                    }
                  }
                }
              }
            }
          }

          // Right Queue Panel
          Stack(
            id: "queue-panel",
            classes: [
              "w-80", "bg-white/60", "dark:bg-zinc-900/60",
              "backdrop-blur-xl", "backdrop-saturate-150",
              "border", "border-zinc-200/50", "dark:border-zinc-700/50",
              "rounded-2xl", "shadow-xl",
              "overflow-y-auto", "hidden", "lg:block", "p-4",
              "mr-4", "my-4", "h-[calc(100vh-10rem)]",
            ]
          ) {
            Text(
              "Queue",
              classes: [
                "text-lg", "font-semibold", "mb-4",
                "text-zinc-900", "dark:text-zinc-100",
              ]
            )

            Stack(id: "queue-list", classes: ["space-y-2"]) {
              // Queue items will be added here dynamically
              Stack(classes: ["text-center", "py-8", "text-zinc-500", "dark:text-zinc-400"]) {
                Icon(name: "list-music", classes: ["w-12", "h-12", "mx-auto", "mb-2", "opacity-50"])
                Text("No tracks in queue", classes: ["text-sm"])
              }
            }
          }
        }

        // Mobile Tab Bar (visible only on mobile, below now playing)
        Stack(classes: [
          "md:hidden", "fixed", "bottom-0", "left-0", "right-0",
          "bg-white/95", "dark:bg-zinc-900/95",
          "backdrop-blur-xl", "backdrop-saturate-150",
          "border-t", "border-zinc-200", "dark:border-zinc-800",
          "z-40", "safe-area-inset-bottom",
        ]) {
          Stack(classes: ["flex", "items-center", "justify-around", "px-2", "py-2"]) {
            MarkupString(
              content: """
                <button onclick="switchView('artists')" class="flex flex-col items-center justify-center gap-1 p-2 px-6 flex-1 text-zinc-600 dark:text-zinc-400 transition-all cursor-pointer nav-link rounded-xl" data-view="artists">
                  <i data-lucide="user" class="w-6 h-6"></i>
                  <span class="text-xs font-medium">Artists</span>
                </button>

                <button onclick="switchView('songs')" class="flex flex-col items-center justify-center gap-1 p-2 px-6 flex-1 text-zinc-600 dark:text-zinc-400 transition-all cursor-pointer nav-link rounded-xl" data-view="songs">
                  <i data-lucide="music" class="w-6 h-6"></i>
                  <span class="text-xs font-medium">Songs</span>
                </button>

                <button onclick="switchView('albums')" class="flex flex-col items-center justify-center gap-1 p-2 px-6 flex-1 text-teal-500 dark:text-teal-400 bg-teal-500/10 dark:bg-teal-400/10 transition-all cursor-pointer nav-link active-tab rounded-xl" data-view="albums">
                  <i data-lucide="disc" class="w-6 h-6"></i>
                  <span class="text-xs font-medium">Albums</span>
                </button>
                """
            )
          }
        }

        // Now Playing Bar (above mobile tab bar on mobile)
        MarkupString(
          content: """
            <style>
              #now-playing-bar {
                bottom: 4rem;
              }
              @media (min-width: 768px) {
                #now-playing-bar {
                  bottom: 0;
                }
              }
            </style>
            """
        )

        Stack(
          id: "now-playing-bar",
          classes: [
            "fixed", "left-0", "right-0",
            "bg-white/95", "dark:bg-zinc-900/95",
            "backdrop-blur-xl", "backdrop-saturate-150",
            "border-t", "border-zinc-200", "dark:border-zinc-800",
            "px-4", "py-3", "hidden", "z-50",
          ]
        ) {
          Stack(classes: ["max-w-7xl", "mx-auto", "flex", "flex-col", "gap-2"]) {
            // Progress bar (full width on top)
            Stack(classes: ["w-full"]) {
              MarkupString(
                content: """
                  <input type="range" id="progress-bar" min="0" max="100" value="0" class="w-full" oninput="seekTrack(this.value)">
                  """
              )
            }

            // Controls row
            Stack(classes: ["flex", "flex-row", "items-center", "gap-3", "md:gap-4"]) {
              // Track info
              Stack(classes: ["flex", "items-center", "gap-3", "w-full", "md:flex-1"]) {
                // Album art
                Stack(classes: [
                  "w-12", "h-12", "rounded-lg",
                  "bg-gradient-to-br", "from-teal-400", "to-blue-500",
                  "flex", "items-center", "justify-center", "flex-shrink-0",
                ]) {
                  Icon(name: "disc", classes: ["w-5", "h-5", "text-white/70"])
                }

                Stack(classes: ["flex-1", "min-w-0", "space-y-0.5"]) {
                  Text(
                    "",
                    id: "now-playing-title",
                    classes: [
                      "font-medium", "text-zinc-900", "dark:text-zinc-100", "truncate", "text-sm", "md:text-base",
                    ]
                  )
                  Text(
                    "",
                    id: "now-playing-artist",
                    classes: [
                      "text-xs", "md:text-sm", "text-zinc-600", "dark:text-zinc-400", "truncate",
                    ]
                  )
                }
              }

              // Playback controls
              Stack(classes: ["flex", "items-center", "gap-2", "justify-center"]) {
                Button(
                  onClick: "previousTrack()",
                  classes: [
                    "p-2", "text-zinc-600", "hover:text-zinc-900",
                    "dark:text-zinc-400", "dark:hover:text-zinc-100",
                    "rounded-lg", "hover:bg-zinc-100",
                    "dark:hover:bg-zinc-800", "transition-colors",
                  ],
                  label: "Previous"
                ) {
                  Icon(name: "skip-back", classes: ["w-4", "h-4", "md:w-5", "md:h-5"])
                }

                MarkupString(
                  content: """
                    <button onclick="togglePlayPause()" id="play-pause-btn" class="p-2 md:p-3 bg-teal-500 hover:bg-teal-600 text-white rounded-full transition-colors" aria-label="Play/Pause">
                      <i data-lucide="play" id="play-pause-icon" class="w-5 h-5 md:w-6 md:h-6"></i>
                    </button>
                    """
                )

                Button(
                  onClick: "nextTrack()",
                  classes: [
                    "p-2", "text-zinc-600", "hover:text-zinc-900",
                    "dark:text-zinc-400", "dark:hover:text-zinc-100",
                    "rounded-lg", "hover:bg-zinc-100",
                    "dark:hover:bg-zinc-800", "transition-colors",
                  ],
                  label: "Next"
                ) {
                  Icon(name: "skip-forward", classes: ["w-4", "h-4", "md:w-5", "md:h-5"])
                }

                // Time on mobile
                Stack(classes: ["md:hidden"]) {
                  Text(
                    "0:00",
                    id: "current-time-mobile",
                    classes: [
                      "text-xs", "text-zinc-600", "dark:text-zinc-400",
                    ]
                  )
                }
              }

              // Volume and time (desktop only)
              Stack(classes: ["items-center", "gap-3", "hidden", "md:flex"]) {
                Text(
                  "0:00",
                  id: "current-time",
                  classes: [
                    "text-sm", "text-zinc-600", "dark:text-zinc-400", "w-12",
                  ]
                )
                Icon(name: "volume-2", classes: ["w-5", "h-5", "text-zinc-600", "dark:text-zinc-400"])
              }
            }
          }
        }
      }

      // Hidden audio element
      MarkupString(
        content: """
            <audio id="audio-player"></audio>
            <script>
              let currentQueue = [];
              let currentTrackIndex = -1;
              let audioPlayer = null;

              document.addEventListener('DOMContentLoaded', function() {
                audioPlayer = document.getElementById('audio-player');

                audioPlayer.addEventListener('timeupdate', function() {
                  const current = audioPlayer.currentTime;
                  const duration = audioPlayer.duration || 0;
                  const percent = duration > 0 ? (current / duration) * 100 : 0;

                  const progressBar = document.getElementById('progress-bar');
                  if (progressBar) progressBar.value = percent;

                  const currentTime = document.getElementById('current-time');
                  if (currentTime) currentTime.textContent = formatTime(current);

                  const currentTimeMobile = document.getElementById('current-time-mobile');
                  if (currentTimeMobile) currentTimeMobile.textContent = formatTime(current);
                });

                audioPlayer.addEventListener('ended', function() {
                  nextTrack();
                });

                // Reinitialize Lucide icons after view switches
                if (typeof lucide !== 'undefined') {
                  lucide.createIcons();
                }
              });

              // View switching functionality
              function switchView(viewName) {
                // Hide all views
                document.querySelectorAll('.music-view').forEach(view => {
                  view.classList.add('hidden');
                });

                // Show selected view
                const targetView = document.getElementById('view-' + viewName);
                if (targetView) {
                  targetView.classList.remove('hidden');
                }

                // Update active state in sidebar (desktop)
                document.querySelectorAll('.nav-link').forEach(link => {
                  if (link.dataset.view === viewName) {
                    // Desktop sidebar styling
                    link.classList.add('bg-zinc-100', 'dark:bg-zinc-800');
                    // Mobile tab bar styling - remove inactive colors, add active colors and background
                    link.classList.remove('text-zinc-600', 'dark:text-zinc-400');
                    link.classList.add('text-teal-500', 'dark:text-teal-400', 'bg-teal-500/10', 'dark:bg-teal-400/10');
                  } else {
                    // Desktop sidebar styling
                    link.classList.remove('bg-zinc-100', 'dark:bg-zinc-800');
                    // Mobile tab bar styling - add inactive colors, remove active colors and background
                    link.classList.add('text-zinc-600', 'dark:text-zinc-400');
                    link.classList.remove('text-teal-500', 'dark:text-teal-400', 'bg-teal-500/10', 'dark:bg-teal-400/10');
                  }
                });

                // Reinitialize icons
                if (typeof lucide !== 'undefined') {
                  lucide.createIcons();
                }
              }

              // Show album detail view
              function showAlbum(albumId) {
                // Hide all views
                document.querySelectorAll('.music-view').forEach(view => {
                  view.classList.add('hidden');
                });

                // Show the specific album detail view
                const albumView = document.getElementById('view-album-' + albumId);
                if (albumView) {
                  albumView.classList.remove('hidden');
                }

                // Reinitialize icons
                if (typeof lucide !== 'undefined') {
                  lucide.createIcons();
                }
              }

              // Show artist detail view
              function showArtist(artistId) {
                // Hide all views
                document.querySelectorAll('.music-view').forEach(view => {
                  view.classList.add('hidden');
                });

                // Show the specific artist detail view
                const artistView = document.getElementById('view-artist-' + artistId);
                if (artistView) {
                  artistView.classList.remove('hidden');
                }

                // Reinitialize icons
                if (typeof lucide !== 'undefined') {
                  lucide.createIcons();
                }
              }

              function playTrack(url, title, artist) {
                if (!audioPlayer) return;

                audioPlayer.src = url;
                const playPromise = audioPlayer.play();

                if (playPromise !== undefined) {
                  playPromise.then(() => {
                    document.getElementById('now-playing-title').textContent = title;
                    document.getElementById('now-playing-artist').textContent = artist;
                    document.getElementById('now-playing-bar').classList.remove('hidden');
                    document.getElementById('play-pause-icon').setAttribute('data-lucide', 'pause');

                    // Sync with mini player
                    if (typeof updateMiniPlayer === 'function') {
                      updateMiniPlayer(title, artist, true);
                    }

                    if (typeof lucide !== 'undefined') {
                      lucide.createIcons();
                    }
                  }).catch(error => {
                    console.error('Playback failed:', error);
                  });
                }
              }

              function togglePlayPause() {
                if (!audioPlayer) return;

                if (audioPlayer.paused) {
                  const playPromise = audioPlayer.play();
                  if (playPromise !== undefined) {
                    playPromise.then(() => {
                      document.getElementById('play-pause-icon').setAttribute('data-lucide', 'pause');

                      // Sync with mini player
                      const title = document.getElementById('now-playing-title').textContent;
                      const artist = document.getElementById('now-playing-artist').textContent;
                      if (typeof updateMiniPlayer === 'function') {
                        updateMiniPlayer(title, artist, true);
                      }

                      if (typeof lucide !== 'undefined') {
                        lucide.createIcons();
                      }
                    }).catch(error => {
                      console.error('Playback failed:', error);
                    });
                  }
                } else {
                  audioPlayer.pause();
                  document.getElementById('play-pause-icon').setAttribute('data-lucide', 'play');

                  // Sync with mini player
                  const title = document.getElementById('now-playing-title').textContent;
                  const artist = document.getElementById('now-playing-artist').textContent;
                  if (typeof updateMiniPlayer === 'function') {
                    updateMiniPlayer(title, artist, false);
                  }

                  if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                  }
                }
              }

              function seekTrack(percent) {
                if (!audioPlayer) return;
                const duration = audioPlayer.duration || 0;
                audioPlayer.currentTime = (percent / 100) * duration;
              }

              function addToQueue(url, title, artist) {
                currentQueue.push({ url, title, artist });
                updateQueueDisplay();
              }

              function updateQueueDisplay() {
                const queueList = document.getElementById('queue-list');
                if (currentQueue.length === 0) {
                  queueList.innerHTML = `
                    <div class="text-center py-8 text-zinc-500 dark:text-zinc-400">
                      <i data-lucide="list-music" class="w-12 h-12 mx-auto mb-2 opacity-50"></i>
                      <p class="text-sm">No tracks in queue</p>
                    </div>
                  `;
                } else {
                  queueList.innerHTML = currentQueue.map((track, index) => `
                    <div class="flex items-center gap-3 p-2 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors cursor-pointer" onclick="playFromQueue(${index})">
                      <i data-lucide="music" class="w-4 h-4 text-zinc-600 dark:text-zinc-400"></i>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-zinc-900 dark:text-zinc-100">${track.title}</p>
                        <p class="text-xs text-zinc-600 dark:text-zinc-400">${track.artist}</p>
                      </div>
                      <button onclick="removeFromQueue(${index}); event.stopPropagation();" class="p-1 text-zinc-500 hover:text-red-500 dark:text-zinc-400 dark:hover:text-red-400 transition-colors">
                        <i data-lucide="x" class="w-4 h-4"></i>
                      </button>
                    </div>
                  `).join('');
                }

                if (typeof lucide !== 'undefined') {
                  lucide.createIcons();
                }
              }

              function playFromQueue(index) {
                currentTrackIndex = index;
                const track = currentQueue[index];
                playTrack(track.url, track.title, track.artist);
              }

              function removeFromQueue(index) {
                currentQueue.splice(index, 1);
                updateQueueDisplay();
              }

              function nextTrack() {
                if (currentQueue.length === 0) return;
                currentTrackIndex = (currentTrackIndex + 1) % currentQueue.length;
                playFromQueue(currentTrackIndex);
              }

              function previousTrack() {
                if (currentQueue.length === 0) return;
                currentTrackIndex = (currentTrackIndex - 1 + currentQueue.length) % currentQueue.length;
                playFromQueue(currentTrackIndex);
              }

              function formatTime(seconds) {
                const mins = Math.floor(seconds / 60);
                const secs = Math.floor(seconds % 60);
                return mins + ':' + (secs < 10 ? '0' : '') + secs;
              }
            </script>
          """
      )

      // Footer
      Footer(classes: [
        // Glassmorphic background
        "bg-white/80", "dark:bg-zinc-900/80",
        "backdrop-blur-xl", "backdrop-saturate-150",
        // Gradient border
        "border-t", "border-zinc-200/50", "dark:border-zinc-700/50",
        // Layout
        "px-4", "py-8", "space-y-4", "flex", "flex-col", "items-center", "justify-center",
        // Subtle shadow for depth
        "shadow-[0_-4px_16px_rgba(0,0,0,0.04)]", "dark:shadow-[0_-4px_16px_rgba(0,0,0,0.2)]",
        // Make sure it's above mobile tab bar
        "mb-16", "md:mb-0",
      ]) {
        Stack(classes: ["flex", "flex-row", "items-center", "gap-3", "flex-wrap", "justify-center"]) {
          // Photos link
          Link(
            to: "/photos",
            classes: [
              "p-3", "text-zinc-600", "hover:text-teal-600",
              "dark:text-zinc-400", "dark:hover:text-teal-400",
              "rounded-xl",
              "bg-zinc-100/50", "dark:bg-zinc-800/50",
              "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
              "border", "border-zinc-200/50", "dark:border-zinc-700/50",
              "transition-all", "duration-300", "cursor-pointer",
              "hover:scale-105", "hover:shadow-lg",
            ]
          ) { Icon(name: "image", classes: ["w-5", "h-5"]) }

          // Posts link
          Link(
            to: "/posts",
            classes: [
              "p-3", "text-zinc-600", "hover:text-teal-600",
              "dark:text-zinc-400", "dark:hover:text-teal-400",
              "rounded-xl",
              "bg-zinc-100/50", "dark:bg-zinc-800/50",
              "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
              "border", "border-zinc-200/50", "dark:border-zinc-700/50",
              "transition-all", "duration-300", "cursor-pointer",
              "hover:scale-105", "hover:shadow-lg",
            ]
          ) { Icon(name: "file-text", classes: ["w-5", "h-5"]) }

          // Email link
          Link(
            to: "mailto:hello@maclong.uk",
            classes: [
              "p-3", "text-zinc-600", "hover:text-teal-600",
              "dark:text-zinc-400", "dark:hover:text-teal-400",
              "rounded-xl",
              "bg-zinc-100/50", "dark:bg-zinc-800/50",
              "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
              "border", "border-zinc-200/50", "dark:border-zinc-700/50",
              "transition-all", "duration-300", "cursor-pointer",
              "hover:scale-105", "hover:shadow-lg",
            ]
          ) { Icon(name: "mail", classes: ["w-5", "h-5"]) }

          // GitHub link
          Link(
            to: "https://github.com/maclong9",
            newTab: true,
            classes: [
              "p-3", "text-zinc-600", "hover:text-teal-600",
              "dark:text-zinc-400", "dark:hover:text-teal-400",
              "rounded-xl",
              "bg-zinc-100/50", "dark:bg-zinc-800/50",
              "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
              "border", "border-zinc-200/50", "dark:border-zinc-700/50",
              "transition-all", "duration-300", "cursor-pointer",
              "hover:scale-105", "hover:shadow-lg",
            ]
          ) { Icon(name: "github", classes: ["w-5", "h-5"]) }
        }

        Stack(classes: ["text-zinc-500", "dark:text-zinc-400", "text-sm", "font-medium"]) {
          Text("© \(Date().formatAsYear()) ")
          Link(
            "Mac Long",
            to: "https://maclong.uk",
            classes: [
              "hover:text-teal-600", "dark:hover:text-teal-400",
              "transition-colors", "duration-300",
              "font-semibold",
            ]
          )
          Text(".")
        }
      }
    }
  }
}
