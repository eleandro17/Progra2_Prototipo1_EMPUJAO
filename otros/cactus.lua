Cactusa = Class{__includes = Enemigo}

function Cactusa:init(x, y, img, frames, velocidadAnim, mundobump)
    Enemigo.init(self, x, y, img, frames, velocidadAnim, mundobump)
    self.seMueve = false
end

function Cactusa:Dibujar()
    if not self.vivo then return end
    love.graphics.draw(self.tex, self.animCuadros[self.animActual],
        redondear(self.posX), redondear(self.posY), 0, 1, 1, self.origX, self.origY)
end