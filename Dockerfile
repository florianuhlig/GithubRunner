# Bessere Alternative: Direkter Download
FROM alpine:3.19 AS builder

RUN apk update && apk add --no-cache \
    curl \
    tar \
    gzip \
    bash \
    ca-certificates

ARG RUNNER_VERSION=2.310.2
WORKDIR /tmp

# Lade GitHub Actions Runner direkt herunter
RUN curl -o actions-runner.tar.gz -L \
    "https://github.com/actions/runner/releases/download/v2.330.0/actions-runner-linux-x64-2.330.0.tar.gz"

# Erstelle Zielverzeichnis
RUN mkdir -p /tmp/actions-runner

# Extrahiere direkt ohne --strip-components (oft problematisch)
RUN tar xzf actions-runner.tar.gz -C /tmp/actions-runner

# Runtime Stage
FROM alpine:3.19

RUN apk update && apk add --no-cache \
    curl \
    jq \
    git \
    bash \
    sudo \
    ca-certificates \
    && rm -rf /var/cache/apk/*

RUN adduser -D -s /bin/bash runneruser && \
    echo "runneruser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /actions-runner
WORKDIR /actions-runner

# Kopiere extrahierte Dateien
COPY --from=builder /tmp/actions-runner ./

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown -R runneruser:runneruser /actions-runner

USER runneruser
ENTRYPOINT ["/entrypoint.sh"]
