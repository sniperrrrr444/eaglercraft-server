#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

read -rp "Public WSS endpoint (e.g. wss://mc.example.com): " WSS
read -rp "Public HTTPS endpoint (e.g. https://mc.example.com): " HTTPS

[[ "$WSS" =~ ^wss:// ]] || { echo "ERROR: endpoint must start with wss://"; exit 1; }
[[ "$HTTPS" =~ ^https:// ]] || { echo "ERROR: endpoint must start with https://"; exit 1; }

cat > server-url.env <<EOF
SERVER_WSS_URL=$WSS
SERVER_HTTPS_URL=$HTTPS
EOF

chmod 600 server-url.env

echo
echo "URL updated."
echo "WSS:   $WSS"
echo "HTTPS: $HTTPS"
echo
echo "This file is the single source of truth for the public URL. Do not commit it if it contains private information."
