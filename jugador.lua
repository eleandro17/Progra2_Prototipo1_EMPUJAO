-- =================== DECLARACION ===================
-- Jugador
jugador= {

    tex = nil,
    tex2 = nil,
    posX= 20,
    posY= 20,
    spawnX = 20,
    spawnY = 20,
    vel= 25,
    alto=8,
    ancho=8,
    origY=4,
    origX=4,
    hBoxX=0,
    hBoxY=0,

    dirX = 0, dirY = -1,

    paso = 8,

    dashDuracion= 0.2,
    dashVel=150;
    dasheando=false,
    dashTiempo = 0,

    dashCooldown = 2.5,   
    cooldownTiempo = 0,   -- contador del cooldown
    enCooldown = false,    -- esperando?

    vivo = true,
    vidas = 3
}
-- =================== INICIALIZACION = ==================
function jugador.cargar()
    jugador.tex = love.graphics.newImage("jugador.png")
    jugador.tex2 = love.graphics.newImage("uda2.png")
end

-- =================== REINICIAR ===================
function jugador.reiniciar()
    jugador.posX = jugador.spawnX
    jugador.posY = jugador.spawnY
    jugador.dirX = 0
    jugador.dirY = -1

    jugador.hBoxX = jugador.posX - jugador.origX
    jugador.hBoxY = jugador.posY - jugador.origY

    jugador.dasheando = false
    jugador.dashTiempo = 0
    jugador.enCooldown = false
    jugador.cooldownTiempo = 0

    jugador.vivo = true
    jugador.vidas = 3
end

--ACTUALIZACION

function jugador.actualizar(dt)
    jugador.hBoxX = jugador.posX - jugador.origX
    jugador.hBoxY = jugador.posY - jugador.origY

    -- Cooldown del dash
    if jugador.enCooldown then
        jugador.cooldownTiempo = jugador.cooldownTiempo + dt
        if jugador.cooldownTiempo >= jugador.dashCooldown then
            jugador.enCooldown = false
            jugador.cooldownTiempo = 0
        end
    end

    -- Dash en curso
    if jugador.dasheando then
        jugador.posX = jugador.posX + jugador.dirX * jugador.dashVel * dt
        jugador.posY = jugador.posY + jugador.dirY * jugador.dashVel * dt
        
        jugador.hBoxX = jugador.posX - jugador.origX
        jugador.hBoxY = jugador.posY - jugador.origY

    -- chequeo de choque contra cada enemigo interactivo mientras dasheo
    for _, e in ipairs(enemigosInteractivos) do
        if chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                             e.hBoxX, e.hBoxY, e.ancho, e.alto) then
            e:Empujar(jugador.dirX, jugador.dirY)
        end
    end
    
    jugador.dashTiempo = jugador.dashTiempo + dt
        if jugador.dashTiempo >= jugador.dashDuracion then
            jugador.dasheando = false
            jugador.dashTiempo = 0
            jugador.enCooldown = true

                        -- el dash cuenta como turno: los enemigos se mueven al terminar
            enemigo1:MoverTurno(jugador.posX, jugador.posY)
            enemigo2:MoverTurno(jugador.posX, jugador.posY)
            enemigo3:MoverTurno(jugador.posX, jugador.posY)

            enemigo5:MoverTurno(jugador.posX, jugador.posY)

            jugador.chequearDanio(enemigosInteractivos)
        end
        return
    end

    -- Inicio de dash
    if love.keyboard.isDown("d") and not jugador.dasheando and not jugador.enCooldown
       and (jugador.dirX ~= 0 or jugador.dirY ~= 0) then
        jugador.dasheando = true
    end
end

--  MOVER (por paso) 
function jugador.mover(dx, dy)
    jugador.dirX = dx
    jugador.dirY = dy

    jugador.posX = jugador.posX + dx * jugador.paso
    jugador.posY = jugador.posY + dy * jugador.paso

    jugador.hBoxX = jugador.posX - jugador.origX
    jugador.hBoxY = jugador.posY - jugador.origY
end

-- Chequear DAÑO
function jugador.chequearDanio(enemigosInteractivos)
    if jugador.dasheando then
        return -- la idea es que en el dash no recibe daño
    end

    local golpeado = false

    for _, e in ipairs(enemigosInteractivos) do
        if e.vivo and chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                        e.hBoxX, e.hBoxY, e.ancho, e.alto) then
            golpeado = true
        end
    end

    if golpeado then
        sonidoColision:play()
        jugador.vidas = jugador.vidas - 1
        if jugador.vidas <= 0 then
            jugador.vivo = false
        end
    end
end
    
-- =================== RENDERIZADO ===================
function jugador.dibujar()
if jugador.dasheando then
    love.graphics.setColor(1,1,1,0.8)
    love.graphics.draw(jugador.tex2, jugador.posX, jugador.posY, 0, 1.5, 1.5, jugador.origX, jugador.origY)
end    
if jugador.enCooldown then
        love.graphics.setColor(1, 0.5, 0.5,0.3) 
    end
    love.graphics.draw(jugador.tex, jugador.posX, jugador.posY, 0, 1, 1, jugador.origX, jugador.origY)
    love.graphics.setColor(1, 1, 1) -- resetear color siempre después
end

-- Funcion de Chequear Colision
function chequearColision (x1,y1,ancho1,alto1,x2,y2,ancho2,alto2)
    return x1 < x2 + ancho2 and
            x2 < x1 + ancho1 and
            y1 < y2 + alto2 and
            y2 < y1 + alto1
end