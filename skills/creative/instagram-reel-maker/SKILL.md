---
name: instagram-reel-maker
description: Create professional Instagram Reels (9:16) from AI-generated images with clean text overlays and transitions. Use when user wants to create Instagram Reels, Stories, TikTok videos, or short-form vertical videos with multiple scenes and text overlays. Covers image generation (nanobana/Gemini), 9:16 formatting, text overlay assembly with FFmpeg, and transition creation.
metadata:
  version: 1.0.0
---

# Instagram Reel Maker

Create professional vertical videos (9:16, 1080x1920) from AI-generated images with clean text overlays and smooth transitions.

## Workflow Overview

```
Generate Images → Format to 9:16 → Create Text Frames → Assemble with FFmpeg → Output
```

## Critical Lessons (from trial and error)

### ❌ What DOESN'T work:
1. **Dark stretched backgrounds** - Blurring images and adding dark overlays creates ugly artifacts
2. **MoviePy text overlays** - Text overlapping/legibility issues with complex backgrounds
3. **Forcing nanobana to generate 9:16** - It ALWAYS outputs 1024x1024 square regardless of prompt

### ✅ What DOES work:
1. **Natural blur-fill method** - Use the image's own colors for background fill
2. **FFmpeg assembly** - More reliable than MoviePy for text + image compositing
3. **Centered text with safe zones** - Position text where backgrounds are cleaner

## Tools Required

- **nanobana** - For AI image generation (npm install -g nanobana)
- **Pillow** - For image processing
- **FFmpeg** - For video assembly (`apt install ffmpeg`)

## Step 1: Generate Images with Nanobana

Generate square (1024x1024) images with prompts designed for Instagram Reels:

```bash
export NANO_IMAGE_API_KEY="your-key"
nano-img "prompt describing scene..." --output /tmp/reel-images/01_scene --format png
```

**Tip**: Include "vertical smartphone photo format" in prompts for better composition.

## Step 2: Convert to 9:16 Format (Natural Blur Method)

Use this Python script to convert square images to 1080x1920 without ugly dark backgrounds: