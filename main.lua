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

-- =================== INICIALIZACION ===================
function love.load()
    love.window.setMode(ventana.ancho* ventana.escala, ventana.alto *ventana.escala)
    love.graphics.setDefaultFilter("nearest","nearest")
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
        
    texFondo = love.graphics.newImage("fondo.png")

    sonidoColision = love.audio.newSource("colision.ogg", "static")
    sonidoFon = love.audio.newSource("samplfondo.ogg", "stream")

  
    jugador.cargar()
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
    end


-- =================== INTERACCION ===================
function love.keypressed(key)
    local dx, dy = 0, 0

    if key == "left" then dx = -1
    elseif key == "right" then dx = 1
    elseif key == "up" then dy = -1
    elseif key == "down" then dy = 1
    end

    if dx ~= 0 or dy ~= 0 then
        jugador.mover(dx, dy)

        -- enemigo1:MoverTurno(jugador.posX, jugador.posY)
        enemigo2:MoverTurno(jugador.posX, jugador.posY)
        enemigo3:MoverTurno(jugador.posX, jugador.posY)
        --enemigo5:MoverTurno(jugador.posX, jugador.posY)
        jugador.chequearDanio()
    end
end


-- =================== ACTUALIZACION ===================
function love.update(dt)
    if not jugador.vivo then
        return -- si ya murió, no actualizo  más
    end
    sonidoFon:setVolume(0.5)
    love.audio.play(sonidoFon)-- sonido de Fondo


    jugador.actualizar(dt)

    enemigo1:ActualizarEmpuje(dt)
    enemigo1:ActualizarAnimacion(dt) --
    enemigo2:ActualizarEmpuje(dt)
    enemigo2:ActualizarAnimacion(dt)--
    enemigo3:ActualizarEmpuje(dt)
    enemigo5:ActualizarEmpuje(dt)
    enemigo5:ActualizarAnimacion(dt)

    if enemigo1.vivo and enPozo(enemigo1.posX, enemigo1.posY) then
        enemigo1.vivo = false
    end
    if enemigo2.vivo and enPozo(enemigo2.posX, enemigo2.posY) then
        enemigo2.vivo = false
    end
    if enemigo3.vivo and enPozo(enemigo3.posX, enemigo3.posY) then
        enemigo3.vivo = false
    end

    if not enemigo1.vivo and not enemigo2.vivo and not enemigo3.vivo then
    hasGanao = true
    end

    
    if enPozo(jugador.posX, jugador.posY) then
        jugador.vivo = false
    end

end
       


-- =================== RENDERIZADO ===================
function love.draw()
    love.graphics.setCanvas(lienzo)

        love.graphics.clear()
        
        love.graphics.draw(texFondo, 0, 0,0,1,1,0,0)

        jugador.dibujar()
        jugador:Debug()

                        
        enemigo1:Dibujar()
        --enemigo1:Debug()
        enemigo2:Dibujar()
        --enemigo2:Debug()
        enemigo3:Dibujar()
        --enemigo3:Debug()
        enemigo4:Dibujar()-- este solo se dibuja, es mas bien un NPC
        enemigo5:Dibujar()
        --enemigo5:Debug()

        hud.dibujar(jugador, hasGanao, ventana, sonidoFon)



    
    love.graphics.setCanvas()
    
    love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    
    
end
