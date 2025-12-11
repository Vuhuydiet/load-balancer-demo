#!/bin/bash

# Simple test script for quick verification
# Usage: ./test.sh [number_of_requests]

NUM_REQUESTS=${1:-10}

# Declare associative array to track server distribution
declare -A server_count

echo "╔════════════════════════════════════════╗"
echo "║  Load Balancer Quick Test             ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Sending $NUM_REQUESTS requests to http://localhost/"
echo ""

for i in $(seq 1 $NUM_REQUESTS)
do
    response=$(curl -s http://localhost/)
    server=$(echo $response | grep -o '"server":"[^"]*"' | cut -d'"' -f4)
    timestamp=$(date '+%H:%M:%S')

    # Track server distribution
    if [[ -n "$server" ]]; then
        ((server_count["$server"]++))
    fi

    # Color based on server
    if [[ $server == *"1"* ]]; then
        echo -e "[$timestamp] Request $i → \033[0;34m$server\033[0m"
    elif [[ $server == *"2"* ]]; then
        echo -e "[$timestamp] Request $i → \033[0;32m$server\033[0m"
    elif [[ $server == *"3"* ]]; then
        echo -e "[$timestamp] Request $i → \033[0;31m$server\033[0m"
    else
        echo "[$timestamp] Request $i → $server"
    fi

    sleep 0.5
done

echo ""
echo "═══════════════════════════════════════"
echo "Test completed! ✅"
echo ""

# Show distribution from tracked data
echo "Distribution:"
for server in "${!server_count[@]}"; do
    count=${server_count[$server]}
    percentage=$(( count * 100 / NUM_REQUESTS ))
    echo "  $server: $count requests ($percentage%)"
done | sort
