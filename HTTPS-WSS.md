# HTTPS + WSS

Para que Eaglercraft y el micrófono funcionen de forma fiable desde navegador, el endpoint público debe usar HTTPS/WSS.

## Arquitectura

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

## Requisitos

1. Un dominio real, por ejemplo `mc.example.com`.
2. El DNS `A/AAAA` del dominio apuntando a tu conexión pública.
3. TCP 443 redirigido en el router hacia el Chromebook.
4. Redirección de puertos de ChromeOS/Linux para el servicio si corresponde.
5. Caddy instalado en el entorno que recibe la conexión.

## Caddy

Copia `Caddyfile.example` como `Caddyfile` y cambia `example.com` por tu dominio.

Caddy se encarga de obtener y renovar el certificado TLS automáticamente cuando el dominio es accesible públicamente.

Arranca Caddy con tu `Caddyfile` y deja EaglerXServer escuchando en el puerto local configurado.

## Dirección del cliente

Con HTTPS/WSS, el jugador debe usar el endpoint seguro que corresponda a EaglerXServer/proxy, por ejemplo:

```text
wss://mc.example.com
```

No uses `ws://` para el endpoint público HTTPS.

## Chromebook

ChromeOS sigue siendo el punto que puede impedir conexiones desde otros dispositivos. HTTPS no elimina la necesidad de configurar la red de ChromeOS y, si juegas desde Internet, el router.

Para una red local, configura la redirección de puertos de ChromeOS. Para Internet, configura además el router/firewall para TCP 443.

## Importante sobre el puerto 25565

No asumas que `wss://dominio:25565` es correcto. En esta arquitectura el cliente público entra por **443** y Caddy reenvía internamente a `127.0.0.1:25565`.

## Seguridad

- No expongas directamente Paper en 25565 a Internet si el proxy puede evitarlo.
- Mantén Caddy y el sistema actualizados.
- Usa whitelist para un servidor privado.
- No des OP innecesariamente.
- El certificado TLS debe ser válido para el dominio.
