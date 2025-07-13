# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **Inception** project - a Docker infrastructure setup that creates a complete LEMP stack (Linux, Nginx, MariaDB, PHP) using Docker containers. The project sets up a WordPress website with the following architecture:

- **NGINX**: Reverse proxy with TLS 1.3 SSL termination
- **WordPress**: PHP-FPM application server 
- **MariaDB**: Database server
- **Docker volumes**: Persistent storage for WordPress files and database
- **Docker network**: Internal communication between containers

## Development Commands

### Core Operations
```bash
# Build and start all containers
make up
# or
make all

# Stop containers (preserves data)
make down

# View container status
make status

# View logs from all containers
make logs

# Restart everything (rebuild containers)
make restart

# Complete cleanup (removes all containers, images, volumes, and data)
./clean.sh
```

### Manual Docker Commands
```bash
# Build without starting
make build

# System cleanup (Docker pruning only)
make clean
```

## Architecture Details

### Container Communication
- All containers run on the `inception` Docker network
- WordPress connects to MariaDB via hostname `mariadb:3306`
- NGINX proxies to WordPress via `wordpress:9000` (PHP-FPM)
- NGINX exposes port 443 (HTTPS only) to the host

### Data Persistence
- **WordPress files**: `/home/clarily/data/wordpress` → `/var/www/html` (in containers)
- **MariaDB data**: `/home/clarily/data/mariadb` → `/var/lib/mysql` (in mariadb container)

### SSL Configuration
- Self-signed certificate generated for `jopfeiff.42.fr`
- NGINX configured for TLS 1.3 only
- Certificate paths: `/etc/ssl/certs/nginx-selfsigned.crt` and `/etc/ssl/private/nginx-selfsigned.key`

## Configuration Files

### Environment Variables
- `.env` file in `/srcs/` contains all sensitive configuration
- Variables include database credentials, WordPress admin details, and URLs

### Key Configuration Files
- `srcs/docker-compose.yml`: Main orchestration file
- `srcs/requirements/nginx/conf/nginx.conf`: NGINX virtual host configuration  
- `srcs/requirements/*/Dockerfile`: Container build instructions
- `srcs/requirements/*/conf/script.sh`: Container startup scripts

## Container Startup Behavior

### MariaDB (`srcs/requirements/mariadb/conf/script.sh:9-22`)
- Initializes database and user on first run
- Creates database and user specified in environment variables
- Sets root password from `MYSQL_ROOT_PASSWORD`

### WordPress (`srcs/requirements/wordpress/conf/script.sh:17-42`)
- Downloads WordPress core if not present
- Waits for database availability before proceeding
- Creates wp-config.php with database connection details
- Runs WordPress installation with WP-CLI
- Creates additional user if `WP_USER` environment variable is set

### NGINX (`srcs/requirements/nginx/conf/script.sh:4-12`)
- Generates SSL certificate for the domain
- Configures local hosts entry
- Starts NGINX in foreground mode

## Development Notes

- All containers restart automatically on crash (`restart: always`)
- WordPress uses WP-CLI for management and installation
- PHP-FPM runs on port 9000 inside the WordPress container
- The setup supports both admin and regular user creation during initialization
- Data directories are created with proper ownership and permissions during container startup