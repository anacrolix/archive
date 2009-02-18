with Ada.Real_time   ; use Ada.Real_time;

with Generic_Servers ;

generic
   Timing_Jitter,
   Min_Allowed_Job_Interarrival : in Time_Span;

   with package Servers is new Generic_Servers (<>);

package Generic_Server_Entry is

   use Servers;

   type Client_Mode is (performance, realtime);

   protected Server_Dispatcher is
      entry Calc (Client_Mode) (x : in  Non_Negative_Float; Result : out Non_Negative_Float);
      procedure Check_In_Realtime_Client (Max_Response : in  Time_Span; Admitted : out Boolean);
   private
      entry Performance_Queue (x : in  Non_Negative_Float; Result : out Non_Negative_Float);
      entry Realtime_Queue (x : in  Non_Negative_Float; Result : out Non_Negative_Float);
   end Server_Dispatcher;

private
   Realtime_Arrivals : Natural := 0;
   Server_Open : Boolean := true;
   Latest_Max_Response : Time_Span;
--     Expected_Completion : array (Server_Range) of Time;
end Generic_Server_Entry;

