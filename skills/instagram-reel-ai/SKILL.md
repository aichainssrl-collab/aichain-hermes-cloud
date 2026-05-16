---
name: instagram-reel-ai
description: Create Instagram Reels (9:16, 1080x1920) from scratch using AI-generated images (nanoBanana/Gemini) and FFmpeg for assembly with Ken Burns zoom effects, crossfade transitions, and text overlay. Includes logo background removal with rembg. Use when the user wants to create a social media video reel from text, a website, or a marketing brief.
---

# Instagram Reel AI Creator

Create professional Instagram Reels (9:16, 1080x1920) using AI image generation and FFmpeg assembly.

## Workflow Overview

```
ANALYZE → WRITE COPY → GENERATE IMAGES → COMPOSE FRAMES → ANIMATE VIDEO
```

### Step 1: Analyze Source Content

If a URL is provided, scrape the page content. Identify:
- The product/service being promoted
- Target audience (be specific — don't assume one category)
- Pain points and solutions
- Real results/metrics if available
- Call to action (CTA)

### Step 2: Write Copy

Follow the **Corey Haines marketing principles**:
- **Hook** (0-3s): Provocative question or statement
- **Problem** (3-8s): 2-3 specific frustrations
- **Solution** (8-15s): Clear, simple explanation
- **Result** (15-20s): Specific number or real outcome
- **CTA** (20-22s): Direct action invitation

**Rules:**
- Match the target audience (legal, accounting, consulting, etc.)
- Use the correct terminology for each sector (e.g., "ufficio" not "studio")
- **ZERO inglesismi/anglicismi — assoluto.** Niente "AI", "Enterprise", "smart", "workflow", "cutting-edge" nel testo overlay. Mai.
  - ❌ "AI Enterprise per professionisti" → ✅ "Soluzioni intelligenti per il tuo ufficio"
  - ❌ "Automazione AI" → ✅ "Automazione su misura"
- Keep text short — 2 lines max per frame

### Step 3: Generate Images with Google Gemini (Python API)

**Note:** The `nanobana` CLI may not be available. Use Python `google.generativeai` directly instead.

```python
import google.generativeai as genai
import os

genai.configure(api_key=os.getenv("GENAI_API_KEY"))
model = genai.GenerativeModel("gemini-2.0-flash-exp")

response = model.generate_images(
    prompt="Bright modern office, photography style, vertical 9:16, NO TEXT, no letters, no graphics overlays",
    number_of_images=1,
    aspect_ratio="9:16"
)
img_bytes = response.images[0].image
with open("/tmp/reel/scene.png", "wb") as f:
    f.write(img_bytes)
```

**Prompt writing rules:**
- Be specific about the scene and mood
- Include "photorealistic" and professional keywords
- **CRITICAL: Add "no text, no letters, no graphics overlays" to prompt**
- Images must be CLEAN — text is added later as overlay, NEVER baked in
- Generate one image per scene
- If nanobana CLI IS available: `nanobana generate --prompt "..." --model gemini-2.0-flash-exp`

### Step 4: Create Frames with Text Overlay

Use Pillow (Python PIL) to compose final 1080x1920 frames:

```python
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1080, 1920  # Instagram Reels 9:16

def scale_to_fill(img, target_w, target_h):
    """Resize image to cover at least the target dimensions"""
    iw, ih = img.size
    scale = max(target_w / iw, target_h / ih)
    return img.resize((int(iw * scale), int(ih * scale)), Image.LANCZOS)

def make_frame(img_path, lines, font_sizes=None, is_cta=False, logo_path=None):
    img = Image.open(img_path).convert('RGB')
    resized = scale_to_fill(img, W, H)
    rw, rh = resized.size
    
    # Create natural background from blurred version of the image
    bg = resized.filter(ImageFilter.GaussianBlur(radius=40))
    
    # Center and crop
    paste_x = (rw - W) // 2
    paste_y = (rh - H) // 2
    bg = bg.crop((paste_x, paste_y, paste_x + W, paste_y + H))
    
    # Subtle dark overlay for text readability
    overlay = Image.new('RGBA', (W, H), (0, 0, 0, 70))
    bg_rgba = bg.convert('RGBA')
    bg = Image.alpha_composite(bg_rgba, overlay).convert('RGB')
    draw = ImageDraw.Draw(bg)
    
    if is_cta:
        # Darker overlay for CTA
        overlay_cta = Image.new('RGBA', (W, H), (0, 0, 0, 140))
        bg = Image.alpha_composite(bg.convert('RGBA'), overlay_cta).convert('RGB')
        draw = ImageDraw.Draw(bg)
        
        # Add transparent logo at top
        if logo_path:
            logo = Image.open(logo_path).convert('RGBA')
            logo_w = 400
            logo = logo.resize((logo_w, int(logo_w * logo.height/logo.width)), Image.LANCZOS)
            bg_rgba = bg.convert('RGBA')
            bg_rgba.paste(logo, ((W - logo_w) // 2, 180), logo)
            bg = bg_rgba.convert('RGB')
            draw = ImageDraw.Draw(bg)
        
        # CTA text
        # ... add text lines with shadow for readability
    else:
        # Center white text with black shadow
        line_h = 58
        total_h = len(lines) * line_h + 10
        y_start = (H - total_h) // 2
        for i, line in enumerate(lines):
            font = ImageFont.truetype(font_bold, font_sizes[i])
            # Shadow first
            draw.text((x+3, y+3), line, fill=(0,0,0,200), font=font)
            # White text
            draw.text((x, y), line, fill='white', font=font)
    
    return bg
```

**Key rule:** DO NOT stretch square images vertically. Always:
1. Scale to cover the target (scale_to_fill)
2. Create a blurred background from the scaled image (natural colors)
3. Crop and center the sharp image on top
4. This avoids ugly dark bars!

### Step 5: Remove Logo Background (Optional)

Use `rembg` for AI background removal:

```bash
pip install rembg
rembg p /path/to/logo.jpg /path/to/logo_no_bg.png
```

Fallback with Pillow for simple white backgrounds:
```python
from PIL import Image
import numpy as np

img = Image.open('logo.jpg').convert('RGBA')
data = np.array(img)
white_mask = (data[:,:,0] > 220) & (data[:,:,1] > 220) & (data[:,:,2] > 220)
data[white_mask, 3] = 0
Image.fromarray(data, 'RGBA').save('logo_no_bg.png')
```

### Step 6: Animate with FFmpeg (Ken Burns + Crossfade)

```bash
# Scene with slow zoom (Ken Burns effect)
ffmpeg -y -loop 1 -i frame.png \
  -filter_complex "zoompan=z='min(zoom+0.002,1.15)':d=120:x='iw/2-(iw/zoom/2)':y='0':s=1080x1920:fps=30" \
  -c:v libx264 -pix_fmt yuv420p -crf 18 -t 4 scene1.mp4

# Assemble with crossfade transitions (0.5s between scenes)
ffmpeg -y -i scene1.mp4 -i scene2.mp4 -i scene3.mp4 -i scene4.mp4 -i scene5.mp4 \
  -filter_complex \
    "[0:v][1:v]xfade=transition=fade:duration=0.5:offset=3.5[v01]; \
     [v01][2:v]xfade=transition=fade:duration=0.5:offset=8.0[v02]; \
     [v02][3:v]xfade=transition=fade:duration=0.5:offset=12.5[v03]; \
     [v03][4:v]xfade=transition=fade:duration=0.5:offset=16.0[v]" \
  -map "[v]" -c:v libx264 -crf 18 -pix_fmt yuv420p output.mp4
```

**Ken Burns effect variations:**
- Zoom in from top: `y='0'`
- Zoom in from center: `y='ih/2-ih/zoom/2'`
- Slow zoom out: `z='if(lte(zoom,1.0),1.03,zoom+0.0008)'`

### Step 7: Verify Final Output

- Check dimensions: 1080x1920 (9:16)
- Check duration: typically 15-30s for Reels
- Verify text is readable on all frames
- Verify transitions are smooth
- Send to user for review

## Common Pitfalls

1. **Images come square (1024x1024)** — never stretch vertically. Use blur-fill method.
2. **Wrong API key** — nanobana needs `NANO_IMAGE_API_KEY`, not `GOOGLE_API_KEY`
3. **Text unreadable** — always add dark overlay (70-100 alpha) and text shadow
4. **Too much text** — 2 lines max per frame, 40-54px font size
5. **Wrong audience language** — verify terminology matches the target sector
6. **Logo with white background** — remove it with rembg before compositing
7. **CRITICAL: Never bake text into source images** — source images must be CLEAN backgrounds only. Text is ALWAYS added as separate FFmpeg/Python overlay. The user may want to review/edit images independently before assembly.
8. **CRITICAL: ZERO English words** — especially "AI", "Enterprise", "smart" in any copy. Use pure Italian alternatives: "Intelligenza artificiale" → "soluzioni intelligenti", "Enterprise" → "per professionisti/uffici"
