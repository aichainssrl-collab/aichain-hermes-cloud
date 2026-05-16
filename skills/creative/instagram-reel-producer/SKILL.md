---
name: instagram-reel-producer
description: >
  End-to-end production workflow for Instagram Reels, TikToks, and YouTube Shorts — 
  from concept to final vertical video. Uses nanobana (Gemini) for image generation,
  Pillow for professional 9:16 composition with gradient backgrounds, and FFmpeg/MoviePy for assembly.
  Triggers when the user wants to "create a reel", "make a tiktok", "video for instagram", or
  "instagram reel".
---

# Instagram Reel Producer

**From concept to video.** This workflow takes any service/product and produces a professional
vertical video (1080x1920) with text overlays, targeting a specific audience and tone.

## Workflow

### 1. Analysis & Scripting

Determine the target audience, language constraints, and core message.

**Define 5 scenes:**
| Scene | Purpose | Duration |
|-------|---------|----------|
| **Hook (Aggancio)** | Arrest attention in 3s | 4s |
| **Problem (Problema)** | Show the pain point | 5s |
| **Solution (Soluzione)** | Present the answer | 5s |
| **Result (Risultato)** | Quantify the benefit | 4s |
| **CTA (Call to Action)** | Invite to action | 4s |

**Language rules:**
- Use pure local language (e.g., Italian — zero English terms like "studio" → use "ufficio").
- Avoid jargon that confuses the audience.
- **CTA must be positive**, never threatening (avoid "Your competitors are ahead").

### 2. Generate Base Images

Use `nano-img` (Gemini API) to generate 5 images. Prompt for scenes with plenty of "negative space"
(wall, empty desk) where text will later be overlaid.

```bash
export NANO_IMAGE_API_KEY=...
nano-img "Prompt describing the scene..." --output /tmp/reel/01_hook --format png
```

Note: Gemini generates square (1024x1024). Do NOT just stretch or crop blindly.

### 3. Compose 9:16 Frames (Gradient Method)

Do NOT use a blurred background filler — it looks amateurish.
Instead, use a gradient extracted from the image's own dominant colors.

```python
from PIL import Image, ImageDraw, ImageFont

W, H = 1080, 1920
# Load image
img = Image.open(source).convert('RGB')
iw, ih = img.size

# Step 1: Scale to width
scale = W / iw
new_h = int(ih * scale)
resized = img.resize((W, new_h), Image.LANCZOS)

# Step 2: Extract dominant colors from edges
avg_r, avg_g, avg_b = 0, 0, 0
count = 0
for x in range(0, W, 10):
    for y in range(0, new_h, 10):
        r, g, b = resized.getpixel((x, y))
        avg_r += r; avg_g += g; avg_b += b
        count += 1
avg_r //= count; avg_g //= count; avg_b //= count

# Step 3: Create gradient background (darker versions of dominant color)
bg = Image.new('RGB', (W, H))
draw = ImageDraw.Draw(bg)
dark_r, dark_g, dark_b = max(1, avg_r//6), max(1, avg_g//6), max(1, avg_b//6)
for y in range(H):
    t = y / H
    # Smooth gradient from dark edges to center-light
    brightness = 0.4 + 0.6 * (0.5 + 0.5 * ((t-0.3)*2)**2 * -1 + 0.5)
    r = int(dark_r + (avg_r - dark_r) * brightness)
    g = int(dark_g + (avg_g - dark_g) * brightness)
    b = int(dark_b + (avg_b - dark_b) * brightness)
    draw.line([(0, y), (W, y)], 
              fill=(max(0, min(255, r)), 
                    max(0, min(255, g)), 
                    max(0, min(255, b))))

# Step 4: Paste image (centered crop)
if new_h >= H:
    crop_y = (new_h - H) // 2
    center = resized.crop((0, crop_y, W, crop_y + H))
    bg.paste(center, (0, 0))
else:
    y_pos = (H - new_h) // 2
    bg.paste(resized, (0, y_pos))

# Step 5: Semi-transparent overlay for text readability (alpha ~100/255)
overlay = Image.new('RGBA', (W, H), (0, 0, 0, 100))
bg_rgba = bg.convert('RGBA')
bg = Image.alpha_composite(bg_rgba, overlay).convert('RGB')

# Step 6: Add text with shadow/stroke
draw = ImageDraw.Draw(bg)
for line, font, color in text_layout:
    bbox = draw.textbbox((0, 0), line, font=font)
    x = (W - bbox[2]) // 2
    draw.text((x+3, y+3), line, fill=(0,0,0,180), font=font) # Shadow
    draw.text((x, y), line, fill=color, font=font)            # Main

bg.save(f'{outdir}/{scene}_frame.png', 'PNG')
```

### 4. Assemble Video

Use FFmpeg for reliable, fast assembly with smooth transitions.

```bash
# Create individual clips
ffmpeg -y -loop 1 -i 01_hook_frame.png -c:v libx264 -t 4 -pix_fmt yuv420p -vf "scale=1080:1920" scene1.mp4
ffmpeg -y -loop 1 -i 02_problem_frame.png -c:v libx264 -t 5 -pix_fmt yuv420p -vf "scale=1080:1920" scene2.mp4
...

# Concatenate
cat > concat.txt << 'EOF'
file 'scene1.mp4'
file 'scene2.mp4'
...
EOF
ffmpeg -y -f concat -safe 0 -i concat.txt -c copy output_reel.mp4
```

### 5. Review Checklist

- [ ] Text is readable and not overlapping key visual elements
- [ ] Language is pure (no English terms if not required)
- [ ] CTA is positive, not threatening
- [ ] Format is exactly 1080x1920

### 4b. Optional: Ken Burns Animation (zoompan)

Instead of static images, add slow zoom/pan using FFmpeg's `zoompan` filter:

```bash
# Ken Burns effect: slow zoom 1.0→1.05, centered, 60fps
ffmpeg -y -loop 1 -i scene.png \
  -vf "scale=1920:3840,zoompan=z='min(zoom+0.0015,1.05)' \
    :x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)' \
    :d=240:s=1080x1920:fps=60,trim=duration=4.0" \
  -c:v libx264 -preset medium -crf 18 scene_animated.mp4
```

**Key parameters:**
- `scale=1920:3840`: Start at 2x resolution so zoompan can zoom in without upscaling artifacts
- `z='min(zoom+0.0015,1.05)'`: Zoom speed (0.0015 = slow), max 1.05x (subtle, professional)
- `:d=240`: Duration in frames (60fps × 4s = 240)
- `:fps=60`: Higher fps = smoother zoom

### 4c. Optional: Logo with Transparent Background Overlay

Remove white background from an existing logo PNG using `rembg`:

```python
from rembg import remove
from PIL import Image
img = Image.open("logo_with_white_bg.png")
out = remove(img)
out.save("logo_transparent.png")
```

Overlay on video with FFmpeg:
```bash
ffmpeg -i video.mp4 -i logo_transparent.png \
  -filter_complex "overlay=x=(main_w-overlay_w)/2:y=main_h-overlay_h-50" \
  -c:v libx264 video_with_logo.mp4
```

### 4d. Backup Source: Logo from Web Audit Directories

If the user's logo is missing from temp directories, check audit workspace directories first:
`<workspace>/audit/<project>/public/android-chrome-512x512.png` or `favicon-*` are often the highest-quality brand assets available. These come from the website's Next.js/Vite build output.

## Pitfalls

- **Square-to-vertical blur:** Never fill 9:16 space with a blurred version of a square image — it looks cheap and creates dark bars. Use the Gradient Method instead.
- **Text contrast:** Always add a semi-transparent overlay behind text. White text on bright photos is unreadable.
- **Wrong tone:** Don't use "competitor anxiety" for B2B professionals. Focus on efficiency and improvement, not fear.
- **English terms:** In Italian, be very specific. "Studio" might mean "office" or "law firm". Use "Ufficio" for generic B2B.
- **Image generation:** NanoBanana/Gemini generates 1024x1024. You *must* compose to 1080x1920. Do not trust external aspect ratio flags.
- **FFmpeg drawtext apostrophes:** In FFmpeg text strings, apostrophes in Italian text (e.g., "è", "l'ufficio") can break parsing. Use double quotes around the text value: `text="...l'ufficio..."` or escape properly.
- **Zoompan input resolution:** If the input image is not scaled to at least 2x the output resolution, `zoompan` will upscale and create artifacts. Always `scale=1920:3840` before zoompan for 1080x1920 output.
- **rembg model download:** The `rembg` library downloads the `u2net.onnx` model (176MB) on first run. Expect ~3-5 seconds on first use. Always run it once beforehand to avoid surprises during rendering.