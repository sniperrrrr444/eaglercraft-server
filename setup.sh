#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

mkdir -p plugins/EaglercraftXServer backups logs

if ! command -v java >/dev/null 2>&1; then
  echo "Java no está instalado. Ejecuta: sudo apt update && sudo apt install -y openjdk-17-jre-headless"
  exit 1
fi

JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
if [[ -z "${JAVA_MAJOR}" || "${JAVA_MAJOR}" -lt 17 ]]; then
  echo "Se necesita Java 17 o superior."
  exit 1
fi

if [[ ! -f paper.jar ]]; then
  echo "Falta paper.jar. Descarga una build compatible con Paper 1.12.2 desde https://papermc.io/downloads/paper y guárdala como paper.jar."
  exit 1
fi

[[ -f eula.txt ]] || echo 'eula=false' > eula.txt

cat > plugins/EaglercraftXServer/settings.yml.example <<'EOF'
# Configuración recomendada para Chromebook/Linux.
# Copia este archivo como settings.yml dentro de plugins/EaglercraftXServer/
# si tu build de EaglerXServer utiliza YAML en Bukkit/Paper.
server_name: "Eaglercraft Chromebook Server"
eagler_login_timeout: 60000
eagler_players_view_distance: 6
enable_authentication_events: true
http_websocket_compression_level: 6
http_websocket_ping_intervention: false
protocols:
  min_minecraft_protocol: 3
  max_minecraft_protocol: 340
  max_minecraft_protocol_v5: -1
  protocol_legacy_allowed: true
  protocol_v3_allowed: true
  protocol_v4_allowed: true
  protocol_v5_allowed: true
  eaglerxrewind_allowed: true
EOF

if [[ ! -f plugins/EaglercraftXServer/settings.yml ]]; then
  cp plugins/EaglercraftXServer/settings.yml.example plugins/EaglercraftXServer/settings.yml
fi

chmod +x start.sh stop.sh backup.sh 2>/dev/null || true

echo "Servidor preparado."
echo "- Login de EaglerXServer: 60 segundos"
echo "- Vista Eaglercraft: 6 chunks"
echo "- Compatibilidad de protocolos preparada"
echo "- Soporte de voz de EaglerXServer documentado en VOICE.md"
echo "Coloca el JAR oficial de EaglerXServer en plugins/ y ejecuta ./start.sh"
