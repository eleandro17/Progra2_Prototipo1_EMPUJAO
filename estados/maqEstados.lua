MaqEstados = Class{}

function MaqEstados:init(estados)
    self.base={
        dibujar= function() end,
        actualizar= function() end,
        ingresar= function() end,
        salir= function() end,
    }

    self.estados = estados or {}
    self.actual = self.base

end

function MaqEstados:cambiar(nEstado)
    assert(self.estados[nEstado])
    self.actual:salir()
    self.actual = self.estados[nEstado]()
    
end
