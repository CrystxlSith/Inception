# Inception

A Docker infrastructure project that creates a complete LEMP stack (Linux, Nginx, MariaDB, PHP) with WordPress using Docker containers and Docker Compose.

## 📋 Project Overview

This project sets up a containerized web infrastructure featuring:

- **NGINX**: Reverse proxy server with TLS 1.3 SSL encryption
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server for WordPress data
- **Docker Volumes**: Persistent storage for data and application files
- **Docker Network**: Secure internal communication between containers

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     NGINX       │    │   WordPress     │    │    MariaDB      │
│   (Port 443)    │◄──►│   (PHP-FPM)     │◄──►│   (Port 3306)   │
│   TLS 1.3 Only  │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    Docker Network: inception
```

### Container Details

- **NGINX Container**
  - Serves as reverse proxy and SSL terminator
  - Configured for TLS 1.3 only
  - Self-signed certificate for `jopfeiff.42.fr`
  - Exposes HTTPS on port 443

- **WordPress Container**
  - PHP-FPM application server
  - WordPress with WP-CLI for management
  - Connects to MariaDB for data storage
  - Runs on internal port 9000

- **MariaDB Container**
  - MySQL-compatible database server
  - Persistent data storage via Docker volumes
  - Configured with custom database and users

## 🚀 Quick Start

### Prerequisites

- Docker Engine
- Docker Compose
- Make (optional, for convenience commands)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Inception
   ```

2. **Configure environment variables**
   ```bash
   # Edit environment variables in srcs/.env
   vim srcs/.env
   ```

3. **Build and start the infrastructure**
   ```bash
   make up
   # or
   make all
   ```

4. **Access your WordPress site**
   - Open browser and navigate to `https://jopfeiff.42.fr`
   - Accept the self-signed certificate warning

## 🛠️ Available Commands

### Using Make (Recommended)

```bash
# Build and start all containers
make up
make all

# Stop containers (preserves data)
make down

# View container status
make status

# View logs from all containers
make logs

# Restart everything (rebuild containers)
make restart

# Build without starting
make build

# System cleanup (Docker pruning only)
make clean

# Complete cleanup (removes all containers, images, volumes, and data)
./clean.sh
```

### Direct Docker Commands

```bash
# Start services
docker-compose -f srcs/docker-compose.yml up -d

# Stop services
docker-compose -f srcs/docker-compose.yml down

# View logs
docker-compose -f srcs/docker-compose.yml logs

# Rebuild containers
docker-compose -f srcs/docker-compose.yml up --build -d
```

## 📁 Project Structure

```
Inception/
├── Makefile                    # Build automation
├── clean.sh                   # Complete cleanup script
└── srcs/
    ├── docker-compose.yml      # Service orchestration
    ├── .env                    # Environment variables
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       ├── nginx.conf
        │       └── script.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        │       └── script.sh
        └── mariadb/
            ├── Dockerfile
            └── conf/
                └── script.sh
```

## 🔧 Configuration

### Environment Variables

Edit `srcs/.env` to configure:

```env
# Database Configuration
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_password

# WordPress Configuration
WP_URL=https://jopfeiff.42.fr
WP_TITLE=Your Site Title
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@example.com
WP_USER=regular_user
WP_USER_EMAIL=user@example.com
WP_USER_PASSWORD=user_password
```

### Data Persistence

Data is stored in host directories:
- **WordPress files**: `/home/clarily/data/wordpress`
- **Database data**: `/home/clarily/data/mariadb`

## 🔒 Security Features

- **TLS 1.3 only**: NGINX configured for modern encryption
- **Self-signed SSL**: Certificate generated for domain
- **Network isolation**: Containers communicate via internal Docker network
- **No latest tags**: All Docker images use specific versions
- **Restart policy**: Containers automatically restart on failure

## 🐛 Troubleshooting

### Common Issues

1. **Port 443 already in use**
   ```bash
   sudo lsof -i :443
   # Stop conflicting services
   ```

2. **Permission issues with data volumes**
   ```bash
   sudo chown -R $USER:$USER /home/clarily/data/
   ```

3. **Container startup failures**
   ```bash
   make logs
   # Check individual container logs
   ```

4. **SSL certificate issues**
   - Certificate is self-signed for `jopfeiff.42.fr`
   - Add to `/etc/hosts`: `127.0.0.1 jopfeiff.42.fr`

### Reset Everything

```bash
# Complete cleanup and restart
./clean.sh
make all
```

## 📋 Requirements Met

- ✅ NGINX container with TLS 1.2/1.3 only
- ✅ WordPress + PHP-FPM container (no NGINX)
- ✅ MariaDB container (no NGINX)
- ✅ WordPress database volume
- ✅ WordPress files volume
- ✅ Docker network for container communication
- ✅ Containers restart on crash
- ✅ No `:latest` tags used


## 📝 License

This project is part of the 42 School curriculum.
