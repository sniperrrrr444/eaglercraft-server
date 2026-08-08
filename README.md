# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft para **Linux/Crostini de ChromeOS**. He revisado la configuración contra la documentación actual de EaglerXServer y he corregido el instalador para que no cree una configuración falsa.

## Instalación rápida

En Terminal de Linux:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre git curl python3

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

El instalador descarga:

- **Paper 1.12.2** desde la API oficial de PaperMC.
- La última release de **EaglerXServer** desde su repositorio oficial.

EaglerXServer requiere Java 17+ y su soporte Bukkit nativo está basado en Paper 1.12.2. citehttps://github.com/lax1dude/eaglerxserverturn3search0

### EULA

Después de instalar:

```bash
nano eula.txt
```

Pon `eula=true` solamente si aceptas el EULA aplicable. Después:

```bash
./start.sh
```

## Compatibilidad comprobada

La combinación elegida tiene sentido para Eaglercraft porque el propio proyecto EaglerXServer indica que su API Bukkit nativa usa **Paper 1.12.2** y que requiere **Java 17 o superior**. También indica soporte para clientes EaglercraftX 1.8, Eaglercraft 1.12.2 y, con EaglerXRewind, clientes 1.5.2. citehttps://github.com/lax1dude/eaglerxserverturn3search0

Paper recomienda Java 11 para Paper 1.12–1.16.4, pero EaglerXServer exige Java 17; por eso este proyecto prioriza el requisito de EaglerXServer y usa Java 17. citeturn0search1turn3search0

## Login: 60 segundos

El archivo `settings.cfg.example` contiene:

```yaml
eagler_login_timeout: 60000
eagler_players_view_distance: 6
```

EaglerXServer documenta `eagler_login_timeout` en milisegundos y su valor predeterminado es 10000 ms; `60000` lo aumenta a **60 segundos**. También documenta `eagler_players_view_distance` como una distancia independiente para jugadores Eaglercraft en Paper, con valores de 3 a 15 o `-1`. citeturn2view0

**Importante:** no copiamos automáticamente todo el ejemplo sobre el archivo generado por EaglerXServer. La versión instalada genera su propio `settings.cfg`; si quieres los 60 segundos, aplica esas dos claves a ese archivo después del primer arranque.

## Micrófono / voz

EaglerXServer incluye una API de voz y permite crear/gestionar canales de voz desde la API. citeturn3search0

Para usar voz desde Chrome:

1. El cliente Eaglercraft debe soportar voz.
2. Chrome debe tener permiso de micrófono.
3. En un servidor público, usa **HTTPS/WSS**.
4. El jugador debe aceptar el permiso del navegador.

El servidor no puede activar físicamente el micrófono del Chromebook: el navegador controla ese permiso.

## Plugins

### Base

- **EaglerXServer** — instalado automáticamente por `install.sh` desde su release oficial.

### Compatibilidad opcional

EaglerXServer indica que, para determinadas configuraciones de servidores Spigot/Paper, normalmente se necesitan **ViaVersion, ViaBackwards y ViaRewind** para compatibilidad con clientes 1.8; EaglerXRewind añade soporte para Eaglercraft 1.5.2. citeturn3search0

No los instalo automáticamente porque las versiones actuales de estos plugins no tienen por qué ser compatibles con Paper 1.12.2. ViaVersion sí requiere Java 17+, pero su versión adecuada debe seleccionarse para la plataforma antigua. citeturn0search8

### Utilidades opcionales

- LuckPerms — permisos.
- EssentialsX — comandos/utilidades.
- WorldEdit — construcción.
- EaglerMOTD — MOTD Eaglercraft.
- EaglerWeb — contenido web desde EaglerXServer.
- EaglerXPlan — estadísticas.

No recomiendo instalar todo en un Chromebook. Empieza con EaglerXServer y añade plugins uno por uno.

## Rendimiento Chromebook

Valores iniciales:

- RAM: `768M–1536M`.
- Render distance: `6`.
- Simulation distance: `4`.
- Máximo inicial: `10` jugadores.

EaglerXServer advierte que distancias grandes pueden provocar problemas en conexiones de poco ancho de banda. citeturn3search0

## Conexión

Averigua la IP del Chromebook:

```bash
hostname -I
```

EaglerXServer añade una capa de traducción para que las conexiones Eaglercraft puedan usar la misma dirección/puerto del servidor Java. citeturn3search0

Para voz y conexiones públicas, configura HTTPS/WSS y un reverse proxy adecuado. No abras el servidor directamente a Internet sin protección.

## Backups

```bash
./backup.sh
```

Los backups se guardan en `backups/`.

## Scripts

- `install.sh` — instala Paper + EaglerXServer oficial.
- `setup.sh` — comprueba el entorno y prepara carpetas.
- `start.sh` — arranca el servidor.
- `stop.sh` — ayuda a detener procesos lanzados con PID si los hubiera; para una sesión interactiva usa `stop` en la consola.
- `backup.sh` — crea una copia comprimida del mundo.

## Problemas

**Java no existe:** instala Java 17 no-headless:

```bash
sudo apt install -y openjdk-17-jre
```

Paper recomienda no utilizar las variantes `-headless` porque pueden carecer de dependencias necesarias. citeturn0search2

**Eaglercraft no conecta:** comprueba que `plugins/EaglerXServer.jar` exista, revisa `logs/latest.log` y comprueba el listener/configuración de EaglerXServer.

**El login es demasiado corto:** edita `plugins/EaglercraftXServer/settings.cfg` y establece `eagler_login_timeout: 60000`.

**El micrófono no funciona:** revisa el permiso de micrófono del sitio y usa HTTPS/WSS en un servidor público.

**Un plugin falla:** Paper 1.12.2 es una plataforma antigua. No instales automáticamente versiones modernas de plugins sin comprobar compatibilidad.

## Fuentes oficiales

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- Configuración EaglerXServer: https://raw.githubusercontent.com/lax1dude/eaglerxserver/main/CONFIG.md
- PaperMC: https://papermc.io/

## Nota sobre JARs

El repositorio no redistribuye JARs propios de Minecraft. `install.sh` descarga Paper desde PaperMC y EaglerXServer desde el repositorio oficial de EaglerXServer en el momento de la instalación.
