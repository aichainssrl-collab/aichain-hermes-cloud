#!/bin/bash
#
# This is an example script demonstrating the pattern for turning a static site
# into a command-line tool. This specific script works for skills.sh.
#
# It can be adapted for other sites by changing the CACHE_FILE and the awk logic.

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
    # Ensure curl is available
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is not installed. Please install it to use the update feature."
        exit 1
    fi
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
# This pattern is specific to how skills.sh is formatted.
awk -v cmd="$SEARCH_TERM" '
    # Match the main header for a command, e.g., "# grep"
    $0 == "# " cmd {
        in_section=1
        # Print the matched header itself
        print $0
        next
    }
    # Stop when the next main command header is found
    in_section && /^# / {
        exit
    }
    # If we are in the correct section, print the line
    in_section {
        print
    }
' "$CACHE_FILE"

# A separate check to see if awk produced any output.
# This is more robust than checking the status of the previous awk command.
if ! awk -v cmd="$SEARCH_TERM" '$0 == "# " cmd { found=1; exit } END { exit !found }' "$CACHE_FILE"; then
    echo "Skill '$SEARCH_TERM' not found."
    echo "Try a different command or update the cache with 'skill update'."
fi
