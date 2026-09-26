EstadoGanar = Class{__includes=Estado}

function EstadoGanar:init()
end

function EstadoGanar:ingresar(parametros)-- para  agregarle algo en el futuro no tan lejano. Puntaje tal vez?
end

function EstadoGanar:actualizar(dt)
end

function EstadoGanar:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()

    hud.dibujarVictoria(ventana)
    
    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)

    hud.dibujarFPS()
    
end

function EstadoGanar:inputsJuego(key)
    if key == "r" then
        MaqEstadoGlobal:cambiar("jugando")
    end
end