#!/bin/bash

# Simple test script for quick verification
# Usage: ./test.sh [number_of_requests]

NUM_REQUESTS=${1:-10}

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

# Show distribution
echo "Distribution:"
for i in $(seq 1 $NUM_REQUESTS)
do
    curl -s http://localhost/ | grep -o '"server":"[^"]*"'
done | sort | uniq -c | while read count server; do
    server_clean=$(echo $server | cut -d'"' -f4)
    percentage=$(echo "scale=1; $count * 100 / $NUM_REQUESTS" | bc)
    echo "  $server_clean: $count requests ($percentage%)"
done
