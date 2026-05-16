---
name: generative-media
description: Best practices and workflows for creating video, images, and audio using generative AI models and platforms.
version: 1.0.0
---

# Generative Media Workflows

This skill contains knowledge and best practices for using various AI-powered generative media tools.

## General Principles

1.  **API First, Local Second**: Before attempting a complex local installation of a new model, always check for available online APIs (e.g., on Replicate, Fal.ai, Hugging Face Spaces). Local setups often have prohibitive hardware requirements (especially high-end GPUs).
2.  **Check the Recommended Workflow**: Always read the `README.md` to find the developer-recommended method. For example, a project might have a basic inference script but recommend using a UI like ComfyUI for superior results.
3.  **Use Specialized APIs**: When available, prefer direct tool APIs (like Brave Search API) over general-purpose browser automation, which can be brittle and prone to being blocked.

## Tools and Platforms

### LTX Studio (by Lightricks)

-   **Type**: Professional AI Video Production Suite.
-   **Core Model**: LTX-2 (open-source on GitHub).
-   **Key Feature**: All-in-one platform from ideation to production, with fine-grained control (text, images, audio, video as input).
-   **Recommended Workflow**: The official documentation strongly recommends using the **ComfyUI integration** for best results.
-   **Pitfall - Local Installation**: The open-source model has significant hardware requirements (e.g., high-end NVIDIA GPUs like H100/RTX 4060 with >8GB VRAM). Attempting a local installation without appropriate hardware is not feasible.
-   **Winning Strategy - API Usage**: The most effective way to use LTX Studio is via its hosted API on platforms like **Replicate** or **Fal.ai**. This bypasses hardware limitations and provides immediate access to the model's full capabilities.
