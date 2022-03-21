# jellyfin-rar2fs
A simple enhancement to the popular `linuxserver/jellyfin` container that adds support to Jellyfin for media compressed in `.rar` files.  Using [`rar2fs`](https://github.com/hasse69/rar2fs), any directories mounted under `/rar` will be re-mounted under `/unrar` for you to add as a share in Jellyfin.

## Usage
To run this container, you will need to provide three additional arguments to your docker run command / docker-copose for the internal `rar2fs` fuse mount to work.

### Docker Compose
Add the following to your docker-compose file:
```
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    devices:
      - /dev/fuse
```

Full example:
```
---
version: "2.1"
services:
  jellyfin:
    image: aidanr/jellyfin-rar2fs
    container_name: jellyfin
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    devices:
      - /dev/fuse
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /path/to/rard/media:/unrar/media:ro
    ports:
      - 8096:8096
      - 8920:8920 #optional
      - 7359:7359/udp #optional
      - 1900:1900/udp #optional
    restart: unless-stopped
```

### Docker CLI
Add the following to your `docker run` command:
```
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
```

Full example:

```
docker run -d \
  --name=jellyfin \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 8096:8096 \
  -p 8920:8920 `#optional` \
  -p 7359:7359/udp `#optional` \
  -p 1900:1900/udp `#optional` \
  -v /path/to/rar/media:/rar/media:ro \
  --restart unless-stopped \
  aidanr/jellyfin-rar2fs
```

## Parameters/Configuration
Refer to the `linuxserver/jellyfin` [documentation](https://github.com/linuxserver/docker-jellyfin#parameters) for a full list of supported configuration options.
