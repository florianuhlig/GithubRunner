# GitHub Actions Runner (Docker)

A lightweight, self-hosted GitHub Actions runner packaged as a Docker container using Alpine Linux.

## Features

- Minimal Alpine Linux base image
- Multi-stage Docker build for smaller image size
- Easy configuration via environment variables
- Docker Compose support for simple deployment

## Quick Start

### 1. Get a Runner Token

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Actions** > **Runners**
3. Click **New self-hosted runner**
4. Copy the token from the configuration instructions

### 2. Configure and Run

```bash
# Copy the example compose file
cp docker-compose.yml.example compose.yml

# Edit with your values
nano compose.yml
```

Update the environment variables:

```yaml
environment:
  RUNNER_TOKEN: "your-runner-token"
  OWNER: "your-github-username"
  REPO: "your-repository-name"
```

Start the runner:

```bash
docker compose up -d
```

### Alternative: Build and Run Manually

```bash
# Build the image
docker build -t github-runner .

# Run the container
docker run -d \
  -e RUNNER_TOKEN="your-token" \
  -e OWNER="your-username" \
  -e REPO="your-repo" \
  --name github-runner \
  github-runner
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `RUNNER_TOKEN` | Yes | GitHub runner registration token |
| `OWNER` | Yes | GitHub username or organization name |
| `REPO` | Yes | Repository name |

## Architecture

```
.
├── Dockerfile                  # Multi-stage build configuration
├── docker-compose.yml.example  # Compose template
├── entrypoint.sh               # Runner configuration and startup script
└── README.md
```

The image uses a two-stage build process:
1. **Builder stage**: Downloads and extracts the GitHub Actions runner
2. **Runtime stage**: Minimal Alpine image with only necessary dependencies

 
