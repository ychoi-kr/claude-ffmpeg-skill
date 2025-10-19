# FFmpeg Toolkit - Claude Skill

A comprehensive Claude Skill for video and audio processing using ffmpeg. This skill provides battle-tested commands and workflows for common multimedia processing tasks.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Skills](https://img.shields.io/badge/Claude-Skills-purple.svg)](https://www.anthropic.com/news/skills)

## 🎯 Overview

The FFmpeg Toolkit skill teaches Claude how to perform professional video and audio processing tasks using ffmpeg. Once installed, Claude will automatically recognize video/audio processing requests and apply the appropriate ffmpeg commands.

**Supported Operations:**
- 🎬 Format conversion (MP4, WebM, MOV, AVI, etc.)
- 📐 Resolution scaling and aspect ratio adjustment
- 🎨 High-quality GIF creation with palette optimization
- 🎵 Audio extraction, conversion, and merging
- ✂️ Video trimming, concatenation, and speed adjustment
- 📝 Subtitle processing (burn-in, soft subs, extraction)
- 🖼️ Thumbnail and frame extraction
- 🗜️ Video compression and web optimization
- 📱 Platform-specific presets (YouTube, Instagram, TikTok, Twitter)

## 📋 Requirements

### System Requirements
- **ffmpeg** must be installed on your system
- Claude Pro, Max, Team, or Enterprise plan
- Claude Code v2.0.12 or higher (for Claude Code users)

### Install ffmpeg

**macOS:**
```bash
brew install ffmpeg
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install ffmpeg
```

**Windows (with Chocolatey):**
```bash
choco install ffmpeg
```

**Verify installation:**
```bash
ffmpeg -version
```

## 🚀 Installation

### For Claude Desktop & claude.ai

Skills are automatically synced between Claude Desktop and claude.ai. Upload once to use on both platforms!

1. **Download the latest release:**
   - Go to [Releases](https://github.com/ychoi-kr/claude-ffmpeg-skill/releases)
   - Download `ffmpeg-toolkit.zip`

2. **Upload the Skill:**
   - In Claude Desktop or claude.ai, go to Settings > Capabilities > Skills
   - Click "Upload Skill"
   - Select the downloaded `ffmpeg-toolkit.zip` file

3. **Start using:**
   - If you uploaded via claude.ai and have Claude Desktop open, restart Claude Desktop to see the Skill
   - Just ask Claude to process videos!

**Note:** Custom Skills require a Pro, Max, Team, or Enterprise plan.

### For Claude Code

**Method 1: Git Clone (Recommended)**

```bash
git clone https://github.com/ychoi-kr/claude-ffmpeg-skill.git
cp -r claude-ffmpeg-skill ~/.claude/skills/ffmpeg-toolkit
```

**Method 2: Quick Install Script**

```bash
curl -sSL https://raw.githubusercontent.com/ychoi-kr/claude-ffmpeg-skill/main/install.sh | bash
```

## 💡 Usage

Once installed, Claude will automatically recognize video/audio processing requests. Just describe what you want in natural language!

### Example Interactions

**Format Conversion:**
```
You: "Convert this MOV file to MP4"
Claude: [Uses FFmpeg Toolkit skill to convert with optimal settings]
```

**GIF Creation:**
```
You: "Create a high-quality GIF from video.mp4, starting at 10 seconds, 5 seconds long"
Claude: [Generates GIF with palette optimization]
```

**Resolution Adjustment:**
```
You: "Resize this 4K video to 1080p for web"
Claude: [Scales video and optimizes for web playback]
```

**Audio Extraction:**
```
You: "Extract the audio from this video as MP3"
Claude: [Extracts audio with high quality settings]
```

**Social Media Optimization:**
```
You: "Prepare this video for Instagram Stories"
Claude: [Converts to 9:16, optimizes settings, limits to 15 seconds]
```

**Batch Processing:**
```
You: "Convert all MOV files in this directory to MP4"
Claude: [Creates and runs batch conversion script]
```

## 📚 Features

### Automatic Skill Activation

Claude automatically detects when to use this skill based on keywords like:
- "convert video"
- "create gif"
- "extract audio"
- "resize video"
- "compress video"
- "add subtitles"
- "merge videos"
- "optimize for [platform]"

### Comprehensive Command Library

The skill includes optimized commands for:
- **20+ common operations**
- **Platform-specific presets** (YouTube, Instagram, TikTok, Twitter)
- **Quality optimization** with appropriate CRF values
- **Web-ready output** with faststart flag
- **Batch processing** patterns

### Best Practices Built-In

- Input validation before processing
- Appropriate codec selection
- Quality vs file size optimization
- Error handling and recovery
- Progress indication for long operations

## 🔧 Customization

You can customize the skill by editing `SKILL.md`:

1. Add your own presets
2. Modify default quality settings
3. Add organization-specific workflows
4. Include custom ffmpeg filters

Example custom preset:
```markdown
### Company Logo Overlay
```bash
ffmpeg -i video.mp4 -i logo.png \
  -filter_complex "overlay=W-w-10:H-h-10" \
  output.mp4
```
```

## 📖 Documentation

### Full Command Reference
See [SKILL.md](SKILL.md) for the complete command library and detailed usage instructions.

### Common Use Cases
- [Format Conversion Examples](examples/conversion.md)
- [GIF Creation Guide](examples/gifs.md)
- [Social Media Presets](examples/social-media.md)
- [Batch Processing](examples/batch.md)

### Troubleshooting
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report bugs** - Open an issue describing the problem
2. **Suggest features** - Share ideas for new ffmpeg workflows
3. **Submit presets** - Add platform-specific or use-case presets
4. **Improve documentation** - Help make the skill easier to use

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 🔒 Security

This skill executes ffmpeg commands on your system. To stay safe:

- ✅ Always review generated commands before execution
- ✅ Only process trusted input files
- ✅ Validate file paths to prevent directory traversal
- ✅ Use this skill from trusted sources only

See [SECURITY.md](SECURITY.md) for more information.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [FFmpeg](https://ffmpeg.org/) - The amazing multimedia framework
- [Anthropic](https://www.anthropic.com/) - For creating Claude and the Skills system
- Community contributors - For testing and feedback

## 📬 Support

- **Issues**: [GitHub Issues](https://github.com/ychoi-kr/claude-ffmpeg-skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ychoi-kr/claude-ffmpeg-skill/discussions)

## 🗺️ Roadmap

- [ ] Add hardware acceleration examples (NVIDIA, AMD, Intel)
- [ ] Include more social media platform presets
- [ ] Add video filter examples (blur, sharpen, color correction)
- [ ] Create interactive preset builder
- [ ] Add performance benchmarking utilities
- [ ] Support for advanced audio processing (normalization, noise reduction)

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/ychoi-kr/claude-ffmpeg-skill)
![GitHub forks](https://img.shields.io/github/forks/ychoi-kr/claude-ffmpeg-skill)
![GitHub issues](https://img.shields.io/github/issues/ychoi-kr/claude-ffmpeg-skill)

---

**Made with ❤️ for the Claude community**

If you find this skill useful, please ⭐ star the repository and share it with others!
