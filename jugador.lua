-- =================== DECLARACION ===================
-- Jugador
jugador= {

    tex = nil,
    tex2 = nil,
    posX= 20,
    posY= 20,
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
    jugador.tex2 = love.graphics.newImage("uda.png")
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

    -- chequeo de choque contra cada enemigo mientras dasheo
    if chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                         enemigo1.hBoxX, enemigo1.hBoxY, enemigo1.ancho, enemigo1.alto) then
        enemigo1:Empujar(jugador.dirX, jugador.dirY)
    end
    if chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                         enemigo2.hBoxX, enemigo2.hBoxY, enemigo2.ancho, enemigo2.alto) then
        enemigo2:Empujar(jugador.dirX, jugador.dirY)
    end
    if chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                         enemigo3.hBoxX, enemigo3.hBoxY, enemigo3.ancho, enemigo3.alto) then
        enemigo3:Empujar(jugador.dirX, jugador.dirY)
    end
    if chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                         enemigo5.hBoxX, enemigo5.hBoxY, enemigo5.ancho, enemigo5.alto) then
        enemigo5:Empujar(jugador.dirX, jugador.dirY)
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

            jugador.chequearDanio()
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
function jugador.chequearDanio()
    if jugador.dasheando then
        return -- la idea es que en el dash no recibe daño
    end

    local golpeado = false

    if enemigo1.vivo and chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                           enemigo1.hBoxX, enemigo1.hBoxY, enemigo1.ancho, enemigo1.alto) then
        golpeado = true
    end
    if enemigo2.vivo and chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                           enemigo2.hBoxX, enemigo2.hBoxY, enemigo2.ancho, enemigo2.alto) then
        golpeado = true
    end
    if enemigo3.vivo and chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                           enemigo3.hBoxX, enemigo3.hBoxY, enemigo3.ancho, enemigo3.alto) then
        golpeado = true
    end
    if enemigo3.vivo and chequearColision(jugador.hBoxX, jugador.hBoxY, jugador.ancho, jugador.alto,
                                           enemigo5.hBoxX, enemigo5.hBoxY, enemigo5.ancho, enemigo5.alto) then
        golpeado = true
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
    love.graphics.setColor(1,0,0,0.7)
    love.graphics.draw(jugador.tex2, jugador.posX, jugador.posY, 0, 0.5, 0.5, jugador.origX, jugador.origY)
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