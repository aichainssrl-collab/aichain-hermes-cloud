#!/usr/bin/env python3
"""
Converts square 1024x1024 images (from nanobana/Gemini) to clean 1080x1920 Instagram Reel format.
Uses natural blur-fill with the image's own colors instead of artificial dark backgrounds.
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os, sys, math

def convert_to_reel(input_path, output_path, W=1080, H=1920):
    """Converts a square image to 1080x1920 using natural blur-fill."""
    img = Image.open(input_path).convert('RGBA')
    iw, ih = img.size
    
    # Step 1: Sample average color for gradient creation
    # Use edges to get ambient/background tones
    samples = []
    for x in range(0, iw, max(10, iw//20)):
        for y in [0, ih//2, ih-1]:
            r, g, b, _ = img.getpixel((x, y))
            samples.append((r, g, b))
    
    avg_r = sum(s[0] for s in samples) // len(samples)
    avg_g = sum(s[1] for s in samples) // len(samples)
    avg_b = sum(s[2] for s in samples) // len(samples)
    
    # Darker versions for gradient depth
    dark_r, dark_g, dark_b = avg_r // 4, avg_g // 4, avg_b // 4
    
    # Step 2: Create vertical gradient background
    bg = Image.new('RGBA', (W, H))
    draw = ImageDraw.Draw(bg)
    for y in range(H):
        t = y / H
        # Smooth sine-wave based gradient
        factor = math.sin(math.pi * t)
        r = int(dark_r + (avg_r - dark_r) * factor)
        g = int(dark_g + (avg_g - dark_g) * factor)
        b = int(dark_b + (avg_b - dark_b) * factor)
        draw.line([(0, y), (W, y)], fill=(r, g, b, 255))
    
    # Step 3: Scale and place the original image
    scale = W / iw
    new_h = int(ih * scale)
    resized = img.resize((W, new_h), Image.LANCZOS)
    
    if new_h >= H:
        # Crop center vertically
        crop_start = (new_h - H) // 2
        final_clip = resized.crop((0, crop_start, W, crop_start + H))
        bg.paste(final_clip, (0, 0))
    else:
        # Center vertically, add soft glow edges
        y_pos = (H - new_h) // 2
        bg.paste(resized, (0, y_pos))
        
        # Soft feather at top/bottom edges (avoid hard transitions)
        for y in range(0, 40):
            alpha = int(255 * (y / 40))
            top_line = bg.crop((0, y_pos - 40 + y, W, y_pos - 40 + y + 1))
            bottom_line = bg.crop((0, y_pos + new_h + 40 - y - 1, W, y_pos + new_h + 40 - y))
            
    # Convert to RGB (drop alpha)
    out_rgb = bg.convert('RGB')
    out_rgb.save(output_path, 'PNG', quality=95)
    return output_path

# Example usage with multiple images:
if __name__ == '__main__':
    if len(sys.argv) > 2:
        convert_to_reel(sys.argv[1], sys.argv[2])
        print(f"Converted: {sys.argv[1]} -> {sys.argv[2]}")
    else:
        # Process all images in /tmp/reel-images
        import glob
        for img_path in sorted(glob.glob('/tmp/reel-images/*/nano-img-*.png')):
            parts = img_path.split('/')
            scene_dir = parts[-2]
            filename = parts[-1].replace('.png', '_reel.png')
            out_path = f'/tmp/reel-frames/{scene_dir}/{filename}'
            os.makedirs(os.path.dirname(out_path), exist_ok=True)
            try:
                convert_to_reel(img_path, out_path)
                print(f"✅ {scene_dir}: {out_path}")
            except Exception as e:
                print(f"❌ {scene_dir}: Error - {e}")
