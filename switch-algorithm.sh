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

# Copy config
echo "📝 Copying configuration..."
docker cp "nginx/$CONFIG" nginx-load-balancer:/etc/nginx/nginx.conf

# Test config
echo "✅ Testing configuration..."
docker-compose exec nginx nginx -t

if [ $? -eq 0 ]; then
    # Reload Nginx
    echo "🔄 Reloading Nginx..."
    docker-compose exec nginx nginx -s reload

    echo ""
    echo "✅ Successfully switched to: $NAME"
    echo ""
    echo "Test with: curl http://localhost/"
    echo "Or run: ./simple-test.sh 10"
else
    echo ""
    echo "❌ Configuration test failed!"
    exit 1
fi
