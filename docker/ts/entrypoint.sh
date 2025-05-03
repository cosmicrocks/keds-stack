#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Check for required environment variables
if [ -z "$TS_AUTHKEY" ]; then
  echo "Error: TS_AUTHKEY environment variable is not set." >&2
  exit 1
fi

if [ -z "$TS_DOMAIN" ]; then
  echo "Error: TS_DOMAIN environment variable is not set." >&2
  exit 1
fi

if [ -z "$P2P_PORT" ]; then
  echo "Error: P2P_PORT environment variable is not set." >&2
  exit 1
fi

# Define the path for the temporary config file
CONFIG_FILE="/tmp/funnel.json"

# Construct the funnel configuration JSON and write it to the file
# Using printf for safer variable expansion
printf '{
  "TCP": {
    "%s": {}
  },
  "AllowFunnel": {
    "%s:%s": false
  }
}' "$P2P_PORT" "$TS_DOMAIN" "$P2P_PORT" > "$CONFIG_FILE"

# Export the path to the dynamically generated configuration file
export TS_SERVE_CONFIG="$CONFIG_FILE"

# Execute the original Tailscale containerboot command
# containerboot will pick up TS_AUTHKEY, TS_STATE_DIR, and the TS_SERVE_CONFIG path
exec /usr/local/bin/containerboot