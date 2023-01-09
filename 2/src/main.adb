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
      to_Unbounded_String("Tristán"),
      to_unbounded_string("Pelayo"),
      to_unbounded_string("Sancho"),
      to_unbounded_string("Borja"),
      to_unbounded_string("Bosco"),
      to_unbounded_string("Guzmán"),
      to_unbounded_string("Froilán"),
      to_unbounded_string("Nicolás"),
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
           ("BUEN DÍA soy " & To_String(MyNom) & " y soy fumador");
      --CRITICA

      monitor.FumLock(MyNom, SalonCliente);
      Put_Line("En " & To_String(MyNom) & " diu: Prendré el menú del dia. Som al saló " & Integer'Image(SalonCliente));
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
           ("     BUEN DÍA soy " & To_String(MyNom) & " y soy NO fumador");
      --Critico

      monitor.NoFumLock(MyNom, SalonCliente);

      Put_Line
        ("En " & To_String(MyNom) & " diu: Prendré el menú del dia. Som al saló " & Integer'Image(SalonCliente));
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
