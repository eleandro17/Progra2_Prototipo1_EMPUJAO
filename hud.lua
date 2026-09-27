---  HUD o  interfaz de mensajes: 

hud = {}

function hud.cargar()
    hud.imgGameOver = love.graphics.newImage("assets/gameover.png")
    hud.imgVictoria = love.graphics.newImage("assets/victoria.png")
    hud.imgVida = love.graphics.newImage("assets/vida.png")
    hud.imgControles = love.graphics.newImage("assets/controles.png")

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
    love.graphics.setColor(0.8, 0.5, 0.1)
    love.graphics.printf("(R)einiciar", 0, ventana.alto *2, ventana.ancho * 2, "center")
    love.graphics.setColor(1, 1, 1)
end

function hud.dibujarControles(ventana)
    if love.keyboard.isDown("c") then
        
        love.graphics.draw(hud.imgControles, 140, 110)
    end
end

function hud.dibujarGameOver(ventana, sonidoFon)
    local x = ventana.ancho/2 - hud.imgGameOver:getWidth()/2
    local y = ventana.alto/2 - hud.imgGameOver:getHeight()/2
    love.graphics.draw(hud.imgGameOver, x, y)
    --sonidoFon:stop()
end

function hud.dibujarVictoria(ventana)
    local x = ventana.ancho/2 - hud.imgVictoria:getWidth()/2
    local y = ventana.alto/2 - hud.imgVictoria:getHeight()/2
    love.graphics.draw(hud.imgVictoria, x, y)

    -- Dejo aca esto porque no quiero olvidarme y pienso retomar esta idea desde el diseño
    -- love.graphics.printf(" Pero quedaste solito ", 0, ventana.alto/2 + 30, ventana.ancho, "center")
   
end

--  sin escalar (osea afuera del canvas)
function hud.dibujarFPS()
    love.graphics.print("  FPS ".. love.timer.getFPS(), 360, 10)
end