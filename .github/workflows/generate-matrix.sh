#!/bin/bash

randomAppsList=$(cut -d' ' -f2 < /opt/am/x86_64-apps | shuf -n 100)
apps=$(echo "$randomAppsList" | jq -R -s -c 'split("\n")[:-1]')

# Convert bash array to JSON array
matrix=$(printf '%s\n' "${apps[@]}" | jq -R . | jq -s .)

# Output the matrix in a format GitHub Actions can use
echo "::set-output name=matrix::$matrix" #>> $GITHUB_OUTPUT
