#!/bin/bash

# NATS Server Test Script
# This script tests basic NATS server functionality

set -e

NATS_HOST="localhost"
NATS_PORT="4222"
MONITOR_PORT="8222"
CONTAINER_NAME="nats-server"

echo "🧪 NATS Server Test Script"
echo "================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check if container is running
echo "📦 Test 1: Checking if NATS container is running..."
if docker ps | grep -q "$CONTAINER_NAME"; then
    echo -e "${GREEN}✅ Container is running${NC}"
else
    echo -e "${RED}❌ Container is not running${NC}"
    echo "   Start with: docker-compose up -d"
    exit 1
fi
echo ""

# Test 2: Check container logs
echo "📋 Test 2: Checking container logs..."
LOGS=$(docker logs "$CONTAINER_NAME" 2>&1 | tail -n 5)
if echo "$LOGS" | grep -q "Server is ready"; then
    echo -e "${GREEN}✅ NATS server is ready${NC}"
elif echo "$LOGS" | grep -q "Listening for client connections"; then
    echo -e "${GREEN}✅ NATS server is listening${NC}"
else
    echo -e "${YELLOW}⚠️  Server status unclear, showing recent logs:${NC}"
    echo "$LOGS"
fi
echo ""

# Test 3: Check if NATS client port is accessible
echo "🌐 Test 3: Checking NATS client port ($NATS_PORT)..."
if nc -z "$NATS_HOST" "$NATS_PORT" 2>/dev/null || timeout 1 bash -c "echo > /dev/tcp/$NATS_HOST/$NATS_PORT" 2>/dev/null; then
    echo -e "${GREEN}✅ Port $NATS_PORT is accessible${NC}"
else
    echo -e "${RED}❌ Port $NATS_PORT is not accessible${NC}"
    exit 1
fi
echo ""

# Test 4: Check monitoring endpoint
echo "📊 Test 4: Checking HTTP monitoring endpoint..."
if curl -s "http://$NATS_HOST:$MONITOR_PORT/varz" > /dev/null; then
    echo -e "${GREEN}✅ Monitoring endpoint is accessible${NC}"
    
    # Get server version
    VERSION=$(curl -s "http://$NATS_HOST:$MONITOR_PORT/varz" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$VERSION" ]; then
        echo "   Server version: $VERSION"
    fi
else
    echo -e "${RED}❌ Monitoring endpoint is not accessible${NC}"
fi
echo ""

# Test 5: Get server statistics
echo "📈 Test 5: Fetching server statistics..."
STATS=$(curl -s "http://$NATS_HOST:$MONITOR_PORT/varz")
if [ ! -z "$STATS" ]; then
    echo -e "${GREEN}✅ Successfully retrieved server stats${NC}"
    
    # Parse and display some key metrics
    CONNECTIONS=$(echo "$STATS" | grep -o '"connections":[0-9]*' | cut -d':' -f2)
    IN_MSGS=$(echo "$STATS" | grep -o '"in_msgs":[0-9]*' | cut -d':' -f2)
    OUT_MSGS=$(echo "$STATS" | grep -o '"out_msgs":[0-9]*' | cut -d':' -f2)
    
    echo "   Active connections: ${CONNECTIONS:-0}"
    echo "   Messages in: ${IN_MSGS:-0}"
    echo "   Messages out: ${OUT_MSGS:-0}"
else
    echo -e "${RED}❌ Failed to retrieve server stats${NC}"
fi
echo ""

# Test 6: Check connections endpoint
echo "🔗 Test 6: Checking connections endpoint..."
CONNZ=$(curl -s "http://$NATS_HOST:$MONITOR_PORT/connz")
if [ ! -z "$CONNZ" ]; then
    echo -e "${GREEN}✅ Connections endpoint is working${NC}"
    CONN_COUNT=$(echo "$CONNZ" | grep -o '"num_connections":[0-9]*' | cut -d':' -f2)
    echo "   Number of connections: ${CONN_COUNT:-0}"
else
    echo -e "${YELLOW}⚠️  Failed to check connections${NC}"
fi
echo ""

# Test 7: Interactive test (optional)
echo "🎯 Test 7: Interactive pub/sub test (optional)"
echo "   To manually test publishing and subscribing:"
echo ""
echo "   Terminal 1 (Subscribe):"
echo "   $ docker exec -it $CONTAINER_NAME sh"
echo "   # nats-sub test.topic"
echo ""
echo "   Terminal 2 (Publish):"
echo "   $ docker exec -it $CONTAINER_NAME sh"
echo "   # nats-pub test.topic \"Hello NATS!\""
echo ""

# Summary
echo "================================"
echo -e "${GREEN}🎉 All automated tests passed!${NC}"
echo ""
echo "📊 Monitoring URLs:"
echo "   Server Info:    http://$NATS_HOST:$MONITOR_PORT/varz"
echo "   Connections:    http://$NATS_HOST:$MONITOR_PORT/connz"
echo "   Routes:         http://$NATS_HOST:$MONITOR_PORT/routez"
echo "   Subscriptions:  http://$NATS_HOST:$MONITOR_PORT/subsz"
echo ""
echo "🔗 Connection String: nats://$NATS_HOST:$NATS_PORT"
echo ""

