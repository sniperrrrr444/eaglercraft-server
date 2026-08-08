# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft para **Linux/Crostini de ChromeOS**, preparado para usar HTTPS/WSS mediante un reverse proxy.

## Instalación rápida

```bash
sudo apt update
sudo apt install -y openjdk-17-jre git curl python3 iproute2

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

El instalador descarga Paper 1.12.2 y la última release de EaglerXServer desde sus fuentes oficiales.

## HTTPS + WSS

Para un servidor público y para que el micrófono del navegador pueda funcionar correctamente, la arquitectura recomendada es:

```text
Cliente Eaglercraft
       |
   HTTPS / WSS
       |
   Caddy :443
       |
127.0.0.1:25565
       |
 EaglerXServer
       |
     Paper
```

El repositorio incluye:

- `Caddyfile.example` — configuración de reverse proxy.
- `HTTPS-WSS.md` — guía completa de publicación segura.

### Necesitas

1. Un dominio real, por ejemplo `mc.tudominio.com`.
2. El DNS del dominio apuntando a tu IP pública.
3. TCP `443` redirigido en tu router al Chromebook.
4. Redirección de puertos de ChromeOS si el servicio está dentro de Crostini.
5. Caddy ejecutándose como reverse proxy.

Caddy obtiene y renueva automáticamente un certificado TLS válido cuando el dominio es accesible públicamente.

Después, el cliente Eaglercraft utiliza un endpoint seguro del tipo:

```text
wss://mc.tudominio.com
```

**No uses `ws://` para el endpoint público.**

No es correcto prometer que GitHub puede configurar automáticamente tu router, DNS o NAT: esas partes dependen de tu red.

## Red local de Chromebook

Para jugar desde otro dispositivo de la misma Wi-Fi, ChromeOS puede necesitar su función **Redirección de puertos / Port forwarding** para publicar el servicio Linux. La IP que debes usar para otros dispositivos es la IP del Chromebook, no una IP interna de Crostini.

Si utilizas el proxy HTTPS, la publicación externa es **443/TCP**, no 25565 directamente.

## Diagnóstico

```bash
./network-check.sh
```

Comprueba el estado del listener y te ayuda a localizar problemas de red.

## EaglercraftXServer

EaglerXServer es la capa de compatibilidad Eaglercraft. Su soporte Bukkit nativo está basado en Paper 1.12.2 y requiere Java 17+.

## Login: 60 segundos

Después del primer arranque, aplica en `plugins/EaglercraftXServer/settings.cfg`:

```text
eagler_login_timeout: 60000
eagler_players_view_distance: 6
```

`60000` ms = 60 segundos.

## Micrófono / voz

El servidor no puede activar el micrófono físicamente. Para voz necesitas:

- cliente Eaglercraft compatible con voz;
- permiso de micrófono en Chrome;
- HTTPS/WSS para un despliegue público;
- configuración de voz compatible con la versión de EaglerXServer.

## Plugins

Base:

- EaglerXServer.

Opcionales: instala únicamente versiones compatibles con Paper 1.12.2:

- ViaVersion / ViaBackwards / ViaRewind.
- LuckPerms.
- EssentialsX.
- WorldEdit.
- EaglerMOTD.
- EaglerWeb.
- EaglerXPlan.

## Rendimiento Chromebook

Empieza con:

- `768M–1536M` RAM.
- `view-distance=6`.
- `simulation-distance=4`.
- 10 jugadores como máximo.

## Seguridad

- No expongas Paper directamente a Internet si puedes mantenerlo detrás de Caddy.
- Usa HTTPS/WSS.
- Mantén el dominio y certificados correctamente configurados.
- Usa whitelist para servidores privados.
- No des OP innecesariamente.

## Scripts

- `install.sh` — instala Paper + EaglerXServer.
- `setup.sh` — prepara el entorno.
- `start.sh` — arranca el servidor.
- `stop.sh` — detiene el servidor.
- `backup.sh` — backups.
- `network-check.sh` — diagnóstico de red.

## Documentación

- `HTTPS-WSS.md` — despliegue HTTPS/WSS.
- `Caddyfile.example` — configuración del proxy.

## Fuentes

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- ChromeOS Port Forwarding: https://developers.google.com/chromeos/app-development/develop/port-forwarding
