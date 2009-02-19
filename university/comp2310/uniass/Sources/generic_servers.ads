with Ada.Real_Time; use Ada.Real_Time;

generic
   No_Of_Servers       : in Positive;
   Delay_Per_Operation : in Duration;

package Generic_Servers is

   type Server_Range is new Positive range 1..No_Of_Servers;

   function Response_Time (Id : in Server_Range) return Time_Span;

   subtype Non_Negative_Float is Float range 0.0..Float'Last;

   task type Server_Task is

      entry Startup       (Id     : in  Server_Range);

      entry Calc          (x      : in  Non_Negative_Float;
                           Result : out Non_Negative_Float);
      entry Responsive;

   end Server_Task;

   General_Servers : array (Server_Range) of Server_Task;

end Generic_Servers;
