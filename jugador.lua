

Jugador = Class{}

-- =================== INICIALIZACION ===================
function Jugador:init(x, y, mundobump)
   
    self.tex = nil
    self.tex2 = nil

    self.posX = x
    self.posY = y
    self.spawnX = x
    self.spawnY = y

    self.anteriorX = self.posX
    self.anteriorY = self.posY

    self.alto = 8
    self.ancho = 8
    self.origY = 4
    self.origX = 4
    self.hBoxX = 0
    self.hBoxY = 0

    self.dirX = 0
    self.dirY = -1

    self.paso = 8

    self.dashDuracion = 0.2
    self.dashVel = 150
    self.dasheando = false
    self.dashTiempo = 0

    self.dashCooldown = 2.5
    self.cooldownTiempo = 0   -- contador del cooldown
    self.enCooldown = false   -- esperando?

    self.vivo = true
    self.vidas = 3

    self.mundobump = mundobump
    self.mundobump:add(self, self.hBoxX,self.hBoxY,self.ancho,self.alto)
end

function Jugador:Cargar()
    self.tex = love.graphics.newImage("assets/jugador.png")
    self.tex2 = love.graphics.newImage("assets/uda2.png")
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
function Jugador:Actualizar(dt, enemigos)
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
        if self.mundobump then
            self.mundobump:update(self, self.hBoxX, self.hBoxY, self.ancho, self.alto)
        end

        -- chequeo de choque contra cada enemigo interactivo mientras dasheo
        for _, e in ipairs(enemigos) do
            if self:Colision(e) then
                e:Empujar(self.dirX, self.dirY)
            end
        end

        self.dashTiempo = self.dashTiempo + dt
        if self.dashTiempo >= self.dashDuracion then
            self.dasheando = false
            self.dashTiempo = 0
            self.enCooldown = true

            -- el dash cuenta como turno: los enemigos se mueven al terminar
            
            for _, e in ipairs(enemigos) do
                if e.esInteractivo and e.seMueve then
                e:MoverTurno(self.posX, self.posY)
                end
            end

            self:ChequearDanio(enemigos)
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

    local prevX, prevY = self.posX, self.posY -- posición justo antes de este movimiento

    self.posX = self.posX + dx * self.paso
    self.posY = self.posY + dy * self.paso

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY

    self.mundobump:update(self, self.hBoxX, self.hBoxY, self.ancho, self.alto)

    if self:ChocaPared() then
        self.posX, self.posY = prevX, prevY
        self.hBoxX = self.posX - self.origX
        self.hBoxY = self.posY - self.origY
        self.mundobump:update(self, self.hBoxX, self.hBoxY, self.ancho, self.alto)
    end
end
-- Chequear DAÑO
function Jugador:ChequearDanio(enemigos)
    if self.dasheando then return end

    local golpeado = false
    for _, e in ipairs(enemigos) do
        if e.esInteractivo and e.vivo and self:Colision(e) then
            golpeado = true
        end
    end

    if golpeado then
        sonidoColision:play()
        self.vidas = self.vidas - 1
        if self.vidas <= 0 then self.vivo = false end
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



function Jugador:Colision(otro)
    local hBoxes, cant = self.mundobump:queryRect(self.hBoxX, self.hBoxY, self.ancho, self.alto)
    for i = 1, cant do
        if hBoxes[i] == otro then
            return true
        end
    end
    return false
end

function Jugador:ChocaPared()
    local hBoxes, cant = self.mundobump:queryRect(self.hBoxX, self.hBoxY, self.ancho, self.alto)
    for i = 1, cant do
        if hBoxes[i].esPared then
            return true
        end
    end
    return false
end