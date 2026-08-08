#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
mkdir -p plugins backups logs
if ! command -v java >/dev/null 2>&1; then
  echo "Java no está instalado. Ejecuta: sudo apt update && sudo apt install -y openjdk-17-jre-headless"
  exit 1
fi
JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
if [[ -z "${JAVA_MAJOR}" || "${JAVA_MAJOR}" -lt 17 ]]; then echo "Se necesita Java 17 o superior."; exit 1; fi
if [[ ! -f paper.jar ]]; then echo "Falta paper.jar. Descarga una build compatible con Paper 1.12.2 desde https://papermc.io/downloads/paper y guárdala como paper.jar."; exit 1; fi
[[ -f eula.txt ]] || echo 'eula=false' > eula.txt
[[ -f server.properties ]] || cp server.properties.example server.properties
chmod +x start.sh stop.sh backup.sh 2>/dev/null || true
echo "Servidor preparado. Coloca EaglercraftXServer compatible en plugins/ y ejecuta ./start.sh"
