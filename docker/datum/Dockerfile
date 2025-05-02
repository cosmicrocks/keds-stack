# Base image (adjust as needed for datum)
FROM debian:bookworm-slim AS base
RUN apt-get update -qqy && apt-get install -qqy --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# Placeholder for building/installing datum
# Replace this section with actual build/install steps for datum
WORKDIR /app
# Example: COPY . .
# Example: RUN make install

# If datum is a pre-built binary, copy it instead
# Example: COPY --from=some-builder /path/to/datum /usr/local/bin/datum

# Assume 'datum' binary is available at /usr/local/bin/datum
# Create a placeholder if it doesn't exist for testing/demonstration
RUN echo '#!/bin/sh\necho "Mock datum executing with config: $2"\necho "Args: $@"\n# Keep container running for inspection\nexec sleep infinity' > /usr/local/bin/datum && chmod +x /usr/local/bin/datum

# Copy and set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create data directory for config
RUN mkdir /data

WORKDIR /

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
# CMD ["--some-default-datum-arg"] # Optional: default arguments for datum