Attribute VB_Name = "modEruBomb"
Public Const FILEEXT_CHARLIST = "emc"
Public Const FILEEXT_TARGETLIST = "emt"
Public Const MAX_BOMBCHARS = 40

Type typBombChar
    used As Boolean
    connectTime As Long
    firstReplyTime As Long
    openBp As Boolean
    putFollow As Boolean
    nextAction As Long
    name As String
    loginPacket() As Byte
    xteaKey() As Byte
End Type

Dim bombChars(MAX_BOMBCHARS - 1) As typBombChar
Dim bestTarPos As Long

Private Sub BombChar_Reset(charIndex As Integer)
    With bombChars(charIndex)
        .connectTime = 0
        .firstReplyTime = 0
        .openBp = False
        .putFollow = False
    End With
End Sub

Private Sub BombChars_ResetList()
    Dim i As Integer
    For i = 0 To MAX_BOMBCHARS - 1
        BombChar_Reset i
    Next i
End Sub

Sub BombChars_LoadList()
    Dim fn As Integer, temp As String, fileName As String, charIndex As Integer ', temp2() As String
    
    fn = FreeFile
    fileName = GetFileName_CharList
    If fileName = "" Or dir(fileName) = "" Then GoTo Error
    Open fileName For Input As #fn
    BombChars_ClearList
    On Error GoTo Error
    While EOF(fn) = False
        Input #fn, temp
        bombChars(charIndex).name = temp
        frmBomb.listChars.AddItem temp
        Input #fn, temp
        bombChars(charIndex).loginPacket = HexStringToByteArray(temp)
        Input #fn, temp
        bombChars(charIndex).xteaKey = HexStringToByteArray(temp)
        bombChars(charIndex).used = True
'        MsgBox "bombChar(" & charIndex & ") : " & bombChars(charIndex).name & vbCrLf _
'        & PacketToString(bombChars(charIndex).loginPacket) & vbCrLf _
'        & PacketToString(bombChars(charIndex).xteaKey)
        charIndex = charIndex + 1
NextChar:
    Wend
    Close fn
    Exit Sub
Error:
    MsgBox "There was an error loading the character list.", vbCritical, "Error"
    BombChars_ClearList
    Exit Sub
End Sub

Private Function GetFileName_TargetList() As String
    On Error GoTo Cancel
    With frmBomb.cdlgBomb
        .fileName = "*." & FILEEXT_TARGETLIST
        .Filter = "EruBomb Target List, *." & FILEEXT_TARGETLIST
        .DialogTitle = "Load Target List"
        .InitDir = App.Path
        .DefaultExt = FILEEXT_TARGETLIST
        .ShowOpen
        GetFileName_TargetList = .fileName
    End With
    Exit Function
Cancel:
End Function

Sub LoadTargets()

End Sub

Public Sub LogDbg(msg As String)

End Sub

Sub BombChars_ChooseTarget()
    Dim canShoot() As Long, i As Integer, j As Integer
    Dim tarPos As Long, tarX As Long, tarY As Long, tarZ As Long
    Dim magePos As Long, mageX As Long, mageY As Long, mageZ As Long
    Dim bestTarIndex As Long
    bestTarPos = -1
    If frmBomb.listTargets.ListCount <= 0 Then GoTo NoTarget
    bestTarIndex = 0
    ReDim canShoot(frmBomb.listTargets.ListCount - 1)
    For i = 0 To frmBomb.listTargets.ListCount - 1
        tarPos = GetIndexByName(frmBomb.listTargets.List(i))
        If tarPos < 0 Then GoTo ContinueTarget
        getCharXYZ tarX, tarY, tarZ, tarPos
        For j = 0 To MAX_BOMBCHARS - 1
            If bombChars(j).name = "" Or bombChars(j).used = False Then GoTo ContinueBombChar
            magePos = GetIndexByName(bombChars(j).name)
            If magePos < 0 Then GoTo ContinueBombChar
            getCharXYZ mageX, mageY, mageZ, magePos
            If tarZ <> mageZ Then GoTo ContinueBombChar
            If GetInRuneRange(tarX, tarY, mageX, mageY) = False Then GoTo ContinueBombChar
            canShoot(i) = canShoot(i) + 1
ContinueBombChar:
        Next j
        If canShoot(i) > canShoot(bestTarIndex) Or (bestTarIndex = 0 And bestTarPos = -1) Then
            bestTarPos = tarPos
            bestTarIndex = i
        End If
ContinueTarget:
    Next i
    If bestTarPos = -1 Then GoTo NoTarget
    frmBomb.lblBestTarget = "Current Target: " & frmBomb.listTargets.List(bestTarIndex)
    Exit Sub
NoTarget:
    frmBomb.lblBestTarget = "Current Target: " & "NONE"
End Sub

Sub BombChars_Connect()
    Dim i As Integer
    
    With frmBomb
        'close existing connections
        For i = 0 To MAX_BOMBCHARS - 1
            If .sckChar(i).State <> sckConnected Then
                .sckChar(i).Close
                BombChar_Reset i
            End If
        Next i
        DoEvents
        'establish all connections to server
        For i = 0 To MAX_BOMBCHARS - 1
            If bombChars(i).used And .sckChar(i).State <> sckConnected Then
                .sckChar(i).Connect .txtServerIP, .txtServerPort
            End If
        Next i
        'wait for connection
WaitForConnection:
        DoEvents
        For i = 0 To MAX_BOMBCHARS - 1
            If bombChars(i).used Then
                If .sckChar(i).State <> sckConnected Then
                    GoTo WaitForConnection
                End If
            End If
        Next i
        'send login packets
        For i = 0 To MAX_BOMBCHARS - 1
            If bombChars(i).used And bombChars(i).connectTime = 0 Then
                .sckChar(i).SendData bombChars(i).loginPacket
                bombChars(i).connectTime = GetTickCount
            End If
        Next i
        DoEvents
    End With
End Sub

Sub BombChars_Disconnect()
    Dim i As Integer
    For i = 0 To MAX_BOMBCHARS - 1
        frmBomb.sckChar(i).Close
    Next i
    BombChars_ResetList
End Sub

Sub BombSocket_ReceivePacket(charIndex As Integer, packet() As Byte)
    If bombChars(charIndex).firstReplyTime = 0 Then
        bombChars(charIndex).firstReplyTime = GetTickCount
'        MsgBox "time to reply" & bombChars(charIndex).firstReplyTime - bombChars(charIndex).connectTime
    End If
End Sub

Sub BombChars_TakeAction()
    Dim curTick As Long, i As Integer
    curTick = GetTickCount
    For i = 0 To MAX_BOMBCHARS - 1
        If frmBomb.sckChar(i).State = sckConnected And curTick >= bombChars(i).firstReplyTime And bombChars(i).firstReplyTime <> 0 Then
            If bombChars(i).openBp = False Then
                BombSocket_SendPacket i, Packet_UseHere(ITEM_BACKPACK_BLACK, SLOT_BACKPACK, 0)
                bombChars(i).openBp = True
                bombChars(i).nextAction = curTick + 200
            ElseIf frmBomb.chkFollowTarget And bombChars(i).putFollow = False And curTick >= bombChars(i).nextAction Then
                If bestTarPos < 0 Then Exit Sub
                BombSocket_SendPacket i, Packet_Follow(ReadMem(ADR_CHAR_ID + bestTarPos * SIZE_CHAR, 4))
                bombChars(i).putFollow = True
                bombChars(i).nextAction = curTick + 200
            ElseIf curTick >= bombChars(i).nextAction Then
                BombChar_ShootRune i
                bombChars(i).nextAction = curTick + 100
            End If
        End If
    Next i
End Sub

Sub BombChar_ShootRune(charIndex As Integer)
    Dim pX As Long, pY As Long, pZ As Long
    If bestTarPos < 0 Then Exit Sub
    getCharXYZ pX, pY, pZ, bestTarPos
    BombSocket_SendPacket charIndex, Packet_UseAt(ITEM_RUNE_LMM, SLOT_INV, 0, pX, pY, pZ)
End Sub

Sub BombSocket_SendPacket(charIndex As Integer, packet() As Byte)
    If (UBound(packet) - 1) Mod 8 <> 0 Then
        MsgBox "Invalid packet length!", vbCritical, "Error"
        End
    End If
    EncodeXTEA packet(0), UBound(packet) + 1, bombChars(charIndex).xteaKey(0)
    If frmBomb.sckChar(charIndex).State = sckConnected Then frmBomb.sckChar(charIndex).SendData packet
End Sub

Sub LogMsg(msg As String)

End Sub
