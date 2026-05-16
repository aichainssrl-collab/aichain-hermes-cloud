# Reliability-First Image Generation Workflow

When a user requests an image, follow this priority order to maximize reliability and speed and avoid frustrating the user with technical delays.

1.  **Gemini Native (via `nanobana-image-gen` skill)**: This is the **default and preferred** method. It's the most stable and directly integrated tool. Use it unless the user's request is impossible to fulfill with it.

2.  **Replicate API (via `replicate-media-gen` skill)**: Use as a fallback if Gemini fails or if a specific model only available on Replicate is needed. **Crucially, you must verify dependencies (`pip install replicate`) and model availability *before* attempting generation.**

3.  **ComfyUI (via `comfyui` skill)**: Use **only** when the user explicitly requests advanced local features like ControlNet, specific LoRAs, or complex multi-step workflows. Before using, always run a health check (`python3 scripts/health_check.py`) to ensure the server is running and configured. **If the health check fails, inform the user about the technical issue and immediately switch to Gemini or Replicate instead of attempting to debug the local server.**

This hierarchy prioritizes delivering a result to the user quickly over attempting to use the most powerful but potentially unavailable tool.