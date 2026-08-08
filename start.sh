#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ -f paper.jar ]] || { echo 'Falta paper.jar. Colócalo en la raíz del repositorio.'; exit 1; }
exec java -Xms768M -Xmx1536M -XX:+UseG1GC -jar paper.jar nogui
