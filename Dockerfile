FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    google-cloud-sdk \
    && rm -rf /var/lib/apt/lists/*

# Set up environment
ENV HERMES_HOME=/home/fred/.hermes
ENV WIKI_PATH=/home/fred/wiki
WORKDIR /home/fred

# Install Hermes Agent
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Copy sync script
COPY scripts/sync_hermes.sh /usr/local/bin/sync_hermes.sh
RUN chmod +x /usr/local/bin/sync_hermes.sh

# Expose port for Webhooks/API (if enabled)
EXPOSE 8080

# Run sync before starting Hermes
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/sync_hermes.sh && hermes gateway run"]
