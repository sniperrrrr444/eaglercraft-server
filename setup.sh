#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
mkdir -p plugins backups logs
if ! command -v java >/dev/null 2>&1; then echo "Java is not installed."; exit 1; fi
JAVA_MAJOR="$(java -version 2>&1 | awk -F '[\".]' '/version/ {print $2; exit}')"
[[ -n "$JAVA_MAJOR" && "$JAVA_MAJOR" -ge 17 ]] || { echo "EaglerXServer requires Java 17+."; exit 1; }
[[ -f paper.jar ]] || { echo "paper.jar is missing. Run ./install.sh first."; exit 1; }
[[ -f eula.txt ]] || echo 'eula=false' > eula.txt
chmod +x *.sh 2>/dev/null || true
echo 'Server prepared. Run ./start.sh.'
echo 'The actual EaglerXServer configuration is generated under the EaglerXServer plugin configuration directory.'
echo 'This script does not create undocumented YAML settings; use keys documented by the installed EaglerXServer version.'
