Attribute VB_Name = "modSck"
Private Const MAX_LOGINLIST_CHARS = 100

Public Type typ_LoginListChar
    name As String
    IP As String
    Port As Integer
End Type

Public LoginListChars(MAX_LOGINLIST_CHARS - 1) As typ_LoginListChar
Private serverReplied As Boolean
Private serverReplyTick As Long

Public Function LoginListPacket(buff() As Byte, Port As Long) As Byte()
    Dim i As Integer, j As Integer, origBuff() As Byte
    Dim numChar As Integer, curChar As Integer
    Dim strTemp As String
    origBuff = buff
    On Error GoTo Fuck
    i = buff(5) + buff(6) * 256 + 9
    If i > UBound(buff) Then GoTo Fuck
    numChar = buff(i - 1)
    For curChar = 0 To numChar - 1
        strTemp = ""
        For j = 0 To buff(i) - 1
            If i + 2 + j > UBound(buff) Then GoTo Fuck
            strTemp = strTemp & Chr(buff(i + 2 + j))
        Next j
        LoginListChars(curChar).name = strTemp
        i = buff(i) + 2 + i
        i = buff(i) + 2 + i
        LoginListChars(curChar).IP = buff(i) & "." & buff(i + 1) & "." & buff(i + 2) & "." & buff(i + 3)
        LoginListChars(curChar).Port = buff(i + 4) + buff(i + 5) * &H100
        buff(i) = 127
        buff(i + 1) = 0
        buff(i + 2) = 0
        buff(i + 3) = 1
        buff(i + 4) = Port - Fix(Port / &H100) * &H100
        buff(i + 5) = Fix(Port / &H100)
        i = i + 6
    Next curChar
    LoginListPacket = buff
    Exit Function
Fuck:
'    MsgBox "Incoming character list unreadable. Unexpected server circumstances may be present."
    LoginListPacket = origBuff
End Function

Public Sub GameDisconnected()
    serverReplied = False
End Sub

Public Sub ReplyReceived()
    If serverReplied = True Then Exit Sub
    serverReplied = True
    serverReplyTick = GetTickCount
End Sub

Public Sub DisconnectGame()
    serverReplied = False
    While frmMain.sckGameClient.State <> sckClosed Or frmMain.sckGameServer.State <> sckClosed
        frmMain.sckGameClient.Close
        frmMain.sckGameServer.Close
    Wend
    With frmMain
        .chkEat = Unchecked
        .chkSpells = Unchecked
        .chkStepper = Unchecked
        .chkAutoAttack = Unchecked
        .chkLogOut = Unchecked
    End With
    UpdateWindowText
End Sub

Public Sub DisconnectLogin()
    If frmMain.sckLoginServer.State <> sckClosed Then frmMain.sckLoginServer.Close
    If frmMain.sckLoginClient.State <> sckClosed Then frmMain.sckLoginClient.Close
    While frmMain.sckLoginClient.State <> sckClosed Or frmMain.sckLoginServer.State <> sckClosed
        DoEvents
    Wend
End Sub

Public Function IsServerReplied() As Boolean
    IsServerReplied = serverReplied
End Function

Public Function IsGameActive() As Boolean
    Const TIME_CLIENT_UPDATE = 100
    If serverReplied = False Then GoTo No
    If frmMain.sckGameClient.State <> sckConnected Or frmMain.sckGameServer.State <> sckConnected Then
'        DisconnectGame
        GoTo No
    End If
    If GetTickCount < serverReplyTick + TIME_CLIENT_UPDATE Then GoTo No
    UpdateCharMem
    If GetPlayerIndex < 0 Then GoTo No
    If TrimCStr(charMem.char(GetPlayerIndex).name) <> playerName Then GoTo No
    GoTo Yes
    Exit Function
Yes:
    IsGameActive = True
    Exit Function
No:
    IsGameActive = False
End Function
