#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ -f server.pid ]]; then kill "$(cat server.pid)" 2>/dev/null || true; rm -f server.pid; fi
echo "Si el servidor está en una terminal interactiva, usa 'stop' desde su consola."
