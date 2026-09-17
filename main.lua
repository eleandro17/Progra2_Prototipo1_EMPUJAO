require "dependencias"


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


MaqEstadoGlobal = MaqEstados{
    ["jugando" ] = function() return EstadoJugando() end,
    ["ganar"] = function() return EstadoGanar() end,
    ["perder"] = function() return EstadoPerder() end,
    ["menu"] = function() return EstadoMenu() end
}

--MaqEstadoGlobal:cambiar("jugando")

function enPozo(x, y)
    return x < limites.minX or x > limites.maxX or y < limites.minY or y > limites.maxY
end


-- =================== INICIALIZACION ===================
function love.load()
    love.window.setMode(ventana.ancho* ventana.escala, ventana.alto *ventana.escala)
    love.graphics.setDefaultFilter("nearest","nearest")
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    hud.cargar()
    
    MaqEstadoGlobal:cambiar("menu") 
    
    end


-- =================== INTERACCION ===================
function love.keypressed(key)
    if key == "escape" then
        MaqEstadoGlobal:cambiar("menu")
        return
    end

    if MaqEstadoGlobal.actual.inputsJuego then
        MaqEstadoGlobal.actual:inputsJuego(key)
    end
end
-- =================== ACTUALIZACION ===================
function love.update(dt)
    MaqEstadoGlobal.actual:actualizar(dt)

end
       


-- =================== RENDERIZADO ===================
function love.draw()

MaqEstadoGlobal.actual:dibujar()    
    
end