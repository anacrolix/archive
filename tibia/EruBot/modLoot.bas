Attribute VB_Name = "modLoot"
Option Explicit
Private lastCorpse As Long, corpseX As Long, corpseY As Long, corpseZ As Long
'Public curLooting As Boolean

Private Type typ_Corpse
    active As Long
    hp As Long
End Type

Private oldCorpses(LEN_CHAR - 1) As typ_Corpse

Private Sub FillArrCorpse(arrCorpse() As typ_Corpse)
    Dim i As Long
    For i = 0 To LEN_CHAR - 1
        arrCorpse(i).active = ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 4)
        arrCorpse(i).hp = ReadMem(ADR_CHAR_HP + i * SIZE_CHAR, 4)
    Next i
End Sub

Public Function GetLastCorpse(cID As Long, cX As Long, cY As Long, cZ As Long) As Boolean
    Dim newCorpses(LEN_CHAR - 1) As typ_Corpse, i As Long
    Dim pX As Long, pY As Long, pZ As Long
    FillArrCorpse newCorpses
    For i = 0 To LEN_CHAR - 1
        If oldCorpses(i).active <> 1 Or newCorpses(i).active <> 0 Then GoTo Continue
        If newCorpses(i).hp > 0 Then GoTo Continue
        getCharXYZ cX, cY, cZ, i
        getCharXYZ pX, pY, pZ, GetPlayerIndex
        If cZ <> pZ Then GoTo Continue
        If GetStepValue(pX - cX, pY - cY) < 0 Then GoTo Continue
        'Pause 500
        cID = GetTopObjTile(GetTileOffset(GetTileChar(ReadMem(ADR_PLAYER_ID, 4)), cX - pX, cY - pY, cZ - pZ))
        GetLastCorpse = True
        oldCorpses(i) = newCorpses(i)
        Exit Function
        Exit For
Continue:
    oldCorpses(i) = newCorpses(i)
    Next i
'    For i = 0 To LEN_CHAR - 1
'        oldCorpses(i) = newCorpses(i)
'    Next i
End Function

Public Function GetIndex_EmptyBP() As Long
    Dim i As Long
    For i = LEN_BP - 1 To 0 Step -1
        If ReadMem(ADR_BP_OPEN + i * SIZE_BP, 4) = 0 Then
            GetIndex_EmptyBP = i
            Exit Function
        End If
    Next i
End Function

Public Function GrabAllLoot() As Boolean
'    curLooting = True
    Dim i As Long, i2 As Long
    Dim item As Long, bpName As String, numItems As Long, bpIndex As Long, itemIndex As Long, quantity As Long
    Dim tarNumItems As Long, tarBpIndex As Long, tarQuant As Long, moved As Boolean
    Dim tarBP As typ_Container
    Dim bagFound As Boolean, bagSlot As Long
    Dim pX As Long, pY As Long, pZ As Long
    If StrInBounds(frmMain.txtLootCap.Text, 1, 10000) Then
        If ReadMem(ADR_CUR_CAP, 4) <= CLng(frmMain.txtLootCap) Then
            If frmMain.tmrAlert Then
                Alert_Change Medium
            Else
                Alert_Start Medium
                LogMsg "Cap minimum reached. Alarm started."
            End If
            GoTo EndGrabAllLoot
        End If
    End If
    If frmMain.chkLootThrowOnGround Then getCharXYZ pX, pY, pZ, GetPlayerIndex
    tarBpIndex = -1

    For bpIndex = LEN_BP - 1 To 0 Step -1
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bpIndex, 1) = 1 Then
            bpName = ReadMemStr(ADR_BP_NAME + SIZE_BP * bpIndex, 7)
            If Left(bpName, 3) = "Bag" Or Left(bpName, 4) = "Dead" Or Left(bpName, 5) = "Slain" Or Left(bpName, 5) = "Split" Or Left(bpName, 6) = "Remain" Then
                numItems = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bpIndex, 1)
                For itemIndex = numItems - 1 To 0 Step -1
                    item = ReadMem(ADR_BP_ITEM + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 2)
                    If frmLoot.IsLoot(item) Then
                        GrabAllLoot = True
                        If tarBpIndex < 0 Then
                            If FindItem(ITEM_ROPE, tarBpIndex, i, False, False) = False Then GoTo EndGrabAllLoot
                            tarBP.numItems = ReadMem(ADR_BP_NUM_ITEMS + (tarBpIndex - &H40) * SIZE_BP, 1)
                            tarBP.MaxItems = ReadMem(ADR_BP_MAX_ITEMS + (tarBpIndex - &H40) * SIZE_BP, 1)
                            ReDim tarBP.item(tarBP.MaxItems)
                            For i = 0 To tarBP.numItems - 1
                                tarBP.item(i).item = ReadMem(ADR_BP_ITEM + (tarBpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2)
                                If frmLoot.IsLoot(tarBP.item(i).item) Then tarBP.item(i).quantity = ReadMem(ADR_BP_ITEM_QUANTITY + (tarBpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 1)
                            Next i
                        End If
                        quantity = ReadMem(ADR_BP_ITEM_QUANTITY + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 1)
                        moved = False
                        If frmLoot.IsStackable(item) Then
                            For i = 0 To tarBP.numItems - 1
                                If tarBP.item(i).item = item Then
                                    If tarBP.item(i).quantity < 100 Then
                                        If tarBP.item(i).quantity + quantity <= 100 Then
                                            SendToServer Packet_MoveItem(item, bpIndex + &H40, itemIndex, tarBpIndex, i, quantity)
                                            moved = True
                                            tarBP.item(i).quantity = tarBP.item(i).quantity + quantity
                                            Pause 300
                                        ElseIf tarBP.item(i).quantity + quantity > 100 And tarBP.numItems < tarBP.MaxItems Then
                                            SendToServer Packet_MoveItem(item, bpIndex + &H40, itemIndex, tarBpIndex, i, quantity)
                                            moved = True
                                            Pause 300
                                            'tarBP.item(i).quantity = 100
                                            For i2 = tarBP.numItems To 1 Step -1
                                              tarBP.item(i2) = tarBP.item(i2 - 1)
                                            Next i2
                                            tarBP.item(0).item = item
                                            tarBP.item(0).quantity = tarBP.item(i + 1).quantity + quantity - 100
                                            tarBP.item(i + 1).quantity = 100
                                            tarBP.numItems = tarBP.numItems + 1
                                        Else
                                            GoTo EndGrabAllLoot
                                        End If
                                    End If
                                End If
                            Next i
                        End If
                        If tarBP.numItems < tarBP.MaxItems And moved = False Then
                            If frmMain.chkLootThrowOnGround And frmLoot.IsStackable(item) = False Then
                                SendToServer Packet_DropItem(item, quantity, bpIndex + &H40, itemIndex, pX, pY, pZ)
                                Pause 300
                            Else
                                SendToServer Packet_MoveItem(item, bpIndex + &H40, itemIndex, tarBpIndex, CInt(tarBP.MaxItems), quantity)
                                Pause 300
                                For i2 = tarBP.numItems To 1 Step -1
                                    tarBP.item(i2) = tarBP.item(i2 - 1)
                                Next i2
                                tarBP.item(0).item = item
                                tarBP.item(0).quantity = quantity
                                tarBP.numItems = tarBP.numItems + 1
                            End If
                        ElseIf moved = False Then
                            GoTo EndGrabAllLoot
                        End If
                    ElseIf item = ITEM_BAG Then
                        SendToServer Packet_UseHere(ITEM_BAG, bpIndex + &H40, itemIndex, GetIndex_EmptyBP)
                        DoEvents
                        Pause 500
                        DoEvents
                    ElseIf IsFood(item) Then
                        SendToServer Packet_UseHere(item, bpIndex + &H40, itemIndex)
                        Pause TIME_ACTION
                    End If
                Next itemIndex
                DoEvents
                SendToServer Packet_CloseContainer(bpIndex)
                Pause 100
            End If
        End If
    Next bpIndex
EndGrabAllLoot:
'    curLooting = False
    'If GrabAllLoot = True Then Pause 500
End Function

