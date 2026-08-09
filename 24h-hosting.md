# 24/7 Hosting Migration

If you want the server to keep running while the Chromebook is powered off, run Paper + EaglerXServer on a hosting service that allows persistent processes.

## Hosting requirements

Before uploading the server, check that the provider supports:

- Java 17 or compatible Java runtime.
- Paper 1.12.2.
- Custom JARs/plugins.
- EaglerXServer.
- WebSockets.
- HTTPS/WSS or a compatible reverse proxy.
- A public WSS endpoint/port.
- Persistent world storage.

**Not every free Minecraft host supports these requirements.** A host advertising free Minecraft hosting does not automatically mean Eaglercraft will work there.

## Migrate from the Chromebook

Create a backup on the Chromebook:

```bash
./backup.sh
```

The backup should contain the world and required configuration. Never upload secrets, tokens or private certificates to GitHub.

On the host:

1. Install/select Java 17.
2. Upload `paper.jar` and the compatible EaglerXServer JAR.
3. Upload the world and `server.properties`.
4. Upload only the plugins you actually use.
5. Configure the public HTTPS/WSS endpoint.
6. Start Paper.
7. Test an Eaglercraft connection first.
8. Test voice/microphone separately.

## Domain

If the host provides a domain/subdomain, use it as the WSS endpoint, for example:

```text
wss://your-server.example
```

A custom domain without WebSocket/WSS support is **not enough for Eaglercraft**.

## Important

This repository does not claim that a particular free provider is guaranteed to work 24/7. Free plans, limits and policies change. Always verify the provider's current terms and EaglerXServer compatibility before migrating.
