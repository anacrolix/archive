with Ada.Numerics.Generic_Elementary_Functions; use Ada.Numerics;
with Ada.Text_IO                              ; use Ada.Text_IO;
with Exceptions                               ; use Exceptions;

package body Generic_Servers is

   package Non_Negative_Float_Elementary_Functions is
     new Generic_Elementary_Functions (Non_Negative_Float);
   use Non_Negative_Float_Elementary_Functions;

   function Response_Time (Id : in Server_Range) return Duration is

   begin
      return Duration (Float (Id) * Float (Delay_Per_Operation));
   end Response_Time;

   function Response_Time (Id : in Server_Range) return Time_Span is

   begin
      return To_Time_Span (Response_Time (Id));
   end Response_Time;

   task body Server_Task is

      Task_Id : Server_Range;

   begin
      accept Startup (Id : in Server_Range) do
         Task_Id := Id;
      end Startup;
      loop
         select
            accept Calc (x         : in  Non_Negative_Float;
                         Result    : out Non_Negative_Float) do
               Result := Sqrt (x);
               delay Response_Time (Task_Id);
            end Calc;
         or
            accept Responsive;
         or
            terminate;
         end select;
      end loop;
   exception
      when E : others => Show_Exception (E);
   end Server_Task;

end Generic_Servers;
