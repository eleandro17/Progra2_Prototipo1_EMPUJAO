EstadoMenu = Class{__includes = Estado}

function EstadoMenu:init()
end

function EstadoMenu:ingresar(parametros)
end

function EstadoMenu:actualizar(dt)
end

function EstadoMenu:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(1,0,0.80)
    love.graphics.printf(" MENÛ. Apretà ENTER para jugar ", 0, ventana.alto/2, ventana.ancho, "center")
    love.graphics.setColor(1, 1, 1)
    

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

    --hud.dibujarFPS()

    hud.dibujarControles(ventana)    
end

function EstadoMenu:inputsJuego(key)
    if key == "return" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end