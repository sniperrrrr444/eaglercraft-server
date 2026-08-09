# HTTPS + WSS

For Eaglercraft and browser microphone features to work reliably, the public endpoint should use HTTPS/WSS when the client requires a secure context.

## Architecture

```text
Eaglercraft (Chrome)
        |
      HTTPS/WSS
        |
     Caddy :443
        |
  127.0.0.1:25565
        |
    EaglerXServer
        |
      Paper
```

## Requirements

1. A real domain, for example `mc.example.com`.
2. The domain's DNS `A/AAAA` record pointing to the public server address.
3. TCP 443 forwarded by the router to the server when self-hosting from home.
4. ChromeOS/Linux port forwarding when required for the service inside Crostini.
5. Caddy installed in the environment receiving the connection.

## Caddy

Copy `Caddyfile.example` to `Caddyfile` and replace `example.com` with your domain.

Caddy can obtain and renew a trusted TLS certificate automatically when the domain is publicly reachable and DNS is configured correctly.

Start Caddy with your `Caddyfile` and keep EaglerXServer listening on the configured local port.

## Client endpoint

With HTTPS/WSS, the player should use the secure endpoint that corresponds to the EaglerXServer/proxy configuration, for example:

```text
wss://mc.example.com
```

Do not use `ws://` for a public endpoint that requires secure WebSockets.

## Chromebook

ChromeOS networking can still prevent connections from other devices. HTTPS does not remove the need to configure ChromeOS networking and, for Internet access, the router/firewall.

For a local network, configure ChromeOS port forwarding as required. For Internet access, also configure TCP 443 on the router/firewall.

## Important about port 25565

Do not assume `wss://domain:25565` is correct. In this architecture, the public client connects through **443** and Caddy proxies internally to `127.0.0.1:25565`.

## Security

- Do not expose Paper directly on 25565 to the Internet when a suitable proxy can protect the public endpoint.
- Keep Caddy and the operating system updated.
- Use a whitelist for private servers.
- Do not grant OP unnecessarily.
- The TLS certificate must be valid for the domain.
