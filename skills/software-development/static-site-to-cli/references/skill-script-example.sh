#!/bin/bash
#
# Script 'skill': A command-line tool to query a local cache of skills.sh
#
# This is an example of the query script described in the static-site-to-cli skill.

set -euo pipefail

# The command we are looking for
SEARCH_TERM="${1:-}"
CACHE_FILE="$HOME/.skills_sh_cache.txt"

if [[ -z "$SEARCH_TERM" ]]; then
    echo "Usage: skill <command_name>"
    echo "Example: skill grep"
    echo ""
    echo "Tip: Use 'skill update' to refresh the local knowledge base."
    exit 1
fi

# Special command to update the cache
if [[ "$SEARCH_TERM" == "update" ]]; then
    echo "Updating local knowledge base from skills.sh..."
    curl -s https://www.skills.sh > "$CACHE_FILE"
    if [[ $? -eq 0 ]]; then
        echo "Update complete."
    else
        echo "Update failed. Please check your internet connection."
        exit 1
    fi
    exit 0
fi

# The core logic: use awk to find the section for the command.
# It starts searching from a line that exactly matches "# <command>"
# and stops printing when it sees the next section "##".
awk -v cmd="$SEARCH_TERM" '
    $0 == "# " cmd { in_section=1; next }
    in_section && /^## / { exit }
    in_section { print }
' "$CACHE_FILE"

# Check if awk produced any output
if ! awk -v cmd="$SEARCH_TERM" '$0 == "# " cmd { found=1; exit } END { exit !found }' "$CACHE_FILE"; then
    echo "Skill '$SEARCH_TERM' not found."
    echo "Try a different command or update the cache with 'skill update'."
fi
