# AmorNuevo — Prototipo 1: Core Loop

Prototipo desarrollado para la materia **Programación de Videojuegos 2** (Tecnicatura en Diseño y Programación de Videojuegos, FICH). Hecho en **LÖVE2D (Lua)**.

## Descripción

Juego de exploración/persecución en una grilla (8x8 por casillero), con movimiento por turnos y un sistema de dash. El jugador debe evadir o escaparse de las entidades, su defensa/ataque es un dash-empujòn que los saca afuera del àrea.

## Estructura del proyecto

```
main.lua      -- loop principal (load, update, draw, keypressed), configuración de ventana y límites
jugador.lua   -- lógica del jugador (singleton): movimiento, dash, colisiones, daño
enemigo.lua   -- clase Enemigo (POO con metatablas): movimiento por turno, empuje, animación
hud.lua       -- interfaz de mensajes: pantallas de Game Over / Victoria, FPS
```

## Mecánicas implementadas

- **Movimiento por turno**: el jugador se mueve con flechas; cada movimiento cuenta como un turno y dispara el movimiento de los enemigos (algunos perseguidores, otros no son realmente enemigos)
- **Dash**: movimiento rápido con cooldown (tecla `d`), invulnerable durante su duración, puede empujar enemigos al colisionar.
- **Empuje (ser Empujao)**: los enemigos pueden ser empujados por el dash del jugador.
- **Animación por sprite sheet**: sistema de animación por quads, configurable por instancia (no todos los enemigos animan).
- **Condición de derrota**: el jugador pierde vidas al colisionar con enemigos vivos; game over al llegar a 0 vidas o caer en el pozo (fuera de límites).
- **Condición de victoria**: se gana al eliminar a los enemigos principales (caída en el pozo).
- **Retroalimentación**: sonido de colisión, sonido de fondo, carteles visuales de Game Over / Victoria.



## Enemigos actuales

| Enemigo | Comportamiento |
|---|---|
| enemigo1 | Estático, empujable, animado , hace daño|
| enemigo2 | Persigue por turno, animado |
| enemigo3 | Persigue por turno |
| enemigo4 | NPC decorativo, aùn sin interacción con el ciclo de juego |
| enemigo5 | Estático, empujable, animado, hace daño |

## Estado del commit actual

Se agrega: sistema de reinicio con tecla R (reciclado de instancias, sin recrear enemigos/jugador)

### Pendiente / próximos pasos
- Optimizar la creación de fuentes en el HUD (se recrean en cada draw de la pantalla de victoria).
- Convertir personaje (de singleton) a clase

## Cómo correrlo

Requiere [LÖVE2D](https://love2d.org/) instalado.

```bash
love .

```
En Windows:


Si solo queres hacer doble click podes bajarte la build.
