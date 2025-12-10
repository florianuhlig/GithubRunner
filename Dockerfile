FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download runner file
RUN curl -o actions-runner.tar.gz -L \
    "https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz"

# Create destination directory and extract
RUN mkdir -p /tmp/actions-runner && \
    tar xzf actions-runner.tar.gz -C /tmp/actions-runner

# Runtime Stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    git \
    sudo \
    ca-certificates \
    libicu72 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash runneruser && \
    echo "runneruser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /actions-runner
WORKDIR /actions-runner

# Copy extracted files
COPY --from=builder /tmp/actions-runner ./

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown -R runneruser:runneruser /actions-runner

USER runneruser
ENTRYPOINT ["/entrypoint.sh"]
