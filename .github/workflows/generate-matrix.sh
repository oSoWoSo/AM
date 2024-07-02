#!/bin/bash

randomAppsList=$(cut -d' ' -f2 < /opt/am/x86_64-apps | shuf -n 100)
apps="$randomAppsList"

# Convert bash array to JSON array
matrix=$(printf '%s\n' "${apps[@]}" | jq -R . | jq -s .)

# Output the matrix in a format GitHub Actions can use
echo "matrix=$matrix" #| tee >> "$GITHUB_OUTPUT"
