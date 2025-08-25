#!/bin/bash

# Streamarr Media Server Stop Script  
# Stops all media server services

set -e  # Exit on any error

echo "⏹️  Stopping Streamarr Media Server"
echo "==================================="

# Check if compose.yaml exists
if [ ! -f "compose.yaml" ]; then
    echo "❌ compose.yaml not found. Make sure you're in the correct directory."
    exit 1
fi

# Check if any containers are running
RUNNING_CONTAINERS=$(docker compose ps -q 2>/dev/null || true)

if [ -z "$RUNNING_CONTAINERS" ]; then
    echo "ℹ️  No services are currently running."
else
    echo "🔄 Stopping Docker services..."
    docker compose down -v
    
    echo ""
    echo "✅ All services stopped successfully!"
fi

echo ""
echo "📝 Services stopped:"
echo "   - Jellyfin (port 8096)"
echo "   - Sonarr (port 8989)" 
echo "   - Radarr (port 7878)"
echo "   - qBittorrent (port 8080)"
echo "   - Prowlarr (port 9696)"
echo "   - Jellyseerr (port 5055)"
echo "   - Bazarr (port 6767)"
echo ""
echo "📝 To start services again: ./scripts/start.sh"
echo "📝 To force remove everything: docker compose down -v --remove-orphans"