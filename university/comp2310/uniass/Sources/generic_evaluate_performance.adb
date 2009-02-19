with Ada.Text_IO;                  use Ada.Text_IO;
with Ada.Integer_Text_IO;          use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;            use Ada.Float_Text_IO;
with Ada.Real_Time;                use Ada.Real_Time;

with Generic_Servers;
with Generic_Server_Entry;
with Generic_Clients;

package body Generic_Evaluate_Performance is

   package Servers      is new Generic_Servers
     (No_Of_Servers                => No_Of_Servers,
      Delay_Per_Operation          => Delay_Per_Operation);

   package Server_Entry is new Generic_Server_Entry
     (Timing_Jitter                => Timing_Jitter,
      Min_Allowed_Job_Interarrival => Min_Allowed_Job_Interarrival,
      Servers                      => Servers);

   package Clients      is new Generic_Clients
     (No_Of_Performance_Clients    => No_Of_Performance_Clients,
      No_Of_Realtime_Clients       => No_Of_Realtime_Clients,
      Runtime                      => Runtime,
      Max_Response_Time            => Max_Response_Time,
      Min_Allowed_Job_Interarrival => Min_Allowed_Job_Interarrival,
      Server_Entry                 => Server_Entry);

   use Clients;
   use Servers;

   type Measurements_T is array (Natural range <>) of Natural;

   Calcs_Performance   : Measurements_T (Performance_Client_Range);
   Calcs_Realtime      : Measurements_T (   Realtime_Client_Range);

   NoOfNoAddmittance,
   NoOfMissedDeadlines : Natural := 0;

   procedure Perform_Tests is

      procedure Print_Results is

         function Max_Capacity return Float is

            Capacity : Float := 0.0;

         begin
            for i in Server_Range'Range loop
               Capacity := Capacity + 1.0 / Float (To_Duration (Response_Time (i)));
            end loop;
            return Capacity;
         end Max_Capacity;

         function Measure_Capacity (Measurements : in Measurements_T) return Float is

            Capacity : Float := 0.0;

         begin
            for i in Measurements'range loop
               Capacity := Capacity + Float (Measurements (i)) / Float (To_Duration (Runtime));
            end loop;
            return Capacity;
         end Measure_Capacity;

      begin
         New_Line;
         Put ("Maximal  capacity                : ");
            Put (Max_Capacity                , 5, 2, 0); Put_Line (" operations per second (100.00 %)");
         Put ("Measured capacity (performance)  : ");
            Put (Measure_Capacity (Calcs_Performance), 5, 2, 0); Put (" operations per second (");
            Put (100.0 * Measure_Capacity (Calcs_Performance) / Max_Capacity, 3, 2, 0);
            Put_Line (" %)");
         Put ("Measured capacity (realtime)     : ");
            Put (Measure_Capacity (Calcs_Realtime   ), 5, 2, 0); Put (" operations per second (");
            Put (100.0 * Measure_Capacity (Calcs_Realtime   )    / Max_Capacity, 3, 2, 0);
            Put_Line (" %)");
         Put ("Number of not admitted clients   : "); Put (NoOfNoAddmittance  , 3); New_Line;
         Put ("Missed deadlines                 : "); Put (NoOfMissedDeadlines, 3); New_Line;
         New_Line;
      end Print_Results;

   begin
      Put_Line ("--------------------------- Starting servers ------------------------");

      for i in Server_Range loop
         General_Servers (i).Startup (i);
      end loop;

      Put ("--- Starting realtime clients ---");
      for i in Realtime_Client_Range loop
         Realtime_Clients (i).Startup;
      end loop;

      Put_Line ("--- Starting performance clients ---");
      for i in Performance_Client_Range loop
         Performance_Clients (i).Startup;
      end loop;

      Put_Line ("---              Clients and servers are running                  ---");
      Put_Line ("--- ('!' are missed deadlines, '#' are too early realtime calls)  ---");

      declare
         Job_Not_Admitted : Boolean;
         MissedDeadlines  : Natural;
      begin
         for i in Performance_Client_Range loop
            Performance_Clients (i).Sync_On_Completion (Calcs_Performance (i));
         end loop;
         Put ("--- performance clients complete ---");
         for i in RealTime_Client_Range loop
            Realtime_Clients (i).Sync_On_Completion (Calcs_Realtime (i),
                                                     Job_Not_Admitted,
                                                     MissedDeadlines);
            if Job_Not_Admitted then
               NoOfNoAddmittance := NoOfNoAddmittance + 1;
            end if;
            NoOfMissedDeadlines := NoOfMissedDeadlines + MissedDeadlines;
         end loop;
         Put_Line ("--- realtime clients complete ---");
      end;

      Print_Results;
   end Perform_Tests;

end Generic_Evaluate_Performance;
