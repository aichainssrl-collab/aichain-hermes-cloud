---
name: social-media-analysis
description: Analyze Instagram and other social media posts/reels for content and marketing insights using browser tools and vision analysis.
version: 1.0.0
metadata:
  hermes:
    tags: [social-media, instagram, content-analysis, marketing, vision]
---

# Social Media Reel Analysis

Use when analyzing Instagram posts, reels, or other social media content that requires visual analysis.

## Browser Prerequisites

On arm64 systems, browser may not be configured. Check `browser-setup-arm64` skill first if browser_navigate fails.

## Analysis Workflow

### Step 1: Navigate to the URL
browser_navigate(url=POST_URL)

### Step 2: Handle Cookie/Consent Modals
Instagram often shows cookie consent dialogs. Accept them:
browser_snapshot(full=true)
Find and click the accept/allow button: browser_click(ref=ACCEPT_BUTTON_REF)

### Step 3: Navigate Again (if redirect)
After accepting cookies, re-navigate: browser_navigate(url=POST_URL)
browser_snapshot(full=true)

### Step 4: Extract Text Content from Snapshot
The snapshot provides:
- Post author/handle
- Timestamp
- Caption text
- Comments and engagement stats
- Related posts content (often with full text visible)

### Step 5: Vision Analysis for Visual Content
browser_vision(question="Describe the reel content in detail: what does the video show, who appears, what text is on screen, what is the main message")

### Step 6: Handle Login Walls
Instagram frequently blocks content behind "Log In" modals. Workarounds:
- Caption and comments are often still visible in the page source
- The "More posts from [user]" section reveals content strategy
- Use snapshot to extract all available text content

## What to Extract

### Content Analysis
- Post type (reel, carousel, image, video)
- Caption text and hashtags
- Visible on-screen text
- Visual elements and people
- Call-to-action (CTA)

### Engagement Metrics
- Likes count
- Comments count
- Comment sentiment

### Strategic Analysis
- Brand positioning and identity
- Content themes and pillars
- Tone of voice
- Target audience signals
- Conversion funnel (CTA to landing page)

## Pitfalls
- Instagram cookie modals must be accepted before content loads
- Login walls may block the main video - use snapshot + related posts as fallback
- Some content is behind JavaScript rendering (use browser, not curl)
- Engagement metrics may be hidden behind login
