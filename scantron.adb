with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

procedure scantron is
    Input_File    : File_Type;
    no_q    : Natural;
    no_stud : Natural;
    value         : Natural;
    line : Unbounded_String;

    r2 : constant positive := 1000;
    subtype index is positive range 1..r2;
    type arr is array(index) of Natural;

    i : Natural;
    ans_key : arr;
begin

    i:= 1;
   Ada.Text_IO.Open (File => Input_File, Mode => Ada.Text_IO.In_File, Name => "rec.txt");

    Ada.Integer_Text_IO.Get (Input_File,no_q);
    Ada.Text_IO.put(Item => "no_q =>");
    Ada.Integer_Text_IO.Put (no_q);
    Ada.Text_IO.New_Line;
      
    Ada.Text_IO.put("Ans Keys =>");
 
   while i <no_q+1 loop
      Ada.Integer_Text_IO.Get (Input_File,value);
      Ada.Text_IO.New_Line;
      ans_key(i) := value;
      Ada.Integer_Text_IO.Put (ans_key(i));
      i:= i+1;
   end loop;

    Ada.Text_IO.New_Line;
    no_stud := 0;

    while not Ada.Text_IO.End_of_File(Input_File) loop
        line:= Ada.Strings.Unbounded.to_unbounded_string(Ada.Text_IO.get_line(Input_File));
        no_stud := no_stud +1;
    end loop;

    no_stud:= no_stud-1;
    Ada.Text_IO.put("Number of students =>");
    Ada.Integer_Text_IO.put(no_stud);
    
    Ada.Text_IO.Close (File => Input_File); 



end scantron;