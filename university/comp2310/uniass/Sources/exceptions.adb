with Ada.Text_IO            ; use Ada.Text_IO;
with Ada.Task_Identification; use Ada.Task_Identification;

package body Exceptions is

   procedure Show_Exception (E       : in Exception_Occurrence;
                             Message : in String                := "") is

   begin
      Put_Line (Current_Error,
                Message & " Task " & Image (Current_Task)
                & " reports: "     & Exception_Name (E)
                & " - "            & Exception_Message (E));
   end Show_Exception;

end Exceptions;
