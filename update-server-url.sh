#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

read -rp "WSS público (ej. wss://mc.example.com): " WSS
read -rp "HTTPS público (ej. https://mc.example.com): " HTTPS

[[ "$WSS" =~ ^wss:// ]] || { echo "ERROR: el endpoint debe empezar por wss://"; exit 1; }
[[ "$HTTPS" =~ ^https:// ]] || { echo "ERROR: la página debe empezar por https://"; exit 1; }

cat > server-url.env <<EOF
SERVER_WSS_URL=$WSS
SERVER_HTTPS_URL=$HTTPS
EOF

chmod 600 server-url.env

echo
 echo "URL actualizada."
echo "WSS:   $WSS"
echo "HTTPS: $HTTPS"
echo
 echo "Este archivo se usa como fuente única de URL. No lo subas a GitHub si contiene datos privados."
