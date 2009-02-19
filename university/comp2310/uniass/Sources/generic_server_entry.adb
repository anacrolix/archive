--  with Ada.Real_time   ; use Ada.Real_time;
with Ada.Text_IO            ; use Ada.Text_IO;

with Generic_Servers;

package body Generic_Server_Entry is

   use Servers;

   protected body Server_Dispatcher is

      entry Calc (for mode in Client_Mode) (x : in  Non_Negative_Float; Result : out Non_Negative_Float)
      when true is
      begin
--  	 Put_Line("server open");
	 Server_Open := true;
	 case mode is
	 when performance =>
	    requeue Performance_Queue;
	 when realtime =>
	    Realtime_Arrivals := Realtime_Arrivals + 1;
	    requeue Realtime_Queue;
	 end case;
      end Calc;

      procedure Check_In_Realtime_Client (Max_Response : in  Time_Span; Admitted : out Boolean) is
      begin
	 Admitted := true;
	 Latest_Max_Response := Max_Response;
      end Check_In_Realtime_Client;

      -- PERFORMANCE CLIENT QUEUE

      entry Performance_Queue (x : in  Non_Negative_Float; Result : out Non_Negative_Float)
	when Server_Open or Realtime_Arrivals = 0 is
	 i : Server_Range;
      begin
	 if Realtime_Arrivals + 1 > Natural(Server_Range'Last) then
	    i := Server_Range'Last; -- More realtime requests than servers
	 else
	    i := Server_Range(Realtime_Arrivals + 1);
	 end if;
--  	 Put_Line("realtime arrivals" & i'img);
	 loop
	    select
	       General_Servers(i).Responsive;
	       --  	       Expected_Completion(i) := Response_Time(i) + Clock;
	       requeue General_Servers(i).Calc;
	    else
	       null;
	    end select;
	    exit when i = Server_Range'Last;
	    i := i + 1;
	 end loop;
	 Server_Open := false;
	 requeue Performance_Queue;
      end Performance_Queue;

      -- REALTIME CLIENT QUEUE

      entry Realtime_Queue (x : in  Non_Negative_Float; Result : out Non_Negative_Float)
	when Server_Open is
      begin
	 for i in Server_Range'Range loop
	    if Response_Time(i) + Timing_Jitter < Latest_Max_Response then
	       select
		  General_Servers(i).Responsive;
		  Realtime_Arrivals := Realtime_Arrivals - 1;
		  --  		  Expected_Completion(i) := Response_Time(i) + Clock;
		  requeue General_Servers(i).Calc;
	       else
		  null;
	       end select;
	    end if;
	 end loop;
	 Server_Open := false;
	 requeue Realtime_Queue;
      end Realtime_Queue;
   end Server_Dispatcher;

end Generic_Server_Entry;
