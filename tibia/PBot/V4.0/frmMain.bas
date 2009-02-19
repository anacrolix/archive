Attribute VB_Name = "modMain"
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function GetForegroundWindow Lib "user32" () As Long
Public Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Public Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal sURL As String, ByVal sHeaders As String, ByVal lHeadersLength As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
Public Declare Function InternetReadFile Lib "wininet.dll" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Public Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Public Const RMem = 1
Public Const WMem = 2

Public Const adrIP = &H5EB918
Public Const adrPort = &H5EB90C

Public Thwnd As Long
Public FName As String
Public FDir As String
Public FColor As Long
Public BColor As Long

Public Function Memory(hwnd As Long, Address As Long, Value As Long, Size As Long, Process As Integer)
    Dim pid As Long
    Dim phandle As Long
    GetWindowThreadProcessId hwnd, pid
    phandle = OpenProcess(&H1F0FFF, False, pid)
    If Process = 1 Then ReadProcessMemory phandle, Address, Value, Size, 0
    If Process = 2 Then WriteProcessMemory phandle, Address, Value, Size, 0
    CloseHandle hProcess
End Function

Public Function Pause(Milliseconds As Long)
    Dim EndPause As Long
    EndPause = GetTickCount + Milliseconds
    Do
        DoEvents
    Loop Until GetTickCount >= EndPause
End Function

Public Function StrToMem(hwnd As Long, Address As Long, Text As String)
    Dim C1 As Integer
    For C1 = 0 To Len(Text) - 1
        Memory hwnd, Address + C1, Asc(Right(Text, Len(Text) - C1)), 1, WMem
    Next
    Memory hwnd, Address + Len(Text), 0, 1, WMem
End Function

Public Function EndAll()
    
End Function
