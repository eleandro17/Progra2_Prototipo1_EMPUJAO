require "dependencias"
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

enemigos = {}

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
        
    texFondo = love.graphics.newImage("assets/fondo.png")

    sonidoColision = love.audio.newSource("assets/colision.ogg", "static")
    sonidoFon = love.audio.newSource("assets/samplfondo.ogg", "stream")

  
    jugador = Jugador(20, 20)
    jugador:Cargar()
    hud.cargar()

        -- enemigo1 = Cactusa(30, 90, "assets/ido-sheet.png", 2, 6)
        -- enemigo5 = Cactusa(100, 30, "assets/ido-sheet.png", 2, 3)
        -- enemigo2 = Cactusa(80, 100, "assets/edo-sheet.png", 2, 4)
        -- enemigo3 = Enemigo(130, 72, "assets/ada.png")
        -- enemigo4 = ZorzalNpc(100, 100, "assets/ada2.png")
    
    table.insert(enemigos, Cactusa(30, 90, "assets/cactusa.png", 2, 6))
    table.insert(enemigos, Enemigo(80, 100, "assets/edo-sheet.png",2,2))
    table.insert(enemigos, Enemigo(130, 72, "assets/ada.png"))
    table.insert(enemigos, Cactusa(100, 30, "assets/cactusa.png", 2, 3))
    table.insert(enemigos, ZorzalNpc(100, 100, "assets/ada2.png"))
    


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

    for _, e in ipairs(enemigos) do
        if e.esInteractivo and e.seMueve then
            e:MoverTurno(jugador.posX, jugador.posY)
        end
    end

    jugador:ChequearDanio(enemigos)
end
end


-- =================== ACTUALIZACION ===================
function love.update(dt)
    if not jugador.vivo then
        return -- si ya murió, no actualizo  más
    end
    sonidoFon:setVolume(0.5)
    love.audio.play(sonidoFon)-- sonido de Fondo


    jugador:Actualizar(dt, enemigos)

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

    -- Condicion de VIctoria
    local quedanEnemigosVivos = false
for _, e in ipairs(enemigos) do
    if e.esInteractivo and e.vivo then
        quedanEnemigosVivos = true
    end
end

if jugador.vivo and not quedanEnemigosVivos then
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
             

        hud.dibujarMensajes(jugador, hasGanao, ventana, sonidoFon)

    love.graphics.setCanvas()

    
    
    love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    if jugador.vivo and not hasGanao then
            hud.dibujarControles(ventana)
        end

    hud.dibujarFPS()
    
end