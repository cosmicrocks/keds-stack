ARG ALPINE_BUILDER_VERSION=3.18

FROM alpine:3.20 AS verifier

ARG KNOTS_VERSION

WORKDIR /tmp

RUN KNOTS_MAJOR_VERSION=$(echo ${KNOTS_VERSION} | cut -c1-2) \
    && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/SHA256SUMS \
    && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/SHA256SUMS.asc \
    && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/bitcoin-${KNOTS_VERSION}.tar.gz

RUN apk add --no-cache \
    coreutils \
    curl \
    gnupg \
    gnupg-keyboxd \
    jq \
    && curl -s https://api.github.com/repos/bitcoinknots/guix.sigs/contents/builder-keys | jq -r '.[].download_url' | while read url; do curl -s "$url" | gpg --import; done \
    && gpg --verify SHA256SUMS.asc SHA256SUMS \
    && sha256sum --ignore-missing -c SHA256SUMS


FROM alpine:${ALPINE_BUILDER_VERSION} AS builder

ARG KNOTS_VERSION

WORKDIR /tmp

COPY --from=verifier /tmp/bitcoin-${KNOTS_VERSION}.tar.gz .

RUN apk add --no-cache \
    autoconf \
    automake \
    bash \
    build-base \
    curl \
    git \
    libtool \
    linux-headers \
    pkgconf \
    cmake

RUN tar zxf bitcoin-${KNOTS_VERSION}.tar.gz

RUN ./bitcoin-${KNOTS_VERSION}/autogen.sh

RUN make -C bitcoin-${KNOTS_VERSION}/depends -j$(nproc) NO_QT=1 NO_NATPMP=1 NO_UPNP=1 NO_USDT=1

ENV CFLAGS="-O2 --static -static -fPIC"
ENV CXXFLAGS="-O2 --static -static -fPIC"
ENV LDFLAGS="-s -static-libgcc -static-libstdc++"

RUN CONFIG_SITE=$(find /tmp/bitcoin-${KNOTS_VERSION}/depends | grep -E "config\.site$") \
    && mkdir build \
    && cd build \
    && ../bitcoin-${KNOTS_VERSION}/configure \
    CONFIG_SITE=${CONFIG_SITE} \
    --disable-bench \
    --disable-fuzz-binary \
    --disable-gui-tests \
    --disable-maintainer-mode \
    --disable-man \
    --disable-tests \
    --enable-lto \
    --with-daemon=yes \
    --with-gui=no \
    --with-libmultiprocess=no \
    --with-libs=no \
    --with-miniupnpc=no \
    --with-mpgen=no \
    --with-natpmp=no \
    --with-qrencode=no \
    --with-utils=yes

RUN make -C ./build -j$(nproc)

RUN make -C ./build install


FROM alpine:3.20 AS final

ARG KNOTS_VERSION
ARG USER=bitcoind
ARG DIR=/data

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /tmp/bitcoin-${KNOTS_VERSION}/test/functional/test_framework /opt/bitcoin/test/functional/test_framework
COPY --from=builder /tmp/bitcoin-${KNOTS_VERSION}/contrib/signet/miner           /opt/bitcoin/contrib/signet/miner
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache \
    python3 \
    tor \
    && ln -s /opt/bitcoin/contrib/signet/miner /usr/local/bin/miner

# $USER name, and data $DIR to be used in the `final` image
RUN adduser --disabled-password \
    --home "$DIR/" \
    --gecos "" \
    "$USER"

# Make entrypoint script executable (must be done before switching user)
RUN chmod +x /entrypoint.sh

USER $USER

# Prevents `VOLUME $DIR/.bitcoind/` being created as owned by `root`
RUN mkdir -p "$DIR/.bitcoin/"

# Expose volume containing all `bitcoind` data
VOLUME $DIR/.bitcoin/

# REST interface
EXPOSE 8080

# P2P network (mainnet, testnet, regtest & signet respectively)
EXPOSE 8333 18333 18444 38333

# RPC interface (mainnet, testnet, regtest & signet respectively)
EXPOSE 8332 18332 18443 38332

# ZMQ ports (for block hashes, raw blocks & raw transactions respectively)
EXPOSE 8443 28332 28333

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]