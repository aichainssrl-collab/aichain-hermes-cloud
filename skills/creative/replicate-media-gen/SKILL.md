---
name: replicate-media-gen
description: "Generate images and videos using Replicate API via the replicate Python package. Covers text-to-image, text-to-video, image-to-video, and model discovery. Use when users request AI media generation through Replicate, or when working with models hosted on replicate.com."
version: 1.0.0
---

# Replicate Media Generation

Python API wrapper for Replicate.com — unified access to dozens of AI models for image and video generation.

## Installation

```bash
pip install replicate
```

## Authentication

```bash
export REPLICATE_API_TOKEN="your-token-here"
# or add to ~/.hermes/.env:
# REPLICATE_API_TOKEN=r8_your-token-here
```

Get a token at https://replicate.com/account/api-tokens

## Basic Usage

```python
import replicate

client = replicate.Client()

# Predictions API (works for most models)
prediction = client.models.predictions.create(
    model="owner/model-name",
    input={"prompt": "your prompt"}
)

# Sync wait for result
prediction.reload()
print(prediction.output)

# Download result
import urllib.request
urllib.request.urlretrieve(prediction.output, "/tmp/output.mp4")
```

## Model Discovery

**Model IDs frequently change** — many popular video models from community authors (fofr, camenduru, lucataco, nateraw) return 404. Always verify before use:

```python
try:
    model = client.models.get("owner/model-name")
    print(f"✅ Available: {model.name}")
except Exception:
    print("❌ Not found")
```

## Known Available Models (as of May 2026)

| Model | Type | Speed | Quality |
|-------|------|-------|---------|
| `minimax/video-01` | text-to-video | ~2-3 min | High |
| `stability-ai/stable-video-diffusion` | image-to-video | Fast | Medium |
| `bytedance/sdxl-lightning-4step` | text-to-image | ~10s | High |
| `luma/photon` | text-to-image | Fast | High |

## Video Generation Pattern

```python
import replicate
import time
import urllib.request

prediction = replicate.models.predictions.create(
    model="minimax/video-01",
    input={"prompt": "cinematic drone shot over coastline at sunset"}
)

max_wait = 300
start = time.time()
while time.time() - start < max_wait:
    prediction.reload()
    if prediction.status in ("succeeded", "failed", "canceled"):
        break
    time.sleep(15)

if prediction.status == "succeeded":
    url = prediction.output if isinstance(prediction.output, str) else prediction.output[0]
    urllib.request.urlretrieve(url, "/tmp/video.mp4")
```

## Pitfalls

- **401 Unauthenticated Error**: If you encounter a `401 Unauthenticated` error, ensure your `REPLICATE_API_TOKEN` is correctly set in an environment variable (`~/.hermes/.env` is a good place). The script must explicitly load this variable (e.g., using `dotenv`) before initializing the Replicate client.
- **404 Not Found Error**: A `404 Not Found` error, even after verifying a model with `client.models.get()`, is common. Model IDs used for predictions can be different, version-specific, or change frequently.
  - **Troubleshooting Workflow**:
    1. Do not trust old model IDs.
    2. Use the `browser` tool to navigate to `https://replicate.com/explore`.
    3. Search for the model by name (e.g., "ltx-video").
## Pitfalls
## Strategy: The "Verify First" Workflow

To avoid 404 errors and wasted credits, ALWAYS verify the model ID before running a prediction.

1.  **Browser Verification**: Navigate to `https://replicate.com/explore` using the `browser_navigate` tool.
2.  **Search**: Use `browser_type` and `browser_press` to search for the desired model (e.g., "ltx-video", "stable video diffusion").
3.  **Identify Correct ID**: Analyze the snapshot of the search results page to find the most popular and recently updated version of the model. The ID will be in the format `owner/model-name:version-hash`. **This is the only reliable way to get a working model ID.**
4.  **Execute**: Use the verified ID in your `replicate.run` or `predictions.create` call.

## Pitfalls

- **Model ID Instability (CRITICAL)**: Model IDs, especially from community authors, are **not stable**. The `owner/model-name` string can become invalid overnight. **NEVER assume an ID from a previous session or this skill's documentation is still valid.** Always verify the exact model/version on the Replicate website first using the browser-based workflow described above.
- **Insufficient Credits**: A `402` error means the account has no funds. This is an administrative issue that must be resolved by the user. Inform them clearly and stop execution.
- **Model IDs are unstable**: Model names and versions on Replicate can change frequently, leading to `404 Not Found` errors even if the model name seems correct. Do not rely on memorized or hardcoded model IDs.
- **Verification Workflow**: The most reliable way to find a working model ID is to:
    1.  Navigate to `https://replicate.com/explore` using the browser.
    2.  Use the search bar to find the desired model (e.g., "stable video diffusion").
    3.  Identify the full model string (e.g., `stability-ai/stable-video-diffusion`) from a popular, recently updated model in the search results.
    4.  Use this exact string for your API call.
## Pitfalls
- **Model Not Found (404 Errors)**: Model IDs on Replicate change frequently and community models can be removed. An ID that worked yesterday may fail today. `replicate.models.get()` can succeed while `replicate.run()` fails with a 404 for the same ID.
- **Workflow for Finding a Stable Model**:
  1.  Try the desired model ID (e.g., `lightricks/ltx-video`).
  2.  If it fails with a 404, **do not try other variations via API**. The API has no search functionality.
  3.  Use the `browser` to navigate to `https://replicate.com/explore`.
  4.  Search for the model name (e.g., "ltx-video") or the desired functionality (e.g., "image-to-video").
  5.  Identify a popular, recently updated model from the search results and use its exact ID (e.g., `stability-ai/stable-video-diffusion`).
- **Insufficient Credit (402 Errors)**: Generation is not free. If you receive a 402 error, the account's credits must be refilled by the user. There is no technical workaround.
- **Model IDs are volatile**: The biggest pitfall is using an outdated model ID, which results in a `404 Not Found` error. Community-hosted models change names or are taken down frequently. **Protocol:** Before using a model ID in a script, **always verify it exists** by navigating to `https://replicate.com/explore` and searching for the model. Use the exact, full name (e.g., `author/model-name:version-hash`) shown on the website.
- **Credit is required**: Many high-quality models are not free. A `402 Insufficient Credit` error is a hard stop. The user must add credits to their account.
- `replicate.run()` does NOT work for many models — use `models.predictions.create()` instead
- Do NOT use `webhook_completed` parameter — many models reject it with 422
- The `prediction.output` can be a string OR a list — always check type
- Video generation is async — always poll with `.reload()`
