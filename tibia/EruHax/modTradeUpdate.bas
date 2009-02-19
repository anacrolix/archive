Attribute VB_Name = "modHotkey"
Public Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Const WM_CHAR = &H102

Public Function Read_Hotkey() As String
  Dim str1, str2() As String
  str1 = Memory_Read_String(ADDRESS_HOTKEY_CTRL_F12)
  str2 = Split(str1, Chr(0))
  Read_Hotkey = str2(0)
End Function

Public Sub Write_Hotkey(str As String)
  Memory_Write_String ADDRESS_HOTKEY_CTRL_F12, Left(str, 255)
End Sub

Public Sub Say_Hotkey()
  Dim i As Integer
  Dim str As String
  
  str = Read_Hotkey
  For i = 1 To Len(str)
    PostMessage Tibia_Hwnd, WM_CHAR, Asc(Mid(str, i, 1)), 0
  Next i
  PostMessage Tibia_Hwnd, WM_CHAR, 13, 0
End Sub
