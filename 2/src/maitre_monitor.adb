package body def_monitor is

   protected body Fum_noFumMonitor is
    entry FumLock when not writing is
    begin
      fumadores := fumadores + 1;
    end FumLock;

    procedure FumUnlock is
    begin
      fumadores := fumadores - 1;
    end FumUnlock;

    entry NoFumLock when (fumadores = 0) and (not writing) is
    begin
      writing := true;
    end NoFumLock;

    procedure NoFumUnlock is
    begin
      writing := false;
    end NoFumUnlock;

  end Fum_noFumMonitor;

end def_monitor;
