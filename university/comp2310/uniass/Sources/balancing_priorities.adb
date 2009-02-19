with Ada.Text_IO                 ; use Ada.Text_IO;
with Ada.Integer_Text_IO         ; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO           ; use Ada.Float_Text_IO;
with Ada.Real_Time               ; use Ada.Real_Time;
with Exceptions                  ; use Exceptions;
with GNAT.Command_Line           ; use GNAT.Command_Line;

with Evaluation_Parameters       ; use Evaluation_Parameters;
with Generic_Evaluate_Performance;

procedure Balancing_Priorities is

   Options_Ok : Boolean := True;
   Option     : Character;

   procedure Print_Options is

   begin
      New_Line; Put ("accepted options:");
      New_Line; Put ("   [-n {number of servers                  : positive }] -> "); Put (No_Of_Servers, 4);
      New_Line; Put ("   [-p {number of performance clients      : positive }] -> "); Put (No_Of_Performance_Clients, 4);
      New_Line; Put ("   [-r {number of realtime clients         : positive }] -> "); Put (No_Of_Realtime_Clients, 4);
      New_Line; Put ("   [-e {evaluation runtime                 : seconds  }] -> "); Put (Float (To_Duration (Runtime                     )), 2, 3, 0);
      New_Line; Put ("   [-d {maximal response time              : seconds  }] -> "); Put (Float (To_Duration (Max_Response_Time           )), 2, 3, 0);
      New_Line; Put ("   [-t {assumed timing jitter              : seconds  }] -> "); Put (Float (To_Duration (Timing_Jitter               )), 2, 3, 0);
      New_Line; Put ("   [-i {minimal realtime interarrival time : seconds  }] -> "); Put (Float (To_Duration (Min_Allowed_Job_Interarrival)), 2, 3, 0);
      New_Line;
      New_Line;
   end Print_Options;

begin
   Initialize_Option_Scan;
   loop
      begin
         Option := Getopt ("n: p: r: e: d: t: i:");
         case Option is
            when ASCII.NUL => exit;
            when 'n' => No_Of_Servers                := Positive'Value (Parameter);
            when 'p' => No_Of_Performance_Clients    := Positive'Value (Parameter);
            when 'r' => No_Of_Realtime_Clients       := Positive'Value (Parameter);
            when 'e' => Runtime                      := To_Time_Span (Duration'Value (Parameter));
            when 'd' => Max_Response_Time            := To_Time_Span (Duration'Value (Parameter));
            when 't' => Timing_Jitter                := To_Time_Span (Duration'Value (Parameter));
            when 'i' => Min_Allowed_Job_Interarrival := To_Time_Span (Duration'Value (Parameter));
            when others => raise Program_Error;
         end case;
      exception
         when others =>
            New_Line; Put ("---> Error in option -"); Put (Option); New_Line;
            Options_Ok := False;
      end;
   end loop;

   Print_Options;

   if Options_Ok then

      declare
         package Evaluate_Performance is new Generic_Evaluate_Performance
           (No_Of_Servers                => No_Of_Servers,
            No_Of_Performance_Clients    => No_Of_Performance_Clients,
            No_Of_Realtime_Clients       => No_Of_Realtime_Clients,
            Runtime                      => Runtime,
            Max_Response_Time            => Max_Response_Time,
            Timing_Jitter                => Timing_Jitter,
            Min_Allowed_Job_Interarrival => Min_Allowed_Job_Interarrival,
            Delay_Per_Operation          => Delay_Per_Operation);
      begin
         Evaluate_Performance.Perform_Tests;
      end;

   end if;
exception
   when E : others => Show_Exception(E);

end Balancing_Priorities;
