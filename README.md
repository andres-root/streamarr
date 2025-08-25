# 🎬 Streamarr Media Server

A complete, automated media server stack using Docker Compose. Stream your movies and TV shows with automatic downloading and organization.

## 📋 Table of Contents

1. [Overview](#-overview)
2. [Features](#-features)
3. [Prerequisites](#-prerequisites)
4. [Quick Start](#-quick-start)
5. [Detailed Installation](#-detailed-installation)
6. [Configuration](#-configuration)
7. [First-Time Setup](#-first-time-setup)
8. [Usage](#-usage)
9. [Troubleshooting](#-troubleshooting)
10. [Advanced Configuration](#-advanced-configuration)
11. [Maintenance](#-maintenance)
12. [Contributing](#-contributing)

## 🎯 Overview

Streamarr is a complete media server solution that combines several powerful applications:

- **🎵 Jellyfin**: Your personal Netflix - stream movies and TV shows
- **📺 Sonarr**: Automatically finds and downloads TV shows  
- **🎬 Radarr**: Automatically finds and downloads movies
- **⬇️ qBittorrent**: Secure torrent download client
- **🔍 Prowlarr**: Manages all your torrent sources in one place

Everything works together automatically: search for content → download → organize → stream!

## ✨ Features

- 🚀 **One-command setup**: Get everything running in minutes
- 🔄 **Fully automated**: Add a movie/show and it downloads automatically
- 🌐 **Web-based**: Control everything from your browser
- 🔒 **Secure**: Isolated Docker network with proper permissions
- 📱 **Mobile friendly**: Access from any device
- 🌍 **Multi-language**: Supports multiple languages and timezones
- 🔧 **Customizable**: Easy to modify and extend

## 📋 Prerequisites

Before you start, make sure you have:

### Required Software
- **Linux, macOS, or Windows** (this guide assumes Linux/macOS)
- **Docker** (version 20.10 or newer)
- **Docker Compose** (version 2.0 or newer)

### Hardware Requirements
- **2GB RAM minimum** (4GB recommended)
- **10GB free disk space** for applications
- **Additional space** for your media collection

### Network Requirements
- **Internet connection** for downloading content
- **Available ports**: 8096, 8989, 7878, 8080, 9696

## 🚀 Quick Start

**For the impatient** - Get everything running in 3 commands:

```bash
# 1. Clone or download this repository
git clone <your-repo-url>
cd streamarr

# 2. Run the setup script
./scripts/setup.sh

# 3. Start all services
./scripts/start.sh
```

That's it! 🎉 Jump to [First-Time Setup](#-first-time-setup) to configure your services.

## 📦 Detailed Installation

### Step 1: Install Docker

#### Ubuntu/Debian:
```bash
# Update package list
sudo apt update

# Install Docker
sudo apt install docker.io docker-compose-plugin

# Add your user to docker group (avoid sudo)
sudo usermod -aG docker $USER

# Log out and back in, then test
docker --version
```

#### macOS:
1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Install and start Docker Desktop
3. Verify: `docker --version`

#### Other Systems:
Visit the [official Docker installation guide](https://docs.docker.com/get-docker/)

### Step 2: Download Streamarr

```bash
# Option 1: Clone with git
git clone <your-repo-url>
cd streamarr

# Option 2: Download ZIP
# Download from GitHub → Extract → cd streamarr
```

### Step 3: Run Setup

The setup script will create all necessary directories and configuration files:

```bash
./scripts/setup.sh
```

**What this does:**
- ✅ Checks if Docker is installed
- ✅ Creates configuration directories
- ✅ Sets up your media folders
- ✅ Creates `.env` file from template
- ✅ Downloads Docker images
- ✅ Sets proper permissions

### Step 4: Start Services

```bash
./scripts/start.sh
```

**Services will start on:**
- Jellyfin: http://localhost:8096
- Sonarr: http://localhost:8989
- Radarr: http://localhost:7878
- qBittorrent: http://localhost:8080
- Prowlarr: http://localhost:9696

## ⚙️ Configuration

### Environment Variables

Edit the `.env` file to customize your setup:

```bash
nano .env
```

**Important settings:**

```env
# Your user/group IDs (run 'id' to get these)
PUID=1000
PGID=1000

# Your timezone
TZ=America/Bogota

# Your media folder location
MEDIA_PATH=/home/yourusername/media

# Change ports if needed
JELLYFIN_PORT=8096
SONARR_PORT=8989
# ... etc
```

### Directory Structure

Your setup will create this structure:

```
streamarr/
├── config/          # Service configurations
├── cache/           # Temporary cache files  
├── downloads/       # Downloaded files
├── scripts/         # Automation scripts
└── .env            # Your settings

/home/yourusername/media/
├── pelis/          # Movies folder
└── series/         # TV shows folder
```

## 🎬 First-Time Setup

After starting services, you need to configure each application:

### 1. Jellyfin Setup (Media Server)
1. Open http://localhost:8096
2. Follow the setup wizard:
   - Create admin user
   - Add media libraries:
     - Movies: `/media/pelis` 
     - TV Shows: `/media/series`
3. Complete setup

### 2. Prowlarr Setup (Indexer Manager)
1. Open http://localhost:9696
2. Go to **Settings** → **General** → Copy the API key
3. Add indexers:
   - **Indexers** → **Add Indexer**
   - Choose public trackers like "1337x", "RARBG", etc.
   - Test and save each indexer

### 3. qBittorrent Setup (Download Client)
1. Open http://localhost:8080
2. Login with: `admin` / `adminadmin`
3. **Change password immediately!**
4. Go to **Tools** → **Options**:
   - **Downloads**: Set default save path to `/downloads/complete`
   - **Connection**: Note the port (usually 8080)

### 4. Sonarr Setup (TV Shows)
1. Open http://localhost:8989
2. Go to **Settings** → **Download Clients** → **Add** → **qBittorrent**:
   - Host: `qbittorrent`
   - Port: `8080`
   - Username/Password: (from qBittorrent)
3. Go to **Settings** → **Indexers** → **Add** → **Prowlarr**:
   - Sync URL: `http://prowlarr:9696`
   - API Key: (from Prowlarr)
4. Go to **Settings** → **Media Management**:
   - Root Folder: `/tv`
   - Enable "Rename Episodes"

### 5. Radarr Setup (Movies)
1. Open http://localhost:7878
2. Same setup as Sonarr, but:
   - Root Folder: `/movies`
   - Enable "Rename Movies"

## 🎯 Usage

### Adding Content

**TV Shows (Sonarr):**
1. Go to **Series** → **Add New Series**
2. Search for your show
3. Choose quality profile and root folder
4. **Add Series** - it will search and download automatically!

**Movies (Radarr):**
1. Go to **Movies** → **Add New Movie**
2. Search for your movie
3. Choose quality profile and root folder  
4. **Add Movie** - it will search and download automatically!

### Watching Content

1. Open Jellyfin: http://localhost:8096
2. Your content appears automatically in libraries
3. Stream from any device!

### Monitoring Downloads

- **qBittorrent**: http://localhost:8080 - See active downloads
- **Prowlarr**: http://localhost:9696 - Test search results
- **Sonarr/Radarr**: Check "Activity" tab for import progress

## 🛠️ Troubleshooting

### Common Issues

**Services won't start:**
```bash
# Check if ports are in use
sudo netstat -tulpn | grep :8096

# Check Docker logs
docker-compose logs jellyfin
```

**Permission errors:**
```bash
# Fix permissions
sudo chown -R $(id -u):$(id -g) config downloads cache
```

**Can't find media:**
```bash
# Check media folder permissions
ls -la /home/$(whoami)/media/
```

**Downloads not moving:**
- Check Sonarr/Radarr logs in "System" → "Logs"
- Verify download client settings
- Ensure paths match between services

### Getting Help

**Check logs:**
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs jellyfin
docker-compose logs -f sonarr  # Follow mode
```

**Restart services:**
```bash
./scripts/stop.sh
./scripts/start.sh
```

**Reset everything:**
```bash
./scripts/stop.sh
sudo rm -rf config cache downloads
./scripts/setup.sh
./scripts/start.sh
```

## 🔧 Advanced Configuration

### Custom Ports

Edit `.env` to change ports:
```env
JELLYFIN_PORT=9096
SONARR_PORT=9989
```

Then restart: `./scripts/stop.sh && ./scripts/start.sh`

### VPN Integration

Add a VPN container to route downloads through VPN (recommended).

### Reverse Proxy

Use nginx or Caddy to access services via custom domains.

### Notifications

Configure Sonarr/Radarr to send notifications when content is added.

## 🧹 Maintenance

### Regular Tasks

**Update containers:**
```bash
docker-compose pull
./scripts/stop.sh
./scripts/start.sh
```

**Backup configurations:**
```bash
tar -czf streamarr-backup-$(date +%Y%m%d).tar.gz config
```

**Clean up space:**
```bash
# Remove old downloads
docker exec qbittorrent find /downloads/complete -mtime +30 -delete

# Clean Docker
docker system prune -f
```

### Monitoring

- Check service health: `docker-compose ps`
- Monitor disk space: `df -h`
- Check logs regularly for errors

## 🤝 Contributing

Found a bug or have a suggestion?

1. Check existing issues
2. Create a new issue with details
3. Submit a pull request

## 📄 License

This project is open source. See individual application licenses for details.

## 🙏 Acknowledgments

Built with amazing open-source projects:
- [Jellyfin](https://jellyfin.org/)
- [Sonarr](https://sonarr.tv/)
- [Radarr](https://radarr.video/)
- [qBittorrent](https://www.qbittorrent.org/)
- [Prowlarr](https://prowlarr.com/)
- [LinuxServer.io](https://www.linuxserver.io/) Docker images

---

**Happy Streaming! 🍿**

*Need help? Open an issue or check the troubleshooting section above.*