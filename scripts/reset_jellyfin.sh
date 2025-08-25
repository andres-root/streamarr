#!/bin/bash

# Streamarr Jellyfin Reset Script
# Completely resets Jellyfin to fresh installation state

set -e  # Exit on any error

echo "🔄 Jellyfin Reset Script"
echo "======================="
echo ""
echo "⚠️  WARNING: This will completely reset Jellyfin!"
echo "   - All users and passwords will be deleted"
echo "   - All libraries and metadata will be removed"
echo "   - All settings will be reset to defaults"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Reset cancelled."
    exit 0
fi

echo ""
echo "🛑 Stopping Jellyfin container..."
docker compose stop jellyfin

echo "🗑️  Removing Jellyfin configuration and cache..."
sudo rm -rf config/jellyfin
sudo rm -rf cache/jellyfin

echo "📁 Creating fresh directories..."
mkdir -p config/jellyfin
mkdir -p cache/jellyfin

echo "🔒 Setting proper permissions..."
USER_ID=$(id -u)
GROUP_ID=$(id -g)
sudo chown -R "$USER_ID:$GROUP_ID" config/jellyfin cache/jellyfin

echo "🚀 Starting Jellyfin with fresh configuration..."
docker compose up -d jellyfin

echo "⏳ Waiting for Jellyfin to start..."
sleep 10

# Check if Jellyfin is running
if docker compose ps jellyfin | grep -q "running"; then
    echo ""
    echo "✅ Jellyfin has been successfully reset!"
    echo ""
    echo "🌐 Access Jellyfin at: http://localhost:8096"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Open http://localhost:8096 in your browser"
    echo "   2. Follow the setup wizard"
    echo "   3. Create a new admin account"
    echo "   4. Add your media libraries:"
    echo "      - Movies: /media/pelis"
    echo "      - TV Shows: /media/series"
else
    echo ""
    echo "⚠️  Jellyfin may still be starting. Check status with:"
    echo "   docker compose ps jellyfin"
    echo "   docker compose logs jellyfin"
fi