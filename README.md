# Eaglercraft Server — Linux Chromebook

Servidor Eaglercraft para ejecutarse en el entorno Linux de un Chromebook.

## Objetivo

Preparar un servidor basado en Paper 1.12.2 + EaglercraftXServer, con scripts sencillos para instalar y arrancar el servidor.

## Instalación

```bash
git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x setup.sh start.sh
./setup.sh
```

Después:

```bash
./start.sh
```

## Estructura

```text
README.md
setup.sh
start.sh
server.properties
.gitignore
```

## Nota

El repositorio no incluye binarios de Minecraft ni Eaglercraft. Los scripts deben obtener las dependencias desde sus fuentes correspondientes.

Para un Chromebook con recursos limitados, empieza con 768–1536 MB de RAM y una distancia de renderizado de 6.
