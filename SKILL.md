---
name: ffmpeg-toolkit
description: Comprehensive video and audio processing using ffmpeg. Handles format conversion, resolution scaling, GIF creation, audio extraction/merging, subtitle processing, and video editing. Activates when user mentions video/audio processing, conversion, GIF creation, extract audio, merge videos, add subtitles, resize video, compress video, or platform names like YouTube, Instagram, TikTok.
---

# FFmpeg Toolkit

A comprehensive skill for video and audio processing using ffmpeg. This skill provides battle-tested commands and workflows for common multimedia processing tasks.

## Prerequisites

Before using this skill, ensure ffmpeg is installed:

```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt-get install ffmpeg

# Windows (with Chocolatey)
choco install ffmpeg
```

Verify installation:
```bash
ffmpeg -version
```

## Supported Operations

### 1. Format Conversion

Convert between video formats with optimized settings.

**MP4 to WebM:**
```bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus output.webm
```

**MOV to MP4:**
```bash
ffmpeg -i input.mov -c:v libx264 -c:a aac -strict experimental output.mp4
```

**Any to MP4 (universal compatibility):**
```bash
ffmpeg -i input.* -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k output.mp4
```

### 2. Resolution Adjustment

Resize videos while maintaining aspect ratio.

**Scale to 720p:**
```bash
ffmpeg -i input.mp4 -vf scale=-1:720 -c:a copy output_720p.mp4
```

**Scale to 1080p:**
```bash
ffmpeg -i input.mp4 -vf scale=-1:1080 -c:a copy output_1080p.mp4
```

**Scale to specific width (auto height):**
```bash
ffmpeg -i input.mp4 -vf scale=1280:-1 -c:a copy output.mp4
```

**Scale with padding (letterbox):**
```bash
ffmpeg -i input.mp4 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" output.mp4
```

### 3. GIF Creation

Create high-quality GIFs from videos with optimized file size.

**Basic GIF (10 fps):**
```bash
ffmpeg -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos" output.gif
```

**High-quality GIF with palette:**
```bash
# Generate palette
ffmpeg -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos,palettegen" palette.png

# Create GIF using palette
ffmpeg -i input.mp4 -i palette.png -filter_complex "fps=10,scale=480:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif
```

**GIF from specific time range:**
```bash
ffmpeg -ss 00:00:10 -t 5 -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif
```

### 4. Audio Operations

Extract, convert, and manipulate audio streams.

**Extract audio to MP3:**
```bash
ffmpeg -i input.mp4 -vn -acodec libmp3lame -q:a 2 output.mp3
```

**Extract audio to WAV:**
```bash
ffmpeg -i input.mp4 -vn -acodec pcm_s16le -ar 44100 -ac 2 output.wav
```

**Convert audio format:**
```bash
ffmpeg -i input.wav -c:a aac -b:a 192k output.m4a
```

**Add background music:**
```bash
ffmpeg -i video.mp4 -i music.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest output.mp4
```

**Mix audio (overlay):**
```bash
ffmpeg -i video.mp4 -i music.mp3 -filter_complex "[0:a][1:a]amix=inputs=2:duration=first" -c:v copy output.mp4
```

### 5. Video Editing

Trim, concatenate, and modify videos.

**Trim video:**
```bash
# From 10s to 30s
ffmpeg -i input.mp4 -ss 00:00:10 -to 00:00:30 -c copy output.mp4

# Duration-based (10s starting from 5s)
ffmpeg -i input.mp4 -ss 00:00:05 -t 10 -c copy output.mp4
```

**Concatenate videos:**
```bash
# Create file list
echo "file 'video1.mp4'" > list.txt
echo "file 'video2.mp4'" >> list.txt
echo "file 'video3.mp4'" >> list.txt

# Concatenate
ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp4
```

**Speed up/slow down:**
```bash
# 2x speed
ffmpeg -i input.mp4 -filter:v "setpts=0.5*PTS" -an output.mp4

# 0.5x speed (slow motion)
ffmpeg -i input.mp4 -filter:v "setpts=2.0*PTS" output.mp4
```

**Rotate video:**
```bash
# 90 degrees clockwise
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4

# 180 degrees
ffmpeg -i input.mp4 -vf "transpose=2,transpose=2" output.mp4
```

### 6. Subtitle Processing

Add, extract, or burn subtitles.

**Burn subtitles into video:**
```bash
ffmpeg -i input.mp4 -vf subtitles=subtitles.srt output.mp4
```

**Add soft subtitles:**
```bash
ffmpeg -i input.mp4 -i subtitles.srt -c copy -c:s mov_text output.mp4
```

**Extract subtitles:**
```bash
ffmpeg -i input.mp4 -map 0:s:0 subtitles.srt
```

### 7. Thumbnail Extraction

Extract frames as images.

**Single frame at specific time:**
```bash
ffmpeg -i input.mp4 -ss 00:00:05 -vframes 1 thumbnail.jpg
```

**Multiple thumbnails:**
```bash
# One frame every 10 seconds
ffmpeg -i input.mp4 -vf fps=1/10 thumb%04d.jpg

# First 10 frames
ffmpeg -i input.mp4 -vframes 10 frame%04d.png
```

### 8. Compression & Optimization

Reduce file size while maintaining quality.

**Compress video (balanced):**
```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4
```

**High compression (smaller file):**
```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 28 -preset veryslow -c:a aac -b:a 96k output.mp4
```

**Compress for web:**
```bash
ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 23 -movflags +faststart -c:a aac -b:a 128k output.mp4
```

## Platform-Specific Presets

### YouTube Optimization
```bash
ffmpeg -i input.mp4 \
  -c:v libx264 -preset slow -crf 18 \
  -c:a aac -b:a 192k \
  -pix_fmt yuv420p \
  -movflags +faststart \
  youtube.mp4
```

### Instagram Story (9:16)
```bash
ffmpeg -i input.mp4 \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -preset medium -crf 23 \
  -c:a aac -b:a 128k \
  -t 15 \
  instagram_story.mp4
```

### Twitter/X (16:9, max 2:20)
```bash
ffmpeg -i input.mp4 \
  -vf scale=1280:720 \
  -c:v libx264 -preset medium -crf 23 \
  -c:a aac -b:a 128k \
  -t 140 \
  twitter.mp4
```

### TikTok (9:16)
```bash
ffmpeg -i input.mp4 \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -preset medium -crf 23 \
  -c:a aac -b:a 128k \
  -t 60 \
  tiktok.mp4
```

## Common Use Cases

### Screen Recording Optimization
```bash
# Reduce file size of screen recordings
ffmpeg -i screen_recording.mov \
  -c:v libx264 -preset medium -crf 23 \
  -vf "scale=1920:-1" \
  -c:a aac -b:a 128k \
  optimized.mp4
```

### Batch Conversion
```bash
# Convert all MOV files to MP4
for i in *.mov; do
  ffmpeg -i "$i" -c:v libx264 -crf 23 -c:a aac "${i%.mov}.mp4"
done
```

### Create Video from Images
```bash
# From image sequence
ffmpeg -framerate 30 -pattern_type glob -i '*.jpg' \
  -c:v libx264 -pix_fmt yuv420p \
  output.mp4

# Single image to video (5 seconds)
ffmpeg -loop 1 -i image.jpg -c:v libx264 -t 5 -pix_fmt yuv420p output.mp4
```

## Best Practices

1. **Always check input file first:**
   ```bash
   ffmpeg -i input.mp4
   # Or use ffprobe for detailed info
   ffprobe -v quiet -print_format json -show_format -show_streams input.mp4
   ```

2. **Use `-c copy` when possible to avoid re-encoding:**
   ```bash
   ffmpeg -i input.mp4 -ss 00:01:00 -t 30 -c copy output.mp4
   ```

3. **Preview before processing with `-t` flag:**
   ```bash
   # Test on first 10 seconds
   ffmpeg -i input.mp4 -t 10 [other options] test.mp4
   ```

4. **Use appropriate CRF values:**
   - 18 = visually lossless
   - 23 = high quality (default)
   - 28 = acceptable quality, smaller file
   - Range: 0 (lossless) to 51 (worst quality)

5. **Add `-movflags +faststart` for web videos:**
   - Enables progressive playback
   - Moves metadata to beginning of file

## Error Handling

When using this skill, always:

1. Verify input file exists and is readable
2. Check ffmpeg installation before processing
3. Validate output path is writable
4. Handle errors gracefully with appropriate messages
5. Show progress when processing large files

## Guidelines for Claude

When a user requests video/audio processing:

1. **Identify the task type** from the request
2. **Select appropriate command** from this skill
3. **Verify prerequisites** (ffmpeg installed, input file exists)
4. **Explain what the command does** before executing
5. **Execute the command** with proper error handling
6. **Verify the output** was created successfully
7. **Suggest optimizations** if applicable

For complex workflows, break down into steps and explain each one.

## Examples

**User:** "Convert this MOV file to MP4"
**Response:** Use the MOV to MP4 conversion command with H.264 codec

**User:** "Make a GIF from this video, but only 5 seconds starting at 10 seconds in"
**Response:** Use GIF creation with time range specification

**User:** "I need to resize this 4K video to 1080p for web"
**Response:** Combine resolution scaling with web optimization preset

**User:** "Extract the audio as MP3"
**Response:** Use audio extraction command with MP3 codec

## References

- FFmpeg Official Documentation: https://ffmpeg.org/documentation.html
- FFmpeg Wiki: https://trac.ffmpeg.org/wiki
- Supported Codecs: https://ffmpeg.org/ffmpeg-codecs.html
- Filter Documentation: https://ffmpeg.org/ffmpeg-filters.html
