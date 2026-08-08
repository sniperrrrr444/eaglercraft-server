#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PORT="${EAGLER_LOCAL_PORT:-25565}"
BIN="$HOME/.local/bin/cloudflared"
mkdir -p "$(dirname "$BIN")"

if ! command -v cloudflared >/dev/null 2>&1 && [[ ! -x "$BIN" ]]; then
  echo "Instalando cloudflared..."
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" ;;
    aarch64|arm64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" ;;
    armv7l) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" ;;
    *) echo "Arquitectura no soportada: $ARCH"; exit 1 ;;
  esac
  curl -fL "$URL" -o "$BIN"
  chmod +x "$BIN"
fi

if command -v cloudflared >/dev/null 2>&1; then
  CF="$(command -v cloudflared)"
else
  CF="$BIN"
fi

echo "Esperando a que EaglerXServer escuche en $PORT..."
for i in {1..60}; do
  if (echo >/dev/tcp/127.0.0.1/$PORT) >/dev/null 2>&1; then break; fi
  sleep 1
done

if ! (echo >/dev/tcp/127.0.0.1/$PORT) >/dev/null 2>&1; then
  echo "No se pudo detectar el puerto $PORT."
  exit 1
fi

LOG="tunnel.log"
rm -f "$LOG"
"$CF" tunnel --url "http://127.0.0.1:$PORT" >"$LOG" 2>&1 &
TUNNEL_PID=$!
echo "$TUNNEL_PID" > .tunnel.pid

URL=""
for i in {1..30}; do
  URL="$(grep -Eo 'https://[-a-z0-9]+\.trycloudflare\.com' "$LOG" | head -n1 || true)"
  [[ -n "$URL" ]] && break
  sleep 1
done

if [[ -z "$URL" ]]; then
  echo "Não foi possível obter a URL do túnel. Veja tunnel.log."
  exit 1
fi

WSS_URL="${URL/https:/wss:}"
HTTPS_URL="$URL"
printf '%s\n' "SERVER_HTTPS_URL=$HTTPS_URL" "SERVER_WSS_URL=$WSS_URL" > server-url.env

cat > PLAYER-LINK.html <<EOF
<!doctype html><meta charset="utf-8"><title>Eaglercraft Server</title>
<h1>Eaglercraft Server</h1>
<p>HTTPS: <a href="$HTTPS_URL">$HTTPS_URL</a></p>
<p>WSS: <code>$WSS_URL</code></p>
<p>En el cliente Eaglercraft usa el endpoint WSS mostrado arriba.</p>
EOF

echo
echo "=========================================="
echo " EAGLERCRAFT — TÚNEL HTTPS/WSS ACTIVO"
echo "=========================================="
echo "HTTPS: $HTTPS_URL"
echo "WSS:   $WSS_URL"
echo
echo "Comparte el enlace HTTPS o configura el WSS en tu cliente Eaglercraft."
echo "PID del túnel: $TUNNEL_PID"
echo "=========================================="
echo
