#!/bin/bash

# Health check demo script
# Demonstrates automatic failover

echo "╔════════════════════════════════════════════════════╗"
echo "║  Health Check & Failover Demo                      ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Switch to health check config
echo "📝 Switching to health check configuration..."
./switch-algorithm.sh health-check
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Normal operation (all servers healthy)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for i in {1..6}; do
    response=$(curl -s http://localhost/)
    server=$(echo $response | grep -o '"server":"[^"]*"' | cut -d'"' -f4)
    echo "  Request $i → $server"
    sleep 0.5
done

echo ""
echo "Press Enter to stop Server 2..."
read

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Stopping Server 2..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker-compose stop server2
echo "⛔ Server 2 is now DOWN"
sleep 2

echo ""
echo "Sending requests (Server 2 is down):"
echo ""

for i in {1..9}; do
    response=$(curl -s http://localhost/)
    server=$(echo $response | grep -o '"server":"[^"]*"' | cut -d'"' -f4)

    if [[ $server == *"Server 2"* ]]; then
        echo "  ❌ Request $i → $server (SHOULD NOT HAPPEN!)"
    else
        echo "  ✅ Request $i → $server"
    fi
    sleep 0.5
done

echo ""
echo "Notice: No requests went to Server 2! 🎉"
echo ""
echo "Press Enter to restart Server 2..."
read

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Restarting Server 2..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker-compose start server2
echo "✅ Server 2 is starting..."
echo "⏳ Waiting for health check to pass..."
sleep 4

echo ""
echo "Sending requests (Server 2 recovered):"
echo ""

for i in {1..9}; do
    response=$(curl -s http://localhost/)
    server=$(echo $response | grep -o '"server":"[^"]*"' | cut -d'"' -f4)

    if [[ $server == *"Server 2"* ]]; then
        echo "  🎉 Request $i → $server (BACK IN ACTION!)"
    else
        echo "  ✅ Request $i → $server"
    fi
    sleep 0.5
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Demo Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Key Takeaways:"
echo "  1. Nginx automatically detected Server 2 was down"
echo "  2. Traffic was routed only to healthy servers"
echo "  3. Server 2 was automatically added back after recovery"
echo "  4. Zero downtime for users! 🚀"
echo ""
