with Ada.Real_Time; use Ada.Real_Time;

package Evaluation_Parameters is

   No_Of_Servers             : Positive  := 10;
   No_Of_Performance_Clients : Natural   := 10;
   No_Of_Realtime_Clients    : Natural   := 10;

   Runtime                      : Time_Span := To_Time_Span (10.000); --   10 s
   Max_Response_Time            : Time_Span := To_Time_Span ( 0.120); --  120 ms
   Timing_Jitter                : Time_Span := To_Time_Span ( 0.010); --   10 ms
   Min_Allowed_Job_Interarrival : Time_Span := To_Time_Span ( 1.000); -- 1000 ms

   Delay_Per_Operation          : Duration  := 0.010;                 --   10 ms

end Evaluation_Parameters;


