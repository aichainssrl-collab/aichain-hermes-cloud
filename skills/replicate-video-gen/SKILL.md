---
name: replicate-video-gen
description: Generate videos and images using Replicate API. Supports MiniMax video-01 (text-to-video), Stable Video Diffusion (image-to-video), Luma Photon (text-to-image), SDXL Lightning (fast text-to-image). Requires REPLICATE_API_TOKEN in environment or .env. Python-based workflow using the replicate Python library.
version: 1.0.0
---

# Replicate Video & Image Generation

Use Replicate for AI video/image generation. Single API key, multiple models. Works from anywhere (no China login required).

## Setup

### 1. Install
```bash
pip install replicate
```

### 2. Auth
```bash
export REPLICATE_API_TOKEN="r8_..."
# Or add to ~/.hermes/.env:
echo 'REPLICATE_API_TOKEN=r8_...' >> ~/.hermes/.env
```

### 3. Test connection
```python
import replicate
client = replicate.Client()
model = client.models.get('stability-ai/stable-video-diffusion')
print('Auth OK:', model.name)
```

## Available Models (tested May 2026)

| Model | Command ID | Input | Output | Cost |
|-------|-----------|-------|--------|------|
| **MiniMax video-01** | `minimax/video-01` | prompt (text) | 5-10s video MP4 | ~$0.02-0.05 |
| **Stable Video Diffusion** | `stability-ai/stable-video-diffusion` | image + params | 2-4s video | ~$0.01-0.03 |
| **Luma Photon** | `luma/photon` | prompt (text) | image PNG | ~$0.005 |
| **SDXL Lightning** | `bytedance/sdxl-lightning-4step` | prompt + ratio | image | cheap/fast |

## Video Generation (MiniMax video-01)

### Parameters
- `prompt` (required, string) — Text description
- `prompt_optimizer` (optional, bool, default: True) — Auto-optimize prompt
- `first_frame_image` (optional, string) — URL to use as first frame
- `subject_reference` (optional, string) — Character reference image

### Python Workflow
```python
import replicate
import time

# Submit
prediction = replicate.models.predictions.create(
    model="minimax/video-01",
    input={"prompt": "Your video description here"}
)

# Poll
prediction.reload()
while prediction.status in ("starting", "processing"):
    time.sleep(15)
    prediction.reload()

# Download
if prediction.status == "succeeded":
    import urllib.request
    url = prediction.output if isinstance(prediction.output, str) else prediction.output[0]
    urllib.request.urlretrieve(url, "/tmp/output.mp4")
```

### Prompting Guidelines for MiniMax
- Describe camera movement: "slow cinematic pan", "static shot", "aerial view"
- Specify lighting: "warm natural lighting", "golden hour", "soft studio light"
- Specify aspect ratio: "16:9 aspect ratio", "9:16 vertical" (though MiniMax may ignore)
- Use "photorealistic, documentary style" for professional looks
- Avoid: text, logos, complex multi-scene descriptions

### Cost Awareness
- Each generation = ~$0.02-0.05
- Failed attempts may still charge
- Always check `user_credit` before bulk generation
- Model availability can change — verify with `client.models.get()` before running

## Image Generation (Luma Photon / SDXL)

### Luma Photon
```python
prediction = replicate.models.predictions.create(
    model="luma/photon",
    input={"prompt": "A professional office desk, warm lighting"}
)
prediction.reload()
while prediction.status in ("starting", "processing"):
    time.sleep(5)
    prediction.reload()
```

## Adding Text Overlays (Post-Processing)

Replicate/MiniMax does NOT support adding text. For text overlays:

### Option 1: FFmpeg (simple)
```bash
ffmpeg -i input.mp4 -vf "drawtext=text='Hello':fontsize=24:fontcolor=white:x=(w-tw)/2:y=h-th-20" output.mp4
```

### Option 2: Python + MoviePy
```python
from moviepy.editor import VideoFileClip, TextClip, CompositeVideoClip
clip = VideoFileClip("input.mp4")
txt = TextClip("Hello", fontsize=24, color='white')
# Composite and export
```

### Option 3: Send to user
The raw video is fine — user adds text with CapCut, InShot, etc.

## Troubleshooting

### 404 Model Not Found
Model was removed or renamed. Search for alternatives:
```python
client.models.list(search="video")
```

### 422 Input Validation Failed
Check parameters with model help:
```bash
curl -s https://api.replicate.com/v1/models/{owner}/{model}/versions/latest \
  -H "Authorization: Token $REPLICATE_API_TOKEN" | python3 -c "..."
```

### Slow Generation
MiniMax video-01 takes 2-5 minutes. This is normal. Don't timeout too aggressively (use 300s+).

### Video Aspect Ratio
MiniMax ignores aspect ratio hints. You get ~16:9 by default. Crop with ffmpeg if needed:
```bash
ffmpeg -i input.mp4 -vf "crop=in_h*9/16:in_h" output_9_16.mp4
```

## Related Skills
- `nanobana-image-gen` — Gemini image generation via CLI (simpler for basic images)
- `copywriting` — Marketing copy for video overlays/captions
- `product-marketing-context` — Product context before generating marketing assets
