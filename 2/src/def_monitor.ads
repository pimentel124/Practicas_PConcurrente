package def_monitor is

    protected type Fum_noFumMonitor is
      entry FumLock;
      procedure FumUnlock;
      entry NoFumLock;
      procedure NoFumUnlock;
    private
      fumadores : integer := 0;
      no_fumadores : boolean := false;
    end Fum_noFumMonitor;

end def_monitor;
