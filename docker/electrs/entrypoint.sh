#!/bin/sh
set -e

# Generate electrs config file from environment variables
cat <<EOF > /data/config
auth = "${BITCOIN_RPC_USER}:${BITCOIN_RPC_PASSWORD}"
network = "${ELECTRS_NETWORK}"
daemon_rpc_addr = "${ELECTRS_DAEMON_RPC_ADDR}"
daemon_p2p_addr = "${ELECTRS_DAEMON_P2P_ADDR}"
electrum_rpc_addr = "${ELECTRS_ELECTRUM_RPC_ADDR}"
server_banner = "${ELECTRS_SERVER_BANNER}"
index_batch_size = ${ELECTRS_INDEX_BATCH_SIZE}
wait_duration_secs = ${ELECTRS_WAIT_DURATION_SECS}
monitoring_addr = "${ELECTRS_MONITORING_ADDR}"
log_filters = "${ELECTRS_LOG_FILTERS}"
db_dir = "${ELECTRS_DB_DIR}"

# Any other config options can be added here

EOF

echo "Generated electrs config:"
cat /data/config
echo "-------------------------"

# Execute the main electrs command, passing the config file
exec electrs --conf /data/config "$@"