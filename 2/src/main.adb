--Dame una soluci�n en Ada al siguiente problema: El Restaurante de los Solitarios es famoso para ser el �nico que solo tiene mesas individuales y d�nde todav�a se  puede fumar. El restaurante se encuentra dividido en X salones de N mesas cada uno de ellos. Como que ha habido quejas de algunos clientes por el humo de los clientes fumadores el amo del restaurante ha decidido establecer el siguiente protocolo: Cuando un cliente llega pide mesa al camarero indicando si es fumador o no y este intentar� darle mesa seg�n los siguientes criterios:


--no fumadores).

--queda restringido a este tipo de comensal. Esto ser� as� hasta que el sal�n quede vac�o.
--Al haber comido los cliente piden la cuenta al camarero que tiene en cuenta la tabla que ha quedado vac�a.
--Indicaciones:
--La simulaci�n se tiene que programar con el lenguaje Ada usando los Objetos protegidos como herramienta de
--sincron�a. Programar la simulaci�n descrita para 7 procesos fumador y 7 procesos no fumador

--La salida que tiene que generar la simulaci�n tiene que ser como la que se muestra en el siguiente ejemplo:
--++++++++++ El Camarero est� preparado
--Hay 3 salones con capacidad de 3 comensales cada uno
--BUEN D�A soy Trist�n y soy fumador
---------- Trist�n tiene mesa en el sal�n de fumadores 1. Disponibilidad: 2
--Trist�n dice: Tomar� el men� del d�a. Estoy en el sal�n 1
--BUEN D�A soy Pelayo y soy fumador
---------- Pelayo tiene mesa en el sal�n de fumadores 1. Disponibilidad: 1
--Pelayo dice: Tomar� el men� del d�a. Estoy en el sal�n 1
--BUEN D�A soy Sancho y soy No fumador

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with maitre_monitor; use maitre_monitor;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   NumClientsFumNoFum : constant Integer := 7;
   monitor : Monitor_Restaurante(NumSalones, NumMesasSalon);

   type cliente is record
      nom: Unbounded_String;
      tipoCliente: Integer;
   end record;

   type nombresArray is array (0..(NumClientsFumNoFum*2-1)) of Unbounded_String;

   nombres : constant nombresArray :=(
      to_Unbounded_String("Trist�n"),
      to_unbounded_string("Pelayo"),
      to_unbounded_string("Sancho"),
      to_unbounded_string("Borja"),
      to_unbounded_string("Bosco"),
      to_unbounded_string("Guzm�n"),
      to_unbounded_string("Froil�n"),
      to_unbounded_string("Nicol�s"),
      to_unbounded_string("Jacobo"),
      to_unbounded_string("Rodrigo"),
      to_unbounded_string("Gonzalo"),
      to_unbounded_string("JoseMari"),
      to_unbounded_string("Cayetano"),
      to_unbounded_string("Leopoldo")
      );

   task type clienteFum is
      entry Start (Nom : in Unbounded_String);
   end clienteFum;

   task type clienteNoFum is
      entry Start (Nom : in Unbounded_String);
   end clienteNoFum;


   task body clienteFum is
      MyNom : Unbounded_String;
      SalonCliente: Integer;
   begin
      accept Start (Nom : in Unbounded_String) do
         MyNom := Nom;
      end Start;
      Put_Line
           ("BUEN D�A soy " & To_String(MyNom) & " y soy fumador");
      --CRITICA

      monitor.FumLock(MyNom, SalonCliente);
      Put_Line("En " & To_String(MyNom) & " diu: Prendr� el men� del dia. Som al sal� " & Integer'Image(SalonCliente));
      delay 0.1;
      Put_Line
        ("En " & To_String(MyNom) & "diu: Ja he dinat, el compte per favor");
      Put_Line
        ("En " & To_String(MyNom) & " SE'N VA");
      monitor.sacarCliente(MyNom, SalonCliente);
   end clienteFum;


   task body clienteNoFum is
      MyNom : Unbounded_String;
      SalonCliente : Integer;
   begin
      accept Start (Nom : in Unbounded_String) do
         MyNom := Nom;
      end Start;

      Put_Line
           ("     BUEN D�A soy " & To_String(MyNom) & " y soy NO fumador");
      --Critico

      monitor.NoFumLock(MyNom, SalonCliente);

      Put_Line
        ("En " & To_String(MyNom) & " diu: Prendr� el men� del dia. Som al sal� " & Integer'Image(SalonCliente));
      delay 0.1;
      Put_Line
         ("     En " & To_String(MyNom) & " diu: Ja he dinat, el compte per favor");
      Put_Line
        ("     En " & To_String(MyNom) & " SE'N VA");
      monitor.sacarCliente(MyNom, SalonCliente);
   end clienteNoFum;


   type fumadors is array (0 .. NumClientsFumNoFum-1) of clienteFum;
   fum : fumadors;
   type noFumadors is array(0 .. NumClientsFumNoFum-1) of clienteNoFum;
   noFum : noFumadors;


begin
   --Principal--
   monitor.prepararMaitre;

   for Idx in 0 .. (NumClientsFumNoFum-1) loop
      fum (Idx).Start(nombres(Idx));
      noFum (Idx).Start(nombres(Idx+NumClientsFumNoFum));
   end loop;

end Main;



--------------------------
