#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

[[ -f paper.jar ]] || { echo 'Falta paper.jar. Ejecuta ./install.sh primero.'; exit 1; }

# ChromeOS/Crostini: muestra las direcciones disponibles para facilitar las pruebas.
echo "=========================================="
echo " Eaglercraft Server - inicio de red"
echo "=========================================="
echo "Puerto del servidor: 25565/TCP"
echo
if command -v hostname >/dev/null 2>&1; then
  echo "IP(s) del entorno Linux:"
  hostname -I 2>/dev/null || true
fi

echo
echo "IMPORTANTE para otros dispositivos:"
echo "- Usa la IP del Chromebook (ChromeOS), NO la IP interna de Crostini."
echo "- En ChromeOS configura Redirección de puertos para TCP 25565."
echo "- Los otros dispositivos deben estar en la misma red si es un servidor LAN."
echo "- No necesitas abrir el puerto del router para jugar solo dentro de tu LAN."
echo

# Evita que una instancia anterior cause un error de puerto ocupado.
if command -v ss >/dev/null 2>&1 && ss -ltn '( sport = :25565 )' | grep -q ':25565'; then
  echo "ERROR: el puerto 25565 ya está ocupado."
  echo "Detén la instancia anterior con ./stop.sh o con 'stop' en su consola."
  exit 1
fi

exec java -Xms768M -Xmx1536M -XX:+UseG1GC -Djava.net.preferIPv4Stack=true -jar paper.jar nogui
