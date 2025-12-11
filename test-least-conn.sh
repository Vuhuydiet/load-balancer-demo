#!/bin/bash

echo "=========================================="
echo "  LEAST CONNECTIONS DEMO"
echo "=========================================="
echo ""

echo "Step 1: Sending slow requests to occupy 2 servers..."
curl -s "http://localhost/slow?delay=8000" > /tmp/slow1.txt &
sleep 0.5
curl -s "http://localhost/slow?delay=8000" > /tmp/slow2.txt &
sleep 1

echo "Two servers are now busy (handling 8-second requests)"
echo ""
echo "Step 2: Sending fast requests..."
echo "These should go to the server with LEAST connections (the free one):"
echo ""

for i in {1..6}; do
  response=$(curl -s http://localhost/)
  server=$(echo $response | grep -o '"server":"[^"]*"' | cut -d'"' -f4)
  echo "Request $i → $server"
  sleep 0.3
done

echo ""
echo "=========================================="
echo "RESULT:"
echo "If Least Connections works, most/all fast"
echo "requests should go to the SAME server"
echo "(the one not handling slow requests)"
echo "=========================================="
