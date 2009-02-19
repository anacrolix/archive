Attribute VB_Name = "modMemory"

Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hWnd As Long, lpdwProcessId As Long) As Long
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private Function Memory_ReadLong(Window_Title As String, Memory_Address As Long) As Long
    Dim Process_Id As Long
    GetWindowThreadProcessId FindWindow(vbNullString, Window_Title), Process_Id
    ReadProcessMemory OpenProcess(&H1F0FFF, False, Process_Id), Memory_Address, Memory_ReadLong, 4, 0&
    CloseHandle OpenProcess(&H1F0FFF, False, Process_Id)
End Function

Private Function Memory_ReadString(Window_Title As String, Memory_Address As Long) As String
    Dim Process_Id As Long
    Dim str(255) As Byte
    GetWindowThreadProcessId FindWindow(vbNullString, Window_Title), Process_Id
    ReadProcessMemory OpenProcess(&H1F0FFF, False, Process_Id), Memory_Address, str(0), 255, 0&
    Memory_ReadString = StrConv(str, vbUnicode)
    CloseHandle OpenProcess(&H1F0FFF, False, Process_Id)
End Function

Public Sub Memory_WriteByte(Window_Title As String, Memory_Address As Long, New_Value As Byte)
    Dim Process_Id As Long
    GetWindowThreadProcessId FindWindow(vbNullString, Window_Title), Process_Id
    WriteProcessMemory OpenProcess(&H1F0FFF, False, Process_Id), Memory_Address, New_Value, 1, 0&
    CloseHandle OpenProcess(&H1F0FFF, False, Process_Id)
End Sub

Private Function Memory_WriteLong(Window_Title As String, Memory_Address As Long, New_Value As Long) As Long
    Dim Process_Id As Long
    GetWindowThreadProcessId FindWindow(vbNullString, Window_Title), Process_Id
    WriteProcessMemory OpenProcess(&H1F0FFF, False, Process_Id), Memory_Address, New_Value, 4, 0&
    CloseHandle OpenProcess(&H1F0FFF, False, Process_Id)
End Function

Private Function Memory_WriteString(Window_Title As String, Memory_Address As Long, New_Value As String)
    Dim Process_Id As Long
    GetWindowThreadProcessId FindWindow(vbNullString, Window_Title), Process_Id
    WriteProcessMemory OpenProcess(&H1F0FFF, False, Process_Id), Memory_Address, ByVal New_Value, 100, 0&
    CloseHandle OpenProcess(&H1F0FFF, False, Process_Id)
End Function

Public Function Memory_ReadByte(Address As Long) As Byte
 
   ' Declare some variables we need
   Dim pid As Long         ' Used to hold the Process Id
   Dim phandle As Long     ' Holds the Process Handle
   Dim valbuffer As Byte   ' Byte
   
   ' First get a handle to the "game" window
   If (Tibia_Hwnd = 0) Then Exit Function
   
   ' We can now get the pid
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   ' Use the pid to get a Process Handle
   phandle = OpenProcess(PROCESS_VM_READ, False, pid)
   If (phandle = 0) Then Exit Function
   
   ' Read Long
   ReadProcessMemory phandle, Address, valbuffer, 1, 0&
       
   ' Return
   Memory_ReadByte = valbuffer
   
   ' Close the Process Handle
   CloseHandle phandle
 
End Function

Public Function Memory_ReadLong(Address As Long) As Long
 
   ' Declare some variables we need
   Dim pid As Long         ' Used to hold the Process Id
   Dim phandle As Long     ' Holds the Process Handle
   Dim valbuffer As Long   ' Long
   
   ' First get a handle to the "game" window
   If (Tibia_Hwnd = 0) Then Exit Function
   
   ' We can now get the pid
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   ' Use the pid to get a Process Handle
   phandle = OpenProcess(PROCESS_VM_READ, False, pid)
   If (phandle = 0) Then Exit Function
   
   ' Read Long
   ReadProcessMemory phandle, Address, valbuffer, 4, 0&
       
   ' Return
   Memory_ReadLong = valbuffer
   
   ' Close the Process Handle
   CloseHandle phandle
 
End Function

Public Sub Memory_WriteByte(Address As Long, valbuffer As Byte)

   'Declare some variables we need
   Dim pid As Long         ' Used to hold the Process Id
   Dim phandle As Long     ' Holds the Process Handle
   
   ' First get a handle to the "game" window
   If (Tibia_Hwnd = 0) Then Exit Sub
   
   ' We can now get the pid
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   ' Use the pid to get a Process Handle
   phandle = OpenProcess(PROCESS_READ_WRITE_QUERY, False, pid)
   If (phandle = 0) Then Exit Sub
   
   ' Write Long
   WriteProcessMemory phandle, Address, valbuffer, 1, 0&
   
   ' Close the Process Handle
   CloseHandle phandle

End Sub

Public Sub Memory_WriteLong(Address As Long, valbuffer As Long)

   'Declare some variables we need
   Dim pid As Long         ' Used to hold the Process Id
   Dim phandle As Long     ' Holds the Process Handle
   
   ' First get a handle to the "game" window
   If (Tibia_Hwnd = 0) Then Exit Sub
   
   ' We can now get the pid
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   ' Use the pid to get a Process Handle
   phandle = OpenProcess(PROCESS_READ_WRITE_QUERY, False, pid)
   If (phandle = 0) Then Exit Sub
   
   ' Write Long
   WriteProcessMemory phandle, Address, valbuffer, 4, 0&
   
   ' Close the Process Handle
   CloseHandle phandle

End Sub

Public Sub Memory_WriteString(Address As Long, valbuffer As String)

   'Declare some variables we need
   Dim pid As Long         ' Used to hold the Process Id
   Dim phandle As Long     ' Holds the Process Handle
   
   ' First get a handle to the "game" window
   If (Tibia_Hwnd = 0) Then Exit Sub
   
   ' We can now get the pid
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   ' Use the pid to get a Process Handle
   phandle = OpenProcess(PROCESS_READ_WRITE_QUERY, False, pid)
   If (phandle = 0) Then Exit Sub
   
   ' Write Long
   WriteProcessMemory phandle, Address, valbuffer, Len(valbuffer), 0&
   
   ' Close the Process Handle
   CloseHandle phandle

End Sub
