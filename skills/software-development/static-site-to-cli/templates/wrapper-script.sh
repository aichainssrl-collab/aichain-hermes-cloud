#!/bin/bash
#
# This is a template for a static-site-to-cli wrapper script.
#
# To use:
# 1. Replace "my-tool" with the name of your command.
# 2. Update a-zA-Z_CACHE_FILE with the path to your local cache.
# 3. Update a-zA-Z_SITE_URL with the URL to download.
# 4. Customize the awk script to match the structure of your target site.

set -euo pipefail

# --- Configuration ---
TOOL_NAME="my-tool"
CACHE_FILE="$HOME/.cache/my-tool-cache.txt"
SITE_URL="https://example.com/data.txt"

# --- Main Logic ---
SEARCH_TERM="${1:-}"

if [[ -z "$SEARCH_TERM" ]]; then
    echo "Usage: $TOOL_NAME <search_term>"
    echo "Example: $TOOL_NAME topic"
    echo ""
    echo "Update with: $TOOL_NAME update"
    exit 1
fi

if [[ "$SEARCH_TERM" == "update" ]]; then
    echo "Updating local cache from $SITE_URL..."
    curl -s "$SITE_URL" > "$CACHE_FILE"
    if [[ $? -eq 0 ]]; then
        echo "Update complete."
    else
        echo "Update failed."
        exit 1
    fi
    exit 0
fi

# This awk script is an example. It assumes sections start with "# <term>"
# and end with the next "##". You will need to customize this.
awk -v term="$SEARCH_TERM" '
    $0 == "# " term { in_section=1; next }
    in_section && /^## / { exit }
    in_section { print }
' "$CACHE_FILE"

# Check if awk produced any output.
if ! awk -v term="$SEARCH_TERM" '$0 == "# " term { found=1; exit } END { exit !found }' "$CACHE_FILE"; then
    echo "Term '$SEARCH_TERM' not found in cache."
fi
