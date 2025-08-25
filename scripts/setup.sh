#!/bin/bash

# Streamarr Media Server Setup Script
# This script automates the initial setup process

set -e  # Exit on any error

echo "🎬 Streamarr Media Server Setup"
echo "==============================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "📋 Creating .env file from template..."
    if [ -f ".env.base" ]; then
        cp .env.base .env
        echo "✅ .env file created from .env.base"
        echo "⚠️  Please edit .env file with your specific configuration before starting services"
    else
        echo "❌ .env.base template not found"
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

# Create required directories
echo "📁 Creating required directories..."

# Config directories
mkdir -p config/{jellyfin,sonarr,radarr,qbittorrent,prowlarr}
echo "✅ Config directories created"

# Downloads directories
mkdir -p downloads/{complete,incomplete}
echo "✅ Downloads directories created"

# Cache directory
mkdir -p cache/jellyfin
echo "✅ Cache directories created"

# Media directories (if they don't exist)
if [ ! -d "/home/$(whoami)/media/pelis" ]; then
    mkdir -p "/home/$(whoami)/media/pelis"
    echo "✅ Movies directory created"
else
    echo "✅ Movies directory already exists"
fi

if [ ! -d "/home/$(whoami)/media/series" ]; then
    mkdir -p "/home/$(whoami)/media/series"
    echo "✅ TV shows directory created"
else
    echo "✅ TV shows directory already exists"
fi

# Set proper permissions
echo "🔒 Setting permissions..."
USER_ID=$(id -u)
GROUP_ID=$(id -g)

chown -R "$USER_ID:$GROUP_ID" config downloads cache
chown -R "$USER_ID:$GROUP_ID" "/home/$(whoami)/media/pelis" "/home/$(whoami)/media/series" 2>/dev/null || true

echo "✅ Permissions set"

# Pull Docker images
echo "📦 Pulling Docker images..."
./scripts/pull.sh

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Edit .env file if needed: nano .env"
echo "2. Start services: ./scripts/start.sh"
echo "3. Access services at:"
echo "   - Jellyfin: http://localhost:8096"
echo "   - Sonarr: http://localhost:8989"
echo "   - Radarr: http://localhost:7878"
echo "   - qBittorrent: http://localhost:8080"
echo "   - Prowlarr: http://localhost:9696"