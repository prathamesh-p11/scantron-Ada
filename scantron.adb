with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;  


procedure scantron is
    ip_file    : File_Type;
    no_q    : Natural;
    no_stud : Natural;
    value   : Natural;
    average : Integer;
    line : Unbounded_String;
    i : Natural;
    j : Natural;
    temp : Natural;    --temp variable
    temp2 : Natural;       --temp variable
    max : constant Integer:= 50;

    Maxrange : constant positive := 1000;
    subtype index is positive range 1..Maxrange;

    --array declaration for answer key
    type arr is array(index) of Natural;
    ans_key : arr;

    --array for student responses
    stud_ans : arr;

    ----array for student scores
    stud_total : arr;
    
    ----array for student rollnumbers
    stud_roll : arr;
    
    ----array for storing frequency 
    v : arr;

    ----array for storing sorted scores 
    s : arr;


    f_name: String(1 .. max);
    Length : Integer range 0 .. max;


--===============================    Calculating student total marks Procedure    =================================  
function calc_score(stud_res : arr ; correct_ans: arr) return integer is
p : integer;
q : integer;
mark : integer;
total : integer;

begin 
p:=1;
q:=1;
mark := 100/ no_q;
total:=0;


--New_Line;
for p in 2..no_q+1 loop
    if (stud_res(p) = correct_ans(q)) then
        total := total + mark;
    end if;
    q:= q+1;
end loop;


return total;

end calc_score;


--===============================      Reading File Procedure       =================================  
procedure read_ans is
begin
    Open (File => ip_file, Name => f_name(1..Length),Mode => Ada.Text_IO.In_File);

    --skip number of questions lines    
    Ada.Integer_Text_IO.Get (ip_file,temp);
    
    i:= 1;
    --read correct answer keys
   -- New_Line;    
  --  Ada.Text_IO.put("Ans Keys =>");
    while i <no_q+1 loop
      Ada.Integer_Text_IO.Get (ip_file,value);
     -- Ada.Text_IO.New_Line;
      ans_key(i) := value;
--      Ada.Integer_Text_IO.Put (ans_key(i));
      i:= i+1;
    end loop;
    

  --  New_Line;
    --New_Line;
    i:= 1;
    
    temp:= 0;

    --read stud response and print marksheet
    
    put("   Student ID     Score");
    New_Line;
    put("=========================");
    while i < no_stud+1 loop
        j:= 1;
        while j<no_q+2 loop
            Ada.Integer_Text_IO.Get (ip_file,value);
            if j=1 then
                stud_roll(i) := value; 
            end if;
            stud_ans(j) := value;
            j:= j+1;
        end loop;

        temp := calc_score(stud_ans,ans_key);
        stud_total(i) := temp;

        New_Line;
        put(stud_roll(i));
        put(stud_total(i));
        i:= i+1;
    end loop;

    New_Line;
    put("===========================");
    New_Line;
    put("Test Graded :");
    put(no_stud);
    New_Line;
    put("===========================");

    i:=1;
    j:=1;
    
    --init score and frequency array
    while i < no_stud+1 loop
        s(i) := stud_total(i);
        v(i) := 1;
        i := i+1;
    end loop;

     --calc frequency
    i:=1;
    while i<no_stud+1 loop
        j:=1;
        while j<i loop
            if s(i) = s(j) then 
                v(i) := v(i)+1;
                v(j) := 0;
            end if;
            j := j+1;
        end loop;
        i := i+1;
    end loop;

    temp := 0;
    temp2 := 0;
    i:=1;
    j := 1;
    
    for i in 1..no_stud+1 loop
        for j in 1..no_stud-i loop
            if s(j) < s(j+1) then
                temp := s(j);
                temp2 := v(j);
                
                s(j) := s(j+1);
                v(j) := v(j+1);
                 
                s(j+1) := temp;
                v(j+1) := temp2;

            end if;
        end loop;
    end loop;


    New_Line;
    put("     Score    Frequency");
    New_Line;
    put("===========================");
    New_Line;

    i:=1;
    temp := 0;
    while i<no_stud+1 loop
        if v(i) /= 0 then
            New_Line;
            put(s(i));
            put(v(i));
        end if;
        temp := temp + (s(i) * v(i));
        i:= i+1;
    end loop;

    New_Line;
    put("===========================");
    New_Line;

    average := temp / no_stud;
    put("Class Average = ");
    put(average);

end read_ans;

--===============================      Main Procedure Begin        =================================  
begin

    Ada.Text_IO.Put_line(Item => "Enter File Name :");

    get_line(Item => f_name, Last => Length);
   if Length = max then
      skip_line;
   end if;

    i:= 1;

    Open (File => ip_file, Name => f_name(1..Length),Mode => Ada.Text_IO.In_File);

    --Read first line => Number of Questions
    Ada.Integer_Text_IO.Get (ip_file,no_q);
  --  Ada.Text_IO.put(Item => "no_q =>");
  --  Ada.Integer_Text_IO.Put (no_q);
    --Ada.Text_IO.New_Line;
    
    --skip ans_key line    
    Ada.Integer_Text_IO.Get (ip_file,temp);
     
    --Ada.Text_IO.New_Line;
    
    --Count number of students
    no_stud := 0;
    while not Ada.Text_IO.End_of_File(ip_file) loop
        line:= Ada.Strings.Unbounded.to_unbounded_string(Ada.Text_IO.get_line(ip_file));
        no_stud := no_stud +1;
    end loop;

    no_stud:= no_stud-1;
    --Ada.Text_IO.put("Number of students =>");
    --Ada.Integer_Text_IO.put(no_stud);

    Ada.Text_IO.Close (File => ip_file);

    --call procedure to read answer keys and student response;
    read_ans;

end scantron;