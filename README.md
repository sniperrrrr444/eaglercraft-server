# Eaglercraft Server — Chromebook / Linux

> **Turn a Chromebook into an Eaglercraft server.** Paper 1.12.2 + EaglerXServer + optional public HTTPS/WSS tunnel.

[![Eaglercraft](https://img.shields.io/badge/Eaglercraft-server-blue)](https://github.com/sniperrrrr444/eaglercraft-server) [![Platform](https://img.shields.io/badge/platform-Chromebook%20%2F%20Linux-informational)](https://github.com/sniperrrrr444/eaglercraft-server) [![License](https://img.shields.io/badge/license-see%20repository-lightgrey)](https://github.com/sniperrrrr444/eaglercraft-server)

**Goal:** make a reproducible Chromebook/Linux server setup that is easy to test, share and later migrate to a persistent 24/7 host.

> **Important:** the public Quick Tunnel is temporary. It is not a 24/7 host, and an HTTPS tunnel URL is not automatically a playable Eaglercraft client page. You still need a compatible Eaglercraft client and a WebSocket endpoint that matches the EaglerXServer configuration.

## Demo / what it does

```text
Chromebook Linux
      ↓
Paper 1.12.2 + EaglerXServer
      ↓
25565 ready
      ↓
Cloudflare Quick Tunnel (optional)
      ↓
HTTPS + WSS endpoint
      ↓
Compatible Eaglercraft client
```

Typical public start:

```bash
./start-public.sh
```

The terminal prints the generated public HTTPS/WSS endpoint when the tunnel is ready.

## Quick start

### 1. Install

```bash
sudo apt update
sudo apt install -y openjdk-17-jre curl python3 iproute2 git

git clone https://github.com/sniperrrrr444/eaglercraft-server.git
cd eaglercraft-server
chmod +x *.sh
./install.sh
```

### 2. Accept the EULA

If `eula.txt` is created, read and accept the Minecraft EULA only if you agree to its terms:

```bash
nano eula.txt
```

Set:

```text
eula=true
```

### 3. Run locally/LAN

```bash
./start.sh
```

### 4. Run with a temporary public HTTPS/WSS endpoint

```bash
./start-public.sh
```

Expected output:

```text
==========================================
 SERVIDOR ONLINE
==========================================
HTTPS: https://xxxxx.trycloudflare.com
WSS:   wss://xxxxx.trycloudflare.com
==========================================
```

Use the WSS endpoint with a compatible Eaglercraft client. The HTTPS URL is the public tunnel address, not automatically a game launcher.

## Features

- Chromebook Linux/Crostini oriented.
- Paper 1.12.2 + EaglerXServer architecture.
- LAN mode.
- Optional public HTTPS/WSS Quick Tunnel.
- Automatic `cloudflared` download for supported Linux architectures.
- Tunnel PID/log management.
- Public endpoint saved to `server-url.env`.
- `PLAYER-LINK.html` endpoint helper.
- Backup and migration documentation.
- 24/7 migration guide.
- Network diagnostics.
- Conservative Chromebook performance defaults.

## Public networking

`start-public.sh` follows this order:

```text
Paper/EaglerXServer
       ↓
25565 is listening
       ↓
cloudflared starts
       ↓
trycloudflare.com URL is detected
       ↓
HTTPS URL is converted to WSS URL
       ↓
URLs are displayed and saved
```

The tunnel is tied to the running Chromebook session. Restarting it normally creates a different temporary URL.

### Stop

Press `Ctrl+C`. The public startup script cleans up the tunnel and server process.

Or stop the tunnel explicitly:

```bash
./tunnel.sh stop
```

## LAN / ChromeOS

For players on the same network, use:

```bash
./start.sh
hostname -I
```

If ChromeOS requires it, configure Linux **Port forwarding** for TCP `25565`. Other devices must use an address reachable from the LAN, not `localhost`.

## Voice / microphone

HTTPS/WSS provides the secure web transport/context needed by browser features, but it does **not** magically enable voice.

Voice requires:

1. A compatible Eaglercraft client.
2. A browser microphone permission.
3. HTTPS/WSS where required by the client.
4. Compatible EaglerXServer/client voice configuration.

## Login timeout

The project targets a **60-second login timeout** where the installed EaglerXServer version exposes the relevant setting. Check the actual generated configuration before changing it:

```text
plugins/EaglerXServer/settings.cfg
```

Do not add undocumented keys to unrelated YAML files.

## Plugins

Keep the base installation small. EaglerXServer is required for Eaglercraft. Optional plugins such as LuckPerms, EssentialsX and WorldEdit must be selected by version and verified for Paper 1.12.2/Java 17 compatibility.

Do not blindly install modern ViaVersion/ViaBackwards/ViaRewind or random Eaglercraft plugins: version compatibility matters.

## Performance

Start conservatively:

- Java heap: `768M–1536M`.
- `view-distance=6`.
- `simulation-distance=4` where supported by the installed Paper version.
- Add players/plugins gradually.

## 24/7 migration

The Quick Tunnel is for testing/temporary public play. It does **not** keep the server alive when the Chromebook is off.

For 24/7, migrate the server to a persistent host supporting:

- Java 17.
- Paper 1.12.2.
- Custom JARs/plugins.
- Persistent processes and storage.
- WebSockets.
- HTTPS/WSS or a compatible reverse proxy.
- A public endpoint.

See [`24h-hosting.md`](24h-hosting.md).

When migrating, the endpoint changes from something like:

```text
wss://xxxxx.trycloudflare.com
```

to your persistent endpoint:

```text
wss://your-server.example
```

Keep the public endpoint in one configuration location rather than editing random files.

## Backup

```bash
./backup.sh
```

Never commit passwords, tokens, private keys or private certificates.

## Troubleshooting

### Paper does not start

```bash
java -version
```

Check `server-console.log` and make sure Java 17+ is available.

### Port 25565 is already in use

Stop the previous instance before starting another.

### No public URL

Check:

```text
tunnel.log
```

and verify that `curl` and Internet access work.

### HTTPS works but Eaglercraft cannot connect

Check the WSS endpoint and confirm that the Eaglercraft client and EaglerXServer are compatible. A generic HTTPS tunnel does not automatically turn an arbitrary TCP service into an Eaglercraft WebSocket service.

### Network diagnostics

```bash
./network-check.sh
```

## Project files

```text
install.sh          installation
setup.sh            preparation
start.sh            local/LAN server
start-public.sh     server + temporary HTTPS/WSS tunnel
tunnel.sh           tunnel lifecycle
stop.sh             stop helper
backup.sh            backups
network-check.sh    network diagnostics
24h-hosting.md      24/7 migration
HTTPS-WSS.md        permanent HTTPS/WSS architecture
Caddyfile.example   reverse-proxy example
```

## Roadmap

- [x] Chromebook/Linux setup
- [x] LAN startup
- [x] Public temporary HTTPS/WSS workflow
- [x] Tunnel lifecycle cleanup
- [x] Backup/migration documentation
- [ ] Automated integration test on a clean Chromebook Linux environment
- [ ] Automated compatibility matrix for EaglerXServer/Paper/plugin versions
- [ ] One-click persistent-host migration profiles

## Contributing

Issues and pull requests are welcome. When reporting a problem, include:

- ChromeOS/Linux environment.
- `java -version`.
- relevant `server-console.log` output.
- relevant `tunnel.log` output.
- EaglerXServer version.
- Paper version.

Never include passwords, tokens or private keys.

## Share the project

If this project helps you, the most useful ways to help it grow are:

- Star the repository.
- Report reproducible bugs.
- Submit compatibility fixes.
- Share a short demo showing the real setup working.

Please avoid spam or mass-posting the repository link.

## Sources

- EaglerXServer: https://github.com/lax1dude/eaglerxserver
- PaperMC: https://papermc.io/
- Cloudflare Quick Tunnels: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/trycloudflare/
- ChromeOS Port Forwarding: https://developers.google.com/chromeos/app-development/develop/port-forwarding
