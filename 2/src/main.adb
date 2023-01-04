--Dame una solución en Ada al siguiente problema: El Restaurante de los Solitarios es famoso para ser el único que solo tiene mesas individuales y dónde todavía se  puede fumar. El restaurante se encuentra dividido en X salones de N mesas cada uno de ellos. Como que ha habido quejas de algunos clientes por el humo de los clientes fumadores el amo del restaurante ha decidido establecer el siguiente protocolo: Cuando un cliente llega pide mesa al camarero indicando si es fumador o no y este intentará darle mesa según los siguientes criterios:


--no fumadores).

--queda restringido a este tipo de comensal. Esto será así hasta que el salón quede vacío.
--Al haber comido los cliente piden la cuenta al camarero que tiene en cuenta la tabla que ha quedado vacía.
--Indicaciones:
--La simulación se tiene que programar con el lenguaje Ada usando los Objetos protegidos como herramienta de
--sincronía. Programar la simulación descrita para 7 procesos fumador y 7 procesos no fumador

--La salida que tiene que generar la simulación tiene que ser como la que se muestra en el siguiente ejemplo:
--++++++++++ El Camarero está preparado
--Hay 3 salones con capacidad de 3 comensales cada uno
--BUEN DÍA soy Tristán y soy fumador
---------- Tristán tiene mesa en el salón de fumadores 1. Disponibilidad: 2
--Tristán dice: Tomaré el menú del día. Estoy en el salón 1
--BUEN DÍA soy Pelayo y soy fumador
---------- Pelayo tiene mesa en el salón de fumadores 1. Disponibilidad: 1
--Pelayo dice: Tomaré el menú del día. Estoy en el salón 1
--BUEN DÍA soy Sancho y soy No fumador

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
--with maitre_monitor; use maitre_monitor;

procedure Main is
   -- Tipos de datos
   MAX_Clients : constant Integer := 7;

   type cident is range 1..MAX_Clients;
   type Nom is new String(1..20);
   type TipoFumador is (Fumador, NoFumador);
   type Salon_Status is (Vacio, Fumador, No_Fumador);
   type Salones is array (1..3) of Salon_Status;
   type Mesa is record
      Ocupado : Boolean;
      Cliente : Positive;
   end record;
   type Salon is record
      Mesas : Mesa(1..3);
   end record;

   -- Variables globales
   --Salones : array (1..3) of Salon;
   Cola_Fumadores : Queue;
   Cola_No_Fumadores : Queue;

   task type clienteFum is
      entry Start (id : in cident);
      entry Join;
   end clienteFum;

   task type clienteNoFum is
      entry Start (id : in cident);
      entry Join;
   end clienteNoFum;


   task body clienteFum is
      MyId : cident;
      MyNom : Nom;
      MyTipoCliente : TipoFumador;
   begin
      accept Start (id : in cident) do
         MyId := id;
         MyNom := "Pepe";
         MyTipoCliente := Fumador;
         Put_Line
        (ASCII.HT & "BUEN DÍA soy Pepe y soy " & TipoFumador'Image(MyTipoCliente));
      end Start;

      accept Join do
         Put_Line
           (ASCII.HT & "Soc el babui SUD");
      end Join;
   end clienteFum;


   task body clienteNoFum is
      MyId : cident;
      MyNom : Nom;
      MyTipoCliente : TipoFumador;
   begin
      accept Start (id : in cident) do
         MyId := id;
         MyNom := "Pepe";
         MyTipoCliente := NoFumador;
         Put_Line
        ("BUEN DÍA soy y soy " & TipoFumador'Image (MyTipoCliente));
      end Start;

      accept Join do
         Put_Line
           (ASCII.HT & "Soc el babui SUD");
      end Join;

   end clienteNoFum;



   -- Monitor para controlar el acceso a las colas y salones
   protected type Restaurant_Monitor is
      entry Asignar_Mesa (Cliente : Positive; Fumador : Boolean);
      entry Pedir_Cuenta (Cliente : Positive);
   end Restaurant_Monitor;


   protected body Restaurant_Monitor is

      -- Función para asignar una mesa a un cliente
      function Asignar_Mesa (Cliente : Positive; Fumador : Boolean) return Natural is
         Salones_Disponibles : Natural;
         Mesa_Disponible : Natural;
      begin
         if Fumador then
            Salones_Disponibles := 0;
            -- Verificar cuántos salones para fumadores hay disponibles
            for I in Salones'Range loop
               if Salones(I).Salon_Status = Vacio or Salones(I).Salon_Status = Fumador then
                  Salones_Disponibles := Salones_Disponibles + 1;
               end if;
            end loop;
            -- Si hay salones disponibles, asignar una mesa en uno de ellos
            if Salones_Disponibles > 0 then
               Mesa_Disponible := 0;
               for I in Salones'Range loop
                  if Salones(I).Salon_Status = Vacio or Salones(I).Salon_Status = Fumador then
                     for J in Salones(I).Mesas'Range loop
                        if not Salones(I).Mesas(J).Ocupado then
                           Salones(I).Mesas(J).Ocupado := True;
                           Salones(I).Mesas(J).Cliente := Cliente;
                           Salones(I).Salon_Status := Fumador;
                           Mesa_Disponible := J;
                           exit;
                        end if;
                     end loop;
                  end if;
               end loop;
               return Mesa_Disponible;
            else
               -- Si no hay salones disponibles, agregar cliente a la cola de fumadores
               Cola_Fumadores.Enqueue (Cliente);
            end if;
        end if;
        end Asignar_Mesa;
   end Restaurant_Monitor;
  begin
      null;
end Main;



--------------------------
