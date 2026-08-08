#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
mkdir -p plugins backups logs
if ! command -v java >/dev/null 2>&1; then echo "Java no está instalado."; exit 1; fi
JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
[[ -n "$JAVA_MAJOR" && "$JAVA_MAJOR" -ge 17 ]] || { echo "EaglerXServer requiere Java 17+."; exit 1; }
[[ -f paper.jar ]] || { echo "Falta paper.jar. Ejecuta ./install.sh primero."; exit 1; }
[[ -f eula.txt ]] || echo 'eula=false' > eula.txt
chmod +x *.sh 2>/dev/null || true
echo 'Servidor preparado. Ejecuta ./start.sh.'
echo 'La configuración real de EaglerXServer se genera como plugins/EaglercraftXServer/settings.cfg.'
echo 'No se crea una configuración YAML inventada: se usan las claves documentadas por EaglerXServer.'
