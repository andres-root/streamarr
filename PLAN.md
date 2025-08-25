# Media Server Setup Plan

## Overview
This plan outlines the step-by-step process to set up a complete media server stack using Docker Compose with:
- **Jellyfin**: Media streaming server
- **Sonarr**: TV shows automation and management
- **Radarr**: Movies automation and management
- **qBittorrent**: Download client
- **Prowlarr**: Indexer manager

### Media Folder Configuration
- **Movies**: `/home/andres/media/pelis`
- **TV Shows**: `/home/andres/media/series`

## Prerequisites
- Docker and Docker Compose installed
- Sufficient storage space for media
- Basic understanding of Docker concepts

## Step-by-Step Implementation Plan

### Step 1: Configure Jellyfin Base Setup
**Objective**: Set up Jellyfin with proper paths and permissions

**Tasks**:
- Update compose.yaml with actual paths for config, cache, and media directories
- Replace placeholder UID:GID with actual user values
- Configure the published server URL
- Remove unnecessary volume mounts

**Sample Code**:
```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    user: 1000:1000  # Replace with your user's UID:GID
    volumes:
      - ./config/jellyfin:/config
      - ./cache/jellyfin:/cache
      - /home/andres/media:/media  # Using host media folder
    ports:
      - 8096:8096
    environment:
      - JELLYFIN_PublishedServerUrl=http://your-server-ip:8096
```

---

### Step 2: Add Sonarr Service
**Objective**: Add Sonarr for TV show management

**Tasks**:
- Add Sonarr service definition to compose.yaml
- Configure volumes for config and TV shows
- Set up port mapping (8989)
- Add environment variables for timezone

**Sample Code**:
```yaml
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - ./config/sonarr:/config
      - /home/andres/media/series:/tv  # Host path for TV shows
      - ./downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
```

---

### Step 3: Add Radarr Service
**Objective**: Add Radarr for movie management

**Tasks**:
- Add Radarr service definition to compose.yaml
- Configure volumes for config and movies
- Set up port mapping (7878)
- Add environment variables

**Sample Code**:
```yaml
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - ./config/radarr:/config
      - /home/andres/media/pelis:/movies  # Host path for movies
      - ./downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
```

---

### Step 4: Create Directory Structure
**Objective**: Create all required directories with proper permissions

**Tasks**:
- Create config directories for each service
- Create media directories (tv, movies)
- Create downloads directory
- Set proper ownership

**Sample Commands**:
```bash
# Create directory structure
mkdir -p config/{jellyfin,sonarr,radarr,qbittorrent,prowlarr}
mkdir -p /home/andres/media/pelis  # Movies folder
mkdir -p /home/andres/media/series  # TV shows folder
mkdir -p downloads/{complete,incomplete}
mkdir -p cache/jellyfin

# Set permissions (replace 1000:1000 with your UID:GID)
sudo chown -R 1000:1000 config downloads cache
sudo chown -R 1000:1000 /home/andres/media/pelis /home/andres/media/series
```

---

### Step 5: Add Download Client (qBittorrent)
**Objective**: Set up qBittorrent for downloading content

**Tasks**:
- Add qBittorrent service to compose.yaml
- Configure volumes for downloads and config
- Set up port mappings (8080 for WebUI, 6881 for torrents)
- Configure environment variables

**Sample Code**:
```yaml
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - WEBUI_PORT=8080
    volumes:
      - ./config/qbittorrent:/config
      - ./downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

---

### Step 6: Add Prowlarr (Indexer Manager)
**Objective**: Set up Prowlarr to manage torrent indexers

**Tasks**:
- Add Prowlarr service to compose.yaml
- Configure volumes
- Set up port mapping (9696)
- Prepare for integration with Sonarr/Radarr

**Sample Code**:
```yaml
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - ./config/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
```

---

### Step 7: Configure Networking
**Objective**: Set up proper Docker networking and service dependencies

**Tasks**:
- Create custom bridge network
- Add all services to the network
- Configure service dependencies
- Add health checks

**Sample Code**:
```yaml
networks:
  media-network:
    driver: bridge

services:
  jellyfin:
    networks:
      - media-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8096/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

### Step 8: Environment Variables & Security
**Objective**: Centralize configuration and improve security

**Tasks**:
- Create .env file for sensitive data
- Move hardcoded values to environment variables
- Set up secure passwords
- Configure API keys placeholder

**Sample .env File**:
```env
# User/Group IDs
PUID=1000
PGID=1000

# Timezone
TZ=America/New_York

# Paths
CONFIG_PATH=./config
MEDIA_PATH=./media
DOWNLOADS_PATH=./downloads

# Ports
JELLYFIN_PORT=8096
SONARR_PORT=8989
RADARR_PORT=7878
QBITTORRENT_PORT=8080
PROWLARR_PORT=9696
```

---

### Step 9: Initial Service Configuration
**Objective**: Start services and perform initial configuration

**Tasks**:
- Start all services with docker-compose
- Access each service's web interface
- Configure Jellyfin media libraries
- Set up Prowlarr indexers
- Connect Sonarr/Radarr to Prowlarr and qBittorrent

**Sample Commands**:
```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f [service-name]

# Access services:
# Jellyfin: http://localhost:8096
# Sonarr: http://localhost:8989
# Radarr: http://localhost:7878
# qBittorrent: http://localhost:8080
# Prowlarr: http://localhost:9696
```

---

### Step 10: Testing & Optimization
**Objective**: Verify setup and optimize performance

**Tasks**:
- Test complete workflow (search → download → import → stream)
- Configure quality profiles in Sonarr/Radarr
- Set up automation rules
- Configure naming conventions
- Test streaming on different devices

**Testing Checklist**:
- [ ] Can search for content in Prowlarr
- [ ] Can add TV show in Sonarr
- [ ] Can add movie in Radarr
- [ ] Downloads start in qBittorrent
- [ ] Media imports to correct folders
- [ ] Media appears in Jellyfin library
- [ ] Can stream media from Jellyfin

---

## Notes
- Always backup your configuration before making changes
- Monitor disk space regularly
- Keep services updated for security
- Consider adding a VPN container for download client
- Optional: Add Bazarr for subtitle management
- Optional: Add Ombi/Overseerr for request management