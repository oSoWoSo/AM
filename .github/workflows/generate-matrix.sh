#!/bin/bash

randomAppsList=$(cut -d' ' -f2 < /opt/am/x86_64-apps | shuf -n 100)
apps=$(echo "$randomAppsList" | jq -R -s -c 'split("\n")[:-1]')
echo "name=matrix::${apps}" >> $GITHUB_OUTPUT
