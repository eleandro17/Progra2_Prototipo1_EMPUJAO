    EstadoJugando = Class {__includes = Estado}

    function EstadoJugando:init()
    
    sonidoColision = love.audio.newSource("assets/colision.ogg", "static")
    sonidoFon = love.audio.newSource("assets/samplfondo.ogg", "stream")
    sonidoFon:setLooping(true)
    sonidoFon:setVolume(0.1)
    love.audio.play(sonidoFon)
    
    mapa = STI ("mapa/escena1.lua")
    mundobump = BUMP.newWorld(8)
    
    self.enemigos = {}
  
    self.jugador = Jugador(20, 20, mundobump)
    
    self.jugador:Cargar()
    hud.cargar()
            
    table.insert(self.enemigos, Cactusa(30, 90, "assets/cactusa.png", 2, 6, mundobump))      
    table.insert(self.enemigos, Enemigo(80, 100, "assets/edo-sheet.png", 2, 2, mundobump))     
    table.insert(self.enemigos, Enemigo(130, 72, "assets/ada.png", nil, nil, mundobump))        
    table.insert(self.enemigos, Cactusa(100, 30, "assets/cactusa.png", 2, 3, mundobump))       
    table.insert(self.enemigos, ZorzalNpc(100, 100, "assets/ada2.png"))       
    
    

    

if mapa.layers["paredes"] then
    for _,obj in ipairs(mapa.layers["paredes"].objects) do
        obj.esPared = true
        mundobump:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end

local mapaAnchoPx = mapa.width * mapa.tilewidth
local mapaAltoPx = mapa.height * mapa.tileheight

limites = {
    minX = 8, maxX = mapaAnchoPx - 8,
    minY = 8, maxY = mapaAltoPx - 8
}

camara = CAM()
    
end

function EstadoJugando:reiniciar()
    self.jugador:Reiniciar()

    for _, e in ipairs(self.enemigos) do
        e:Reiniciar()
    end

    hasGanao = false
end

    function EstadoJugando:actualizar(dt)
        
          if not self.jugador.vivo then
            MaqEstadoGlobal:cambiar("perder")
        return -- si ya murió, no actualizo  más
    end
  


    self.jugador:Actualizar(dt, self.enemigos)

    camara:lookAt(self.jugador.posX,self.jugador.posY)
    
clampCamara(camara, mapa.width * mapa.tilewidth, mapa.height * mapa.tileheight, ventana.ancho, ventana.alto)

    for _, e in ipairs(self.enemigos) do
        e:ActualizarEmpuje(dt)
        e:ActualizarAnimacion(dt) -- no hace nada si el enemigo no tiene animación configurada

        if e.vivo and enPozo(e.posX, e.posY) then
            e.vivo = false
        end
    end

    
    if enPozo(self.jugador.posX, self.jugador.posY) then
        self.jugador.vivo = false
        MaqEstadoGlobal:cambiar("perder")
    end

    -- Condicion de VIctoria
    local quedanEnemigosVivos = false
    for _, e in ipairs(self.enemigos) do
        if e.esInteractivo and e.vivo then
            quedanEnemigosVivos = true
        end
    end

    if not quedanEnemigosVivos then
        MaqEstadoGlobal:cambiar("ganar")
    end
end

   function EstadoJugando:dibujar()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()
    
    camara:attach(0,0,ventana.ancho,ventana.alto)
    
    mapa:drawLayer(mapa.layers["piso"])
    self.jugador:Dibujar()
    self.jugador:Debug()

    for _, e in ipairs(self.enemigos) do
        e:Dibujar()
        e:Debug() ----------------------
    end
    
    -- Debug hitboxes de paredes
    love.graphics.setColor(1, 0, 0) -- para diferenciar de jugador/enemigos
    if mapa.layers["paredes"] then
        for _, obj in ipairs(mapa.layers["paredes"].objects) do
            love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height)
        end
    end

    love.graphics.setColor(1, 1, 1) -- resetear color

    hud.dibujarVidas(self.jugador.vidas)
   
    camara:detach()
    love.graphics.setCanvas()
    love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    
    --hud.dibujarControles(ventana)    

    hud.dibujarFPS()
end
    

function EstadoJugando:inputsJuego(key)
    if key == "r" then
        self:reiniciar()
        return
    end

    local dx, dy = 0, 0

    if key == "left" then dx = -1
    elseif key == "right" then dx = 1
    elseif key == "up" then dy = -1
    elseif key == "down" then dy = 1
    end

    if dx ~= 0 or dy ~= 0 then
        self.jugador:Mover(dx, dy)

        for _, e in ipairs(self.enemigos) do
            if e.esInteractivo and e.seMueve then
                e:MoverTurno(self.jugador.posX, self.jugador.posY)
            end
        end

        self.jugador:ChequearDanio(self.enemigos)
    end
end

function EstadoJugando:salir()
    if sonidoFon then
        sonidoFon:stop()
        --sonidoFon = nil
    end
end