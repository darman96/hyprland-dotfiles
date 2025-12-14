FROM ghcr.io/oraios/serena:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends libicu-dev && \
    rm -rf /var/lib/apt/lists/*