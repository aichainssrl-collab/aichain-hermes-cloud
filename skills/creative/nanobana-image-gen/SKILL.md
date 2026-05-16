---
name: nanobana-image-gen
description: "Generate images using nanobana CLI — a wrapper around Google Gemini's native image generation (gemini-2.5-flash-image). Installable globally via npm."
version: 1.0.0
---

# nanobana Image Generation

CLI wrapper for Google Gemini native image generation.

## Installation

```bash
npm install -g nanobana
```

## API Key

Requires a Google AI Studio API key (get at https://aistudio.google.com/apikey).

**IMPORTANT:** The environment variable is `NANO_IMAGE_API_KEY`, NOT `GOOGLE_API_KEY`. This is a common mistake.

```bash
export NANO_IMAGE_API_KEY="your-api-key-here"
# or add to ~/.hermes/.env:
# NANO_IMAGE_API_KEY=your-api-key-here
```

## Usage

```bash
nano-img "prompt here" [options]
# or
nano-image "prompt here" [options]
```

## Options

| Flag | Description |
|------|-------------|
| `-m, --model <name>` | Override the Gemini image model |
| `-o, --output <dir>` | Output directory for generated files |
| `-w, --width <px>` | Resize output width (aspect preserved) |
| `-h, --height <px>` | Resize output height (aspect preserved) |
| `-f, --format <type>` | Output format: png, jpg, jpeg, webp |
| `--ref <path>` | Add a reference image (repeatable) |
| `--prefix <name>` | Output filename prefix |
| `--no-default-refs` | Ignore ~/.nano-img/assets |
| `-j, --json` | Print machine-readable JSON |

## Examples

```bash
# Basic generation
nano-img "a cute robot holding a banana, dark background"

# With specific output and format
nano-img "cyberpunk cityscape at night" --output /tmp/images --format png -w 1024 -h 1024

With reference image
nano-img "same style but during daytime" --ref /path/to/reference.png
```

## Pitfalls

- **Silent Failures with Complex Prompts**: The tool may fail silently (creating a `.txt` file but no `.png`) if the prompt is too long, complex, or contains words that trigger Google's safety filters (e.g., words implying stress or negativity). If generation fails, simplify the prompt to its core visual elements and try again.
- **API Key Naming**: The environment variable must be `NANO_IMAGE_API_KEY`, not `GOOGLE_API_KEY`.
- **Dimension Resizing**: Width and height flags (`-w`, `-h`) are applied locally *after* generation. The initial image from Gemini does not have a guaranteed size.

## Notes

- Gemini native image generation does NOT accept exact width/height. The `--width`/`--height` values are applied locally AFTER generation via sharp resize.
- Uses model `gemini-2.5-flash-image` by default.
- Supports image-to-image via `--ref` flag.
- If you get "Set NANO_IMAGE_API_KEY before generating images", the env var is not exported or named incorrectly.