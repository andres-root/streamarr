#!/bin/bash

# Streamarr Media Server Pull Script
# Pulls all required Docker images

set -e  # Exit on any error

echo "📦 Pulling Streamarr Docker Images"
echo "==================================="

# Check if compose.yaml exists
if [ ! -f "compose.yaml" ]; then
    echo "❌ compose.yaml not found. Make sure you're in the correct directory."
    exit 1
fi

# Pull latest images
echo "⬇️  Pulling latest Docker images..."
docker compose pull

echo ""
echo "✅ All Docker images ready!"
echo ""
echo "📝 Next steps:"
echo "   - Start services: ./scripts/start.sh"
echo "   - Check images: docker images"