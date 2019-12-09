with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;  


procedure scantron is
    ip_file    : File_Type;
    no_q    : Natural;
    no_stud : Natural;
    value         : Natural;
    line : Unbounded_String;

    max : constant Integer:= 50;
    r2 : constant positive := 1000;
    subtype index is positive range 1..r2;
    type arr is array(index) of Natural;

    i : Natural;
    ans_key : arr;


--===============================      Reading File Procedure       =================================  

procedure read_ans(File : out Ada.Text_IO.File_Type) is

f_name: String(1 .. max);
Length : Integer range 0 .. max;

begin
get_line(Item => f_name, Last => Length);
   if Length = max then
      skip_line;
   end if;

i:= 1;

    Open (File => File, Name => f_name(1..Length),Mode => Ada.Text_IO.In_File);

    --Read first line => Number of Questions
    Ada.Integer_Text_IO.Get (File,no_q);
    Ada.Text_IO.put(Item => "no_q =>");
    Ada.Integer_Text_IO.Put (no_q);
    Ada.Text_IO.New_Line;
    
     
    --read correct answer keys    
    Ada.Text_IO.put("Ans Keys =>");
    while i <no_q+1 loop
      Ada.Integer_Text_IO.Get (File,value);
      Ada.Text_IO.New_Line;
      ans_key(i) := value;
      Ada.Integer_Text_IO.Put (ans_key(i));
      i:= i+1;
    end loop;

    Ada.Text_IO.New_Line;
    
    --Count number of students
    no_stud := 0;
    while not Ada.Text_IO.End_of_File(File) loop
        line:= Ada.Strings.Unbounded.to_unbounded_string(Ada.Text_IO.get_line(File));
        no_stud := no_stud +1;
    end loop;

    no_stud:= no_stud-1;
    Ada.Text_IO.put("Number of students =>");
    Ada.Integer_Text_IO.put(no_stud);
        

    Ada.Text_IO.Close (File => File);

end read_ans;



--===============================      Main Procedure Begin        =================================  
begin

    Ada.Text_IO.Put_line(Item => "Enter File Name :");
    read_ans(File=> ip_file);

end scantron;