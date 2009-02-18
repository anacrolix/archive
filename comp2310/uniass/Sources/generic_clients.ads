with Ada.Real_time; use Ada.Real_time;

with Generic_Server_Entry;

generic
   No_Of_Performance_Clients,
   No_Of_Realtime_Clients       : in Natural;
   Runtime,
   Max_Response_Time,
   Min_Allowed_Job_Interarrival : in Time_Span;

   With package Server_Entry is new Generic_Server_Entry(<>);

package Generic_Clients is

   use Server_Entry;
   use Server_Entry.Servers;

   type Client_Mode is (performance, realtime);

   subtype Performance_Client_Range is Positive range 1..No_Of_Performance_Clients;
   subtype Realtime_Client_Range    is Positive range 1..No_Of_Realtime_Clients;

   task type Client_Task (Mode : Client_Mode := performance) is
      entry Startup;
      entry Sync_On_Completion (NoOfCalcs           : out Natural); -- performance clients
      entry Sync_On_Completion (NoOfCalcs           : out Natural;  -- realtime clients
                                Job_Not_Admitted    : out Boolean;
                                NoOfMissedDeadlines : out Natural);
   end Client_Task;

   Performance_Clients : array (Performance_Client_Range) of Client_Task (performance);
   Realtime_Clients    : array (Realtime_Client_Range   ) of Client_Task (realtime   );

end Generic_Clients;

