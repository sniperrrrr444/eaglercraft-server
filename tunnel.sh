#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PORT="${EAGLER_LOCAL_PORT:-25565}"
BIN="$HOME/.local/bin/cloudflared"
PID_FILE=".tunnel.pid"
LOG="tunnel.log"
mkdir -p "$(dirname "$BIN")"

get_cf() {
  if command -v cloudflared >/dev/null 2>&1; then
    command -v cloudflared
    return
  fi
  [[ -x "$BIN" ]] || {
    echo "Instalando cloudflared..."
    ARCH="$(uname -m)"
    case "$ARCH" in
      x86_64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" ;;
      aarch64|arm64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" ;;
      armv7l) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" ;;
      *) echo "Arquitectura no soportada: $ARCH"; return 1 ;;
    esac
    command -v curl >/dev/null 2>&1 || { echo 'Falta curl. Instálalo con sudo apt install curl.'; return 1; }
    curl -fL "$URL" -o "$BIN"
    chmod +x "$BIN"
  }
  echo "$BIN"
}

stop_tunnel() {
  if [[ -f "$PID_FILE" ]]; then
    PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [[ "$PID" =~ ^[0-9]+$ ]] && kill -0 "$PID" 2>/dev/null; then
      kill "$PID" 2>/dev/null || true
      for _ in {1..10}; do
        kill -0 "$PID" 2>/dev/null || break
        sleep 0.2
      done
      kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f "$PID_FILE"
  fi
  rm -f server-url.env PLAYER-LINK.html
}

case "${1:-start}" in
  stop)
    stop_tunnel
    echo 'Túnel HTTPS/WSS detenido.'
    exit 0
    ;;
  start)
    stop_tunnel
    ;;
  *)
    echo "Uso: $0 {start|stop}"
    exit 2
    ;;
esac

CF="$(get_cf)"
echo "Esperando a que EaglerXServer escuche en 127.0.0.1:$PORT..."
for _ in {1..60}; do
  if (echo >/dev/tcp/127.0.0.1/$PORT) >/dev/null 2>&1; then break; fi
  sleep 1
done
if ! (echo >/dev/tcp/127.0.0.1/$PORT) >/dev/null 2>&1; then
  echo "No se pudo detectar el puerto $PORT."
  exit 1
fi

rm -f "$LOG"
"$CF" tunnel --url "http://127.0.0.1:$PORT" >"$LOG" 2>&1 &
TUNNEL_PID=$!
echo "$TUNNEL_PID" > "$PID_FILE"

URL=""
for _ in {1..30}; do
  URL="$(grep -Eo 'https://[-a-z0-9]+\.trycloudflare\.com' "$LOG" | head -n1 || true)"
  [[ -n "$URL" ]] && break
  if ! kill -0 "$TUNNEL_PID" 2>/dev/null; then break; fi
  sleep 1
done

if [[ -z "$URL" ]]; then
  echo "No se pudo obtener la URL del túnel. Revisa tunnel.log."
  stop_tunnel
  exit 1
fi

WSS_URL="${URL/https:/wss:}"
printf '%s\n' "SERVER_HTTPS_URL=$URL" "SERVER_WSS_URL=$WSS_URL" > server-url.env

cat > PLAYER-LINK.html <<EOF
<!doctype html><meta charset="utf-8"><title>Eaglercraft Server</title>
<h1>Eaglercraft Server</h1>
<p>Endpoint seguro WSS:</p><p><code>$WSS_URL</code></p>
<p>Este enlace es el endpoint del servidor; necesitas un cliente Eaglercraft compatible para conectarte.</p>
EOF

echo
echo '=========================================='
echo ' EAGLERCRAFT — HTTPS/WSS ACTIVO'
echo '=========================================='
echo "HTTPS: $URL"
echo "WSS:   $WSS_URL"
echo "PID:   $TUNNEL_PID"
echo '=========================================='
