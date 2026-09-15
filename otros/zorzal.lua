ZorzalNpc = Class{__includes = Enemigo}

function ZorzalNpc:init (x,y,img)
Enemigo.init(self,x,y,img)
self.esInteractivo = false
self.seMueve = false

-- function ZorzalNpc:MoverTurno(jugadorX, jugadorY)
--     -- no hace nada
end