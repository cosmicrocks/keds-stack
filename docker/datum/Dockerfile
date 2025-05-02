FROM ubuntu as base

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
RUN apt-get update && apt-get install -y \
    cmake \
    make \
    g++ \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the DATUM Gateway repository
# Consider using ARG for version control
RUN git clone https://github.com/OCEAN-xyz/datum_gateway.git

# Build DATUM Gateway
RUN mkdir /datum_gateway/build
WORKDIR /datum_gateway/build
RUN cmake ..
RUN make -j$(nproc)

FROM base AS result

# Copy and set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy the binary
COPY --from=build /datum_gateway/build/datum_gateway /usr/bin/datum_gateway

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
