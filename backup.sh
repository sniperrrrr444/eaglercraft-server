#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p backups
STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
tar --exclude='./backups' --exclude='./logs' -czf "backups/world-$STAMP.tar.gz" world 2>/dev/null || { echo 'No existe todavía la carpeta world.'; exit 0; }
echo "Backup creado: backups/world-$STAMP.tar.gz"
