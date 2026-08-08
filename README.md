# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft pensado para ejecutarse en **Linux (Crostini) de ChromeOS**.

La base recomendada es **Paper 1.12.2 + EaglercraftXServer**. EaglerXServer soporta EaglercraftX 1.8, Eaglercraft 1.12.2 y Eaglercraft 1.5.2, y requiere Java 17 o superior. También dispone de infraestructura/API de voz. urlEaglerXServer oficialhttps://github.com/lax1dude/eaglerxserver

> **Importante:** el repositorio contiene scripts y configuración, pero no redistribuye JARs de Minecraft/Eaglercraft ni plugins de terceros. Esto evita meter binarios no autorizados en GitHub.

## Qué incluye

- Paper 1.12.2 como servidor backend.
- Preparación de EaglercraftXServer.
- Login de EaglerXServer aumentado a **60 segundos** (`60000 ms`). El valor por defecto del proyecto oficial es 10 segundos. citeturn3view0
- Vista Eaglercraft independiente de **6 chunks** para ahorrar recursos.
- Compatibilidad de protocolos configurada para Eaglercraft.
- `setup.sh`, `start.sh`, `stop.sh` y `backup.sh`.
- Configuración de plugins.
- Documentación de voz/micrófono en `VOICE.md`.
- Plantilla `eaglerxserver-settings.yml.example`.
- Backups del mundo.
- Configuración optimizada para Chromebook.

## 1. Preparar Linux en Chromebook

Activa **Entorno de desarrollo de Linux** en ChromeOS y abre Terminal.

Instala las herramientas:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless git curl wget unzip
```

Comprueba:

```bash
java -version
git --version
```

Debe aparecer Java 17 o superior.

## 2. Instalar el servidor

```bash
git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x setup.sh start.sh stop.sh backup.sh
./setup.sh
```

El instalador prepara las carpetas y crea la configuración recomendada.

Después coloca el **JAR oficial de EaglercraftXServer compatible con Paper 1.12.2** dentro de:

```text
plugins/
```

EaglerXServer indica que puede instalarse como un único JAR en Spigot/Paper y que Java 17+ es obligatorio. citeturn0search0

## 3. Paper

Descarga una build compatible de Paper 1.12.2 desde su fuente oficial y guárdala como:

```text
paper.jar
```

No subas `paper.jar` a GitHub.

## 4. Primer arranque

```bash
./start.sh
```

En el primer arranque Paper generará `eula.txt`. Si aceptas el EULA, cambia:

```text
eula=false
```

a:

```text
eula=true
```

y vuelve a ejecutar:

```bash
./start.sh
```

## 5. Configuración EaglerXServer

La plantilla está en:

```text
eaglerxserver-settings.yml.example
```

Y `setup.sh` prepara:

```text
plugins/EaglercraftXServer/settings.yml
```

Ajustes principales:

```yaml
eagler_login_timeout: 60000
eagler_players_view_distance: 6
enable_authentication_events: true
http_websocket_compression_level: 6
```

`eagler_login_timeout` está expresado en milisegundos: `60000 = 60 segundos`. EaglerXServer documenta este parámetro como el tiempo máximo que una conexión puede permanecer en fase de login. citeturn3view0

## 6. Plugins recomendados

### Obligatorio

**EaglercraftXServer** — puente/capa principal para que clientes Eaglercraft puedan conectarse al backend Paper.

### Recomendados

- **ViaVersion** — compatibilidad adicional de versiones cuando sea necesaria.
- **ViaBackwards** — junto a ViaVersion cuando se necesiten clientes antiguos.
- **ViaRewind** — útil para compatibilidad legacy; EaglerXServer también dispone de EaglerXRewind para Eaglercraft 1.5.2.
- **LuckPerms** — permisos.
- **EssentialsX** — comandos y utilidades.
- **WorldEdit** — administración/construcción del mundo.
- **EaglerMOTD** — MOTD específico para Eaglercraft.
- **EaglerWeb** — alojamiento web desde el servidor EaglerXServer.
- **EaglerXPlan** — estadísticas/analítica de jugadores.

EaglerXServer recomienda ViaVersion, ViaBackwards y ViaRewind en determinadas configuraciones y ofrece oficialmente EaglerXRewind, EaglerMOTD, EaglerWeb y EaglerXPlan. citeturn0search0

**No instales todos a la vez en un Chromebook.** Para empezar recomiendo solamente:

```text
EaglercraftXServer
LuckPerms
EssentialsX
```

Y añadir el resto cuando el servidor funcione correctamente.

## 7. Micrófono / chat de voz

El servidor incluye una guía específica en:

```text
VOICE.md
```

EaglerXServer tiene sistema/API de canales de voz (`IVoiceService`, `IVoiceManager` y canales de voz). citeturn13file0turn13file8

Para que el navegador pueda usar el micrófono:

1. El cliente Eaglercraft debe ser compatible con voz.
2. Chrome debe tener permiso para el micrófono.
3. Para un servidor público, utiliza **HTTPS/WSS**.
4. El jugador debe aceptar el permiso de micrófono cuando Chrome lo solicite.

No recomiendo meter un plugin de voz de Minecraft genérico y asumir que será compatible con Eaglercraft. La voz de Eaglercraft debe utilizar la infraestructura de EaglerXServer/cliente.

## 8. Conexión

En una red local puedes empezar con:

```text
ws://IP_DEL_CHROMEBOOK:PUERTO
```

Averigua la IP con:

```bash
hostname -I
```

Para voz desde Internet y una experiencia correcta en navegador, configura HTTPS/WSS mediante un dominio y un reverse proxy.

## 9. Rendimiento para Chromebook

Valores iniciales recomendados:

- RAM: `768M–1536M`.
- Render distance: `6`.
- Simulation distance: `4`.
- Máximo inicial: `10` jugadores.
- Pocos plugins.
- Evita granjas enormes de mobs/redstone.

EaglerXServer advierte que distancias de renderizado grandes pueden provocar problemas en conexiones de bajo ancho de banda. citeturn0search0

## 10. Backups

Antes de actualizar o modificar el mundo:

```bash
./backup.sh
```

Los backups se guardan en:

```text
backups/
```

## 11. Administración

Desde la consola:

```text
list
say Hola
op TU_NOMBRE
whitelist on
whitelist add NOMBRE
stop
```

## 12. Problemas habituales

### Java no existe

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless
```

### Login demasiado rápido

Comprueba que EaglerXServer esté usando:

```yaml
eagler_login_timeout: 60000
```

### El micrófono no aparece

Comprueba el permiso de micrófono de Chrome y utiliza HTTPS/WSS para servidores públicos. Consulta `VOICE.md`.

### Eaglercraft da `End of stream`

Reduce `view-distance` y `eagler_players_view_distance`. EaglerXServer recomienda reducir la distancia cuando hay conexiones de poco ancho de banda. citeturn0search0

### Un plugin falla

Comprueba su versión de Minecraft/Paper y Java. No todos los plugins actuales funcionan con Paper 1.12.2.

## 13. Seguridad

- Activa whitelist si es privado.
- No des OP a cualquiera.
- Haz backups.
- No ejecutes JARs desconocidos.
- Descarga plugins de sus fuentes oficiales.
- No expongas directamente el servidor a Internet sin protección.
- Para voz pública usa HTTPS/WSS.

## Estructura

```text
.
├── README.md
├── VOICE.md
├── eaglerxserver-settings.yml.example
├── setup.sh
├── start.sh
├── stop.sh
├── backup.sh
├── server.properties
├── plugins/
│   └── EaglercraftXServer/
│       └── settings.yml
├── world/
├── backups/
└── logs/
```

## Fuentes

- urlEaglercraftXServerhttps://github.com/lax1dude/eaglerxserver
- urlDocumentación de configuración de EaglerXServerhttps://raw.githubusercontent.com/lax1dude/eaglerxserver/main/CONFIG.md
- urlPaperMChttps://papermc.io/
- urlLuckPermshttps://luckperms.net/
- urlEssentialsXhttps://essentialsx.net/

## Licencia y distribución

Este repositorio proporciona automatización, configuración y documentación. No incluye ni redistribuye archivos de Minecraft o JARs de terceros que no estén autorizados para redistribución.