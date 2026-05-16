---
name: instagram-reel-creator
description: Create vertical 1080x1920 Instagram Reels from AI-generated image slides with text overlays using nanobana and FFmpeg. Pure Italian B2B copywriting, no anglicisms.
metadata:
  version: 2.0.0
---

# Instagram Reel Creator

Create vertical 1080x1920 Instagram Reels by generating image slides, overlaying text, and assembling into video.

## Pipeline

PLAN then GENERATE IMAGES then CTA SLIDE then ASSEMBLE VIDEO then DELIVER

## Step 1: Plan the Reel

Determine 5 scenes following classic marketing flow:

| Scene | Purpose | Duration |
|-------|---------|----------|
| 1 - Aggancio | Question or pain point that stops scrolling | 4s |
| 2 - Problema | Specific frustrations, 3 bullet points | 5s |
| 3 - Soluzione | The product or AI solution | 5s |
| 4 - Risultato | Real numbers or outcome | 4s |
| 5 - CTA | Call to action with brand logo | 4s |

**Language rules**: use pure Italian, zero English words, no anglicisms. Match the audience everyday language.

**Audience**: Legal studios, accountants, labor consultants, corporate consultants. Do NOT default to automotive or manufacturing examples.

## Step 2: Generate Images with NanoBanana

NanoBanana is a CLI wrapper around Google Gemini image generation.

Setup:
```bash
export NANO_IMAGE_API_KEY="YOUR_GEMINI_API_KEY"
mkdir -p /tmp/reel-images
```

Generate each scene image. NanoBanana **always outputs 1024x1024 squares** regardless of width or height flags:
```bash
nano-img "YOUR_PROMPT_HERE" --output /tmp/reel-images/01_aggancio --format png
```

**CRITICAL**: The `--width` and `--height` flags are applied LOCALLY after generation. The model always generates 1024x1024. Do not promise vertical output from NanoBanana prompts.

### Prompt Guidelines
- Describe the scene centered on a clean background with margins
- Do NOT use "vertical" or "9:16" or "portrait" in prompts — the model ignores it
- Include style words: photorealistic, corporate photography, professional office
- No text in prompts — the model does not render text reliably

### Known Good Prompts
```
# Professional office
"Modern professional Italian office desk with organized documents, warm natural lighting, photorealistic corporate photography, clean sophisticated style"

# Frustration
"Frustrated professional at desk overwhelmed by piles of paperwork, realistic office, warm lighting, business photography style, photorealistic"

# Tech solution
"Sleek digital tablet showing organized documents on clean office desk, modern technology, warm professional lighting, photorealistic corporate tech aesthetic"

# Success
"Confident happy professional in modern bright office looking at tablet with satisfaction, golden hour sunlight, success atmosphere, photorealistic corporate photography"
```

## Step 3: Vertical Reframe 9:16

**DO NOT use the blur-and-letterbox method**. Dark blurred borders around a clean center look awful and were rejected by the user.

### Working approaches

**Option A: FFmpeg clean crop** — scale then center-crop, loses side margins:
```bash
ffmpeg -i input.png -vf "scale=1920:1920,crop=1080:1920:(iw-1080)/2:(ih-1920)/2" output.png
```

**Option B: FFmpeg brand-color pad** — scale to fit width, pad top and bottom with brand color:
```bash
ffmpeg -i input.png -vf "scale=1080:1080,pad=1080:1920:0:(1920-1080)/2:color=#0B0F2E" output.png
```

**Option C: Generate with AI video models** — use Replicate MiniMax, Wan 2.7, or Kling to generate video directly from text in 9:16. No image-to-video step needed.

## Step 4: Create CTA Logo Slide

When you need a branded closing slide with the company logo:

```python
from PIL import Image, ImageDraw, ImageFont

def make_cta_slide(logo_path, out_path, title, subtitle, tagline=""):
    target_w, target_h = 1080, 1920
    bg_top = (11, 15, 46)
    bg_bottom = (25, 30, 75)

    bg = Image.new('RGBA', (target_w, target_h))
    draw = ImageDraw.Draw(bg)
    for y in range(target_h):
        ratio = y / target_h
        r = int(bg_top[0] + (bg_bottom[0] - bg_top[0]) * ratio)
        g = int(bg_top[1] + (bg_bottom[1] - bg_top[1]) * ratio)
        b = int(bg_top[2] + (bg_bottom[2] - bg_top[2]) * ratio)
        draw.line([(0, y), (target_w, y)], fill=(r, g, b, 255))

    logo = Image.open(logo_path).convert('RGBA')
    logo_w = 600
    logo = logo.resize((logo_w, int(logo_w * logo.height / logo.width)), Image.LANCZOS)
    logo_x = (target_w - logo.width) // 2
    logo_y = 180
    bg.paste(logo, (logo_x, logo_y), logo)

    bold_font = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeSansBold.ttf', 42)
    reg_font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 26)

    bbox = draw.textbbox((0, 0), title, font=bold_font)
    draw.text(((target_w - bbox[2] + bbox[0]) // 2, 1000), title, fill='#FFFFFF', font=bold_font)

    bbox2 = draw.textbbox((0, 0), subtitle, font=reg_font)
    draw.text(((target_w - bbox2[2] + bbox2[0]) // 2, 1060), subtitle, fill='#D4A017', font=reg_font)

    out_rgb = Image.new('RGB', (target_w, target_h))
    out_rgb.paste(bg.convert('RGB'), (0, 0))
    out_rgb.save(out_path, 'PNG')
```

## Step 5: Assemble Video with FFmpeg NOT MoviePy

**DO NOT use MoviePy for text overlays**. MoviePy TextClip with color overlay creates dirty rendering: dark semi-transparent layers muddy the underlying image, text artifacts appear over existing text, readability suffers.

**Use FFmpeg drawtext** — clean, crisp, reliable:

### Single scene with text
```bash
ffmpeg -loop 1 -i image.png \
  -vf "drawtext=text='Your Text':fontfile=/usr/share/fonts/truetype/freefont/FreeSansBold.ttf:fontsize=38:fontcolor=white:box=1:boxcolor=black@0.3:boxborderw=6:x=(w-tw)/2:y=(h-th)/2" \
  -t 4 -c:v libx264 -pix_fmt yuv420p scene1.mp4
```

### Full reel assembly — all 5 scenes
```bash
# 1. One clip per scene
ffmpeg -loop 1 -i scene1.png -vf "drawtext=text=HOOK_TXT:fontfile=$FONT:fontsize=38:fontcolor=white:box=1:boxcolor=black@0.3:boxborderw=6:x=(w-tw)/2:y=(h-th)/2" -t 4 -c:v libx264 -pix_fmt yuv420p s1.mp4
ffmpeg -loop 1 -i scene2.png -vf "drawtext=text=PROB_TXT:fontfile=$FONT:fontsize=38:fontcolor=white:box=1:boxcolor=black@0.3:boxborderw=6:x=(w-tw)/2:y=(h-th)/2" -t 5 -c:v libx264 -pix_fmt yuv420p s2.mp4
# ... repeat for scenes 3-5

# 2. Concatenate
printf "file 's1.mp4'\nfile 's2.mp4'\nfile 's3.mp4'\nfile 's4.mp4'\nfile 's5.mp4'\n" > concat.txt
ffmpeg -f concat -safe 0 -i concat.txt -c copy reel_final.mp4
```

### FFmpeg drawtext formatting
- `box=1:boxcolor=black@0.3:boxborderw=6` creates a subtle semi-transparent background box for readability over any image
- `x=(w-tw)/2:y=(h-th)/2` centers the text
- For multi-line text: stack multiple drawtext filters with different `y` values or use `\n` in the text string
- Font paths on Linux: `/usr/share/fonts/truetype/freefont/FreeSansBold.ttf` or `/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf`

## Available Tools

| Tool | Purpose |
|------|---------|
| nanobana (nano-img) | AI image generation via Google Gemini (npm CLI) |
| FFmpeg | Clean video assembly with text overlays |
| replicate + minimax/video-01 | Alternate text-to-video generation |
| Wan 2.7 / Kling 3.0 | AI video generation via RunComfy (supports 9:16 directly) |
| PIL/Pillow | Image manipulation, CTA slide creation |

## Pitfalls

1. **NanoBanana ignores aspect ratio** — always outputs 1024x1024 squares. Width and height flags are local resize only.
2. **Blur-and-letterbox reframing looks awful** — dark blurred borders around clean center content. DO NOT USE.
3. **MoviePy text overlays create dirty rendering** — dark semi-transparent layer muddles the image, text artifacts, poor readability. Use FFmpeg drawtext instead.
4. **Apostrophes in Python strings** within heredocs cause syntax errors. Use double-quoted strings for copy with apostrophes.
5. **Dreamina CLI (ByteDance/Jimeng)** requires Douyin QR login — impractical outside China.
6. **Replicate MiniMax video-01** generates video from text only, 2-3 min per video.
7. **Always show images to user before assembly** — let them approve or replace any image before wasting time assembling.
8. **Wrong audience is fatal** — confirm target audience before writing any copy. Legal/accounting professionals are NOT the same as manufacturing or tech audiences.
9. **Anglicisms break trust** — words like "workflow", "automation", "time-to-value" sound out of place in Italian B2B copy for traditional professionals.

## Style Guidelines

- **Font**: FreeSansBold at 38px for readability on mobile screens
- **Text overlay**: White text with subtle semi-transparent black box behind (black@0.3)
- **Scene duration**: 4-5 seconds each
- **Total length**: about 22 seconds (ideal for Instagram Reels engagement)
- **No audio** (voiceover can be added later in Instagram or CapCut)
- **CTA slide**: Brand logo centered on dark navy brand background, gold accent text
