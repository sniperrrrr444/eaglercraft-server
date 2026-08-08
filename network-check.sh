#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PORT=25565

command -v ss >/dev/null 2>&1 || { echo "Instala iproute2: sudo apt install -y iproute2"; exit 1; }

HOST_IPS="$(hostname -I 2>/dev/null || true)"
CHROME_IP_HINT=""

if [[ -z "$HOST_IPS" ]]; then
  echo "No se detectó una IP dentro de Linux. Comprueba que ChromeOS tenga red."
else
  echo "IPs del entorno Linux: $HOST_IPS"
fi

echo
echo "Comprobando puerto TCP $PORT..."
if ss -ltn "sport = :$PORT" | grep -q LISTEN; then
  echo "OK: hay un proceso escuchando en TCP $PORT."
else
  echo "AVISO: nada está escuchando en TCP $PORT. Ejecuta ./start.sh."
fi

echo
echo "CONFIGURACIÓN NECESARIA EN CHROMEOS"
echo "1. Abre Configuración > Desarrolladores > Entorno de desarrollo de Linux."
echo "2. Abre Redirección de puertos/Port forwarding."
echo "3. Añade TCP 25565."
echo "4. Mantén Linux ejecutándose mientras haces la prueba."
echo "5. En el otro dispositivo usa la IP del CHROMEBOOK + :25565."
echo
echo "NO uses la IP 100.x/192.168.x interna de Crostini como dirección pública del Chromebook."
echo "ChromeOS documenta que el reenvío de puertos permite que otros dispositivos de la misma red accedan al servidor Linux usando la IP del dispositivo ChromeOS."
echo
echo "Si el servidor se va a usar desde Internet, además necesitarás una solución de publicación segura (por ejemplo, proxy/WSS o VPN) y la configuración correspondiente del router."
