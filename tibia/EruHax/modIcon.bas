Attribute VB_Name = "modIcon"
'To get the key pressed
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
'To read and write into ini file
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
'To add icon  into the system tray
Public Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Long
Public Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long

Public Type NOTIFYICONDATA
        cbSize As Long
        hwnd As Long
        uID As Long
        uFlags As Long
        uCallbackMessage As Long
        hIcon As Long
        szTip As String * 64
End Type

Public Const WM_LBUTTONDOWN = &H201
Public Const WM_RBUTTONDOWN = &H204
Public Const NIM_ADD = &H0
Public Const NIM_DELETE = &H2
Public Const NIM_MODIFY = &H1
Public Const NIF_ICON = &H2
Public Const NIF_MESSAGE = &H1
Public Const NIF_TIP = &H4
Public Const WM_MOUSEMOVE = &H200

Global nid As NOTIFYICONDATA

Public Sub Display_Icon(frm As Form)
    'Tray icon properties
    nid.cbSize = Len(nid)
    nid.hIcon = frm.Icon
    nid.hwnd = frm.hwnd
    nid.szTip = frm.Caption & vbNullChar
    nid.uCallbackMessage = WM_MOUSEMOVE
    nid.uFlags = NIF_ICON Or NIF_MESSAGE Or NIF_TIP
    nid.uID = vbNull
    Shell_NotifyIcon NIM_ADD, nid
End Sub
