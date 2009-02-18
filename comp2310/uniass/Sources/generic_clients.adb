with Ada.Text_IO;                  use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Exceptions;                   use Exceptions;

package body Generic_Clients is

   subtype Square_Type is Integer range 0..100;

   task body Client_Task is

      package Random_Squares is new
        Ada.Numerics.Discrete_Random (Square_Type);
      use Random_Squares;
      Square_Generator : Generator;

      Admitted         : Boolean;
      MissedDeadlines  : Natural   := 0;
      Client_Start     : Time      := Clock;
      Calcs            : Natural   := 0;

   begin
      accept Startup;

      If Mode = realtime then
         Server_Dispatcher.Check_In_Realtime_Client (Max_Response_Time, Admitted);
      end if;

      Reset (Square_Generator);

      if Mode /= realtime or Admitted then

         while Clock - Client_Start < Runtime loop

            declare
               x, Result : Float;
               Job_Start : Time;
            begin
               x := Float (Random (Square_Generator));

               begin
                  case Mode is
                     when performance =>
                        delay 0.0;
                        Server_Dispatcher.Calc (performance) (x, Result);
                     when realtime =>
                        delay To_Duration (Min_Allowed_Job_Interarrival);
                        Job_Start := Clock;
                        Server_Dispatcher.Calc (realtime)    (x, Result);
                  end case;
               exception
                  when Constraint_Error => Put ('.'); -- negative x?
                  when CallIsTooSoon    => Put ('#');
                  when E : others       => Put ('?'); Show_Exception(E);
               end;

               if Mode = realtime
                 and then Clock - Job_Start > Max_Response_Time then
                  MissedDeadlines := MissedDeadlines + 1;
                  Put ('!');
               else
                  Calcs := Calcs + 1;
               end if;
            end;
         end loop;
      end if;

      case Mode is

         when performance =>
            accept Sync_On_Completion (NoOfCalcs           : out Natural) do
              NoOfCalcs            := Calcs;
            end Sync_On_Completion;

         when realtime =>
            accept Sync_On_Completion (NoOfCalcs           : out Natural;
                                       Job_Not_Admitted    : out Boolean;
                                       NoOfMissedDeadlines : out Natural) do
               NoOfCalcs           := Calcs;
               Job_Not_Admitted    := not Admitted;
               NoOfMissedDeadlines := MissedDeadlines;
            end Sync_On_Completion;

      end case;

   end Client_Task;

end Generic_Clients;
