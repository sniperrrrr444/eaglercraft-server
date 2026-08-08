#!/bin/bash
set -e
cd "$(dirname "$0")/server"
if [ ! -f server.jar ]; then echo 'Falta server/server.jar. Ejecuta ./setup.sh y configura EaglercraftXServer.'; exit 1; fi
java -Xms768M -Xmx1536M -jar server.jar nogui
