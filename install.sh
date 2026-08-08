#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

# Instalador para Linux/Crostini. No descarga ni redistribuye software propietario.
# Descarga Paper y plugins desde sus endpoints oficiales/configurados.

PAPER_VERSION="1.12.2"
PAPER_URL="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Falta $1"; exit 1; }; }
need_cmd curl
need_cmd java
need_cmd python3

JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
[[ -n "$JAVA_MAJOR" && "$JAVA_MAJOR" -ge 17 ]] || { echo "Necesitas Java 17 o superior."; exit 1; }

mkdir -p plugins backups logs

# Descarga la build más reciente de Paper 1.12.2 mediante la API oficial de PaperMC.
if [[ ! -f paper.jar ]]; then
  BUILD="$(curl -fsSL "$PAPER_URL" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["builds"][-1]["build"])')"
  PAPER_NAME="paper-${PAPER_VERSION}-${BUILD}.jar"
  echo "Descargando Paper ${PAPER_VERSION} build ${BUILD}..."
  curl -fL "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${BUILD}/downloads/${PAPER_NAME}" -o paper.jar
fi

[[ -f eula.txt ]] || printf '%s\n' 'eula=false' > eula.txt

if [[ ! -f server.properties ]]; then
cat > server.properties <<'EOF'
motd=§bEaglercraft §f| §aChromebook Server
server-port=25565
online-mode=false
max-players=10
view-distance=6
simulation-distance=4
spawn-protection=16
white-list=true
enable-command-block=false
network-compression-threshold=256
EOF
fi

cat > SERVER-INSTALL.md <<'EOF'
# Instalación automática

Ejecuta `./install.sh` desde Linux/Crostini.

El script instala Paper 1.12.2 desde la API oficial de PaperMC y prepara el servidor. Los componentes EaglercraftXServer y voz deben descargarse siguiendo sus instrucciones oficiales porque sus artefactos/configuración pueden cambiar entre versiones.

Después:
1. Revisa `eula.txt`.
2. Pon `eula=true` si aceptas el EULA aplicable.
3. Añade el componente EaglercraftXServer compatible a `plugins/` siguiendo su documentación oficial.
4. Ejecuta `./start.sh`.

No ejecutes JARs descargados de fuentes desconocidas.
EOF

chmod +x *.sh 2>/dev/null || true

echo
 echo '=== INSTALACIÓN PREPARADA ==='
echo 'Paper 1.12.2 instalado en paper.jar.'
echo 'Ahora revisa eula.txt y ejecuta ./start.sh.'
echo 'EaglercraftXServer debe instalarse según su documentación oficial.'
