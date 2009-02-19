Attribute VB_Name = "modPackets"
Public Function Packet_LogOut() As Byte()
    Dim buff(9) As Byte
    
    buff(0) = 8
    buff(1) = 0
    buff(2) = 1
    buff(3) = 0
    buff(4) = &H14
    
    Packet_LogOut = buff
End Function

Public Sub SendToClient(buff() As Byte)
    If (UBound(buff) - 1) Mod 8 <> 0 Then
        LogMsg "BUG: Inbound packet is of invalid length for XTEA encryption"
        Exit Sub
    End If
    If frmMain.mnuFilterIncoming.Checked _
    Then LogMsg "inbound erubot packet: " & PacketToString(buff) & " EOF"
    UpdateEncryptionKey
    EncodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
    If frmMain.sckClient.State = sckConnected Then frmMain.sckClient.SendData buff
End Sub

Public Sub SendToServer(buff() As Byte)
    If (UBound(buff) - 1) Mod 8 <> 0 Then
        LogMsg "BUG: Attempted to send XTEA packet of invalid length."
        Exit Sub
    End If
    If frmMain.mnuFilterServer.Checked Then LogMsg "outgoing erubot packet:" & vbCrLf & PacketToString(buff) & " EOF"
    UpdateEncryptionKey
    EncodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
End Sub

Public Function Packet_UseAt(item As Long, fromLoc As Long, fromSlot As Long, toX As Long, toY As Long, toZ As Long) As Byte()
    Dim buff(25) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &H18
    buff(1) = &H0
    buff(2) = &H11
    buff(3) = 0
    buff(4) = &H83
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    byte1 = Fix(item / 256)
    byte2 = item - (Fix(item / 256) * 256)
    buff(10) = byte2
    buff(11) = byte1
    buff(12) = fromSlot
    byte1 = Fix(toX / 256)
    byte2 = toX - (Fix(toX / 256) * 256)
    buff(13) = byte2
    buff(14) = byte1
    byte1 = Fix(toY / 256)
    byte2 = toY - (Fix(toY / 256) * 256)
    buff(15) = byte2
    buff(16) = byte1
    buff(17) = toZ
    If item = ITEM_FISHING_ROD Then
        buff(18) = &HF5 + Int(Rnd * 6)
        buff(19) = &H11
        buff(20) = &H0
    ElseIf item = ITEM_ROPE Then
        buff(18) = &H82
        buff(19) = 1
        buff(20) = 0
    Else
        buff(18) = &H63
        buff(19) = &H0
        buff(20) = &H1
    End If
    Packet_UseAt = buff
End Function

Public Function Packet_DropItem(item As Long, quantity As Long, fromLoc As Long, fromSlot As Long, toX As Long, toY As Long, toZ As Long) As Byte()
'18 00 0F 00 78 FF FF 40 00 00 D7 0B 00 C0 80 2D 7D 06 5F B6 32 02 B6 60 80 76 EOF
    Dim buff(25) As Byte, bytID() As Byte
    'len packet
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    'len instruction
    buff(2) = 15
    buff(3) = 0
    'instruction type
    buff(4) = &H78
    'x
    buff(5) = &HFF
    buff(6) = &HFF
    'y
    buff(7) = fromLoc
    buff(8) = 0
    'z
    buff(9) = fromSlot
    'item id
    ConvertIDtoBytes item, bytID
    buff(10) = bytID(0)
    buff(11) = bytID(1)
    '????
    buff(12) = fromSlot
    'x
    ConvertIDtoBytes toX, bytID
    buff(13) = bytID(0)
    buff(14) = bytID(1)
    'y
    ConvertIDtoBytes toY, bytID
    buff(15) = bytID(0)
    buff(16) = bytID(1)
    'z
    buff(17) = toZ
    'quantity
    buff(18) = quantity
    'return packet
    Packet_DropItem = buff
End Function

Public Function Packet_MoveItem(item As Long, fromLoc As Long, fromSlot As Long, toLoc As Long, toSlot As Long, quant As Long) As Byte()
    Dim buff(25) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = 24
    buff(1) = 0
    buff(2) = &HF
    buff(3) = &H0
    buff(4) = &H78
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    byte1 = Fix(item / 256)
    byte2 = item - (Fix(item / 256) * 256)
    buff(10) = byte2
    buff(11) = byte1
    buff(12) = fromSlot
    buff(13) = &HFF
    buff(14) = &HFF
    buff(15) = toLoc
    buff(16) = &H0
    buff(17) = toSlot
    buff(18) = quant
    Packet_MoveItem = buff
End Function

Public Function Packet_GrabItem(item As Long, fromX As Long, fromY As Long, fromZ As Long, toLoc As Integer, toSlot As Integer, quant As Long)
    Dim buff(16) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &HF
    buff(1) = &H0
    buff(2) = &H78
    byte1 = fromX - (Fix(fromX / 256) * 256)
    byte2 = Fix(fromX / 256)
    buff(3) = byte1
    buff(4) = byte2
    byte1 = fromY - (Fix(fromY / 256) * 256)
    byte2 = Fix(fromY / 256)
    buff(5) = byte1
    buff(6) = byte2
    buff(7) = fromZ
    byte1 = Fix(item / 256)
    byte2 = item - (Fix(item / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = fromSlot
    buff(11) = &HFF
    buff(12) = &HFF
    buff(13) = toLoc
    buff(14) = &H0
    buff(15) = toSlot
    buff(16) = quant
    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
End Function



Public Function Packet_UseGround(id As Long, X As Long, Y As Long, z As Long, objType As Integer, Optional newLoc As Integer = 0) As Byte()
'10 00 0A 00 82 0D 80 60 7B 08 A5 0F 02 01 C0 C3 27 24 EOF
'10 00 0A 00 82 0D 80 5F 7B 08 62 01 00 01 5C 17 EF BC EOF
'len-2 cmd-2 cmd xxxx yy yy zz id id new - -  -  -  -
    Dim buff(17) As Byte, bytes() As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = &HA 'len-2
    buff(3) = 0 '?
    buff(4) = &H82 'command usehere
    ConvertLongToBytes X, bytes, 2
    buff(5) = bytes(0)
    buff(6) = bytes(1)
    ConvertLongToBytes Y, bytes, 2
    buff(7) = bytes(0)
    buff(8) = bytes(1)
    buff(9) = z
    ConvertLongToBytes id, bytes, 2
    buff(10) = bytes(0)
    buff(11) = bytes(1)
    buff(12) = objType
    buff(13) = newLoc
    Packet_UseGround = buff
End Function

Public Function Packet_UseHere(item As Long, fromLoc As Long, fromSlot As Long, Optional newLoc As Long = 0) As Byte()
    Dim buff(17) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = &HA
    buff(3) = &H0
    buff(4) = &H82
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    byte1 = Fix(item / 256)
    byte2 = item - (Fix(item / 256) * 256)
    buff(10) = byte2
    buff(11) = byte1
    buff(12) = fromSlot
    buff(13) = newLoc
    Packet_UseHere = buff
End Function

Public Function Packet_UpBpLevel(bpIndex As Long) As Byte()
    Dim buff(9) As Byte
    buff(0) = 8
    buff(1) = 0
    buff(2) = &H2
    buff(3) = &H0
    buff(4) = &H88
    buff(5) = bpIndex
    
    Packet_UpBpLevel = buff
    LogDbg "Constructed 'move up backpack level #" & bpIndex & " packet."
End Function

Public Function RoundUp(num As Long, den As Long) As Long
    Dim val As Long
    val = Fix(num / den)
    If num Mod den <> 0 Then val = val + 1
    RoundUp = val
End Function

Public Function Packet_SayDefault(str As String) As Byte()
    Dim buff() As Byte
    Dim i As Integer
    ReDim buff(8 * RoundUp(6 + Len(str), 8) + 1) As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = Len(str) + 4
    buff(3) = &H0
    buff(4) = &H96
    buff(5) = &H1
    buff(6) = Len(str)
    buff(7) = 0
    For i = 1 To Len(str)
        buff(i + 7) = Asc(Mid(str, i, 1))
    Next i
    Packet_SayDefault = buff
End Function

Public Function Packet_UseAtMonster(item As Long, fromLoc As Long, fromSlot As Long, id As Long) As Byte()
    '0D 00 84 FF FF 45 00 00 7E 0C 00 A3 A9 00 40
    Dim buff(17) As Byte, bytID() As Byte, i As Integer
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = &HD
    buff(3) = &H0
    buff(4) = &H84
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    'rune id
    buff(11) = Fix(item / 256)
    buff(10) = item - (Fix(item / 256) * 256)
    buff(12) = fromSlot
    ConvertIDtoBytes id, bytID
    For i = 0 To 3
        buff(13 + i) = bytID(i)
    Next i
    Packet_UseAtMonster = buff
End Function

Public Function MessagePerson(CharTo As String, MessageTo As String)
    Dim buff() As Byte
    Dim C1 As Byte
    ReDim buff(7 + Len(CharTo) + Len(MessageTo)) As Byte
    buff(0) = 6 + Len(CharTo) + Len(MessageTo)
    buff(1) = &H0
    buff(2) = &H96
    buff(3) = &H4
    buff(4) = Len(CharTo)
    For C1 = 6 To Len(CharTo) + 5
        buff(C1) = Asc(Right(CharTo, Len(CharTo) + 6 - C1))
    Next
    buff(C1) = Len(MessageTo)
    buff(C1 + 1) = &H0
    For C1 = C1 + 2 To C1 + 1 + Len(MessageTo)
        buff(C1) = Asc(Right(MessageTo, Len(MessageTo) + 8 + Len(CharTo) - C1))
    Next
    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
End Function

Public Function Packet_TurnDirection(dir As Long) As Byte()
    Dim buff() As Byte
    ReDim buff(9)
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = 1
    buff(3) = 0
    buff(4) = &H6F + dir
    Packet_TurnDirection = buff
End Function

Public Function Packet_StepDirection(dir As Long, Optional numSteps As Long = 1) As Byte()
    Dim buff() As Byte
    ReDim buff(8 * RoundUp(2 + numSteps, 8) + 1)
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = numSteps
    buff(3) = 0
    For i = 0 To numSteps - 1
        buff(i + 4) = dir + &H65
    Next i
    Packet_StepDirection = buff
End Function

Public Function FollowHim(id As Long)
    Dim buff(6) As Byte, idBytes() As Byte, i As Integer
    buff(0) = &H5
    buff(1) = &H0
    buff(2) = &HA2
    ConvertIDtoBytes id, idBytes
    For i = 0 To 3
        buff(3 + i) = idBytes(i)
    Next i
    WriteMem ADR_FOLLOW_ID, id, 4
    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
End Function

Public Function Packet_Attack(id As Long) As Byte()
    Dim buff(9) As Byte, idByte() As Byte, i As Integer
    
    buff(0) = 8
    buff(1) = 0
    buff(2) = &H5
    buff(3) = &H0
    buff(4) = &HA1
    ConvertIDtoBytes id, idByte
    For i = 0 To 3
        buff(5 + i) = idByte(i)
    Next i
    
    WriteMem ADR_TARGET_ID, id, 4
    Packet_Attack = buff
End Function

Public Function Packet_Follow(id As Long) As Byte()
    Dim buff(9) As Byte, idByte() As Byte, i As Integer
    
    buff(0) = 8
    buff(1) = 0
    buff(2) = &H5
    buff(3) = &H0
    buff(4) = &HA2
    ConvertIDtoBytes id, idByte
    For i = 0 To 3
        buff(5 + i) = idByte(i)
    Next i
    
    WriteMem ADR_FOLLOW_ID, id, 4
    Packet_Follow = buff
End Function

Public Function Packet_CloseContainer(bpIndex As Long) As Byte()
    Dim buff(9) As Byte
    
    buff(0) = 8
    buff(1) = 0
    buff(2) = 2
    buff(3) = 0
    buff(4) = &H87
    buff(5) = bpIndex
    
    Packet_CloseContainer = buff
End Function

Public Function Packet_PrivateMessage(name As String, msg As String) As Byte()
    Dim buff() As Byte
    ReDim buff(8 * RoundUp(8 + Len(name) + Len(msg), 8) + 1) As Byte
    buff(1) = Fix((UBound(buff) - 1) / &H100)
    buff(0) = UBound(buff) - 1 - &H100 * buff(1)
    buff(3) = Fix((6 + Len(name) + Len(msg)) / &H100)
    buff(2) = 6 + Len(name) + Len(msg) - &H100 * buff(3)
    buff(3) = &H0
    buff(4) = &H96
    buff(5) = 4
    buff(6) = Len(name)
    buff(7) = &H0
    For i = 1 To Len(name)
        buff(7 + i) = Asc(Mid(name, i, 1))
    Next i
    buff(Len(name) + 8) = Len(msg)
    buff(Len(name) + 9) = 0
    For i = 1 To Len(msg)
        buff(Len(name) + 9 + i) = Asc(Mid(msg, i, 1))
    Next i
    Packet_PrivateMessage = buff
End Function

Public Function Packet_ChangeOutfit(outfit As Long, head As Long, body As Long, legs As Long, feet As Long) As Byte()
    Dim buff(17) As Byte
    
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = 7
    buff(3) = 0
    buff(4) = &HD3
    buff(5) = outfit
    buff(6) = 0
    buff(7) = head
    buff(8) = body
    buff(9) = legs
    buff(10) = feet
    
    Packet_ChangeOutfit = buff
End Function
