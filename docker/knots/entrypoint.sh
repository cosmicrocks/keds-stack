#!/bin/sh
# This script acts as an entrypoint for the bitcoind container.
# It retrieves RPC credentials from environment variables and passes them
# along with any other command-line arguments to the bitcoind executable.

set -e

# Use provided RPC user/password or fallback to defaults (though defaults shouldn't be needed if .env is set)
RPC_USER=${RPC_USER:-rpcuser}
RPC_PASSWORD=${RPC_PASSWORD:-rpcpassword}

echo "Starting bitcoind with RPC user: $RPC_USER"

# Prepend rpc user/password args and execute bitcoind, passing along any other arguments ("$@")
exec /usr/local/bin/bitcoind -rpcuser="$RPC_USER" -rpcpassword="$RPC_PASSWORD" "$@"