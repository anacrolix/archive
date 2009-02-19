with Ada.Exceptions; use Ada.Exceptions;

package Exceptions is

   procedure Show_Exception (E       : in Exception_Occurrence;
                             Message : in String                := "");

   CallIsTooSoon,
   UnknownRealtimeClient : exception;

end Exceptions;
