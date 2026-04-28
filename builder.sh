#!/bin/bash
set -e

ENV=${1:-development}
ACTION=${2:-none}

# Normalize ENV
if [ "$ENV" == "dev" ]; then ENV="development"; fi

# Validate ENV
if [[ "$ENV" != "development" && "$ENV" != "staging" && "$ENV" != "production" ]]; then
    echo "Error: Invalid environment '$ENV'. Use: development | staging | production"
    exit 1
fi

echo "========================================"
echo "  Gateway API Build System"
echo "  Target Environment: $ENV"
echo "========================================"

# Initialize submodules if not present
if [ ! -f "modules/Base-Api/BaseApi/BaseApi.csproj" ]; then
    echo "[0/4] Initializing submodules..."
    git submodule update --init --recursive
fi

echo "[1/4] Building solution..."
dotnet build GatewayApi.sln -c Release

echo "[2/4] Building Docker Image ($ENV)..."
docker compose -f docker-compose.yml -f docker-compose.$ENV.yml build

echo "[3/4] Creating backup archive (.tar)..."
TIMESTAMP=$(date +%Y%m%d%H%M%S)
mkdir -p ./backups
tar -cf "./backups/gateway-api-$ENV-$TIMESTAMP.tar" --exclude="./bin" --exclude="./obj" --exclude="./.git" .
echo "Backup created: ./backups/gateway-api-$ENV-$TIMESTAMP.tar"

if [ "$ACTION" == "up" ]; then
    echo "[4/4] Starting stack with Docker Compose..."
    docker compose -f docker-compose.yml -f docker-compose.$ENV.yml up -d
elif [ "$ACTION" == "down" ]; then
    echo "[4/4] Stopping stack..."
    docker compose -f docker-compose.yml -f docker-compose.$ENV.yml down
else
    echo "[4/4] Build complete. Use './builder.sh $ENV up' to start services."
fi

echo "========================================"
echo "  Done."
echo "========================================"
