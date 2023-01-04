package def_monitor is

    type TipoFumador is(Fumador, NoFumador);
    protected type Cliente is
         record
            Nombre : String(1..20);
            TipoCliente : TipoFumador;
    end Cliente;

end def_monitor;
