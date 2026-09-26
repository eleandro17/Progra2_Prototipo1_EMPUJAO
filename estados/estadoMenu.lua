EstadoMenu = Class{__includes = Estado}

function EstadoMenu:init()
    texMenu = love.graphics.newImage("assets/menu.png")
end

function EstadoMenu:ingresar(parametros)
end

function EstadoMenu:actualizar(dt)
end

function EstadoMenu:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.draw(texMenu, 0, 0,0,1,1,0,0)

    -- love.graphics.setFont(love.graphics.newFont(20))
    -- love.graphics.setColor(1,0,3.90)
    -- love.graphics.printf(" ENTER empezar ", 0, ventana.alto/2, ventana.ancho, "center")
    -- love.graphics.setColor(1, 1, 1)
    

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

    hud.dibujarControles(ventana)    
end

function EstadoMenu:inputsJuego(key)
    if key == "return" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end