#!/bin/sh
set -e

# Create configuration directory
CONFIG_DIR="/data/config"
mkdir -p ${CONFIG_DIR}

# Define default values or ensure required variables are set
: "${DATUM_RPCUSER:=rpcuser}"
: "${DATUM_RPCPASSWORD:=rpcpassword}"
: "${DATUM_RPCURL:=knots:8332}"
: "${DATUM_WORK_UPDATE_SECONDS:=40}"
: "${DATUM_NOTIFY_FALLBACK:=true}"

: "${DATUM_LISTEN_PORT:=23334}"
: "${DATUM_MAX_CLIENTS_PER_THREAD:=128}"
: "${DATUM_MAX_THREADS:=8}"
: "${DATUM_MAX_CLIENTS:=1024}"
: "${DATUM_VARDIFF_MIN:=16384}"
: "${DATUM_VARDIFF_TARGET_SHARES_MIN:=8}"
: "${DATUM_VARDIFF_QUICKDIFF_COUNT:=8}"
: "${DATUM_VARDIFF_QUICKDIFF_DELTA:=8}"
: "${DATUM_SHARE_STALE_SECONDS:=120}"
: "${DATUM_FINGERPRINT_MINERS:=true}"
: "${DATUM_IDLE_TIMEOUT_NO_SUBSCRIBE:=15}"
: "${DATUM_IDLE_TIMEOUT_NO_SHARES:=7200}"
: "${DATUM_IDLE_TIMEOUT_MAX_LAST_WORK:=0}"

# Make pool address mandatory or provide a default if appropriate
: "${DATUM_POOL_ADDRESS:?DATUM_POOL_ADDRESS environment variable must be set}"
: "${DATUM_COINBASE_TAG_PRIMARY:=DATUM Gateway}"
: "${DATUM_COINBASE_TAG_SECONDARY:=Cosmic Rocks}"
: "${DATUM_COINBASE_UNIQUE_ID:=32359}"
: "${DATUM_SAVE_SUBMITBLOCKS_DIR:=}"

: "${DATUM_API_LISTEN_PORT:=8080}"
: "${DATUM_API_ADMIN_PASSWORD:=admin}"
# Expecting JSON array as string e.g. '["http://host1:port","http://host2:port"]'
: "${DATUM_EXTRA_BLOCK_SUBMISSIONS_URLS:="[]"}"

: "${DATUM_LOG_TO_CONSOLE:=true}"
: "${DATUM_LOG_TO_STDERR:=false}"
: "${DATUM_LOG_TO_FILE:=false}"
: "${DATUM_LOG_FILE:=}"
: "${DATUM_LOG_ROTATE_DAILY:=true}"
: "${DATUM_LOG_CALLING_FUNCTION:=true}"
: "${DATUM_LOG_LEVEL_CONSOLE:=2}"
: "${DATUM_LOG_LEVEL_FILE:=1}"

: "${DATUM_POOL_PASS_WORKERS:=true}"
: "${DATUM_POOL_PASS_FULL_USERS:=true}"
: "${DATUM_ALWAYS_PAY_SELF:=true}"
: "${DATUM_POOLED_MINING_ONLY:=false}"
: "${DATUM_PROTOCOL_GLOBAL_TIMEOUT:=60}"

: "${DATUM_POOL_HOST:="datum-beta1.mine.ocean.xyz"}"
: "${DATUM_POOL_PORT:=28915}"
: "${DATUM_POOL_PUBKEY:="f21f2f0ef0aa1970468f22bad9bb7f4535146f8e4a8f646bebc93da3d89b1406f40d032f09a417d94dc068055df654937922d2c89522e3e8f6f0e649de473003"}"

# Generate datum config file from environment variables
cat <<EOF > ${CONFIG_DIR}/config.json
{
  "bitcoind": {
      "rpcuser": "${DATUM_RPCUSER}",
      "rpcpassword": "${DATUM_RPCPASSWORD}",
      "rpcurl": "${DATUM_RPCURL}",
      "work_update_seconds": ${DATUM_WORK_UPDATE_SECONDS},
      "notify_fallback": ${DATUM_NOTIFY_FALLBACK}
  },
  "stratum": {
      "listen_port": ${DATUM_LISTEN_PORT},
      "max_clients_per_thread": ${DATUM_MAX_CLIENTS_PER_THREAD},
      "max_threads": ${DATUM_MAX_THREADS},
      "max_clients": ${DATUM_MAX_CLIENTS},
      "vardiff_min": ${DATUM_VARDIFF_MIN},
      "vardiff_target_shares_min": ${DATUM_VARDIFF_TARGET_SHARES_MIN},
      "vardiff_quickdiff_count": ${DATUM_VARDIFF_QUICKDIFF_COUNT},
      "vardiff_quickdiff_delta": ${DATUM_VARDIFF_QUICKDIFF_DELTA},
      "share_stale_seconds": ${DATUM_SHARE_STALE_SECONDS},
      "fingerprint_miners": ${DATUM_FINGERPRINT_MINERS},
      "idle_timeout_no_subscribe": ${DATUM_IDLE_TIMEOUT_NO_SUBSCRIBE},
      "idle_timeout_no_shares": ${DATUM_IDLE_TIMEOUT_NO_SHARES},
      "idle_timeout_max_last_work": ${DATUM_IDLE_TIMEOUT_MAX_LAST_WORK}
  },
  "mining": {
      "pool_address": "${DATUM_POOL_ADDRESS}",
      "coinbase_tag_primary": "${DATUM_COINBASE_TAG_PRIMARY}",
      "coinbase_tag_secondary": "${DATUM_COINBASE_TAG_SECONDARY}",
      "coinbase_unique_id": ${DATUM_COINBASE_UNIQUE_ID},
      "save_submitblocks_dir": "${DATUM_SAVE_SUBMITBLOCKS_DIR}"
  },
  "api": {
      "listen_port": ${DATUM_API_LISTEN_PORT},
      "admin_password": "${DATUM_API_ADMIN_PASSWORD}"
  },
  "extra_block_submissions": {
      "urls": ${DATUM_EXTRA_BLOCK_SUBMISSIONS_URLS}
  },
  "logger": {
      "log_to_console": ${DATUM_LOG_TO_CONSOLE},
      "log_to_stderr": ${DATUM_LOG_TO_STDERR},
      "log_to_file": ${DATUM_LOG_TO_FILE},
      "log_file": "${DATUM_LOG_FILE}",
      "log_rotate_daily": ${DATUM_LOG_ROTATE_DAILY},
      "log_calling_function": ${DATUM_LOG_CALLING_FUNCTION},
      "log_level_console": ${DATUM_LOG_LEVEL_CONSOLE},
      "log_level_file": ${DATUM_LOG_LEVEL_FILE}
  },
  "datum": {
      "pool_host": "${DATUM_POOL_HOST}",
      "pool_port": ${DATUM_POOL_PORT},
      "pool_pubkey": "${DATUM_POOL_PUBKEY}",
      "pool_pass_workers": ${DATUM_POOL_PASS_WORKERS},
      "pool_pass_full_users": ${DATUM_POOL_PASS_FULL_USERS},
      "always_pay_self": ${DATUM_ALWAYS_PAY_SELF},
      "pooled_mining_only": ${DATUM_POOLED_MINING_ONLY},
      "protocol_global_timeout": ${DATUM_PROTOCOL_GLOBAL_TIMEOUT}
  }
}
EOF

echo "Generated datum config:"
cat ${CONFIG_DIR}/config.json
echo "-------------------------"

# Execute the main datum command, passing the config file
# Replace 'datum' with the actual executable name if different
# Replace '--config' with the actual config file argument if different
exec /usr/bin/datum_gateway --config ${CONFIG_DIR}/config.json "$@"