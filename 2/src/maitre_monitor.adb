with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body maitre_monitor is

   protected body Monitor_Restaurante is
      entry FumLock(nombre : in Unbounded_String; SalonCliente : out Integer) when canEntry(1) is
         dispo : Integer;
         i : Integer;

      begin

         colocarCLiente(nombre, 0, i);

         dispo := NumMesasSalon - salones(i).Capacidad;

         SalonCliente := i+1;
         Put_Line
           ("---------- En " & To_String(nombre) & " té taula al saló de fumadors " & SalonCliente'Image & ". Disponibilitat: " & dispo'Image);
      end FumLock;


    entry NoFumLock(nombre : in Unbounded_String; SalonCliente : out Integer) when NumSalones>0 is
         dispo : Integer;
         i : Integer;
      begin

         colocarCLiente(nombre, 1, i);

         dispo := NumMesasSalon - salones(i).Capacidad;

         SalonCliente := i+1;
         Put_Line
           ("********** En " & To_String(nombre) & "té taula al saló de NO fumadors " & SalonCliente'Image & ". Disponibilitat: " & dispo'Image);

      end NoFumLock;

      procedure colocarCLiente(nombre : in Unbounded_String; tipus : in Integer; id : out Integer) is
         trobat : Boolean;

      begin
         trobat := False;
         for i in 0..(numSalones-1) loop
            if salones(i).Tipo = tipus then
               if salones(i).Capacidad < NumMesasSalon then
                  if not trobat then
                     trobat := true;
                     salones(i).Capacidad := salones(i).Capacidad+1;
                     id := i;
                  end if;
               else
                  SalonAval(i) := false;
               end if;
            elsif salones(i).Tipo = 2 and not trobat then
               trobat := true;
               salones(i).Capacidad := salones(i).Capacidad +1;
               salones(i).Tipo := tipus;
               id := i;
            end if;
         end loop;

         trobat := False;
         canEntry(0) := False; -- bloqueamos acceso a fumadores y no fumadores
         canEntry(1) := False;
         for i in 0..(numSalones-1) loop
            if SalonAval(i) then -- verificamos si el salón está disponible
                 if salones(i).Tipo = 2 then -- si el salon está vacío
                  canEntry(0) := TRUE; --fumadores pueden entrar
                  canEntry(1) := TRUE; -- no fumadores pueden entrar
                 else
                  canEntry(salones(i).Tipo) := true;
                 end if;
            end if;
         end loop;
      end colocarCLiente;



      procedure sacarCliente(nombre : in Unbounded_String; id : in Integer) is
         dispo : Integer;
         i : Integer;

      begin
         i := id -1;

         salones(i).Capacidad := salones(i).Capacidad -1;

         canEntry(salones(i).Tipo) := TRUE;
         SalonAval(i) := TRUE;

         if salones(i).Capacidad = 0 then
            salones(i).Tipo := 2;
         end if;

         dispo := NumMesasSalon - salones(i).Capacidad;
         if salones(i).Tipo = 0 then
            Put_Line
              ("---------- En " & To_String(nombre) & " allibera una taula del saló" & Integer'Image(id) & ". Disponibilitat: " & Integer'Image(dispo) & " Tipus: " & To_String(TipoCliente(salones(i).Tipo)));
         elsif salones(i).Tipo = 1 then
            Put_Line
             ("********** En " & To_String(nombre) & " allibera una taula del saló" & Integer'Image(id) & ". Disponibilitat: " & Integer'Image(dispo) & " Tipus: " & To_String(TipoCliente(salones(i).Tipo)));
         end if;

      end sacarCliente;

      procedure prepararMaitre is
      begin
         canEntry(0) := TRUE;
         canEntry(1) := TRUE;

         SalonAval(0) := TRUE;
         SalonAval(1) := TRUE;
         SalonAval(2) := TRUE;

         for i in salones'Range loop
            salones(i).Capacidad := 0;
            salones(i).Tipo := 2;
         end loop;
         Put_Line
           ("+++++++++ El Maître està preparat");
         Put_Line
           ("+++++++++ Hi ha " & numSalones'Image & " salons amb capacitat de " & Integer'Image(NumMesasSalon) & " comensals cada un");
      end prepararMaitre;

   end Monitor_Restaurante;

end maitre_monitor;
