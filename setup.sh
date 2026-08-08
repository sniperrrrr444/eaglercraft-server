#!/bin/bash
set -e
mkdir -p server
cd server
command -v java >/dev/null || { echo 'Instala Java 17+ primero.'; exit 1; }
# TODO: descargar aquí una versión compatible de Paper y EaglercraftXServer desde sus fuentes oficiales.
echo 'Preparación completada. Añade los binarios/configuración de EaglercraftXServer antes de arrancar.'
