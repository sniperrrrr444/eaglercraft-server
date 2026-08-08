# Voz / micrófono en Eaglercraft

EaglercraftXServer incluye infraestructura de voz y una API de canales de voz. El servidor puede gestionar canales de voz Eaglercraft, pero el micrófono no se activa por magia desde Paper: el cliente Eaglercraft debe ser compatible con voz y el navegador debe conceder permiso para usar el micrófono.

## 1. Requisitos

- EaglercraftXServer actualizado.
- Cliente EaglercraftX compatible con voz.
- Navegador con WebRTC/micrófono.
- Para conexiones públicas, usa HTTPS/WSS. Los navegadores restringen el acceso al micrófono en contextos no seguros.

## 2. Permitir el micrófono en Chrome

Cuando el cliente solicite acceso al micrófono, pulsa **Permitir**.

Si lo bloqueaste anteriormente:

1. Abre los permisos del sitio en Chrome.
2. Busca **Micrófono**.
3. Selecciona **Permitir**.
4. Recarga Eaglercraft.

En ChromeOS también comprueba que el sistema no tenga el micrófono bloqueado.

## 3. Servidor local

Para pruebas en la misma máquina puedes empezar con la conexión WebSocket configurada por EaglerXServer.

```text
ws://HOST:PUERTO
```

La voz puede depender de que el cliente y el contexto del navegador permitan captura de audio.

## 4. Servidor público: WSS

Para un servidor accesible por Internet recomendamos:

```text
https://tu-dominio.example
```

y conexión Eagler mediante:

```text
wss://tu-dominio.example
```

Configura un certificado TLS válido y un reverse proxy como Caddy o nginx delante de EaglerXServer.

No uses certificados autofirmados para un servidor público si quieres evitar problemas de permisos del navegador.

## 5. Importante sobre los canales de voz

EaglerXServer expone un sistema de canales de voz mediante su API. La configuración exacta del canal depende del plugin que vaya a administrar los canales. No se debe instalar un plugin de voz de Minecraft cualquiera y asumir que funcionará con Eaglercraft.

El proyecto oficial documenta la API de voz y contiene `IVoiceService`, `IVoiceManager` e implementaciones de canales de voz.

## 6. Privacidad

El micrófono transmite audio a través del sistema de voz mientras esté activo. Informa a los jugadores de que existe chat de voz y no concedas permisos innecesarios a sitios desconocidos.
