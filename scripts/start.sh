#!/bin/bash

# Streamarr Media Server Start Script
# Starts all media server services

set -e  # Exit on any error

echo "🚀 Starting Streamarr Media Server"
echo "=================================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Run ./scripts/setup.sh first."
    exit 1
fi

# Check if compose.yaml exists
if [ ! -f "compose.yaml" ]; then
    echo "❌ compose.yaml not found. Make sure you're in the correct directory."
    exit 1
fi

# Start services
echo "🔄 Starting Docker services..."
docker compose up -d

# Wait a moment for services to start
echo "⏳ Waiting for services to start..."
sleep 5

# Check service status
echo "📊 Service Status:"
docker compose ps

echo ""
echo "✅ All services started successfully!"
echo ""
echo "🌐 Access your services at:"
echo "   - Jellyfin:     http://localhost:8096"
echo "   - Sonarr:       http://localhost:8989"
echo "   - Radarr:       http://localhost:7878"
echo "   - qBittorrent:  http://localhost:8080"
echo "   - Prowlarr:     http://localhost:9696"
echo ""
echo "📝 To view logs: docker-compose logs -f [service-name]"
echo "📝 To stop services: ./scripts/stop.sh"