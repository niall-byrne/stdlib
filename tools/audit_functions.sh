#!/bin/bash

# This script audits the function order in production code files.
# It checks for alphabetical order, with '_' sorted after 'a-z'.
# Outputs a JSON array of files with out-of-order functions.

export LC_ALL=C

exit_code=0
files=("$@")

if [[ ${#files[@]} -eq 0 ]]; then
    mapfile -t files < <(find src \( -name "*.sh" -o -name "*.snippet" \) -not -path "*/tests/*" | sort)
fi

results=()

for file in "${files[@]}"; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    # Extract function names: lines starting with name followed by () {
    funcs=$(grep -E '^[a-zA-Z0-9._-]+ *\(\) *\{' "$file" | sed -E 's/([a-zA-Z0-9._-]+).*/\1/')

    if [[ -z "$funcs" ]]; then
        continue
    fi

    # Custom sort: map '_' to '{' (ASCII 123) to ensure it sorts after 'z' (ASCII 122)
    sorted_funcs=$(echo "$funcs" | sed 's/_/{/g' | sort | sed 's/{/_/g')

    if [[ "$funcs" != "$sorted_funcs" ]]; then
        exit_code=1

        # Build JSON object for this file using jq
        current_json=$(echo "$funcs" | jq -R . | jq -s .)
        expected_json=$(echo "$sorted_funcs" | jq -R . | jq -s .)

        file_result=$(jq -n \
            --arg file "$file" \
            --argjson current "$current_json" \
            --argjson expected "$expected_json" \
            '{file: $file, current: $current, expected: $expected}')

        results+=("$file_result")
    fi
done

if [[ ${#results[@]} -gt 0 ]]; then
    printf '%s\n' "${results[@]}" | jq -s .
fi

exit "$exit_code"
