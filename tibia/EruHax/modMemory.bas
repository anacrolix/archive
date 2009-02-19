Attribute VB_Name = "modMemory"
Option Explicit

Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
''
Public Const SWP_NOACTIVATE = &H10
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOSIZE = &H1
Public Const HWND_TOPMOST = -1
Public Const PROCESS_VM_READ = (&H10)
Public Const PROCESS_VM_WRITE = (&H20)
Public Const PROCESS_VM_OPERATION = (&H8)
Public Const PROCESS_QUERY_INFORMATION = (&H400)
Public Const PROCESS_READ_WRITE_QUERY = PROCESS_VM_READ + PROCESS_VM_WRITE + PROCESS_VM_OPERATION + PROCESS_QUERY_INFORMATION
''

Public Function Tibia_Hwnd() As Long
  Dim tibiaClient As Long
  
  tibiaClient = FindWindow("tibiaclient", vbNullString)
  Tibia_Hwnd = tibiaClient
End Function

Public Function Memory_Read_Byte(address As Long) As Byte
   Dim pid As Long         'process id
   Dim phandle As Long     'process handle
   Dim val As Byte   'retrieved value
   
   'get window handle
   If (Tibia_Hwnd = 0) Then Exit Function
   
   'get process id
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   'open process handle
   phandle = OpenProcess(PROCESS_VM_READ, False, pid)
   If (phandle = 0) Then Exit Function
   
   'read from memory
   ReadProcessMemory phandle, address, val, 1, 0&
       
   'return
   Memory_Read_Byte = val
   
   'close process handle
   CloseHandle phandle
End Function

Public Function Memory_Read_Long(address As Long) As Long
   Dim pid As Long         'process id
   Dim phandle As Long     'process handle
   
   'get window handle
   If (Tibia_Hwnd = 0) Then Exit Function
   
   'get process id
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   'open process handle
   phandle = OpenProcess(PROCESS_VM_READ, False, pid)
   If (phandle = 0) Then Exit Function
   
   'read from memory
   ReadProcessMemory phandle, address, Memory_Read_Long, 4, 0&
       
   'close process handle
   CloseHandle phandle
End Function

Public Function Memory_Read_String(address As Long) As String
   Dim pid As Long         'process id
   Dim phandle As Long     'process handle
   Dim str(500) As Byte    'retrieved string
   
   'get window handle
   If (Tibia_Hwnd = 0) Then Exit Function
   
   'get process id
   GetWindowThreadProcessId Tibia_Hwnd, pid
   
   'open process handle
   phandle = OpenProcess(PROCESS_VM_READ, False, pid)
   If (phandle = 0) Then Exit Function
   
   'read from memory
   ReadProcessMemory phandle, address, str(0), 500, 0&
   
   'return
   Memory_Read_String = StrConv(str, vbUnicode)
       
   'close process handle
   CloseHandle phandle
End Function

Public Sub Memory_Write_Byte(address As Long, valbuffer As Byte)

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
   WriteProcessMemory phandle, address, valbuffer, 1, 0&
   
   ' Close the Process Handle
   CloseHandle phandle

End Sub

Public Sub Memory_Write_Long(address As Long, valbuffer As Long)

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
   WriteProcessMemory phandle, address, valbuffer, 4, 0&
   
   ' Close the Process Handle
   CloseHandle phandle
End Sub

Public Sub Memory_Write_String(address As Long, str As String)
  Dim pid As Long         'process id
  Dim phandle As Long     'process handle
  Dim buffer As Byte      'byte that transverses string
  Dim i As Integer
  
  'turn str into an array of bytes
  
  'get window handle
  If (Tibia_Hwnd = 0) Then Exit Sub
  
  'get process id
  GetWindowThreadProcessId Tibia_Hwnd, pid
  
  'open process handle
  phandle = OpenProcess(PROCESS_READ_WRITE_QUERY, False, pid)
  If (phandle = 0) Then Exit Sub
  
  'write to memory
  str = str & Chr(0)
  For i = 1 To Len(str)
    buffer = Asc((Mid(str, i, 1)))
    WriteProcessMemory phandle, address + i - 1, buffer, 1, 0&
  Next i

   'close process handle
   CloseHandle phandle
End Sub
