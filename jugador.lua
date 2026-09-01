Jugador = {}
Jugador.__index = Jugador

-- =================== INICIALIZACION ===================
function Jugador:Nuevo(x, y)
    local o = setmetatable({}, Jugador)

    o.tex = nil
    o.tex2 = nil

    o.posX = x
    o.posY = y
    o.spawnX = x
    o.spawnY = y

    o.alto = 8
    o.ancho = 8
    o.origY = 4
    o.origX = 4
    o.hBoxX = 0
    o.hBoxY = 0

    o.dirX = 0
    o.dirY = -1

    o.paso = 8

    o.dashDuracion = 0.2
    o.dashVel = 150
    o.dasheando = false
    o.dashTiempo = 0

    o.dashCooldown = 2.5
    o.cooldownTiempo = 0   -- contador del cooldown
    o.enCooldown = false   -- esperando?

    o.vivo = true
    o.vidas = 3

    return o
end

function Jugador:Cargar()
    self.tex = love.graphics.newImage("jugador.png")
    self.tex2 = love.graphics.newImage("uda2.png")
end

-- =================== REINICIAR ===================
function Jugador:Reiniciar()
    self.posX = self.spawnX
    self.posY = self.spawnY
    self.dirX = 0
    self.dirY = -1

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY

    self.dasheando = false
    self.dashTiempo = 0
    self.enCooldown = false
    self.cooldownTiempo = 0

    self.vivo = true
    self.vidas = 3
end

-- =================== ACTUALIZACION ===================
function Jugador:Actualizar(dt, enemigosInteractivos)
    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY

    -- Cooldown del dash
    if self.enCooldown then
        self.cooldownTiempo = self.cooldownTiempo + dt
        if self.cooldownTiempo >= self.dashCooldown then
            self.enCooldown = false
            self.cooldownTiempo = 0
        end
    end

    -- Dash en curso
    if self.dasheando then
        self.posX = self.posX + self.dirX * self.dashVel * dt
        self.posY = self.posY + self.dirY * self.dashVel * dt

        self.hBoxX = self.posX - self.origX
        self.hBoxY = self.posY - self.origY

        -- chequeo de choque contra cada enemigo interactivo mientras dasheo
        for _, e in ipairs(enemigosInteractivos) do
            if chequearColision(self.hBoxX, self.hBoxY, self.ancho, self.alto,
                                 e.hBoxX, e.hBoxY, e.ancho, e.alto) then
                e:Empujar(self.dirX, self.dirY)
            end
        end

        self.dashTiempo = self.dashTiempo + dt
        if self.dashTiempo >= self.dashDuracion then
            self.dasheando = false
            self.dashTiempo = 0
            self.enCooldown = true

            -- el dash cuenta como turno: los enemigos se mueven al terminar
            enemigo1:MoverTurno(self.posX, self.posY)
            enemigo2:MoverTurno(self.posX, self.posY)
            enemigo3:MoverTurno(self.posX, self.posY)
            enemigo5:MoverTurno(self.posX, self.posY)

            self:ChequearDanio(enemigosInteractivos)
        end
        return
    end

    -- Inicio de dash
    if love.keyboard.isDown("d") and not self.dasheando and not self.enCooldown
       and (self.dirX ~= 0 or self.dirY ~= 0) then
        self.dasheando = true
    end
end

--  MOVER (por paso)
function Jugador:Mover(dx, dy)
    self.dirX = dx
    self.dirY = dy

    self.posX = self.posX + dx * self.paso
    self.posY = self.posY + dy * self.paso

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY
end

-- Chequear DAÑO
function Jugador:ChequearDanio(enemigosInteractivos)
    if self.dasheando then
        return -- la idea es que en el dash no recibe daño
    end

    local golpeado = false

    for _, e in ipairs(enemigosInteractivos) do
        if e.vivo and chequearColision(self.hBoxX, self.hBoxY, self.ancho, self.alto,
                                        e.hBoxX, e.hBoxY, e.ancho, e.alto) then
            golpeado = true
        end
    end

    if golpeado then
        sonidoColision:play()
        self.vidas = self.vidas - 1
        if self.vidas <= 0 then
            self.vivo = false
        end
    end
end

-- =================== RENDERIZADO ===================
function Jugador:Dibujar()
    if self.dasheando then
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.draw(self.tex2, self.posX, self.posY, 0, 1.5, 1.5, self.origX, self.origY)
    end
    if self.enCooldown then
        love.graphics.setColor(1, 0.5, 0.5, 0.3)
    end
    love.graphics.draw(self.tex, self.posX, self.posY, 0, 1, 1, self.origX, self.origY)
    love.graphics.setColor(1, 1, 1) -- resetear color siempre después
end

-- =================== DEPURAR ===================
function Jugador:Debug()
    love.graphics.rectangle("line", redondear(self.hBoxX), redondear(self.hBoxY), self.ancho, self.alto)
    love.graphics.print("Pos Jugador X"..self.posX, 10, 10)
    love.graphics.print("Y "..self.posY, 15, 20)
    love.graphics.print("Vidas: "..self.vidas, 10, 30)
end

-- Funcion de Chequear Colision
function chequearColision(x1, y1, ancho1, alto1, x2, y2, ancho2, alto2)
    return x1 < x2 + ancho2 and
           x2 < x1 + ancho1 and
           y1 < y2 + alto2 and
           y2 < y1 + alto1
end