#!/bin/bash

# Script to switch between different load balancing algorithms
# Usage: ./switch-algorithm.sh [round-robin|least-conn|ip-hash|weighted|health-check]

ALGORITHM=${1:-round-robin}

case $ALGORITHM in
    round-robin)
        CONFIG="nginx-round-robin.conf"
        NAME="Round Robin"
        DESC="Distributes requests evenly across all servers"
        ;;
    least-conn)
        CONFIG="nginx-least-conn.conf"
        NAME="Least Connections"
        DESC="Sends requests to server with fewest active connections"
        ;;
    ip-hash)
        CONFIG="nginx-ip-hash.conf"
        NAME="IP Hash"
        DESC="Routes same client IP to same server (session persistence)"
        ;;
    weighted)
        CONFIG="nginx-weighted.conf"
        NAME="Weighted Round Robin"
        DESC="Server 1: 50%, Server 2: 30%, Server 3: 20%"
        ;;
    health-check)
        CONFIG="nginx-health-check.conf"
        NAME="Health Check"
        DESC="Automatically removes unhealthy servers"
        ;;
    *)
        echo "Usage: $0 [round-robin|least-conn|ip-hash|weighted|health-check]"
        exit 1
        ;;
esac

echo "╔════════════════════════════════════════════════════╗"
echo "║  Switching Load Balancing Algorithm                ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "Algorithm: $NAME"
echo "Description: $DESC"
echo "Config: nginx/$CONFIG"
echo ""

# Update docker-compose.yml to use the selected config
echo "📝 Updating docker-compose.yml..."
# Only replace the active line (not the commented ones)
sed -i.bak "/^      - \.\/nginx\/nginx-.*\.conf:\/etc\/nginx\/nginx.conf:ro$/c\      - ./nginx/$CONFIG:/etc/nginx/nginx.conf:ro" docker-compose.yml

# Stop and remove nginx container to remount volume with new config
echo "🔄 Restarting nginx with new config..."
docker compose stop nginx > /dev/null 2>&1
docker compose rm -f nginx > /dev/null 2>&1
docker compose up -d nginx > /dev/null 2>&1

# Wait for nginx to start
echo "⏳ Waiting for nginx to start..."
sleep 3

# Verify the config is loaded
echo "✅ Verifying configuration..."
docker exec nginx-load-balancer cat /etc/nginx/nginx.conf | head -n 3

echo ""
echo "✅ Successfully switched to: $NAME"
echo ""
echo "Test with: curl http://localhost/"
echo "Or run: ./simple-test.sh 10"
