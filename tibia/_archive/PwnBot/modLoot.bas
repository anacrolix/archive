Attribute VB_Name = "modLoot"
Public Function GetIndex_EmptyBP() As Long
    Dim i As Long
    For i = LEN_BP - 1 To 0 Step -1
        If ReadMem(ADR_BP_OPEN + i * SIZE_BP, 4) = 0 Then
            GetIndex_EmptyBP = i
            Exit Function
        End If
    Next i
End Function

Public Function IsLootableBp(bpIndex As Long) As Boolean
    Dim str1 As String
    str1 = ReadMemStr(ADR_BP_NAME + SIZE_BP * bpIndex, 32)
    If NameInList(ListIniPath, "loot lists", "loot containers", str1) Then GoTo Yes
    Exit Function
Yes:
    IsLootableBp = True
End Function

Public Function KeyContainsItemValue(val As Long, fileName As String, section As String, key As String) As Boolean
    If CheckIfIniKeyExists(fileName, section, key) = False Then
        WriteToINI fileName, section, key, ""
        GoTo Cancel
    End If
    Dim str1() As String, str2() As String, str3 As String, i As Integer
    On Error GoTo Cancel
    str1 = Split(ReadFromINI(fileName, section, key), ";")
    If UBound(str1) < 0 Then GoTo Cancel
    For i = LBound(str1) To UBound(str1)
        str2 = Split(str1(i), ",")
        If UBound(str2) < 1 Then GoTo NextValue
        str3 = Trim(str2(1))
        If StrIsBoundedLong(str3, 1, &H7FFFFFFF) = False Then GoTo NextValue
        If CLng(str3) <> val Then GoTo NextValue
        KeyContainsItemValue = True
        Exit Function
NextValue:
    Next i
    Exit Function
Cancel:
'    MsgBox "error parsing val list"
End Function

Public Function FindItem_Container(item As Long, itemExtra As Long, bpIndex As Long) As Long
    Dim lng1 As Long, lng2 As Long
    FindItem_Container = -1
    If ReadMem(ADR_BP_OPEN + bpIndex * SIZE_BP, 1) <> 1 Then Exit Function
    lng1 = ReadMem(ADR_BP_NUM_ITEMS + bpIndex * SIZE_BP, 1)
    If lng1 <= 0 Then Exit Function
    For lng2 = lng1 - 1 To 0 Step -1
        If ReadMem(ADR_BP_ITEM + bpIndex * SIZE_BP + lng2 * SIZE_ITEM, 2) = item Then
            FindItem_Container = lng2
            Exit Function
        End If
    Next lng2
End Function

Public Function FindItem_Inventory( _
    ByVal item As Long, _
    ByVal itemExtra As Long, _
    bpIndex As Long, _
    itemIndex As Long) _
As Boolean
    For bpIndex = 0 To LEN_BP - 1
        itemIndex = FindItem_Container(item, itemExtra, bpIndex)
        If itemIndex >= 0 Then
            FindItem_Inventory = True
            Exit Function
        End If
    Next bpIndex
    bpIndex = -1
    itemIndex = -1
End Function

Public Function IsLoot(ByVal id As Long) As Boolean
    If IsDropLoot(id) Then GoTo Yes
    If IsPickUpLoot(id) Then GoTo Yes
    If IsStackLoot(id) Then GoTo Yes
    Exit Function
Yes:
    IsLoot = True
End Function

Public Function GetLootBpMarkerId() As Long
    Const fileName = "\lists.ini"
    Const section = "loot lists"
    Const key = "loot bp marker"
    Dim filePath As String
    filePath = App.Path & fileName
    If CheckIfIniKeyExists(filePath, section, key) = False Then
        WriteToINI filePath, section, key, "Rope," & ITEM_ROPE
    End If
    Dim str1() As String, str2() As String, str3 As String
    str1 = Split(ReadFromINI(filePath, esction, key), ";")
    If UBound(str1) < 0 Then GoTo default
    str2 = Split(str1(0), ",")
    If UBound(str2) < 1 Then GoTo default
    str3 = Trim(str2(1))
    If StrIsBoundedLong(str3, 1, &H7FFF) = False Then GoTo default
    getlootbpmarker = CLng(str3)
    Exit Function
default:
    GetLootBpMarkerId = ITEM_ROPE
End Function

Public Function GetLootBpIndex(ByVal lootBpIndex As Long) As Long
    If FindItem_Container(GetLootBpMarkerId, 0, lootBpIndex) < 0 Then
        If FindItem_Inventory(GetLootBpMarkerId, 0, lootBpIndex, 0) = False Then
            GetLootBpIndex = -1
        Else
            GetLootBpIndex = lootBpIndex
        End If
    Else
        GetLootBpIndex = lootBpIndex
    End If
End Function

Public Function IsDropLoot(ByVal id As Long) As Boolean
    If KeyContainsItemValue(id, App.Path & "\lists.ini", "loot lists", "drop loot") Then IsDropLoot = True
End Function

Public Function IsPickUpLoot(ByVal id As Long) As Boolean
    If KeyContainsItemValue(id, App.Path & "\lists.ini", "loot lists", "pickup loot") Then IsPickUpLoot = True
End Function

Public Function IsStackLoot(ByVal id As Long) As Boolean
    If KeyContainsItemValue(id, App.Path & "\lists.ini", "loot lists", "stack loot") Then IsStackLoot = True
End Function

'0 = nothing happened
'1 = item was taken
'2 = container search was finished
'3 = no bp marker
'4 = loot can't fit
Public Function GrabLoot(curTick As Long) As Long
    Static bpIndex As Long, itemIndex As Long, lootBpIndex As Long, lootBp As typ_Container, fresh As Boolean, markToClose As Boolean
    If bpIndex < 0 Then bpIndex = LEN_BP - 1
    
    For bpIndex = bpIndex To 0 Step -1
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bpIndex, 1) <> 1 Then GoTo NextBp
        If IsLootableBp(bpIndex) = False Then GoTo NextBp
        Dim curBpItemCount As Long
        curBpItemCount = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bpIndex)
        If curBpItemCount <= 0 Or markToClose Then GoTo CloseBp
        If itemIndex = -1 Or itemIndex >= curBpItemCount Then itemIndex = curBpItemCount - 1
        For itemIndex = itemIndex To 0 Step -1
            Dim itemID As Long, itemQuantity As Long
            itemID = ReadMem(ADR_BP_ITEM + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 2)
            itemQuantity = ReadMem(ADR_BP_ITEM_QUANTITY + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 1)
            'update loot bp copy
            If IsStackLoot(itemID) Or IsPickUpLoot(itemID) Then
                Dim tempLootBpIndex As Long
                tempLootBpIndex = GetLootBpIndex(lootBpIndex)
                If tempLootBpIndex < 0 Then GoTo NoLootBpMarker
                If tempLootBpIndex <> lootBpIndex Then fresh = False
                lootBpIndex = tempLootBpIndex
                If fresh = False Then
                    ReadProcessMemory hProcClient, ADR_BP_OPEN + lootBpIndex * SIZE_BP, lootBp, Len(lootBp), 0
                    fresh = True
                End If
            End If
            'do loot relevant actions
            If itemID = ITEM_BAG Then
                SendToServer Packet_UseHere(itemID, bpIndex + &H40, itemIndex, GetIndex_EmptyBP)
                GoTo OpenedBag
            ElseIf IsDropLoot(itemID) Then 'nonstackable
                UpdateCharMem
                With charMem.char(GetPlayerIndex)
                    SendToServer Packet_DropItem(itemID, itemQuantity, bpIndex + &H40, itemIndex, .x, .y, .z)
                End With
                GoTo TookItem
            ElseIf IsStackLoot(itemID) Then 'stackable
                Dim smallestPileIndex As Long, smallestPileQuantity As Long
                Dim curPileIndex As Long, curPileQuantity As Long
                Dim bpFull As Boolean
                If lootBp.itemCount + 1 > lootBp.maxItems Then bpFull = True
                smallestPileQuantity = 100
                smallestPileIndex = -1
                For curPileIndex = lootBp.itemCount - 1 To 0 Step -1
                    If lootBp.items(curPileIndex).id <> itemID Then GoTo NextPile
                    curPileQuantity = lootBp.items(curPileIndex).extra1
                    If curPileQuantity >= smallestPileQuantity Then GoTo NextPile
                    smallestPileQuantity = curPileQuantity
                    smallestPileIndex = curPileIndex
                    Exit For
NextPile:
                Next curPileIndex
                'item can fit in another pile
                If smallestPileIndex >= 0 And smallestPileQuantity + itemQuantity <= 100 Then
                    SendToServer Packet_MoveItem(itemID, bpIndex + &H40, itemIndex, lootBpIndex + &H40, smallestPileIndex, itemQuantity)
                    lootBp.items(smallestPileIndex).extra1 = lootBp.items(smallestPileIndex).extra1 + itemQuantity
                    GoTo TookItem
                'item can overflow another pile and bp isn't full
                ElseIf smallestPileIndex >= 0 And smallestPileQuantity + itemQuantity > 100 And bpFull = False Then
                    SendToServer Packet_MoveItem(itemID, bpIndex + &H40, itemIndex, lootBpIndex + &H40, smallestPileIndex, itemQuantity)
                    'update overflowed pile
                    lootBp.items(smallestPileIndex).extra1 = 100
                    'move backpack up
                    Dim shiftIndex As Long
                    For shiftIndex = lootBp.itemCount To 1 Step -1
                        lootBp.items(shiftIndex) = lootBp.items(shiftIndex - 1)
                    Next shiftIndex
                    'copy moved item in
                    ReadProcessMemory hProcClient, ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, lootBp.items(0), SIZE_ITEM, 0
                    'adjust for overflow quantity
                    lootBp.items(0).extra1 = smallestPileQuantity + itemQuantity - 100
                    'adjust total bp fullness
                    lootBp.itemCount = lootBp.itemCount + 1
                    GoTo TookItem
                'item can partially fit and bp is full
                ElseIf smallestPileIndex >= 0 And bpFull = True Then
                    SendToServer Packet_MoveItem(itemID, bpIndex + &H40, itemIndex, lootBpIndex + &H40, smallestPileIndex, itemQuantity)
                    lootBp.items(smallestPileIndex).extra1 = 100
                    GoTo TookItem
                'no similar nonfull piles and bp not full
                ElseIf bpFull = False And smallestPileIndex < 0 Then
                    'move bp memory up
                    SendToServer Packet_MoveItem(itemID, bpIndex + &H40, itemIndex, lootBpIndex + &H40, lootBp.maxItems, itemQuantity)
                    For shiftIndex = lootBp.itemCount To 1 Step -1
                        lootBp.items(shiftIndex) = lootBp.items(shiftIndex - 1)
                    Next shiftIndex
                    'copy in the moved item
                    ReadProcessMemory hProcClient, ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, lootBp.items(0), SIZE_ITEM, 0
                    'adjust bp fullness
                    lootBp.itemCount = lootBp.itemCount + 1
                    GoTo TookItem
                End If
                'item can't fit
                GoTo NextItem
            ElseIf IsPickUpLoot(itemID) Then
                If lootBp.itemCount + 1 > lootBp.maxItems Then GoTo NextItem
                'pickup item
                SendToServer Packet_MoveItem(itemID, bpIndex + &H40, itemIndex, lootBpIndex + &H40, lootBp.maxItems, itemQuantity)
                For shiftIndex = 1 To lootBp.maxItems
                    lootBp.items(shiftIndex) = lootBp.items(shiftIndex - 1)
                Next shiftIndex
                'copy in the moved item
                ReadProcessMemory hProcClient, ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, lootBp.items(0), SIZE_ITEM, 0
                'adjust bp fullness
                lootBp.itemCount = lootBp.itemCount + 1
                GoTo TookItem
            ElseIf IsFood(itemID) Then
                SendToServer Packet_UseHere(itemID, bpIndex + &H40, itemIndex)
                GoTo TookItem
            End If
NextItem:
        Next itemIndex
    GoTo CloseBp
NextBp:
    itemIndex = -1
    Next bpIndex
    Exit Function
TookItem:
    GrabLoot = 1
    GoTo DecrementLootIndex
CloseBp:
    fresh = False
    GrabLoot = 2
    SendToServer Packet_CloseContainer(bpIndex)
    markToClose = False
    bpIndex = bpIndex - 1
    itemIndex = -1
    Exit Function
OpenedBag:
    GrabLoot = 1
    GoTo DecrementLootIndex
DecrementLootIndex:
    itemIndex = itemIndex - 1
    If itemIndex < 0 Then markToClose = True
    Exit Function
NoLootBpMarker:
    GrabLoot = 3
    Exit Function
End Function


