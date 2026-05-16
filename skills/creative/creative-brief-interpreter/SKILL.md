---
name: creative-brief-interpreter
description: "A skill that codifies the key lessons learned about interpreting creative briefs from the Boss. Its purpose is to prevent misunderstandings and hallucinations by enforcing a strict process."
version: 1.0.0
---

# Creative Brief Interpreter

This skill contains the guiding principles for interpreting and executing creative briefs from the Boss. It must be loaded before any creative generation task.

## Core Principles

1.  **The Brief is the Single Source of Truth:** Never rely on short-term memory or previous conversations. Always refer back to the written brief saved in `.hermes/creative_brief_aichain.md`.
2.  **'Simplify' Means 'Translate Faithfully':** When adapting a prompt for an AI tool, the goal is to translate the user's creative vision without losing the core concept, mood, or key details. It does **not** mean ignoring or replacing the user's ideas with generic ones.
3.  **Verify, Then Trust:** After generating a piece of media, verify that it meets all the key requirements of the brief *before* showing it to the Boss. Check for missing elements, incorrect mood, or other deviations.

## Workflow

1.  **Load the Brief:** Before starting, read the content of `.hermes/creative_brief_aichain.md`.
2.  **Deconstruct the Scene:** For each scene, identify the non-negotiable core elements (e.g., "silenzio imbarazzante", "meeting fallito").
3.  **Translate to a "Smart" Prompt:** Create a prompt that is simple enough for the AI to understand but detailed enough to capture the core elements.
4.  **Generate and Verify:** Generate the image and compare it against the core elements identified in step 2. If it fails, iterate on the prompt, don't just show the failure.
