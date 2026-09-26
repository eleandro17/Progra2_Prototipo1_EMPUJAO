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

    hud.dibujarControles(ventana)  

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

     
end

function EstadoMenu:inputsJuego(key)
    if key == "return" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end