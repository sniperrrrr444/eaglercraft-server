#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PORT=25565

command -v ss >/dev/null 2>&1 || { echo "Install iproute2: sudo apt install -y iproute2"; exit 1; }

HOST_IPS="$(hostname -I 2>/dev/null || true)"

if [[ -z "$HOST_IPS" ]]; then
  echo "No Linux environment IP was detected. Check that ChromeOS networking is working."
else
  echo "Linux environment IPs: $HOST_IPS"
fi

echo
echo "Checking TCP port $PORT..."
if ss -ltn "sport = :$PORT" | grep -q LISTEN; then
  echo "OK: a process is listening on TCP port $PORT."
else
  echo "WARNING: nothing is listening on TCP port $PORT. Run ./start.sh."
fi

echo
echo "REQUIRED CHROMEOS NETWORKING"
echo "1. Open Settings > Developers > Linux development environment."
echo "2. Open Port forwarding."
echo "3. Add TCP port 25565 when using LAN mode."
echo "4. Keep Linux running while testing."
echo "5. From another device, use the CHROMEBOOK IP + :25565."
echo
echo "Do not use localhost from another device."
echo "Do not treat the internal Crostini address as the Chromebook's public Internet address."
echo
echo "For Internet access, use the public HTTPS/WSS workflow or another secure publishing solution and configure the corresponding router/firewall rules."
