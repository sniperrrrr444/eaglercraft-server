# Servidor 24/7 desde una web de hosting

Si quieres que el servidor siga funcionando cuando el Chromebook esté apagado, necesitas ejecutar Paper + EaglerXServer en un servicio de hosting que permita procesos persistentes.

## Qué debe soportar el hosting

Antes de subir el servidor, comprueba que el servicio permite:

- Java 17 o compatible.
- Paper 1.12.2.
- JARs/plugins personalizados.
- EaglerXServer.
- WebSockets.
- HTTPS/WSS o un reverse proxy compatible.
- Puerto/endpoint público para WSS.
- Almacenamiento persistente para el mundo.

**No todos los hostings gratuitos permiten estas cosas.** Que una web ofrezca Minecraft gratis no significa que Eaglercraft funcione allí.

## Migrar desde el Chromebook

En el Chromebook puedes preparar una copia con:

```bash
./backup.sh
```

La copia debe contener el mundo y las configuraciones necesarias. No subas secretos, tokens ni certificados privados a GitHub.

En el hosting:

1. Instala Java 17.
2. Sube `paper.jar` y el JAR compatible de EaglerXServer.
3. Sube el mundo y `server.properties`.
4. Sube los plugins que realmente uses.
5. Configura el endpoint público HTTPS/WSS.
6. Arranca Paper.
7. Comprueba primero una conexión Eaglercraft.
8. Comprueba después la voz/micrófono.

## Dominio

Si el hosting proporciona un dominio/subdominio, úsalo como endpoint WSS, por ejemplo:

```text
wss://tu-servidor.ejemplo
```

Si proporciona un dominio propio pero no permite WebSockets/WSS, **no será suficiente para Eaglercraft**.

## Importante

Este repositorio no recomienda un proveedor concreto como garantizado 24/7 porque los planes gratuitos, límites y políticas cambian. Comprueba siempre las condiciones actuales del proveedor y la compatibilidad con EaglerXServer antes de migrar.
