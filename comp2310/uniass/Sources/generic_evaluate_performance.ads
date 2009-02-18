with Ada.Real_Time; use Ada.Real_Time;

generic

   No_Of_Servers                : in Positive;
   No_Of_Performance_Clients,
   No_Of_Realtime_Clients       : in Natural;
   Runtime,
   Max_Response_Time,
   Timing_Jitter,
   Min_Allowed_Job_Interarrival : in Time_Span;
   Delay_Per_Operation          : in Duration;

package Generic_Evaluate_Performance is

   procedure Perform_Tests;

end Generic_Evaluate_Performance;

