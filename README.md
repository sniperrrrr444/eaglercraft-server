# Eaglercraft Server — Chromebook / Linux

Servidor Eaglercraft basado en **Paper 1.12.2 + EaglerXServer**, pensado para ejecutarse en el entorno Linux de un Chromebook.

> **Estado:** preparado para LAN y para pruebas públicas mediante Cloudflare Quick Tunnel. El Quick Tunnel proporciona una URL temporal; no es un servicio 24/7.

## 1. Qué necesitas

- Chromebook con Linux (Crostini) activado.
- Java 17 o superior.
- Internet para la instalación y para el túnel público.
- Un cliente Eaglercraft compatible con EaglerXServer.

## 2. Instalación desde cero

Abre **Terminal de Linux** y ejecuta:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre curl python3 iproute2 git

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

`install.sh` prepara Paper 1.12.2 y descarga la release disponible de EaglerXServer. También crea la configuración básica del servidor.

### EULA

La primera instalación crea `eula.txt`. Abre el archivo y acepta el EULA de Minecraft únicamente si estás de acuerdo con sus términos:

```bash
nano eula.txt
```

Cambia:

```text
eula=false
```

a:

```text
eula=true
```

Guarda el archivo.

## 3. Primer arranque local

Para ejecutar el servidor dentro del Chromebook:

```bash
./start.sh
```

Este modo es para LAN/pruebas. El servidor usa el puerto local `25565`.

Para detenerlo, utiliza `stop` en la consola del servidor o:

```bash
./stop.sh
```

## 4. Servidor público con enlace automático

Si quieres el sistema que **arranca el servidor y te da un enlace para compartir**, utiliza:

```bash
./start-public.sh
```

El proceso es:

```text
Paper 1.12.2
     ↓
EaglerXServer
     ↓
25565 listo
     ↓
Cloudflare Quick Tunnel
     ↓
HTTPS público
     ↓
endpoint WSS
```

La terminal debería mostrar:

```text
==========================================
 SERVIDOR ONLINE
==========================================
HTTPS: https://xxxxx.trycloudflare.com
WSS:   wss://xxxxx.trycloudflare.com
==========================================
```

### Qué enlace compartes

El `wss://...` es el **endpoint WebSocket seguro** que necesita el cliente Eaglercraft compatible.

El `https://...` es la dirección HTTPS del túnel. **No es automáticamente una página de juego Eaglercraft.** Para entrar hace falta un cliente Eaglercraft compatible y configurar en él el endpoint WSS.

El proyecto guarda temporalmente las URLs en:

```text
server-url.env
```

y genera:

```text
PLAYER-LINK.html
```

La URL de Quick Tunnel es temporal y puede cambiar al reiniciar.

## 5. Cómo se instala Cloudflare Tunnel

No necesitas instalar `cloudflared` manualmente. `tunnel.sh` detecta la arquitectura del Chromebook e intenta descargar la versión Linux correspondiente.

Si la descarga automática falla, instala `cloudflared` manualmente y vuelve a ejecutar:

```bash
./start-public.sh
```

El script guarda los mensajes del túnel en:

```text
tunnel.log
```

## 6. Detener correctamente el modo público

Pulsa:

```text
Ctrl+C
```

El script debe detener el proceso del túnel y el servidor Paper.

También puedes detener solo el túnel:

```bash
./tunnel.sh stop
```

## 7. Si los amigos están en la misma Wi-Fi

Para LAN puedes usar `./start.sh` sin publicar el servidor en Internet.

Obtén las direcciones disponibles con:

```bash
hostname -I
```

En ChromeOS puede ser necesario configurar **Redirección de puertos / Port forwarding** para TCP `25565` desde la configuración del entorno Linux.

Los demás dispositivos deben conectarse usando la **IP del Chromebook**, no `localhost` y no una IP interna de Crostini que no sea accesible desde la LAN.

## 8. HTTPS/WSS permanente

El Quick Tunnel no proporciona un dominio permanente. Si quieres algo como:

```text
wss://mc.tudominio.com
```

necesitas un dominio y un despliegue permanente con un reverse proxy/túnel compatible.

El repositorio incluye:

- `Caddyfile.example`
- `HTTPS-WSS.md`

para documentar esa arquitectura.

## 9. Micrófono / voz

El servidor **no puede activar el micrófono del Chromebook por sí solo**.

Para voz necesitas que:

1. El cliente Eaglercraft sea compatible con voz.
2. El navegador conceda permiso de micrófono.
3. La conexión utilice un contexto seguro HTTPS/WSS cuando el cliente lo requiera.
4. EaglerXServer y el cliente utilicen una configuración de voz compatible.

HTTPS/WSS no crea la función de voz; únicamente proporciona el transporte/contexto seguro necesario para las funciones web que lo requieran.

## 10. Login de 60 segundos

El proyecto busca utilizar un timeout de login de **60.000 ms (60 segundos)** en la configuración real de EaglerXServer.

No se debe añadir esa opción a un YAML inventado. Tras el primer arranque, revisa:

```text
plugins/EaglerXServer/settings.cfg
```

y aplica la clave `eagler_login_timeout` si está disponible en la versión instalada.

## 11. EaglerXServer + Paper

La base del proyecto utiliza Paper 1.12.2 y Java 17+. EaglerXServer proporciona la integración Eaglercraft sobre el servidor Bukkit/Paper.

No sustituyas el JAR de EaglerXServer por una versión aleatoria de Internet: utiliza una versión compatible con la base del servidor.

## 12. Plugins

Plugins recomendados únicamente cuando su versión indique compatibilidad con Paper 1.12.2/Java 17:

- EaglerXServer — necesario para Eaglercraft.
- LuckPerms — permisos.
- EssentialsX — utilidades, verificando compatibilidad con 1.12.2.
- WorldEdit — opcional.

**No se instalan automáticamente ViaVersion, ViaBackwards, ViaRewind ni plugins adicionales de Eaglercraft**, porque una versión moderna no es automáticamente compatible con Paper 1.12.2.

## 13. Rendimiento en Chromebook

Empieza de forma conservadora:

- Java: `768M–1536M` de heap.
- `view-distance=6`.
- `simulation-distance=4` cuando la versión de Paper lo soporte.
- pocos jugadores y plugins.

Si el Chromebook tiene poca RAM, reduce primero el número de jugadores, distancia de visión y plugins.

## 14. Diagnóstico

Ejecuta:

```bash
./network-check.sh
```

Si falla el modo público, revisa:

```text
server-console.log
tunnel.log
```

Y comprueba:

```bash
ss -ltn | grep 25565
```

Debe existir un listener cuando Paper esté funcionando.

## 15. Backup y migración

Antes de migrar a un servidor 24/7:

```bash
./backup.sh
```

La copia debe conservar el mundo, plugins y configuración necesaria.

**No subas a GitHub contraseñas, tokens, certificados privados ni otros secretos.**

## 16. Servidor 24/7

El Quick Tunnel sirve para jugar mientras el Chromebook está encendido. **No mantiene el servidor activo con el Chromebook apagado.**

Para 24/7 necesitas migrar Paper + EaglerXServer a un hosting que permita como mínimo:

- Java 17.
- Paper 1.12.2.
- JARs/plugins personalizados.
- procesos persistentes.
- almacenamiento persistente.
- WebSockets.
- HTTPS/WSS o un reverse proxy compatible.
- un endpoint público.

Consulta `24h-hosting.md`.

No se declara ningún proveedor gratuito como compatible al 100% sin comprobar sus límites y soporte actuales.

## 17. Cambio de URL al migrar

Cuando pases del Chromebook a un hosting 24/7, el endpoint cambia, por ejemplo:

```text
ANTES
wss://xxxxx.trycloudflare.com

DESPUÉS
wss://tu-servidor.example
```

Usa el sistema de configuración de URL del proyecto para actualizar el endpoint en lugar de editar archivos al azar.

## 18. Archivos principales

```text
install.sh          instalación
setup.sh            preparación
start.sh            servidor LAN/local
start-public.sh     servidor + enlace HTTPS/WSS temporal
tunnel.sh           Cloudflare Quick Tunnel
stop.sh             parada
backup.sh           copias de seguridad
network-check.sh    diagnóstico
24h-hosting.md      migración a 24/7
HTTPS-WSS.md        HTTPS/WSS permanente
Caddyfile.example   ejemplo de reverse proxy
```

## 19. Solución rápida de problemas

### `Falta paper.jar`

Ejecuta:

```bash
./install.sh
```

### `puerto 25565 ocupado`

Hay otra instancia funcionando. Deténla antes de arrancar otra.

### Paper se cierra inmediatamente

Revisa:

```text
server-console.log
```

y comprueba Java:

```bash
java -version
```

Debe ser Java 17 o superior para la configuración de este proyecto.

### No aparece el enlace HTTPS

Revisa:

```text
tunnel.log
```

Comprueba Internet y que `curl` funcione.

### El enlace HTTPS funciona pero Eaglercraft no conecta

Comprueba que estás usando el **endpoint WSS correcto**, que el cliente Eaglercraft sea compatible con EaglerXServer y que el endpoint corresponda al servicio WebSocket real. Un túnel HTTPS genérico no convierte automáticamente cualquier servidor TCP en un servidor Eaglercraft.

## 20. Seguridad

- No publiques el puerto de Paper directamente si puedes mantenerlo detrás de un proxy/túnel adecuado.
- Mantén Java, Paper, EaglerXServer y el sistema actualizados dentro de las versiones compatibles.
- Usa whitelist si el servidor es privado.
- No des OP innecesariamente.
- No publiques secretos en GitHub.

## Fuentes

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- Cloudflare Quick Tunnels: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/trycloudflare/
- ChromeOS Port Forwarding: https://developers.google.com/chromeos/app-development/develop/port-forwarding
