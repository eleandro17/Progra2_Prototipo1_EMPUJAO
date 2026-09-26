EstadoGanar = Class{__includes=Estado}

function EstadoGanar:init()
    sonidoGanar = love.audio.newSource ( "assets/hasganao.ogg", "static")
    sonidoGanar:setVolume(0.5)
    sonidoGanar:play()
end

function EstadoGanar:ingresar(parametros)-- para  agregarle algo en el futuro no tan lejano
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

function EstadoGanar:salir()
    if sonidoGanar then
        sonidoGanar:stop()
    end
end