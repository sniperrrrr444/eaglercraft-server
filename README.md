# Eaglercraft Server para Chromebook Linux

Servidor Eaglercraft para **Linux/Crostini de ChromeOS**, preparado para funcionar en una red local con otros dispositivos.

## Instalación rápida

En Terminal de Linux:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre git curl python3 iproute2

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

El instalador descarga Paper 1.12.2 y la última release de EaglerXServer desde sus fuentes oficiales.

## Red: MUY IMPORTANTE en Chromebook

El servidor puede escuchar correctamente dentro de Linux y aun así ser inaccesible desde otro móvil/PC porque **Crostini está dentro del entorno Linux de ChromeOS**. Esto no se arregla cambiando Minecraft: hay que publicar el puerto de ChromeOS.

Google documenta que ChromeOS tiene **Redirección de puertos / Port forwarding** para permitir que otros dispositivos de la misma red accedan a servidores que se ejecutan dentro de Linux. citeturn1search0

### Para jugar desde otro dispositivo de tu Wi-Fi

1. Arranca Linux/Terminal en el Chromebook.
2. Ejecuta:

```bash
./start.sh
```

3. En ChromeOS abre **Configuración → Desarrolladores → Entorno de desarrollo de Linux → Redirección de puertos**.
4. Añade:
   - **Puerto:** `25565`
   - **Protocolo:** `TCP`
5. Déjalo activado mientras el servidor esté funcionando.
6. En **Configuración → Red**, mira la IP del **Chromebook**.
7. Desde el otro dispositivo usa esa IP y el puerto `25565`.

Ejemplo:

```text
192.168.1.50:25565
```

**No uses como dirección para los demás dispositivos la IP interna que muestra `hostname -I` dentro de Crostini.** En la configuración de port forwarding de ChromeOS se utiliza la IP del dispositivo ChromeOS. citeturn1search0

### Comprobación automática

Antes de arrancar puedes ejecutar:

```bash
./network-check.sh
```

Comprueba si el puerto 25565 está escuchando y muestra exactamente qué tienes que configurar en ChromeOS.

### El servidor arranca solo cuando hay red

`start.sh` muestra las IP disponibles, comprueba que el puerto 25565 no esté ocupado y fuerza IPv4 para evitar algunos problemas de compatibilidad con clientes/redes antiguas.

## Internet, fuera de tu Wi-Fi

El port forwarding de ChromeOS sirve para publicar el servidor en la red local. Para que alguien pueda conectarse desde otra casa necesitas además una solución de acceso remoto/publicación y, si usas voz en navegador, HTTPS/WSS. No hay una configuración dentro de este repositorio que pueda saltarse el NAT de tu router o las restricciones de ChromeOS.

No recomiendo abrir `25565` directamente a Internet sin protección.

## EaglercraftXServer

EaglerXServer funciona como capa de traducción para que los clientes Eaglercraft utilicen el mismo endpoint del servidor. Su documentación indica soporte para EaglercraftX 1.8, Eaglercraft 1.12.2 y Eaglercraft 1.5.2 mediante los componentes correspondientes. citeturn0search0

## Login: 60 segundos

Después del primer arranque, aplica en la configuración generada por EaglerXServer:

```yaml
eagler_login_timeout: 60000
eagler_players_view_distance: 6
```

`60000` ms son 60 segundos.

No se sobrescribe automáticamente el archivo generado por EaglerXServer para evitar romper configuraciones entre versiones.

## Micrófono / voz

EaglerXServer dispone de API de voz, pero el micrófono depende también del cliente Eaglercraft y del navegador. Para un servidor público utiliza HTTPS/WSS y concede permiso de micrófono al sitio.

## Plugins

Base:

- EaglerXServer.

Opcionales, instalándolos solo después de comprobar compatibilidad con Paper 1.12.2:

- ViaVersion / ViaBackwards / ViaRewind.
- LuckPerms.
- EssentialsX.
- WorldEdit.
- EaglerMOTD.
- EaglerWeb.
- EaglerXPlan.

No instales versiones modernas al azar en Paper 1.12.2.

## Rendimiento Chromebook

Empieza con:

- `768M–1536M` de RAM.
- `view-distance=6`.
- `simulation-distance=4`.
- 10 jugadores como máximo inicialmente.

EaglerXServer recomienda reducir la distancia de visión si aparecen errores de conexión en redes de poco ancho de banda. citeturn0search0

## Scripts

- `install.sh` — instala Paper + EaglerXServer.
- `setup.sh` — prepara el entorno.
- `start.sh` — arranque con diagnóstico de red.
- `stop.sh` — detención.
- `backup.sh` — backup del mundo.
- `network-check.sh` — diagnóstico de conectividad.

## Fuentes

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- Guía oficial de ChromeOS Port Forwarding: https://developers.google.com/chromeos/app-development/develop/port-forwarding
