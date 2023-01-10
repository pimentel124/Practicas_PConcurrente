with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with maitre_monitor; use maitre_monitor;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   --Numero de procesos Fumador/No Fumador
   NumClientsFumNoFum : constant Integer := 7;
   monitor : Monitor_Restaurante(NumSalones, NumMesasSalon);

   --Array con el nombre de los clientes
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

   --Declaramos las tareas
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

      --SC
      monitor.ClientLock(MyNom, 0, SalonCliente);

      Put_Line("En " & To_String(MyNom) & " diu: Prendré el menú del dia. Som al saló " & Integer'Image(SalonCliente));
      delay 0.1;

      Put_Line
        ("En " & To_String(MyNom) & " diu: Ja he dinat, el compte per favor");
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

      --SC
      monitor.ClientLock(MyNom, 1, SalonCliente);

      Put_Line
        ("En " & To_String(MyNom) & " diu: Prendré el menú del dia. Som al saló " & Integer'Image(SalonCliente));
      delay 0.1;
      Put_Line
         ("     En " & To_String(MyNom) & " diu: Ja he dinat, el compte per favor");
      Put_Line
        ("     En " & To_String(MyNom) & " SE'N VA");

      monitor.sacarCliente(MyNom, SalonCliente);
   end clienteNoFum;

   --Array de tareas de cada proceso
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
