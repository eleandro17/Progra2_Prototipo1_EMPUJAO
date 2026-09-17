---  HUD o  interfaz de mensajes: 

hud = {}

function hud.cargar()
    hud.imgGameOver = love.graphics.newImage("assets/gameover.png")
    hud.imgVictoria = love.graphics.newImage("assets/victoria.png")
    hud.imgVida = love.graphics.newImage("assets/vida.png")

    hud.fuentePequena = love.graphics.newFont(22)
    hud.fuentePequena:setFilter("nearest", "nearest")

  
end

function hud.dibujarVidas(vidas)
    local margen = 4
    local espaciado = hud.imgVida:getWidth() + 2

    for i = 1, vidas do
        local x = margen + (i - 1) * espaciado
        love.graphics.draw(hud.imgVida, x, margen)
    end
end

function hud.dibujarReinicio(ventana)
    love.graphics.setFont(hud.fuentePequena)
    love.graphics.setColor(0.8, 0.5, 1)
    love.graphics.printf("(R)einiciar", 0, ventana.alto -1, ventana.ancho, "center")
    love.graphics.setColor(1, 1, 1)
end

function hud.dibujarControles(ventana)
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Flechas: mover | D: dash | R: reiniciar", 0, ventana.alto - 22, ventana.ancho, "center")
    love.graphics.setColor(1, 1, 1)
end

function hud.dibujarGameOver(ventana, sonidoFon)
    local x = ventana.ancho/2 - hud.imgGameOver:getWidth()/2
    local y = ventana.alto/2 - hud.imgGameOver:getHeight()/2
    love.graphics.draw(hud.imgGameOver, x, y)
    sonidoFon:stop()
end

function hud.dibujarVictoria(ventana)
    local x = ventana.ancho/2 - hud.imgVictoria:getWidth()/2
    local y = ventana.alto/2 - hud.imgVictoria:getHeight()/2
    love.graphics.draw(hud.imgVictoria, x, y)

    love.graphics.setFont(love.graphics.newFont(10))
    love.graphics.setColor(0.13,0,0.20)
    love.graphics.printf(" Pero quedaste solito ", 0, ventana.alto/2 + 30, ventana.ancho, "center")
    love.graphics.setColor(1, 1, 1)
end

--  sin escalar (osea afuera del canvas)
function hud.dibujarFPS()
    love.graphics.print("  FPS ".. love.timer.getFPS(), 360, 10)
end