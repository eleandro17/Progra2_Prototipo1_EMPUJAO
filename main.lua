require "jugador"
require "enemigo"
require "hud"
-- =================== DECLARACION ===================

ventana = {
    alto = 136, ancho = 240, escala = 3
}

texFondo = nil

enColision = false

hasGanao = false

limites = {
    minX = 8,
    maxX = ventana.ancho - 8,
    minY = 8,
    maxY = ventana.alto - 8
}

function enPozo(x, y)
    return x < limites.minX or x > limites.maxX or y < limites.minY or y > limites.maxY
end

-- =================== REINICIO ===================
function reiniciarJuego()
    jugador:Reiniciar()

    for _, e in ipairs(enemigos) do
        e:Reiniciar()
    end

    hasGanao = false
end

-- =================== INICIALIZACION ===================
function love.load()
    love.window.setMode(ventana.ancho* ventana.escala, ventana.alto *ventana.escala)
    love.graphics.setDefaultFilter("nearest","nearest")
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
        
    texFondo = love.graphics.newImage("fondo.png")

    sonidoColision = love.audio.newSource("colision.ogg", "static")
    sonidoFon = love.audio.newSource("samplfondo.ogg", "stream")

  
    jugador = Jugador:Nuevo(20, 20)
    jugador:Cargar()
    hud.cargar()

        
    --enemigo1 = Enemigo:Nuevo(90, 90, "ido.png", 16)
    enemigo1 = Enemigo:Nuevo(30, 90, "ido-sheet.png")
    enemigo5 = Enemigo:Nuevo(100,30,"ido-sheet.png")

    enemigo1:ConfigurarAnimacion(2, 6)
    enemigo5:ConfigurarAnimacion(2, 3)
    

    --enemigo2 = Enemigo:Nuevo(80, 100, "edo.png")
    enemigo2 = Enemigo:Nuevo(80, 100, "edo-sheet.png")
    enemigo2:ConfigurarAnimacion(2, 4)
    enemigo3 = Enemigo:Nuevo(130, 72, "ada.png")
    enemigo4 = Enemigo:Nuevo(100,100,"ada2.png")

    -- Todos los enemigos: para dibujar, animar, empujar y chequear pozo
    enemigos = { enemigo1, enemigo2, enemigo3, enemigo4, enemigo5 }
    -- Enemigos que interactúan con el jugador (todos menos el NPC decorativo enemigo4)
    enemigosInteractivos = { enemigo1, enemigo2, enemigo3, enemigo5 }
    end


-- =================== INTERACCION ===================
function love.keypressed(key)
    if key == "r" then
        reiniciarJuego()
        return
    end

    local dx, dy = 0, 0

    if key == "left" then dx = -1
    elseif key == "right" then dx = 1
    elseif key == "up" then dy = -1
    elseif key == "down" then dy = 1
    end

    if dx ~= 0 or dy ~= 0 then
        jugador:Mover(dx, dy)

        -- enemigo1:MoverTurno(jugador.posX, jugador.posY)
        enemigo2:MoverTurno(jugador.posX, jugador.posY)
        enemigo3:MoverTurno(jugador.posX, jugador.posY)
        --enemigo5:MoverTurno(jugador.posX, jugador.posY)
        jugador:ChequearDanio(enemigosInteractivos)
    end
end


-- =================== ACTUALIZACION ===================
function love.update(dt)
    if not jugador.vivo then
        return -- si ya murió, no actualizo  más
    end
    sonidoFon:setVolume(0.5)
    love.audio.play(sonidoFon)-- sonido de Fondo


    jugador:Actualizar(dt, enemigosInteractivos)

    for _, e in ipairs(enemigos) do
        e:ActualizarEmpuje(dt)
        e:ActualizarAnimacion(dt) -- no hace nada si el enemigo no tiene animación configurada

        if e.vivo and enPozo(e.posX, e.posY) then
            e.vivo = false
        end
    end

    
    if enPozo(jugador.posX, jugador.posY) then
        jugador.vivo = false
    end

    if jugador.vivo and not enemigo1.vivo and not enemigo2.vivo and not enemigo3.vivo and not enemigo5.vivo then
        hasGanao = true
    end

end
       


-- =================== RENDERIZADO ===================
function love.draw()
    love.graphics.setCanvas(lienzo)

        love.graphics.clear()
        
        love.graphics.draw(texFondo, 0, 0,0,1,1,0,0)

        jugador:Dibujar()
        --jugador:Debug()

        for _, e in ipairs(enemigos) do
            e:Dibujar()
            --e:Debug()
        end
        

        hud.dibujarVidas(jugador.vidas)

                if jugador.vivo and not hasGanao then
            hud.dibujarControles(ventana)
        end

        hud.dibujarMensajes(jugador, hasGanao, ventana, sonidoFon)

    love.graphics.setCanvas()
    
    love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    hud.dibujarFPS()
    
end