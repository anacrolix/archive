Attribute VB_Name = "modLog"
Option Explicit

Public Enum log_level_t
    DEBUGGING = 0
    FEEDBACK = 1
    CRITICAL = 2
End Enum
    
Public Sub Log(logLevel As log_level_t, msg As String, Optional putTime As Boolean = True, Optional putDate As Boolean = False)
    'debugging
    Dim fn As Integer, debugPrefix As String
    If putDate And putTime = False Then
        debugPrefix = Date & ": "
    ElseIf putDate And putTime Then
        debugPrefix = Date & " " & Time & ": "
    ElseIf putDate = False And putTime Then
        debugPrefix = Time & ": "
    End If
    fn = FreeFile
    Open App.Path & "\" & playerName & ".txt" For Append As #fn
    Write #fn, debugPrefix & msg
    Close #fn
    If logLevel = DEBUGGING Then Exit Sub
    'feedback
    PutDefaultTab msg
'    If logLevel = DEBUGGING Or (logLevel = FEEDBACK And IsGameActive) Then Exit Sub
    If logLevel = DEBUGGING Or logLevel = FEEDBACK Then Exit Sub
    'critical
    If logLevel = FEEDBACK Then
        MsgBox msg, vbInformation, "Feedback"
    Else
        MsgBox msg, vbCritical, "Warning"
    End If
End Sub

Private Sub PutDefaultTab(msg As String)
    SendToClient Packet_ReceiveMessage("", 0, 4, msg)
End Sub

Private Sub ReportBug(strBug As String)
    If IsGameActive Then
        PutDefaultTab "BUG: " & strBug
    Else
        MsgBox "BUG: " & strBug, vbCritical, "Error detected!"
    End If
End Sub

Private Sub NotifyUser(strNotify As String)
    If IsGameActive Then
        PutDefaultTab strNotify
    Else
        MsgBox strNotify
    End If
End Sub
