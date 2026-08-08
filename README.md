# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft para **Linux/Crostini de ChromeOS** con modo público HTTPS/WSS mediante Cloudflare Quick Tunnel.

## Instalación rápida

En Terminal de Linux:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre curl python3 iproute2 git

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

Después acepta el EULA aplicable en `eula.txt` y arranca el servidor.

## Arrancar y obtener un enlace público

Para el modo que tú quieres —**arrancar, obtener un enlace y compartirlo**— usa:

```bash
./start-public.sh
```

El orden es importante:

```text
Paper/EaglerXServer
       ↓
abre 25565
       ↓
Cloudflare Quick Tunnel
       ↓
genera HTTPS público
       ↓
se convierte en endpoint WSS
```

La terminal mostrará algo parecido a:

```text
SERVIDOR ONLINE

HTTPS: https://xxxxx.trycloudflare.com
WSS:   wss://xxxxx.trycloudflare.com
```

El enlace `wss://` es el endpoint seguro que debe configurar el cliente Eaglercraft. El enlace HTTPS sirve como dirección web del túnel; **no es por sí mismo un cliente Eaglercraft completo**.

El enlace de Quick Tunnel es temporal y normalmente cambia al reiniciar. Es adecuado para pruebas/juego ocasional, no como dirección permanente 24/7.

## Detener el servidor

Pulsa `Ctrl+C` o detén el proceso. El script limpia el túnel y elimina las URLs temporales de `server-url.env`.

También puedes detener solo el túnel con:

```bash
./tunnel.sh stop
```

## Si solo quieres LAN

Puedes usar el arranque normal:

```bash
./start.sh
```

Obtén la IP del Chromebook:

```bash
hostname -I
```

Para otros dispositivos de la misma Wi-Fi, configura la **Redirección de puertos de ChromeOS** para TCP 25565 si es necesaria y utiliza la IP del Chromebook. No uses `localhost` desde otro dispositivo.

## HTTPS/WSS permanente

El Quick Tunnel no proporciona una URL permanente. Para un dominio fijo necesitas un despliegue con un dominio y un reverse proxy/túnel permanente.

El archivo `Caddyfile.example` y `HTTPS-WSS.md` explican la arquitectura con Caddy:

```text
Internet
   ↓ HTTPS/WSS :443
Caddy
   ↓
EaglerXServer
   ↓
Paper
```

No hace falta Caddy para `./start-public.sh`: ese comando utiliza Cloudflare Quick Tunnel.

## Micrófono / voz

HTTPS/WSS es necesario para el contexto seguro del navegador, pero **no activa el micrófono automáticamente**. Para voz necesitas:

- un cliente Eaglercraft compatible con voz;
- permiso de micrófono en Chrome;
- configuración de voz compatible con la versión de EaglerXServer.

El servidor no puede conceder permisos del navegador por sí mismo.

## Login aumentado

El objetivo de configuración es un timeout de login de **60 segundos**. El valor debe existir en la configuración real de EaglerXServer instalada; no añadas una clave inventada a un archivo YAML distinto.

Comprueba el `settings.cfg` generado por la versión instalada y usa la clave que indique su documentación oficial para `eagler_login_timeout`.

## EaglerXServer y Paper

EaglerXServer proporciona la compatibilidad Eaglercraft sobre Bukkit/Paper. El proyecto está orientado a Paper 1.12.2 y Java 17+.

## Plugins

Instala solo versiones que indiquen compatibilidad con **Paper 1.12.2 + Java 17**. Recomendaciones iniciales:

- EaglerXServer — necesario para Eaglercraft.
- LuckPerms — permisos.
- EssentialsX — comandos/utilidades, si la versión elegida soporta 1.12.2.
- WorldEdit — opcional.

ViaVersion/ViaBackwards/ViaRewind y plugins específicos de Eaglercraft deben comprobarse por versión antes de instalarlos. No se instalan automáticamente a ciegas.

## Rendimiento Chromebook

Empieza con:

- `768M–1536M` de RAM para Java.
- `view-distance=6`.
- `simulation-distance=4` cuando la versión de Paper utilizada lo admita.
- pocos jugadores/plugins al principio.

## Diagnóstico

```bash
./network-check.sh
```

Si el modo público falla, revisa:

```text
server-console.log
tunnel.log
```

Comprueba también que `cloudflared` pueda iniciar y que Paper esté escuchando en `127.0.0.1:25565`.

## 24/7

El Quick Tunnel está pensado para pruebas y desarrollo. Si quieres que tus amigos puedan entrar aunque el Chromebook esté apagado, migra el servidor a un hosting que permita:

- Java 17.
- Paper 1.12.2.
- JARs/plugins personalizados.
- EaglerXServer.
- WebSockets/WSS.
- almacenamiento persistente.
- un endpoint HTTPS/WSS público.

Consulta `24h-hosting.md` para la migración.

## Backup

```bash
./backup.sh
```

No subas mundos, tokens, claves privadas o certificados a GitHub.

## Scripts

- `install.sh` — instala/prepara Paper y EaglerXServer.
- `setup.sh` — preparación adicional.
- `start.sh` — servidor local/LAN.
- `start-public.sh` — servidor + túnel HTTPS/WSS temporal.
- `tunnel.sh` — inicia/detiene Cloudflare Quick Tunnel.
- `stop.sh` — detención.
- `backup.sh` — copias de seguridad.
- `network-check.sh` — diagnóstico.

## Fuentes

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- Cloudflare Quick Tunnels: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/trycloudflare/
- ChromeOS Port Forwarding: https://developers.google.com/chromeos/app-development/develop/port-forwarding
