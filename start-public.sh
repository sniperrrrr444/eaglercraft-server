#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

[[ -f paper.jar ]] || { echo 'Falta paper.jar. Ejecuta ./install.sh primero.'; exit 1; }

cleanup() {
  [[ -x ./tunnel.sh ]] && ./tunnel.sh stop >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
  echo 'ERROR: el puerto 25565 ya está ocupado.'
  exit 1
fi

if [[ -x ./tunnel.sh ]]; then
  echo 'Iniciando túnel HTTPS/WSS...'
  ./tunnel.sh start || echo 'No se pudo iniciar el túnel; se continúa en LAN.'
fi

[[ -f server-url.env ]] && source server-url.env || true

echo
echo '=========================================='
echo ' EAGLERCRAFT SERVER ONLINE'
echo '=========================================='
[[ -n "${SERVER_HTTPS_URL:-}" ]] && echo "HTTPS: ${SERVER_HTTPS_URL}"
[[ -n "${SERVER_WSS_URL:-}" ]] && echo "WSS:   ${SERVER_WSS_URL}"
echo '=========================================='

exec java -Xms768M -Xmx1536M -XX:+UseG1GC -Djava.net.preferIPv4Stack=true -jar paper.jar nogui
