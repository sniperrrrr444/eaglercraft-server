#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

[[ -f paper.jar ]] || { echo 'Falta paper.jar. Ejecuta ./install.sh primero.'; exit 1; }
[[ -x ./tunnel.sh ]] || { echo 'Falta tunnel.sh ejecutable.'; exit 1; }

cleanup() {
  ./tunnel.sh stop >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
  echo 'ERROR: el puerto 25565 ya está ocupado.'
  exit 1
fi

rm -f server-url.env

echo '=========================================='
echo ' EAGLERCRAFT SERVER'
echo '=========================================='
echo 'Iniciando Paper/EaglerXServer...'

java -Xms768M -Xmx1536M -XX:+UseG1GC -Djava.net.preferIPv4Stack=true -jar paper.jar nogui >server-console.log 2>&1 &
SERVER_PID=$!

ready=0
for _ in $(seq 1 60); do
  if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
    ready=1
    break
  fi
  if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo 'ERROR: Paper se cerró antes de abrir el puerto 25565.'
    tail -n 40 server-console.log || true
    exit 1
  fi
  sleep 1
done

if [[ "$ready" -ne 1 ]]; then
  echo 'ERROR: el servidor no abrió 25565 en 60 segundos.'
  tail -n 40 server-console.log || true
  kill "$SERVER_PID" 2>/dev/null || true
  exit 1
fi

echo 'Servidor escuchando en 25565.'
echo 'Iniciando túnel HTTPS/WSS...'
./tunnel.sh start

if [[ -f server-url.env ]]; then
  # shellcheck disable=SC1091
  source server-url.env
fi

echo
echo '=========================================='
echo ' SERVIDOR ONLINE'
echo '=========================================='
echo "HTTPS: ${SERVER_HTTPS_URL:-no disponible}"
echo "WSS:   ${SERVER_WSS_URL:-no disponible}"
echo
echo 'Comparte la URL HTTPS de entrada con tus jugadores.'
echo 'El WSS se usa como endpoint seguro del servidor.'
echo '=========================================='

tail --pid="$SERVER_PID" -f /dev/null & WAIT_PID=$!
wait "$SERVER_PID" || true
kill "$WAIT_PID" 2>/dev/null || true
