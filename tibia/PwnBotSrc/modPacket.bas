Attribute VB_Name = "modPacket"
'Public Function Packet_LogOut() As Byte()
'    Dim buff(9) As Byte
'
'    buff(0) = 8
'    buff(1) = 0
'    buff(2) = 1
'    buff(3) = 0
'    buff(4) = &H14
'
'    Packet_LogOut = buff
'End Function
'
'Public Sub SendToClient(buff() As Byte)
'    If (UBound(buff) - 1) Mod 8 <> 0 Then
'        LogMsg "BUG: Inbound packet is of invalid length for XTEA encryption"
'        Exit Sub
'    End If
'    If frmMain.mnuFilterIncoming.Checked _
'    Then LogMsg "inbound erubot packet: " & PacketToString(buff) & " EOF"
'    UpdateEncryptionKey
'    EncodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
'    If frmMain.sckClient.State = sckConnected Then frmMain.sckClient.SendData buff
'End Sub

Public Sub SendToClient(buff() As Byte)
    If (UBound(buff) - 1) Mod 8 <> 0 Then
        MsgBox "incoming bot packet has invalid length"
        Exit Sub
    End If
    Dim encBuff() As Byte
    encBuff = buff
    EncipherXteaPacket encBuff(0), UBound(encBuff) + 1, xteaKey(0)
    If frmMain.chkRecordPackets Then
        If IsGameActive = False Then
            MsgBox "bot sending packets while game inactive"
        End If
        If frmPacket.chkShowBotPackets Then
            frmPacket.IncomingBotPacket buff
        End If
    End If
    If frmMain.sckGameClient.State = sckConnected Then frmMain.sckGameClient.SendData encBuff
End Sub

Public Sub SendToServer(buff() As Byte)
    If (UBound(buff) - 1) Mod 8 <> 0 Then
        MsgBox "outgoing bot packet has invalid length"
        Exit Sub
    End If
    Dim encBuff() As Byte
    encBuff = buff
    EncipherXteaPacket encBuff(0), UBound(encBuff) + 1, xteaKey(0)
    If frmMain.chkRecordPackets Then
        If IsGameActive = False Then
            MsgBox "bot sending packets while game inactive :\"
        End If
        If frmPacket.chkShowBotPackets Then
            frmPacket.OutgoingBotPacket buff
        End If
    End If
    If frmMain.sckGameServer.State = sckConnected Then frmMain.sckGameServer.SendData encBuff
End Sub

'Public Function Packet_UseAtLocation(item As Long, fromLoc As Long, fromSlot As Long, toX As Long, toY As Long, toZ As Long) As Byte()
'    Dim buff(25) As Byte
'    Dim byte1 As Byte
'    Dim byte2 As Byte
'    buff(0) = &H18
'    buff(1) = &H0
'    buff(2) = &H11
'    buff(3) = 0
'    buff(4) = &H83
'    buff(5) = &HFF
'    buff(6) = &HFF
'    buff(7) = fromLoc
'    buff(8) = &H0
'    buff(9) = fromSlot
'    byte1 = Fix(item / 256)
'    byte2 = item - (Fix(item / 256) * 256)
'    buff(10) = byte2
'    buff(11) = byte1
'    buff(12) = fromSlot
'    byte1 = Fix(toX / 256)
'    byte2 = toX - (Fix(toX / 256) * 256)
'    buff(13) = byte2
'    buff(14) = byte1
'    byte1 = Fix(toY / 256)
'    byte2 = toY - (Fix(toY / 256) * 256)
'    buff(15) = byte2
'    buff(16) = byte1
'    buff(17) = toZ
'    If item = ITEM_FISHING_ROD Then
'        buff(18) = &HF5 + Int(Rnd * 6)
'        buff(19) = &H11
'        buff(20) = &H0
'    ElseIf item = ITEM_ROPE Then
'        buff(18) = &H82
'        buff(19) = 1
'        buff(20) = 0
'    Else
'        buff(18) = &H63
'        buff(19) = &H0
'        buff(20) = &H1
'    End If
'    Packet_UseAtLocation = buff
'End Function
'
Public Function Packet_DropItem(item As Long, quantity As Long, fromLoc As Long, fromSlot As Long, toX As Long, toY As Long, toZ As Long) As Byte()
'18 00 0F 00 78 FF FF 40 00 00 D7 0B 00 C0 80 2D 7D 06 5F B6 32 02 B6 60 80 76 EOF
    Dim buff(25) As Byte
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
    buff(10) = GetByte(0, item)
    buff(11) = GetByte(1, item)
    '????
    buff(12) = fromSlot
    'x
    buff(13) = GetByte(0, toX)
    buff(14) = GetByte(1, toX)
    'y
    buff(15) = GetByte(0, toY)
    buff(16) = GetByte(1, toY)
    'z
    buff(17) = toZ
    'quantity
    buff(18) = quantity
    'return packet
    Packet_DropItem = buff
End Function

Public Function Packet_MoveItem( _
    ByVal item As Long, _
    ByVal fromLoc As Long, _
    ByVal fromSlot As Long, _
    ByVal toLoc As Long, _
    ByVal toSlot As Long, _
    ByVal quant As Long) _
As Byte()
    Dim buff(25) As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = 15
    buff(3) = 0
    buff(4) = &H78
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    buff(10) = GetByte(0, item)
    buff(11) = GetByte(1, item)
    buff(12) = fromSlot
    buff(13) = &HFF
    buff(14) = &HFF
    buff(15) = toLoc
    buff(16) = &H0
    buff(17) = toSlot
    buff(18) = quant
    Packet_MoveItem = buff
End Function
'
'Public Function Packet_GrabItem(item As Long, fromX As Long, fromY As Long, fromZ As Long, toLoc As Integer, toSlot As Integer, quant As Long)
'    Dim buff(16) As Byte
'    Dim byte1 As Byte
'    Dim byte2 As Byte
'    buff(0) = &HF
'    buff(1) = &H0
'    buff(2) = &H78
'    byte1 = fromX - (Fix(fromX / 256) * 256)
'    byte2 = Fix(fromX / 256)
'    buff(3) = byte1
'    buff(4) = byte2
'    byte1 = fromY - (Fix(fromY / 256) * 256)
'    byte2 = Fix(fromY / 256)
'    buff(5) = byte1
'    buff(6) = byte2
'    buff(7) = fromZ
'    byte1 = Fix(item / 256)
'    byte2 = item - (Fix(item / 256) * 256)
'    buff(8) = byte2
'    buff(9) = byte1
'    buff(10) = fromSlot
'    buff(11) = &HFF
'    buff(12) = &HFF
'    buff(13) = toLoc
'    buff(14) = &H0
'    buff(15) = toSlot
'    buff(16) = quant
'    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
'End Function
'
'Public Function Packet_UseGround(id As Long, X As Long, Y As Long, z As Long, objType As Integer, Optional newLoc As Integer = 0) As Byte()
''10 00 0A 00 82 0D 80 60 7B 08 A5 0F 02 01 C0 C3 27 24 EOF
''10 00 0A 00 82 0D 80 5F 7B 08 62 01 00 01 5C 17 EF BC EOF
''len-2 cmd-2 cmd xxxx yy yy zz id id new - -  -  -  -
'    Dim buff(17) As Byte, bytes() As Byte
'    buff(0) = UBound(buff) - 1
'    buff(1) = 0
'    buff(2) = &HA 'len-2
'    buff(3) = 0 '?
'    buff(4) = &H82 'command usehere
'    ConvertLongToBytes X, bytes, 2
'    buff(5) = bytes(0)
'    buff(6) = bytes(1)
'    ConvertLongToBytes Y, bytes, 2
'    buff(7) = bytes(0)
'    buff(8) = bytes(1)
'    buff(9) = z
'    ConvertLongToBytes id, bytes, 2
'    buff(10) = bytes(0)
'    buff(11) = bytes(1)
'    buff(12) = objType
'    buff(13) = newLoc
'    Packet_UseGround = buff
'End Function
'
Public Function Packet_UseHere( _
    ByVal item As Long, _
    ByVal fromLoc As Long, _
    ByVal fromSlot As Long, _
    Optional ByVal newLoc As Long = 0) _
As Byte()
    Dim buff(17) As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = 10
    buff(3) = &H0
    buff(4) = &H82
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = &H0
    buff(9) = fromSlot
    buff(10) = GetByte(0, item)
    buff(11) = GetByte(1, item)
    buff(12) = fromSlot
    buff(13) = newLoc
    Packet_UseHere = buff
End Function
'
'Public Function Packet_UpBpLevel(bpIndex As Long) As Byte()
'    Dim buff(9) As Byte
'    buff(0) = 8
'    buff(1) = 0
'    buff(2) = &H2
'    buff(3) = &H0
'    buff(4) = &H88
'    buff(5) = bpIndex
'
'    Packet_UpBpLevel = buff
'    LogDbg "Constructed 'move up backpack level #" & bpIndex & " packet."
'End Function
'
Public Function Packet_SayDefault( _
    str As String) _
As Byte()
    Dim lenPacket As Integer, lenUnit As Integer
    lenUnit = Len(str) + 4
    lenPacket = 8 * RoundUp(CLng(lenUnit) + 2, 8)
    Dim buff() As Byte, i As Integer
    ReDim buff(lenPacket + 1) As Byte
    buff(0) = GetByte(0, lenPacket)
    buff(1) = GetByte(1, lenPacket)
    buff(2) = GetByte(0, lenUnit)
    buff(3) = GetByte(1, lenUnit)
    buff(4) = &H96
    buff(5) = &H1
    buff(6) = GetByte(0, Len(str))
    buff(7) = GetByte(1, Len(str))
    For i = 1 To Len(str)
        buff(i + 7) = Asc(Mid(str, i, 1))
    Next i
    Packet_SayDefault = buff
End Function

Public Function Packet_UseAt( _
    itemID As Long, _
    itemExtra As Long, _
    tarID As Long, _
    Optional fromLoc As Long = 0, _
    Optional fromSlot As Long = 0) _
As Byte()
    Dim buff(17) As Byte, byteID() As Byte, i As Long
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = &HD
    buff(3) = 0
    buff(4) = &H84
    buff(5) = &HFF
    buff(6) = &HFF
    buff(7) = fromLoc
    buff(8) = 0
    buff(9) = fromSlot
    buff(10) = GetByte(0, itemID)
    buff(11) = GetByte(1, itemID)
    buff(12) = itemExtra
    For i = 0 To 3
        buff(13 + i) = GetByte(i, tarID)
    Next i
    Packet_UseAt = buff
End Function

'Public Function Packet_UseAtMonster(item As Long, fromLoc As Long, fromSlot As Long, id As Long) As Byte()
'    '0D 00 84 FF FF 45 00 00 7E 0C 00 A3 A9 00 40
'    Dim buff(17) As Byte, bytID() As Byte, i As Integer
'    buff(0) = UBound(buff) - 1
'    buff(1) = 0
'    buff(2) = &HD
'    buff(3) = &H0
'    buff(4) = &H84
'    buff(5) = &HFF
'    buff(6) = &HFF
'    buff(7) = fromLoc
'    buff(8) = &H0
'    buff(9) = fromSlot
'    'rune id
'    buff(11) = Fix(item / 256)
'    buff(10) = item - (Fix(item / 256) * 256)
'    buff(12) = fromSlot
'    ConvertIDtoBytes id, bytID
'    For i = 0 To 3
'        buff(13 + i) = bytID(i)
'    Next i
'    Packet_UseAtMonster = buff
'End Function
'
'Public Function MessagePerson(CharTo As String, MessageTo As String)
'    Dim buff() As Byte
'    Dim C1 As Byte
'    ReDim buff(7 + Len(CharTo) + Len(MessageTo)) As Byte
'    buff(0) = 6 + Len(CharTo) + Len(MessageTo)
'    buff(1) = &H0
'    buff(2) = &H96
'    buff(3) = &H4
'    buff(4) = Len(CharTo)
'    For C1 = 6 To Len(CharTo) + 5
'        buff(C1) = Asc(Right(CharTo, Len(CharTo) + 6 - C1))
'    Next
'    buff(C1) = Len(MessageTo)
'    buff(C1 + 1) = &H0
'    For C1 = C1 + 2 To C1 + 1 + Len(MessageTo)
'        buff(C1) = Asc(Right(MessageTo, Len(MessageTo) + 8 + Len(CharTo) - C1))
'    Next
'    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
'End Function
'
'Public Function Packet_TurnDirection(dir As Long) As Byte()
'    Dim buff() As Byte
'    ReDim buff(9)
'    buff(0) = UBound(buff) - 1
'    buff(1) = 0
'    buff(2) = 1
'    buff(3) = 0
'    buff(4) = &H6F + dir
'    Packet_TurnDirection = buff
'End Function
'
Public Function Packet_Step(dir As Long) As Byte()
    Dim buff() As Byte
    ReDim buff(8 * RoundUp(2 + 1, 8) + 1)
    buff(0) = UBound(buff) - 1
    buff(1) = 0
    buff(2) = 1
    buff(3) = 0
    For i = 0 To 1 - 1
        buff(i + 4) = dir + &H65
    Next i
    Packet_Step = buff
End Function
'
'Public Function FollowHim(id As Long)
'    Dim buff(6) As Byte, idBytes() As Byte, i As Integer
'    buff(0) = &H5
'    buff(1) = &H0
'    buff(2) = &HA2
'    ConvertIDtoBytes id, idBytes
'    For i = 0 To 3
'        buff(3 + i) = idBytes(i)
'    Next i
'    WriteMem ADR_FOLLOW_ID, id, 4
'    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
'End Function
'
Public Function Packet_Attack(id As Long) As Byte()
    Dim buff(9) As Byte, i As Integer

    buff(0) = 8
    buff(1) = 0
    buff(2) = &H5
    buff(3) = &H0
    buff(4) = &HA1
    For i = 0 To 3
        buff(5 + i) = GetByte(i, id)
    Next i
    Packet_Attack = buff
End Function

Public Function Packet_Follow(id As Long) As Byte()
    Dim buff(9) As Byte, i As Integer

    buff(0) = 8
    buff(1) = 0
    buff(2) = &H5
    buff(3) = &H0
    buff(4) = &HA2
    For i = 0 To 3
        buff(5 + i) = GetByte(i, id)
    Next i
    Packet_Follow = buff
End Function

Public Function Packet_CloseContainer( _
    bpIndex As Long) _
As Byte()
    Dim buff(9) As Byte
    buff(0) = 8
    buff(1) = 0
    buff(2) = 2
    buff(3) = 0
    buff(4) = &H87
    buff(5) = bpIndex
    Packet_CloseContainer = buff
End Function
'
'Public Function Packet_PrivateMessage(Name As String, msg As String) As Byte()
'    Dim buff() As Byte
'    ReDim buff(8 * RoundUp(8 + Len(Name) + Len(msg), 8) + 1) As Byte
'    buff(1) = Fix((UBound(buff) - 1) / &H100)
'    buff(0) = UBound(buff) - 1 - &H100 * buff(1)
'    buff(3) = Fix((6 + Len(Name) + Len(msg)) / &H100)
'    buff(2) = 6 + Len(Name) + Len(msg) - &H100 * buff(3)
'    buff(3) = &H0
'    buff(4) = &H96
'    buff(5) = 4
'    buff(6) = Len(Name)
'    buff(7) = &H0
'    For i = 1 To Len(Name)
'        buff(7 + i) = Asc(Mid(Name, i, 1))
'    Next i
'    buff(Len(Name) + 8) = Len(msg)
'    buff(Len(Name) + 9) = 0
'    For i = 1 To Len(msg)
'        buff(Len(Name) + 9 + i) = Asc(Mid(msg, i, 1))
'    Next i
'    Packet_PrivateMessage = buff
'End Function
'
'Public Function Packet_ChangeOutfit(outfit As Long, head As Long, body As Long, legs As Long, feet As Long, addons As Long) As Byte()
'    Dim buff(17) As Byte
'
'    buff(0) = UBound(buff) - 1
'    buff(1) = 0
'    buff(2) = 8
'    buff(3) = 0
'    buff(4) = &HD3
'    buff(5) = outfit
'    buff(6) = 0
'    buff(7) = head
'    buff(8) = body
'    buff(9) = legs
'    buff(10) = feet
'    buff(11) = addons
'
'    Packet_ChangeOutfit = buff
'End Function

'channel 4=default
Public Function Packet_ReceiveMessage( _
    ByVal sender As String, _
    ByVal level As Integer, _
    ByVal channel As Byte, _
    ByVal msg As String) _
As Byte()
    Dim lenPacket As Integer, lenUnit As Integer
    lenUnit = 12 + Len(sender) + Len(msg)
    lenPacket = 8 * RoundUp(CLng(lenUnit) + 4, 8) 'lenUnit+2 for unit header, 2 for unit tail "FFFF"
    Dim buff() As Byte, j As Long, i As Integer
    ReDim buff(lenPacket + 1)
    buff(0) = GetByte(0, lenPacket)
    buff(1) = GetByte(1, lenPacket)
    buff(2) = GetByte(0, lenUnit)
    buff(3) = GetByte(1, lenUnit)
    buff(4) = &HAA
    buff(9) = GetByte(0, Len(sender))
    buff(10) = GetByte(1, Len(sender))
    i = 10
    For j = 1 To Len(sender)
        buff(i + j) = CByte(Asc(Mid(sender, j, 1)))
    Next j
    i = i + Len(sender)
    buff(i + 1) = GetByte(0, level)
    buff(i + 2) = GetByte(1, level)
    buff(i + 3) = channel
    buff(i + 4) = GetByte(0, Len(msg))
    buff(i + 5) = GetByte(1, Len(msg))
    i = i + 5
    For j = 1 To Len(msg)
        buff(i + j) = CByte(Asc(Mid(msg, j, 1)))
    Next j
    i = i + Len(msg)
    buff(i + 1) = &HFF
    buff(i + 2) = &HFF
    Packet_ReceiveMessage = buff
End Function

'    Client->Server (10)
' 08000100BE4DAFDA 161B
Public Function Packet_StopAction() As Byte()
    Dim lenPacket As Integer, lenUnit As Integer
    lenUnit = 1
    lenPacket = 8 * RoundUp(CLng(lenUnit) + 2, 8)
    Dim buff() As Byte
    ReDim buff(lenPacket + 1)
    buff(0) = GetByte(0, lenPacket)
    buff(1) = GetByte(1, lenPacket)
    buff(2) = GetByte(0, lenUnit)
    buff(3) = GetByte(1, lenUnit)
    buff(4) = &HBE
    Packet_StopAction = buff
End Function
