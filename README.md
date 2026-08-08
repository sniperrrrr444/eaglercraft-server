# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft para **Linux/Crostini de ChromeOS**, preparado para instalarse con un único script.

## Instalación rápida

En Terminal de Linux:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless git curl python3

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x install.sh setup.sh start.sh stop.sh backup.sh
./install.sh
```

`install.sh` descarga automáticamente la última build disponible de **Paper 1.12.2** desde la API oficial de PaperMC y prepara el servidor. No guarda JARs de terceros dentro de GitHub.

Después:

```bash
nano eula.txt
```

Cambia `eula=false` a `eula=true` si aceptas el EULA aplicable y ejecuta:

```bash
./start.sh
```

## EaglercraftXServer

El componente que permite las conexiones Eaglercraft debe instalarse siguiendo el repositorio oficial de EaglerXServer. No recomiendo que el instalador descargue automáticamente un JAR de una URL fija de GitHub porque las builds pueden cambiar y queremos evitar instalar un binario incorrecto o desactualizado.

Repositorio oficial: https://github.com/lax1dude/eaglerxserver

Coloca el JAR compatible con Paper/Spigot en:

```text
plugins/
```

EaglerXServer requiere Java 17+ y ofrece soporte para Eaglercraft X 1.8, Eaglercraft 1.12.2 y 1.5.2 según su configuración/componentes.

## Login aumentado

La configuración del proyecto está preparada para un máximo de **60 segundos** de login:

```yaml
eagler_login_timeout: 60000
eagler_players_view_distance: 6
```

`60000` son 60.000 ms = 60 segundos.

## Micrófono / voz

EaglerXServer dispone de infraestructura de voz. El repositorio incluye `VOICE.md` con la configuración y requisitos.

Para que funcione en navegador:

1. El cliente Eaglercraft debe soportar voz.
2. Chrome debe tener permiso para usar el micrófono.
3. Para un servidor público, utiliza **HTTPS/WSS**.
4. El jugador debe aceptar el permiso de micrófono.

No se ha añadido un plugin genérico de voz de Minecraft porque no implica automáticamente compatibilidad con el sistema de voz de Eaglercraft.

## Plugins

### Recomendados para empezar

- EaglercraftXServer — necesario para Eaglercraft.
- LuckPerms — permisos.
- EssentialsX — comandos y utilidades.

### Opcionales

- ViaVersion
- ViaBackwards
- ViaRewind
- WorldEdit
- EaglerMOTD
- EaglerWeb
- EaglerXPlan

**No instales todos de golpe en un Chromebook.** Empieza con EaglercraftXServer + LuckPerms + EssentialsX y comprueba el rendimiento.

## Chromebook: rendimiento

Configuración inicial:

- RAM: `768M–1536M`.
- Render distance: `6`.
- Simulation distance: `4`.
- Máximo inicial: `10` jugadores.
- Pocos plugins.

Si el Chromebook tiene poca RAM, reduce `-Xmx1536M` en `start.sh`.

## Conexión local

Averigua la IP del Chromebook:

```bash
hostname -I
```

La conexión Eaglercraft utiliza el endpoint WebSocket configurado por EaglerXServer, normalmente con una dirección del tipo:

```text
ws://IP_DEL_SERVIDOR:PUERTO
```

Para Internet y micrófono, usa HTTPS/WSS y una configuración de proxy/reverse proxy apropiada. No expongas directamente el servidor sin protección.

## Administración

En la consola:

```text
list
say Hola
op TU_NOMBRE
whitelist on
whitelist add NOMBRE
stop
```

## Backups

```bash
./backup.sh
```

Las copias se guardan en `backups/`.

## Problemas

**Java no existe:**

```bash
sudo apt install -y openjdk-17-jre-headless
```

**El servidor va lento:** baja render distance, jugadores y plugins.

**El micrófono no aparece:** revisa permisos de Chrome y usa HTTPS/WSS en servidores públicos.

**Eaglercraft no conecta:** comprueba EaglerXServer, el puerto WebSocket y que el cliente sea compatible.

**Plugin incompatible:** Paper 1.12.2 es antiguo; usa versiones de plugins compatibles con esa plataforma.

## Fuentes oficiales

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- LuckPerms: https://luckperms.net/
- EssentialsX: https://essentialsx.net/

## Nota sobre los archivos JAR

Este repositorio contiene scripts y configuración, no redistribuye JARs de Minecraft/Eaglercraft ni plugins de terceros. El instalador descarga Paper desde la API oficial de PaperMC y deja la instalación de EaglerXServer bajo su fuente oficial/documentación para evitar distribuir binarios de terceros sin autorización.
