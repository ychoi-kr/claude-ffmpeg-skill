#!/bin/bash
# FFmpeg Toolkit - Format Conversion Examples
# This file contains real-world examples of format conversion

echo "FFmpeg Toolkit - Format Conversion Examples"
echo "============================================"
echo ""

# Example 1: Convert MOV to MP4 (most common)
echo "Example 1: MOV to MP4 (H.264 + AAC)"
echo "-----------------------------------"
cat << 'EOF'
ffmpeg -i input.mov \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -c:a aac \
  -b:a 128k \
  output.mp4
EOF
echo ""

# Example 2: Convert to WebM for web
echo "Example 2: MP4 to WebM (VP9 + Opus)"
echo "------------------------------------"
cat << 'EOF'
ffmpeg -i input.mp4 \
  -c:v libvpx-vp9 \
  -crf 30 \
  -b:v 0 \
  -c:a libopus \
  -b:a 128k \
  output.webm
EOF
echo ""

# Example 3: Convert AVI to MP4
echo "Example 3: AVI to MP4 (legacy conversion)"
echo "------------------------------------------"
cat << 'EOF'
ffmpeg -i input.avi \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -c:a aac \
  -strict experimental \
  output.mp4
EOF
echo ""

# Example 4: Convert MKV to MP4 (copy streams if compatible)
echo "Example 4: MKV to MP4 (fast, no re-encoding)"
echo "---------------------------------------------"
cat << 'EOF'
ffmpeg -i input.mkv \
  -c copy \
  output.mp4
EOF
echo ""

# Example 5: Convert with quality control
echo "Example 5: High Quality Conversion (visually lossless)"
echo "-------------------------------------------------------"
cat << 'EOF'
ffmpeg -i input.mov \
  -c:v libx264 \
  -preset slow \
  -crf 18 \
  -c:a aac \
  -b:a 192k \
  output.mp4
EOF
echo ""

# Example 6: Batch conversion
echo "Example 6: Batch Convert All MOV to MP4"
echo "----------------------------------------"
cat << 'EOF'
#!/bin/bash
for file in *.mov; do
  output="${file%.mov}.mp4"
  echo "Converting: $file -> $output"
  ffmpeg -i "$file" \
    -c:v libx264 \
    -preset medium \
    -crf 23 \
    -c:a aac \
    -b:a 128k \
    "$output"
done
EOF
echo ""

# Example 7: Convert with subtitle burn-in
echo "Example 7: Convert with Hardcoded Subtitles"
echo "--------------------------------------------"
cat << 'EOF'
ffmpeg -i input.mkv \
  -vf "subtitles=subtitles.srt" \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -c:a copy \
  output.mp4
EOF
echo ""

# Example 8: Convert 4K to 1080p
echo "Example 8: 4K to 1080p with Conversion"
echo "---------------------------------------"
cat << 'EOF'
ffmpeg -i input_4k.mp4 \
  -vf scale=-1:1080 \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -c:a copy \
  output_1080p.mp4
EOF
echo ""

# Example 9: Convert for Apple devices
echo "Example 9: Convert for iOS/macOS (H.264 High Profile)"
echo "------------------------------------------------------"
cat << 'EOF'
ffmpeg -i input.mp4 \
  -c:v libx264 \
  -profile:v high \
  -level 4.0 \
  -preset medium \
  -crf 23 \
  -c:a aac \
  -b:a 192k \
  -movflags +faststart \
  apple_compatible.mp4
EOF
echo ""

# Example 10: Convert with two-pass encoding (best quality)
echo "Example 10: Two-Pass Encoding (optimal quality/size)"
echo "-----------------------------------------------------"
cat << 'EOF'
# Pass 1
ffmpeg -i input.mp4 \
  -c:v libx264 \
  -preset medium \
  -b:v 2M \
  -pass 1 \
  -an \
  -f mp4 /dev/null

# Pass 2
ffmpeg -i input.mp4 \
  -c:v libx264 \
  -preset medium \
  -b:v 2M \
  -pass 2 \
  -c:a aac \
  -b:a 128k \
  output.mp4
EOF
echo ""

# Tips
echo "Tips & Best Practices:"
echo "----------------------"
echo "• Use -c copy when codecs are already compatible (much faster)"
echo "• CRF 18 = visually lossless, 23 = high quality (default), 28 = acceptable"
echo "• Preset options: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow"
echo "• Add -movflags +faststart for web videos (enables progressive playback)"
echo "• Use two-pass encoding for best quality at target bitrate"
echo "• Always test with a short clip (-t 10) before processing full video"
echo ""

# Interactive example
echo "Want to convert a file now? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Enter input file path:"
    read -r input_file
    
    if [ ! -f "$input_file" ]; then
        echo "Error: File not found!"
        exit 1
    fi
    
    echo "Enter output file path (e.g., output.mp4):"
    read -r output_file
    
    echo ""
    echo "Converting $input_file to $output_file..."
    echo ""
    
    ffmpeg -i "$input_file" \
      -c:v libx264 \
      -preset medium \
      -crf 23 \
      -c:a aac \
      -b:a 128k \
      -movflags +faststart \
      "$output_file"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Conversion successful!"
        echo "Output: $output_file"
    else
        echo ""
        echo "✗ Conversion failed"
        exit 1
    fi
else
    echo "No conversion performed. See examples above for reference."
fi
