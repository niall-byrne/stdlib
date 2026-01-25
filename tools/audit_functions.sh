#!/bin/bash

# This script audits the function order in all production code files within src/.
# It checks for alphabetical order using LC_ALL=C.

export LC_ALL=C

echo "# Function Order Audit Report"
echo ""
echo "This report details files in \`src/\` where functions are not in alphabetical order."
echo ""

# Find .sh and .snippet files in src/ excluding tests directories
find src \( -name "*.sh" -o -name "*.snippet" \) -not -path "*/tests/*" | sort | while read -r file; do
    # Extract function names: lines starting with name followed by () {
    # We use a regex that matches the standard function definition in this repo.
    funcs=$(grep -E '^[a-zA-Z0-9._-]+ *\(\) *\{' "$file" | sed -E 's/([a-zA-Z0-9._-]+).*/\1/')

    if [[ -z "$funcs" ]]; then
        continue
    fi

    sorted_funcs=$(echo "$funcs" | sort)

    if [[ "$funcs" != "$sorted_funcs" ]]; then
        echo "### File: \`$file\`"
        echo ""
        echo "| Current Order | Expected Order |"
        echo "|---|---|"
        # Use paste to create a side-by-side comparison
        paste <(echo "$funcs") <(echo "$sorted_funcs") | while IFS=$'\t' read -r curr exp; do
            if [[ "$curr" == "$exp" ]]; then
                echo "| $curr | $exp |"
            else
                echo "| **$curr** | **$exp** |"
            fi
        done
        echo ""
    fi
done
