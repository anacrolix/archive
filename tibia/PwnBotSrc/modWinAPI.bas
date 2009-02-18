Attribute VB_Name = "modWinAPI"
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long

Public Declare Function GetClassName Lib "user32.dll" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
''Public Declare Function SetActiveWindow Lib "user32" (ByVal hwnd As Long) As Long
'
Public Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Public Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
'

Public Declare Function EncipherXteaPacket Lib "pwn.dll" (ByRef packet As Byte, ByVal length As Long, ByRef key As Byte) As Long
Public Declare Function DecipherXteaPacket Lib "pwn.dll" (ByRef packet As Byte, ByVal length As Long, ByRef key As Byte) As Long

Public Const PROCESS_ALL_ACCESS = &H1F0FFF

Public Declare Function MessageBeep Lib "user32" _
    (ByVal wType As Long) As Long
Public Const MB_ICONASTERISK = &H40&
Public Const MB_ICONEXCLAMATION = &H30&
Public Const MB_ICONHAND = &H10&
Public Const MB_ICONINFORMATION = MB_ICONASTERISK
Public Const MB_ICONMASK = &HF0&
Public Const MB_ICONQUESTION = &H20&
Public Const MB_ICONSTOP = MB_ICONHAND

