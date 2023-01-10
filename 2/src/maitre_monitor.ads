with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

--
 -- @author Alvaro Pimentel, Andreu Marquès Valerià
 -- @video
--

package maitre_monitor is

   NumSalones : constant Integer := 3;
   NumMesasSalon : constant Integer := 3;

   type TipoSalon is (Vacio, Fumador, NoFumador);
   type Salon is record
      Tipo : Integer;
      numClientes : Integer;
   end record;

   type arrSalones is array (0..2) of Salon;
   type arrStings is array (0..2) of Unbounded_String;
   TipoCliente : constant arrStings := (To_Unbounded_String("Fumador"),
                                        To_Unbounded_String("NoFumador"),
                                        To_Unbounded_String("Ninguno"));
   type arrBoolEntry is array (0..1) of Boolean;
   type arrBoolSalones is array (0..2) of Boolean;

   protected type Monitor_Restaurante(numSalones: Integer; Capacidad: Integer) is
      entry ClientLock(nombre : in Unbounded_String; tipus : in Integer; SalonCliente : out Integer);
      procedure colocarCLiente(nombre : in Unbounded_String; tipus : in Integer; id : out Integer);
      procedure sacarCliente(nombre : in Unbounded_String; id : in Integer);
      procedure prepararMaitre;

   private
      canEntry : arrBoolEntry;
      SalonAval : arrBoolSalones;
      salones : arrSalones;
      TipoCli : arrStings := TipoCliente;

   end Monitor_Restaurante;


end maitre_monitor;
