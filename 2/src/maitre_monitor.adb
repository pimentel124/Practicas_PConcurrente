with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

--
 -- @author Alvaro Pimentel, Andreu Marquès Valerià
 -- @video
--

package body maitre_monitor is

   protected body Monitor_Restaurante is

      --colocamos el cliente en uno de los salones en función de su tipo y los salones disponibles
      entry ClientLock(nombre : in Unbounded_String; tipus : in Integer; SalonCliente : out Integer) when canEntry(0) or canEntry(1) is
         dispo : Integer;
         i : Integer;

      begin

         colocarCLiente(nombre, tipus, i);

         dispo := NumMesasSalon - salones(i).numClientes;

         SalonCliente := i+1;
         if tipus = 0 then
           Put_Line
              ("---------- En " & To_String(nombre) & " té taula al saló de fumadors " & SalonCliente'Image & ". Disponibilitat: " & dispo'Image);
         elsif tipus = 1 then
            Put_Line
              ("********** En " & To_String(nombre) & " té taula al saló de NO fumadors " & SalonCliente'Image & ". Disponibilitat: " & dispo'Image);
         end if;

      end ClientLock;

      --función que se encarga de asignar un salón a cada cliente
      procedure colocarCLiente(nombre : in Unbounded_String; tipus : in Integer; id : out Integer) is
         trobat : Boolean;

      begin
         trobat := False;

         --Recorremos todos los salones y comprobamos su disponibilidad
         for i in 0..(numSalones-1) loop
            if salones(i).Tipo = tipus then
               if salones(i).numClientes < NumMesasSalon then
                  if not trobat then
                     trobat := true;
                     salones(i).numClientes := salones(i).numClientes+1;
                     id := i;
                  end if;
               else
                  SalonAval(i) := false; -- si el salón está lleno, lo indicamos poniendo su indice en el array de salones disponibles en Falso
               end if;
              -- Si el salón está vacío
            elsif salones(i).Tipo = 2 and not trobat then
               trobat := true;
               salones(i).numClientes := salones(i).numClientes +1;
               salones(i).Tipo := tipus; --Asignamos el tipo de salón según el cliente que entra
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

                  canEntry(salones(i).Tipo) := true; --En caso de que ya haya un tipo de cliente en el salón, permitimos la entrada sólo a ese tipo de clientes
               end if;
            end if;
         end loop;
      end colocarCLiente;


      --función que saca a los clientes de los salones una vez han acabado
      procedure sacarCliente(nombre : in Unbounded_String; id : in Integer) is
         dispo : Integer;
         i : Integer;

      begin

         i := id -1;

         --Restamos 1 a la cantidad de clientes del salón y lo ponemos como disponible en caso de que no lo esté
         salones(i).numClientes := salones(i).numClientes -1;

         canEntry(salones(i).Tipo) := TRUE;
         SalonAval(i) := TRUE;

         --si el salón queda vacío, ponemos el tipo de salón a "ninguno".
         if salones(i).numClientes = 0 then
            salones(i).Tipo := 2;
         end if;

         dispo := NumMesasSalon - salones(i).numClientes;
         if salones(i).Tipo = 0 then
            Put_Line
              ("---------- En " & To_String(nombre) & " allibera una taula del saló" & Integer'Image(id) & ". Disponibilitat: " & Integer'Image(dispo) & " Tipus: " & To_String(TipoCliente(salones(i).Tipo)));
         elsif salones(i).Tipo = 1 then
            Put_Line
             ("********** En " & To_String(nombre) & " allibera una taula del saló" & Integer'Image(id) & ". Disponibilitat: " & Integer'Image(dispo) & " Tipus: " & To_String(TipoCliente(salones(i).Tipo)));
         end if;

      end sacarCliente;

      --Función que prepara todos los salones al principio de la ejecución del programa
      procedure prepararMaitre is
      begin

         canEntry(0) := TRUE;
         canEntry(1) := TRUE;

         SalonAval(0) := TRUE;
         SalonAval(1) := TRUE;
         SalonAval(2) := TRUE;

         for i in salones'Range loop
            salones(i).numClientes := 0;
            salones(i).Tipo := 2;
         end loop;
         Put_Line
           ("+++++++++ El Maître està preparat");
         Put_Line
           ("+++++++++ Hi ha " & numSalones'Image & " salons amb capacitat de " & Integer'Image(NumMesasSalon) & " comensals cada un");
      end prepararMaitre;

   end Monitor_Restaurante;

end maitre_monitor;
