# Music Files

This directory contains audio files for the music player.

## Adding Music

Place your MP3, WAV, M4A, OGG, or FLAC files in this directory. The music player will automatically detect and display them.

## Free Music Resources

### CC0 / Public Domain (No Attribution Required)
- **FreePD.com** - https://freepd.com - Completely free public domain music
- **Pixabay Music** - https://pixabay.com/music - Free music downloads, no attribution needed
- **Chosic CC0** - https://www.chosic.com/free-music/all/?attribution=no - Public domain music

### Creative Commons (Attribution Required)
- **Free Music Archive** - https://freemusicarchive.org
- **ccMixter** - http://ccmixter.org
- **Incompetech** - https://incompetech.com/music/royalty-free

## Quick Download Examples

```bash
# Download from FreePD (visit site to browse)
curl -O https://freepd.com/music/[track-name].mp3

# Or download their entire collection
curl -O https://freepd.com/downloads/FreePD_mp3s.zip
unzip FreePD_mp3s.zip -d ./
```

## File Naming

Files will be automatically processed:
- Filename becomes the song title (with dashes replaced by spaces)
- If you add metadata, it will override the filename
- Organize by album by setting metadata tags

## Current Status

The music player currently uses sample data. Add real audio files here to populate the player with actual music.
