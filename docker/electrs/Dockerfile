# Important: This file is provided for demonstration purposes and may NOT be suitable for production use.
# The maintainers of electrs are not deeply familiar with Docker, so you should DYOR.
# If you are not familiar with Docker either it's probably be safer to NOT use it.

FROM debian:bookworm-slim AS base
RUN apt-get update -qqy
RUN apt-get install -qqy librocksdb-dev curl git

### Electrum Rust Server ###
FROM base AS electrs-build
RUN apt-get install -qqy cargo clang cmake

# clone the electrs repository
RUN git clone https://github.com/romanz/electrs.git

# Install electrs
WORKDIR /electrs
ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib
RUN cargo install --locked --path .

FROM base AS result
# Copy the binaries
COPY --from=electrs-build /root/.cargo/bin/electrs /usr/bin/electrs

# Copy and set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]