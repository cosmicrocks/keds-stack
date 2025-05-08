#!/bin/sh
set -e

# Define the path for the nodes configuration
NODE_CONFIG_DIR="/data/.specter/nodes"
SPECTRUM_NODE_CONFIG_FILE="$NODE_CONFIG_DIR/spectrum_node.json"
KNOTS_NODE_CONFIG_FILE="$NODE_CONFIG_DIR/knots_node.json"

# Create the nodes directory if it doesn't exist
mkdir -p "$NODE_CONFIG_DIR"

# Create the Spectrum node configuration file using runtime environment variables
# Use default values if environment variables are not set (should not happen with docker-compose)
cat <<EOF >"$SPECTRUM_NODE_CONFIG_FILE"
{
    "python_class": "cryptoadvance.specterext.spectrum.spectrum_node.SpectrumNode",
    "fullpath": "/data/.specter/nodes/spectrum_node.json",
    "name": "Spectrum Node",
    "alias": "spectrum_node",
    "host": "electrs",
    "port": 50001,
    "ssl": false
}
EOF

echo "Generated Specter Spectrum node config at $SPECTRUM_NODE_CONFIG_FILE"

# Create the Knots node configuration file
cat <<EOF > "$KNOTS_NODE_CONFIG_FILE"
{
  "python_class": "cryptoadvance.specter.node.Node",
  "fullpath": "$KNOTS_NODE_CONFIG_FILE",
  "name": "knots",
  "alias": "knots",
  "autodetect": false,
  "datadir": "",
  "user": "${RPC_USER:-rpcuser}",
  "password": "${RPC_PASSWORD:-rpcpassword}",
  "port": "8332",
  "host": "knots",
  "protocol": "http",
  "node_type": "BTC"
}
EOF

echo "Generated Specter Knots node config at $KNOTS_NODE_CONFIG_FILE"

# Execute the original command (passed as arguments to this script)
exec /usr/local/bin/python3 -m cryptoadvance.specter server --host 0.0.0.0 --port 25441