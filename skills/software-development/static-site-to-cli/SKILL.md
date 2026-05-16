---
name: static-site-to-cli
description: "Turn any static, text-based website into a fast, offline CLI tool using a `curl | awk` pattern. Ideal for cheat sheets and reference sites."
version: 1.0.0
---

# Static Site to CLI

This skill documents the pattern for turning a static, single-page, text-based website (like a cheat sheet or reference guide) into a fast, offline command-line tool.

This approach is vastly more efficient than using browser tools for every query and works offline.

## When to Use

When the user points to a reference website that is primarily text and asks to create a tool to "query", "search", or "look up" information on it. A prime example is turning a command-line cheat sheet website into a terminal command.

## Core Pattern: `curl | awk`

The process involves two main phases: creating a local cache of the content, and then creating a script to query that cache.

### Phase 1: Create the Local Cache

Use `curl` to download the entire content of the site into a single, hidden text file in the user's home directory.

```bash
# Example: Downloading the content of skills.sh
curl -s https://www.skills.sh > ~/.skills_sh_cache.txt
```

This file is the local, offline knowledge base.

### Phase 2: Create the Query Script

Create a `bash` script that uses a text-processing utility like `awk` or `grep` to parse the cache file. `awk` is particularly powerful for this, as it can extract sections of text based on start and end patterns.

**Key features of a good query script:**
- Accepts a search term as its first argument.
- Handles the case where no argument is given (shows usage instructions).
- Includes a special command (e.g., `update`) to re-download the cache file.
- Uses `awk` to find a start pattern (e.g., a line matching the search term) and print lines until an end pattern is found.
- Provides a helpful "not found" message if the search term yields no results.

See `references/skill-script-example.sh` for a complete, annotated example of the script created to query `skills.sh`.

### Phase 3: Install the Script

To make the script a globally available command:
1.  Ensure `~/.local/bin` exists (`mkdir -p ~/.local/bin`).
2.  Make the script executable (`chmod +x /path/to/script`).
3.  Move the script into the bin directory (`mv /path/to/script ~/.local/bin/<command_name>`).

## Pitfalls
- **Not for Dynamic Sites**: This pattern only works for single-page or very simple static sites. It will not work for complex, JavaScript-heavy web applications.
- **Parser Fragility**: The `awk` script is tailored to the HTML/text structure of the target site. If the site's structure changes, the parser will break. The `update` command might fetch a new site version that is incompatible with the script.
- **Not a Replacement for APIs**: If a service provides an API, it's always better to build a CLI around that. For OpenAPI specs, use [[concepts/printing-press.md|Printing Press]]. Use this `curl | awk` pattern for content-only sites that lack an API.
