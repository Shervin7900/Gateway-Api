# Gateway API

A .NET 10 microservice acting as an API Gateway for the Discount Manager ecosystem. Built with **Ocelot** and integrated with **Consul** for dynamic service discovery.

## 🚀 Features

- **API Gateway**: Centralized entry point using Ocelot.
- **Service Discovery**: Automated registration and discovery via Consul.
- **Shared Infrastructure**: Built upon the `Base-Api` submodule for consistent logging, metrics, and health checks.
- **Containerized**: Fully Dockerized with environment-specific compose files.
- **CI/CD**: GitHub Actions workflows for Development, Staging, and Production.
- **Health Monitoring**: Integrated health checks compatible with Prometheus and Grafana.

## 🛠 Tech Stack

- **Framework**: .NET 10 (ASP.NET Core)
- **Gateway**: Ocelot
- **Service Discovery**: Consul
- **Submodule**: Base-Api (Shared Infrastructure)
- **Containerization**: Docker & Docker Compose

## 📁 Project Structure

```text
Gateway-Api/
├── .github/workflows/      # CI/CD Workflows
├── backups/                # Backup .tar archives
├── GatewayApi/             # Main project source
│   ├── ocelot.json         # Ocelot routing configurations
│   ├── appsettings.json    # Application settings
│   └── Dockerfile          # Multi-stage Docker build
├── modules/
│   └── Base-Api/           # Git Submodule for shared logic
├── builder.sh              # Unified build & deployment script
└── docker-compose.yml      # Base orchestration file
```

## 🚦 Getting Started

### Prerequisites

- .NET 10 SDK
- Docker & Docker Compose
- Git

### Installation

1. Clone the repository with submodules:
   ```bash
   git clone --recursive https://github.com/Shervin7900/Gateway-Api.git
   ```

2. Alternatively, initialize submodules manually:
   ```bash
   git submodule update --init --recursive
   ```

### Running Locally

Use the provided `builder.sh` script to build and start the services:

```bash
# Build and start in development mode
./builder.sh development up

# Stop the services
./builder.sh development down
```

The gateway will be available at `http://localhost:5000`.
Consul UI will be available at `http://localhost:8500`.

## 🛣 API Routing

The gateway routes traffic to downstream services based on the path:

| Upstream Path | Downstream Service | Consul Service Name |
| :--- | :--- | :--- |
| `/basket/*` | Basket-Api | `Basket-Api` |
| `/customer/*` | Customer-Api | `Customer-Api` |

## 🌐 Environments

The project supports three environments with specific configurations:

- **Development**: Local testing with localhost addresses.
- **Staging**: Pre-production environment for integration testing.
- **Production**: Secure, scaled environment with production-grade settings.

Configurations are managed via:
- `ocelot.{Environment}.json`
- `appsettings.{Environment}.json`
- `docker-compose.{Environment}.yml`

## 🔄 CI/CD

The GitHub Actions workflow [`.github/workflows/ci.yml`](.github/workflows/ci.yml) handles the lifecycle:
1. **Build & Test**: Triggered on every push to `main` or PR.
2. **Security Check**: Scans for vulnerable packages.
3. **Deployment**: Triggered via `workflow_dispatch` (manual) or push to `main` for staging.

## 📦 Backups

The `builder.sh` script automatically creates a `.tar` archive of the source code (excluding build artifacts) in the `./backups` folder during every build.

---
*Maintained by Shervin*