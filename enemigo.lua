Enemigo = {}
Enemigo.__index = Enemigo
-- =================== INICIALIZACION ===================
function Enemigo:Nuevo(x, y, img )
    local o = setmetatable({}, Enemigo)

    o.posX = x
    o.posY = y
    o.spawnX = x
    o.spawnY = y
    o.tex = love.graphics.newImage(img)
    o.ancho = o.tex:getWidth()
    o.alto  = o.tex:getHeight()
    o.origX = o.ancho / 2
    o.origY = o.alto / 2
    o.hBoxX = 0
    o.hBoxY = 0
   -- o.vel = v YA NO LO uso

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

     -- SALTO (solo animaciòn)
    o.saltoTiempo = 0
    o.saltoAltura = 6      -- qué tan alto "salta" en píxeles
    o.saltoVelocidad = 6   -- qué tan rápido salta
    o.saltoOffset = 0

    return o
end

-- =================== REINICIAR ===================
-- Resetea el estado a los valores de spawn, sin recargar la textura
-- ni recrear la instancia (evita generar entidades nuevas en runtime)
function Enemigo:Reiniciar()
    self.posX = self.spawnX
    self.posY = self.spawnY
    self.vivo = true

    self.empujado = false
    self.empujeTiempo = 0
    self.dirX = 0
    self.dirY = 0

    self.hBoxX = self.posX - self.origX
    self.hBoxY = self.posY - self.origY

    if self.animCuadros then
        self.animTiempo = 0
        self.animActual = 1
    end
end

-- MOVER POR TURNO 
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

-- EMPUJE (mas bien ser EMPUJAO)
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

    if self.animCuadros then
        love.graphics.draw(self.tex, self.animCuadros[self.animActual],
            redondear(self.posX), redondear(self.posY), 0, 1, 1, self.origX, self.origY)
    else
        love.graphics.draw(self.tex, redondear(self.posX), redondear(self.posY), 0, 1, 1, self.origX, self.origY)
    end
end


-- =================== DEPURAR ===================
function Enemigo:Debug()
    if not self.vivo then return end

    love.graphics.rectangle("line", redondear(self.hBoxX), redondear(self.hBoxY), self.ancho, self.alto)
    love.graphics.circle("fill", redondear(self.posX), redondear(self.posY), 1)

    love.graphics.print("Ancho: "..self.ancho.." Alto: "..self.alto, redondear(self.posX), redondear(self.posY) - 20)
    love.graphics.print("Frame: "..(self.animActual or "sin animar"), redondear(self.posX), redondear(self.posY) - 10)
end

function redondear(n)
    return math.floor(n + 0.5)
end

-- ANIMACION (se la asigno por instancia, no a todos) ========
function Enemigo:ConfigurarAnimacion(frames, velocidadAnim)
    self.animFrames = frames              -- cantidad de frames 
    self.animVelocidad = velocidadAnim or 6 -- frames por s
    self.animTiempo = 0
    self.animActual = 1

    local anchoFrame = self.tex:getWidth() / frames
    local altoFrame  = self.tex:getHeight()

    self.animCuadros = {}
    for i = 0, frames - 1 do
        self.animCuadros[i + 1] = love.graphics.newQuad(
            i * anchoFrame, 0, anchoFrame, altoFrame,
            self.tex:getDimensions()
        )
    end

    -- calculo de los origX/origY . (es el de 1 frame)
    self.origX = anchoFrame / 2
    self.origY = altoFrame / 2
    self.ancho = anchoFrame
    self.alto  = altoFrame
end

function Enemigo:ActualizarAnimacion(dt)
    if not self.vivo or not self.animCuadros then return end

    self.animTiempo = self.animTiempo + dt
    if self.animTiempo >= 1 / self.animVelocidad then
        self.animTiempo = 0
        self.animActual = self.animActual + 1
        if self.animActual > self.animFrames then
            self.animActual = 1
        end
    end
end