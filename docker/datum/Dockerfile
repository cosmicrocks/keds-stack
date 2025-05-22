FROM ubuntu AS base

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libjansson-dev \
    libmicrohttpd-dev \
    libsodium-dev \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

FROM base AS build

ARG DATUM_VERSION=main

RUN apt-get update && apt-get install -y \
    cmake \
    make \
    g++ \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the DATUM Gateway repository
# Consider using ARG for version control
RUN git clone --branch ${DATUM_VERSION} https://github.com/OCEAN-xyz/datum_gateway.git

# Build DATUM Gateway
RUN mkdir /datum_gateway/build
WORKDIR /datum_gateway/build
RUN cmake ..
RUN make -j$(nproc)

FROM base AS result

# Define user and data directory
ARG USER=datum
ARG DIR=/data

# Copy and set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy the binary
COPY --from=build /datum_gateway/build/datum_gateway /usr/bin/datum_gateway

# Create a non-root user
RUN adduser --disabled-password \
    --home "$DIR/" \
    --gecos "" \
    "$USER"

# Switch to non-root user
USER $USER

# Create data directory (owned by USER)
RUN mkdir -p "$DIR/"

# Expose volume containing datum data
VOLUME $DIR/

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
