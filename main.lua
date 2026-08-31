require "jugador"
require "enemigo"
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
  
    jugador.cargar()

        
    enemigo1 = Enemigo:Nuevo(90, 90, "ido.png", 16)
    enemigo2 = Enemigo:Nuevo(80, 100, "edo.png", 4)
    enemigo3 = Enemigo:Nuevo(130, 72, "ada.png", 8)
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

        enemigo1:MoverTurno(jugador.posX, jugador.posY)
        enemigo2:MoverTurno(jugador.posX, jugador.posY)
        enemigo3:MoverTurno(jugador.posX, jugador.posY)

        jugador.chequearDanio()
    end
end


-- =================== ACTUALIZACION ===================
function love.update(dt)
    if not jugador.vivo then
        return -- si ya murió, no actualizamos nada más
    end

    jugador.actualizar(dt)

    enemigo1:ActualizarEmpuje(dt)
    enemigo2:ActualizarEmpuje(dt)
    enemigo3:ActualizarEmpuje(dt)

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



    enColision = false

    enColision = chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                   enemigo1.hBoxX, enemigo1.hBoxY, enemigo1.ancho, enemigo1.alto)
end
       


-- =================== RENDERIZADO ===================
function love.draw()
    love.graphics.setCanvas(lienzo)

        love.graphics.clear()
         
        love.graphics.draw(texFondo, 0, 0,0,1,1,0,0)

        jugador.dibujar()
                        
        enemigo1:Dibujar()
        --enemigo1:Debug()
        enemigo2:Dibujar()
        --enemigo2:Debug()
        enemigo3:Dibujar()
        --enemigo3:Debug()

-- chequeeo debug de colisiones
    if enColision then
        love.graphics.setColor(0.5, 0.9, 0.3)
        love.graphics.circle("fill",30,30,5)
        love.graphics.setColor(1,1, 1)
    end
--una pantalla de GAME OVER provisoria
    if not jugador.vivo then
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 0, ventana.alto/2 - 10, ventana.ancho, "center")
    love.graphics.setColor(1, 1, 1)
    end
-- y una de VICTORIA provisoria
    if hasGanao then
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.printf(" Has Ganao ", 0, ventana.alto/2 - 10, ventana.ancho, "center")
        
        love.graphics.setFont(love.graphics.newFont(10))
        love.graphics.printf(" Pero quedaste solito ", 0, ventana.alto/2 + 30, ventana.ancho, "center")
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(1, 1, 1)
    end
        
    
    love.graphics.setCanvas()
    
    love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    love.graphics.print("Pos Jugador X"..jugador.posX, 10, 10)
    love.graphics.print("Y "..jugador.posY,15,20)

    love.graphics.print("  FPS ".. love.timer.getFPS(),360,10)

    
    
end
