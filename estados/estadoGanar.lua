EstadoGanar = Class{}

function EstadoGanar:init()
end

function EstadoGanar:ingresar(parametros)-- para  agregarle algo en el futuro no tan lejano
end

function EstadoGanar:actualizar(dt)
end

function EstadoGanar:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    love.graphics.draw(texFondo, 0, 0, 0, 1, 1, 0, 0)

    hud.dibujarVictoria(ventana)
    --hud.dibujarReinicio(ventana)

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

    hud.dibujarFPS()
    hud.dibujarReinicio(ventana)
end

function EstadoGanar:inputsJuego(key)
    if key == "r" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end