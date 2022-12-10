with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Restaurant is

   -- Tipos de datos
   type Salon_Status is (Vacio, Fumador, No_Fumador);
   type Salones is array (1..X) of Salon_Status;
   type Mesa is record
      Ocupado : Boolean;
      Cliente : Positive;
   end record;
   type Salon is record
      Mesas : array (1..N) of Mesa;
   end record;

   -- Variables globales
   Salones : array (1..X) of Salon;
   Cola_Fumadores : Queue;
   Cola_No_Fumadores : Queue;

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
               if Salones(I)'Salon_Status = Vacio or Salones(I)'Salon_Status = Fumador then
                  Salones_Disponibles := Salones_Disponibles + 1;
               end if;
            end loop;
            -- Si hay salones disponibles, asignar una mesa en uno de ellos
            if Salones_Disponibles > 0 then
               Mesa_Disponible := 0;
               for I in Salones'Range loop
                  if Salones(I)'Salon_Status = Vacio or Salones(I)'Salon_Status = Fumador then
                     for J in Salones(I)'Mesas'Range loop
                        if not Salones(I)'Mesas(J)'Ocupado then
                           Salones(I)'Mesas(J)'Ocupado := True;
                           Salones(I)'Mesas(J)'Cliente := Cliente;
                           Salones(I)'Salon_Status := Fumador;
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


