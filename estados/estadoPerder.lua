EstadoPerder = Class{}

function EstadoPerder:init()
end

function EstadoPerder:ingresar(parametros)
end

function EstadoPerder:actualizar(dt)
end

function EstadoPerder:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.draw(texFondo, 0, 0, 0, 1, 1, 0, 0)

    hud.dibujarGameOver(ventana, sonidoFon)
    

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

    hud.dibujarFPS()

    hud.dibujarReinicio(ventana)
end

function EstadoPerder:inputsJuego(key)
    if key == "r" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end