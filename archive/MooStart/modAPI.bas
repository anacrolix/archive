Attribute VB_Name = "modAPI"
Public Declare Function SendMessageByString Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As String) As Long
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
Public Const WM_SETTEXT = &HC
Public Declare Function MoveWindow Lib "user32" (ByVal hwnd As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long

Sub ChangeStartButton(pWidth As Integer, pText As String)
    On Error GoTo NoRunTimes
    Dim Button As Long
    Dim ShellTrayWnd As Long
    TaskBar = FindWindow("Shell_TrayWnd", vbNullString)
    StartButton = FindWindowEx(TaskBar, 0, "button", vbNullString)
    ShellTrayWnd = FindWindow("Shell_TrayWnd", vbNullString)
    Button = FindWindowEx(ShellTrayWnd, 0, "Button", vbNullString)
    Call SendMessageByString(Button, WM_SETTEXT, 0&, pText)
    Call MoveWindow(StartButton, 0, 0, pWidth, 32, 1)
    MsgBox "Start button modification now applied.", vbInformation, "Changes made"
    Exit Sub
NoRunTimes:
        MsgBox "I don't have the necessary runtimes", vbCritical
End Sub

Sub Main()
    Dim StartText As String
    Dim ButtonLen As Integer
    StartText = InputBox("What do you wish to change the start button to read?", "Enter new start button text")
    ButtonLen = Len(StartText) * 10 + 60
    ChangeStartButton ButtonLen, StartText
End Sub


