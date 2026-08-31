Enemigo = {}
Enemigo.__index = Enemigo
-- =================== INICIALIZACION ===================
function Enemigo:Nuevo(x, y, img, v )
    local o = setmetatable({}, Enemigo)

    o.posX = x
    o.posY = y
    o.tex = love.graphics.newImage(img)
    o.ancho = o.tex:getWidth()
    o.alto  = o.tex:getHeight()
    o.origX = o.ancho / 2
    o.origY = o.alto / 2
    o.hBoxX = 0
    o.hBoxY = 0
    o.vel = v

    o.paso= 8

    o.vivo = true

-- EMPUJAO    
-- esto serìa como el complementario del dash cuando hay interaccion
    o.empujado = false
    o.empujeVel = 500
    o.empujeDuracion = 0.3
    o.empujeTiempo = 0
    o.dirX = 0
    o.dirY = 0

    return o
end

-- =================== MOVER POR TURNO ===================
function Enemigo:MoverTurno(jugadorX, jugadorY)
    if not self.vivo then return end
    local dx, dy = 0, 0

    local distX = jugadorX - self.posX
    local distY = jugadorY - self.posY

    if math.abs(distX) > math.abs(distY) then
        dx = distX > 0 and 1 or -1
    else
        dy = distY > 0 and 1 or -1
    end

    self.posX = self.posX + dx * self.paso
    self.posY = self.posY + dy * self.paso

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY
end
-- =================== ACTUALIZAR ===================
function Enemigo:Actualizar(x, y, a, dt)

    if not self.vivo then return end

    -- Persecución
    local dist_x = math.abs(self.posX - x)
    local dist_y = math.abs(self.posY - y)

    if dist_x > dist_y then
        if dist_x > a then
            if self.posX < x then
                self.posX = self.posX + (self.vel * dt)
            elseif self.posX > x then
                self.posX = self.posX - (self.vel * dt)
            end
        end
    else
        if dist_y > a then
            if self.posY < y then
                self.posY = self.posY + (self.vel * dt)
            elseif self.posY > y then
                self.posY = self.posY - (self.vel * dt)
            end
        end
    end

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY
end

-- ========= EMPUJE (del dash) =====
function Enemigo:Empujar(dx, dy)
    if not self.empujado then
        self.empujado = true
        self.dirX = dx
        self.dirY = dy
        self.empujeTiempo = 0
    end
end

function Enemigo:ActualizarEmpuje(dt)

    if not self.vivo then return end

    if self.empujado then
        self.posX = self.posX + self.dirX * self.empujeVel * dt
        self.posY = self.posY + self.dirY * self.empujeVel * dt

        self.hBoxX = self.posX - self.origX
        self.hBoxY = self.posY - self.origY

        self.empujeTiempo = self.empujeTiempo + dt
        if self.empujeTiempo >= self.empujeDuracion then
            self.empujado = false
            self.empujeTiempo = 0
        end
    end
end
-- =================== RENDERIZADO ===================
function Enemigo:Dibujar()

    if not self.vivo then return end

    love.graphics.draw(self.tex, redondear(self.posX), redondear(self.posY), 0, 1, 1, self.origX, self.origY)
end

-- =================== DEPURAR ===================
function Enemigo:Debug()

    if not self.vivo then return end

    love.graphics.rectangle("line", redondear(self.hBoxX), redondear(self.hBoxY), self.ancho, self.alto)
    love.graphics.circle("fill", redondear(self.posX), redondear(self.posY), 1)
end

function redondear(n)
    return math.floor(n + 0.5)
end