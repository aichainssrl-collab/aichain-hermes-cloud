---
name: browser-setup-arm64
description: Install and configure a working browser for browser_navigate on Ubuntu arm64 (OrbStack) where Puppeteer's bundled Chrome is wrong architecture (x86). Uses Playwright's arm64 Chromium instead.
version: 1.0.0
metadata:
  hermes:
    tags: [browser, arm64, chromium, puppeteer, playwright, orbstack]
---

# Browser Setup on Ubuntu arm64 (OrbStack)

## Problem
On Ubuntu arm64 machines (like OrbStack containers), `browser_navigate` fails because Puppeteer's cached Chrome binary is x86:
```
OrbStack ERROR: Dynamic loader not found: /lib64/ld-linux-x86-64.so.2
```

Puppeteer's cache at `~/.cache/puppeteer/chrome/linux_arm-*` actually contains an x86 binary despite the directory name suggesting arm64.

## Solution: Use Playwright's arm64 Chromium

Playwright already downloads the correct arm64 chromium binary at:
```
~/.cache/ms-playwright/chromium-*/chrome-linux/chrome
```

### Step 1: Verify Playwright chromium exists and works
```bash
# Find the correct chromium
find ~/.cache/ms-playwright -name "chrome" -type f 2>/dev/null

# Verify it runs (should print version like "Chromium 147.0.7727.0")
<path-to-playwright-chrome> --version
```

If Playwright chromium doesn't exist, install it:
```bash
cd /tmp && npm install playwright
npx playwright install chromium
```

### Step 2: Patch Puppeteer's cache with a symlink
Rename the broken Puppeteer chrome binary and symlink to Playwright's:
```bash
# Find the puppeteer chrome binary path
PUPPETEER_CHROME=$(find ~/.cache/puppeteer/chrome -name "chrome" -type f 2>/dev/null | head -1)

# Rename the broken one
mv "$PUPPETEER_CHROME" "${PUPPETEER_CHROME}.bak"

# Symlink to Playwright's working arm64 binary
PLAYWRIGHT_CHROME=$(find ~/.cache/ms-playwright -name "chrome" -type f 2>/dev/null | head -1)
ln -s "$PLAYWRIGHT_CHROME" "$PUPPETEER_CHROME"

# Verify
ls -la "$PUPPETEER_CHROME"
```

### Step 3: Also configure agent-browser cache
`browser_navigate` checks `~/.agent-browser/browsers/` as a fallback:
```bash
mkdir -p ~/.agent-browser/browsers
ln -sf "$(find ~/.cache/ms-playwright -name "chrome" -type f 2>/dev/null | head -1)" ~/.agent-browser/browsers/chrome
```

### Step 4: Verify browser_navigate works
```
browser_navigate(url="https://example.com")
```

## Common pitfalls
- The directory `linux_arm` in puppeteer's cache name is misleading — it contains x86_64 linux binaries
- Snap packages for chromium won't work in containers (snap not available)
- `apt install chromium-browser` on Ubuntu 25.10 only gives a transitional package pointing to snap
- Always verify with `--version` before using

## Environment specifics
- OS: Ubuntu 25.10 (Questing Quokka) arm64
- Runtime: OrbStack (arm64 emulation)
- Playwright chromium: chromium-1217 (v147)
- Puppeteer chrome: downloaded as x86 binary (wrong arch)