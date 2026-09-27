# AmorNuevo — Prototipo 2: Maquina de Estados

Prototipo desarrollado para la materia **Programación de Videojuegos 2** (Tecnicatura en Diseño y Programación de Videojuegos, FICH). Hecho en **LÖVE2D (Lua)**.

## Descripción

Juego de exploración/persecución en una grilla (8x8 por casillero), con movimiento por turnos y un sistema de dash. El jugador debe evadir o escaparse de las entidades, su defensa/ataque es un dash-empujòn que los saca afuera del àrea.

## Controles
Tecla	Acción
Flechas (↑ ↓ ← →)	Mover al jugador (un paso por turno)
D	Dash (movimiento rápido, invulnerable, empuja enemigos)
R	Reiniciar la partida (en cualquier momento)

## Estructura del proyecto

```
main.lua              -- loop principal (load, update, draw, keypressed), configuración de ventana, límites y enPozo 
dependencias.lua       -- requiere HUMP/STI y todos los módulos del proyecto
utilidades.lua          -- funciones auxiliares (clamp de cámara, etc.)

estados/
  maqEstados.lua        -- máquina de estados genérica (cambiar, estado actual)
  estado.lua             -- clase base Estado (init/ingresar/salir/actualizar/dibujar/reiniciar)
  estadoMenu.lua          -- pantalla de menú principal
  estadoJugando.lua       -- estado de juego: lógica del core loop, cámara, colisiones
  estadoGanar.lua         -- pantalla de victoria
  estadoPerder.lua        -- pantalla de game over

jugador.lua             -- clase Jugador (con HUMP): movimiento, dash, colisiones, daño
otros/
  enemigo.lua            -- clase base Enemigo (con HUMP): movimiento por turno, empuje, animación opcional
  cactus.lua              -- clase Cactusa (hereda de Enemigo): variante animada
  zorzal.lua              -- clase ZorzalNpc (hereda de Enemigo): NPC sin interacción, solo dibujado

hud.lua                 -- interfaz de mensajes: vidas, pantallas de Game Over/Victoria, FPS

mapa/
  escena1.lua             -- mapa exportado 

lib/                    -- librerías externas 
  class.lua               
  camera.lua              
  sti/                    
```

## Mecánicas implementadas

- **Movimiento por turno**: el jugador se mueve con flechas; cada movimiento cuenta como un turno y dispara el movimiento de los enemigos (algunos perseguidores, otros no son realmente enemigos)
- **Dash**: movimiento rápido con cooldown (tecla `d`), invulnerable durante su duración, puede empujar enemigos al colisionar.
- **Empuje (ser Empujao)**: los enemigos pueden ser empujados por el dash del jugador.
- **Animación por sprite sheet**: sistema de animación por quads, configurable por instancia (no todos los enemigos animan).
- **Condición de derrota**: el jugador pierde vidas al colisionar con enemigos vivos; game over al llegar a 0 vidas o caer en el pozo (fuera de límites).
- **Condición de victoria**: se gana al empujar a los enemigos principales (caída en el pozo).
- **Retroalimentación**: sonido de colisión, sonido de fondo, carteles de Game Over / Victoria.

Sistema de flags por instancia: cada enemigo define esInteractivo (si hace daño al jugador) y seMueve (si persigue por turno) de forma independiente, en vez de mantener listas separadas. Permite combinar comportamientos sin duplicar clases (ej: animado + quieto + interactivo).
 Tabla de enemigos:
 todos los enemigos/NPCs viven en una sola tabla, iterada con for en vez de quedar sueltas.


## Enemigos actuales

Instancia	Clase	Se mueve	Hace daño	Animado
Cactusa (cactusa.png)	Cactusa	No	Sí	Sí
Enemigo (edo-sheet.png)	Enemigo	Sí	Sí	Sí
Enemigo (ada.png)	Enemigo	Sí	Sí	No
Cactusa (cactusa.png, quieto)	Cactusa	No	Sí	Sí
ZorzalNpc (ada2.png)	ZorzalNpc	No	No	No

## Estado del commit actual

Máquina de estados:

-MaqEstados:cambiar ahora llama a ingresar(parametros) del nuevo estado (antes solo llamaba salir() del anterior y creaba el nuevo; ingresar estaba definido pero nunca se disparaba).
-Reimplementado reiniciar(), esta vez respetando la interfaz de Estado que dio el profe (antes habìa hecho un reinicio propio por fuera del patrón; después se había sacado del todo como para recrear el estado con cambiar("jugando")). Ahora EstadoJugando:reiniciar() resetea jugador y enemigos, sin recrear todo el estado ( estimo que es mas eficiente??)
-Fix en Jugador:Reiniciar y Enemigo:Reiniciar: faltaba sincronizar mundobump:update() tras resetear posición — sin eso, el mundo de colisiones quedaba con la posición vieja tras reiniciar.
- Tecla "r" en EstadoJugando ahora llama a self:reiniciar() en vez de MaqEstadoGlobal:cambiar("jugando").

Limpieza:

Eliminè código muerto: funciones EnPozo duplicadas/comentadas, comentarios sueltos y bloques de debug comentados en estadoJugando.lua (aunque tal vez despues tenga que haer un fichero de funciones DEBUG)

### Pendiente / próximos pasos


- Agregar comportamiento propio a ZorzalNpc (diálogos/interacción).
- Crear un assets Manager 





## Cómo correrlo

Requiere [LÖVE2D](https://love2d.org/) instalado.

```bash
love .

```
En Windows:



