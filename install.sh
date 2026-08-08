#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
PAPER_VERSION="1.12.2"
EAGLER_REPO="lax1dude/eaglerxserver"
need_cmd(){ command -v "$1" >/dev/null 2>&1 || { echo "Falta '$1'."; exit 1; }; }
need_cmd curl
need_cmd java
need_cmd python3
JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
[[ -n "$JAVA_MAJOR" && "$JAVA_MAJOR" -ge 17 ]] || { echo "EaglerXServer requiere Java 17 o superior."; exit 1; }
mkdir -p plugins backups logs
if [[ ! -f paper.jar ]]; then
  PAPER_API="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds"
  BUILD="$(curl -fsSL "$PAPER_API" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["builds"][-1]["build"])')"
  PAPER_NAME="paper-${PAPER_VERSION}-${BUILD}.jar"
  echo "Descargando ${PAPER_NAME}..."
  curl -fL "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${BUILD}/downloads/${PAPER_NAME}" -o paper.jar
fi
if ! compgen -G "plugins/EaglerXServer*.jar" >/dev/null; then
  echo "Buscando la última release de EaglerXServer..."
  EAGLER_URL="$(curl -fsSL "https://api.github.com/repos/${EAGLER_REPO}/releases/latest" | python3 -c 'import json,sys; r=json.load(sys.stdin); a=r.get("assets",[]); m=[x for x in a if x.get("name","").lower().endswith(".jar") and "eaglerxserver" in x.get("name","").lower()]; print(m[0]["browser_download_url"] if m else "")')"
  [[ -n "$EAGLER_URL" ]] || { echo "No se encontró el JAR EaglerXServer en la última release."; exit 1; }
  curl -fL "$EAGLER_URL" -o plugins/EaglerXServer.jar
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
chmod +x *.sh 2>/dev/null || true
echo '=== INSTALACIÓN COMPLETADA ==='
echo 'Paper 1.12.2 + EaglerXServer oficial preparados.'
echo 'Revisa eula.txt, acepta el EULA si corresponde y ejecuta ./start.sh.'
echo 'EaglerXServer generará su configuración settings.cfg en el primer arranque.'
