    EstadoJugando = Class {__includes = Estado}

    function EstadoJugando:init()
    
    texFondo = love.graphics.newImage("assets/fondo.png")

    sonidoColision = love.audio.newSource("assets/colision.ogg", "static")
    sonidoFon = love.audio.newSource("assets/samplfondo.ogg", "stream")
    sonidoFon:setLooping(true)
    sonidoFon:setVolume(0.5)
    love.audio.play(sonidoFon)
    
    self.enemigos = {}
  
    self.jugador = Jugador(20, 20)
    
    self.jugador:Cargar()
    hud.cargar()
            
    table.insert(self.enemigos, Cactusa(30, 90, "assets/cactusa.png", 2, 6))
    table.insert(self.enemigos, Enemigo(80, 100, "assets/edo-sheet.png",2,2))
    table.insert(self.enemigos, Enemigo(130, 72, "assets/ada.png"))
    table.insert(self.enemigos, Cactusa(100, 30, "assets/cactusa.png", 2, 3))
    table.insert(self.enemigos, ZorzalNpc(100, 100, "assets/ada2.png"))

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
    --love.graphics.draw(texFondo, 0, 0,0,1,1,0,0)
    camara:attach(0,0,ventana.ancho,ventana.alto)
    --mapa:draw()
    mapa:drawLayer(mapa.layers["piso"])
    self.jugador:Dibujar()

    for _, e in ipairs(self.enemigos) do
        e:Dibujar()
    end

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