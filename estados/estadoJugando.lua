    EstadoJugando = Class {__includes = Estado}

    function EstadoJugando:init()
    
    sonidoColision = love.audio.newSource("assets/colision.ogg", "static")
    sonidoFon = love.audio.newSource("assets/samplfondo.ogg", "stream")
    sonidoFon:setLooping(true)
    sonidoFon:setVolume(0.1)
    love.audio.play(sonidoFon)
    
    mapa = STI ("mapa/escena1.lua")
--
--     self.debugCapas = {}
-- local function listarCapas(layers, prefijo)
--     prefijo = prefijo or ""
--     for _, capa in ipairs(layers) do
--         table.insert(self.debugCapas, prefijo .. capa.name .. " (tipo: " .. capa.type .. ")")
--         if capa.type == "group" and capa.layers then
--             listarCapas(capa.layers, prefijo .. "  ")
--         end
--     end
-- end
-- listarCapas(mapa.layers)
-- ---
    
    mundobump = BUMP.newWorld(8)
    
    self.enemigos = {}
  
    self.jugador = Jugador(20, 20, mundobump)
    
    self.jugador:Cargar()
    hud.cargar()
         
    self.debugEntidades = {}

-- Instanciar elementos de Capas de tiled
if mapa.layers["entidades"] then
    for _, obj in ipairs(mapa.layers["entidades"].objects) do
        table.insert(self.debugEntidades, string.format("'%s' x=%d y=%d", tostring(obj.name), obj.x, obj.y))

        if obj.name == "Cactusa" then
            table.insert(self.enemigos, Cactusa(obj.x, obj.y, "assets/cactusa.png", 2, 6, mundobump))
        elseif obj.name == "Enemigo" then
            table.insert(self.enemigos, Enemigo(obj.x, obj.y, "assets/edo-sheet.png", 2, 2, mundobump))
        elseif obj.name == "Enemigo2" then
            table.insert(self.debugEntidades, ">>> entrando a Enemigo2")
            table.insert(self.enemigos, Enemigo(obj.x, obj.y, "assets/ada.png", nil, nil, mundobump))
            table.insert(self.debugEntidades, ">>> Enemigo2 insertado, total: " .. #self.enemigos)
        elseif obj.name == "ZorzalNPC" then
            table.insert(self.enemigos, ZorzalNpc(obj.x, obj.y, "assets/ada2.png"))
        end
    end

end
    
if mapa.layers["paredes"] then
    for _,obj in ipairs(mapa.layers["paredes"].objects) do
        obj.esPared = true
        mundobump:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end

if mapa.layers["caida"] then
    --print(mapa.layers["caida"].objects) 
    for _, obj in ipairs(mapa.layers["caida"].objects) do
        obj.esPozo = true
        mundobump:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end



local mapaAnchoPx = mapa.width * mapa.tilewidth
local mapaAltoPx = mapa.height * mapa.tileheight


camara = CAM()
    
end

    function EstadoJugando:actualizar(dt)
        
          if not self.jugador.vivo then
            MaqEstadoGlobal:cambiar("perder")
        return 
    end
  


    self.jugador:Actualizar(dt, self.enemigos)

    camara:lookAt(self.jugador.posX,self.jugador.posY)
    
clampCamara(camara, mapa.width * mapa.tilewidth, mapa.height * mapa.tileheight, ventana.ancho, ventana.alto)
  
    for _, e in ipairs(self.enemigos) do
    e:ActualizarEmpuje(dt)
    e:ActualizarAnimacion(dt)

    if e.vivo and e:EnPozo() then
        e.vivo = false
    end
end

if self.jugador:EnPozo() then
    self.jugador.vivo = false
    --print("perdiste")
    MaqEstadoGlobal:cambiar("perder")
    return
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
    --self.jugador:Debug() ----------------

    for _, e in ipairs(self.enemigos) do
        e:Dibujar()
        --e:Debug() ----------------------
    end
    
    -- Debug hitboxes de paredes
    -- love.graphics.setColor(1, 0, 0) -- para diferenciar de jugador/enemigos
    -- if mapa.layers["paredes"] then
    --     for _, obj in ipairs(mapa.layers["paredes"].objects) do
    --         love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height)
    --     end
    -- end

    -- love.graphics.setColor(1, 1, 1) -- resetear color

    
    hud.dibujarControles(ventana)   
    camara:detach()

    -- Debug en pantalla de instancias de enemigos
-- for i, linea in ipairs(self.debugEntidades or {}) do
--     love.graphics.print(linea, 10, 10 + (i-1) * 12)
-- end

    -- Debug en pantalla (fuera del canvas chico
-- for i, linea in ipairs(self.debugCapas) do
--     love.graphics.print(linea, 10, 30 + (i-1) * 12)
-- end

    hud.dibujarVidas(self.jugador.vidas)

   love.graphics.setCanvas()
   love.graphics.draw(lienzo,0,0,0,ventana.escala,ventana.escala)

    
    

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
    end
end

function EstadoJugando:reiniciar()
    self.jugador:Reiniciar()
    for _, e in ipairs(self.enemigos) do
        e:Reiniciar()
    end
end