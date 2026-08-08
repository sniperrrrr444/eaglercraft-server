#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

[[ -f paper.jar ]] || { echo 'Falta paper.jar. Ejecuta ./install.sh primero.'; exit 1; }
[[ -x ./tunnel.sh ]] || { echo 'Falta tunnel.sh ejecutable.'; exit 1; }
[[ -f eula.txt ]] || { echo 'Falta eula.txt. Ejecuta ./install.sh primero.'; exit 1; }
grep -q '^eula=true' eula.txt || { echo 'Primero acepta el EULA aplicable editando eula.txt y poniendo eula=true.'; exit 1; }

SERVER_PID=""

cleanup() {
  trap - EXIT INT TERM
  echo
  echo 'Deteniendo túnel...'
  ./tunnel.sh stop >/dev/null 2>&1 || true
  if [[ -n "$SERVER_PID" ]] && kill -0 "$SERVER_PID" 2>/dev/null; then
    echo 'Deteniendo Paper...'
    kill "$SERVER_PID" 2>/dev/null || true
    for _ in {1..15}; do
      kill -0 "$SERVER_PID" 2>/dev/null || break
      sleep 1
    done
    kill -9 "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
  echo 'ERROR: el puerto 25565 ya está ocupado.'
  echo 'Detén la instancia anterior con ./stop.sh.'
  exit 1
fi

rm -f server-url.env

cat <<'EOF'
==========================================
 EAGLERCRAFT SERVER — PUBLIC HTTPS/WSS
==========================================
EOF

echo 'Iniciando Paper/EaglerXServer...'
java -Xms768M -Xmx1536M -XX:+UseG1GC -Djava.net.preferIPv4Stack=true -jar paper.jar nogui >server-console.log 2>&1 &
SERVER_PID=$!

ready=0
for _ in {1..60}; do
  if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
    ready=1
    break
  fi
  if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo 'ERROR: Paper se cerró antes de abrir 25565.'
    tail -n 60 server-console.log || true
    exit 1
  fi
  sleep 1
done

if [[ "$ready" -ne 1 ]]; then
  echo 'ERROR: Paper no abrió 25565 en 60 segundos.'
  tail -n 60 server-console.log || true
  exit 1
fi

echo 'Paper está escuchando en 25565.'
echo 'Iniciando Cloudflare Quick Tunnel...'
if ! ./tunnel.sh start; then
  echo 'ERROR: no se pudo crear el túnel HTTPS/WSS.'
  exit 1
fi

if [[ -f server-url.env ]]; then
  # shellcheck disable=SC1091
  source server-url.env
fi

[[ -n "${SERVER_WSS_URL:-}" ]] || { echo 'ERROR: el túnel no generó SERVER_WSS_URL.'; exit 1; }

cat <<EOF

==========================================
 SERVIDOR ONLINE
==========================================
HTTPS: ${SERVER_HTTPS_URL:-no disponible}
WSS:   ${SERVER_WSS_URL}

Usa el WSS como endpoint en un cliente Eaglercraft compatible.
La URL de Quick Tunnel es temporal y puede cambiar al reiniciar.
==========================================
EOF

echo 'El servidor permanecerá activo. Pulsa Ctrl+C para detener Paper y el túnel.'
wait "$SERVER_PID"
