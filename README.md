# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft pensado para ejecutarse en **Linux (Crostini) de ChromeOS**.

> **Importante:** el repositorio contiene scripts y configuración, no redistribuye los archivos propietarios de Minecraft. La instalación descarga las dependencias desde sus proyectos oficiales cuando sea posible.

## Qué tendrás

- Paper 1.12.2 como base del servidor.
- EaglercraftXServer para permitir conexiones de clientes Eaglercraft.
- Configuración optimizada para un Chromebook con recursos limitados.
- Scripts `setup.sh`, `start.sh` y `stop.sh`.
- Copias de seguridad del mundo.
- Configuración de plugins.
- Mensaje MOTD y ajustes básicos.
- Guía de problemas habituales de Linux/ChromeOS.

## 1. Preparar Linux en Chromebook

En ChromeOS activa **Entorno de desarrollo de Linux** y abre la aplicación Terminal.

Comprueba que Java y Git funcionan:

```bash
java -version
git --version
```

Si no tienes Java 17:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless git curl wget unzip
```

Comprueba Java:

```bash
java -version
```

Debe mostrar Java 17 o superior.

## 2. Descargar el servidor

```bash
git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x setup.sh start.sh stop.sh backup.sh
./setup.sh
```

El instalador crea la estructura necesaria y descarga las dependencias configuradas.

## 3. Primer arranque

```bash
./start.sh
```

En el primer arranque Paper puede generar el `eula.txt`. Si aceptas el EULA, cambia:

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

## 4. Plugins

La carpeta de plugins es:

```text
plugins/
```

### Plugins recomendados

**EaglercraftXServer** — componente principal para compatibilidad Eaglercraft. Debe proceder de su repositorio oficial y ser compatible con la versión de Paper utilizada.

**ViaVersion** — útil si quieres aceptar clientes de versiones diferentes, aunque no es necesario para un servidor Eaglercraft básico.

**LuckPerms** — permisos y grupos de jugadores.

**EssentialsX** — comandos básicos como `/spawn`, `/home`, `/tp`, etc. Comprueba siempre la compatibilidad con Paper 1.12.2 antes de instalar una versión.

**WorldEdit** — construcción y administración de mapas. Es opcional y consume más recursos.

No instales plugins al azar: un plugin moderno puede requerir una versión de Minecraft/Paper que no sea compatible con 1.12.2.

## 5. Conectarse desde Eaglercraft

Si el servidor Eaglercraft utiliza WebSockets, la dirección dependerá de la configuración del puente WebSocket de EaglercraftXServer.

Ejemplo conceptual:

```text
ws://IP_DEL_SERVIDOR:PUERTO
```

Para conexiones desde otro dispositivo de tu red local, primero averigua la IP del Chromebook/servidor:

```bash
hostname -I
```

**No abras puertos a Internet sin entender las implicaciones de seguridad.** Para jugar con amigos desde fuera de casa es preferible utilizar una solución de red segura en lugar de exponer directamente el servidor.

## 6. Comandos de administración

Desde la consola del servidor:

```text
stop
list
say Hola
op TU_NOMBRE
whitelist on
whitelist add NOMBRE
```

Desde un jugador con permisos:

```text
/plugins
```

## 7. Copias de seguridad

Antes de actualizar plugins o tocar el mundo:

```bash
./backup.sh
```

Las copias se guardan en `backups/`.

## 8. Detener el servidor

```bash
./stop.sh
```

Si el servidor está ejecutándose en una terminal, también puedes usar `stop` desde la consola del servidor.

## 9. Configuración recomendada para Chromebook

Empieza con:

- RAM: `768M–1536M`.
- Render distance: `6`.
- Simulation distance: `4`.
- Pocos plugins.
- Evita granjas gigantes de mobs/redstone.
- No ejecutes el servidor con toda la RAM del contenedor Linux.

Ejemplo de arranque:

```bash
java -Xms768M -Xmx1536M -jar paper.jar nogui
```

Si tu Chromebook tiene poca RAM, baja `-Xmx`.

## 10. Estructura

```text
.
├── README.md
├── setup.sh
├── start.sh
├── stop.sh
├── backup.sh
├── server.properties
├── eula.txt
├── paper.yml
├── plugins/
├── world/
├── backups/
└── logs/
```

Los directorios generados por el servidor están incluidos en `.gitignore` para evitar subir mundos, logs y archivos pesados a GitHub.

## 11. Problemas habituales

### `java: command not found`

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless
```

### El servidor va lento

Reduce la distancia de renderizado y el número de plugins. También puedes reducir `-Xmx` si ChromeOS está quedándose sin memoria.

### No pueden conectarse desde otro dispositivo

Comprueba primero que ambos dispositivos estén en la misma red y que estés usando la IP correcta. Después revisa el puerto y la configuración WebSocket de EaglercraftXServer.

### El plugin no funciona

Comprueba que la versión del plugin sea compatible con Paper 1.12.2 y con Java 17. Revisa `logs/latest.log`.

## 12. Seguridad

Para un servidor privado:

- Activa whitelist.
- No des `op` a cualquiera.
- Haz backups.
- No ejecutes archivos `.jar` desconocidos.
- Descarga plugins únicamente de fuentes fiables.
- Mantén Java y ChromeOS actualizados.

## Fuentes oficiales

- EaglercraftXServer: https://github.com/lax1dude/eaglerxserver
- Paper: https://papermc.io/
- LuckPerms: https://luckperms.net/
- EssentialsX: https://essentialsx.net/
- WorldEdit: https://enginehub.org/worldedit/

## Licencia y distribución

Este repositorio proporciona automatización y configuración. No incluye ni redistribuye archivos de Minecraft que no estén autorizados para redistribución.