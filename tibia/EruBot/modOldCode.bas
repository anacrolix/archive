Attribute VB_Name = "modOldCode"
'''Dim keysDown(255) As Boolean
'''Dim healStop As Long
'''Dim healMana As Long
'''Dim healSpell As String
'''
'''Private Sub combobutton_Click(Index As Integer)
'''  Dim c As Integer
'''  If comboButton(Index).ListIndex = -1 Then Exit Sub
'''  If comboButton(Index).ListIndex = 6 Then
'''    comboButton(Index).ListIndex = -1
'''    Exit Sub
'''  End If
'''  For c = comboButton.LBound To comboButton.UBound
'''    If comboButton(c).ListIndex = comboButton(Index).ListIndex And c <> Index Then
'''      comboButton(c).ListIndex = -1
'''      Exit Sub
'''    End If
'''  Next c
'''End Sub
'''
'''Private Sub Command1_Click()
'''  Me.Hide
'''End Sub
'''
'''Private Sub Form_Load()
'''    hscrHealAt_Change
'''End Sub
'''
'''Private Sub hscrHealAt_Change()
'''    lblHealAt = "Heal friends at " & hscrHealAt & "% of full hp"
'''End Sub
'''
'''Private Sub tmrExura_Timer()
'''    If ReadMem(ADR_CUR_HP, 2) < healStop And ReadMem(ADR_CUR_MANA, 2) >= healMana Then
'''        SayStuff healSpell
'''    Else
'''        tmrExura.Enabled = False
'''    End If
'''End Sub
'''
'''Private Sub tmrTime_Timer()
'''    On Error Resume Next 'Error Handling
'''    'To check if delete key is pressed
'''    If GetForegroundWindow <> hwndTibia Then Exit Sub
'''
'''    If GetPressedKey(vbKeyDelete) Then ButtonDown "Delete": Exit Sub
'''    If GetPressedKey(vbKeyPageDown) Then ButtonDown "PageDown": Exit Sub
'''    If GetPressedKey(vbKeyHome) Then ButtonDown "Home": Exit Sub
'''    If GetPressedKey(vbKeyPageUp) Then ButtonDown "PageUp": Exit Sub
'''    If GetPressedKey(vbKeyInsert) Then ButtonDown "Insert": Exit Sub
'''    If GetPressedKey(vbKeyEnd) Then ButtonDown "End": Exit Sub
'''
'''    Dim i As Long
'''    For i = vbKeyF1 To vbKeyF12
'''        If GetPressedKey(i) Then ButtonDown "F" & i - vbKeyF1 + 1: Exit Sub
'''    Next i
'''End Sub
'''
'''Private Function GetPressedKey(key As Long) As Boolean
'''    GetPressedKey = False
'''    If keysDown(key) = False And GetAsyncKeyState(key) Then
'''        keysDown(key) = True
'''        GetPressedKey = True
'''    Else
'''        If GetAsyncKeyState(key) = 0 Then keysDown(key) = False
'''    End If
'''End Function
'''
'''Public Sub ToggleHealToFull(hp As Long, mana As Long, spell As String)
'''    healStop = hp
'''    healMana = mana
'''    healSpell = spell
'''    If tmrExura.Enabled = False Then
'''        tmrExura.Enabled = True
'''    Else
'''        tmrExura.Enabled = False
'''    End If
'''End Sub
'''
'''Private Sub ButtonDown(Button As String)
'''    Dim c As Integer
'''    For c = comboButton.LBound To comboButton.UBound
'''        If comboButton(c).Text = Button Then
'''            Select Case c
'''                Case 0 To 8: AimbotRune lblAction(c).Caption
'''                Case 9 To 10: SwapWeaponConfig (c - 9)
'''                Case 11: DrinkFluid
'''                Case 12:
'''                    If frmMageCrew.mageCrewActive = False Then
'''                        frmMageCrew.LogInMageCrew
'''                    Else
'''                        frmMageCrew.LogOutMageCrew
'''                    End If
'''                Case 13: ToggleHealToFull 0.95 * ReadMem(ADR_MAX_HP, 4), 25, "exura"
'''            End Select
'''            Exit Sub
'''        End If
'''    Next c
'''End Sub
'''
'''Private Sub DrinkFluid()
'''    Dim pX As Long, pY As Long, pZ As Long
'''    Static bpIndex As Integer, slotIndex As Integer
'''    Dim curMana As Long, maxMana As Long
'''    Dim foundFluid As Boolean, moveUpBp As Boolean
'''    Dim i As Integer
'''
'''    curMana = ReadMem(ADR_CUR_MANA, 2)
'''    maxMana = ReadMem(ADR_MAX_MANA, 2)
'''
'''    If curMana < maxMana * 0.8 Or curMana < maxMana - 60 Then
'''        foundFluid = False
'''        'have fluided b4 from bp, and current fluid is not last in bp and bp still open
'''        'If bpIndex >= &H40 And slotIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1 _
'''        'And ReadMem(ADR_BP_OPEN + (bpIndex - &H40) * SIZE_BP, 1) = 1 Then
'''        '    If confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (slotIndex + 1) * SIZE_ITEM, ITEM_VIAL) Then
'''        '        foundFluid = True
'''        '        slotIndex = slotIndex + 1
'''        '    End If
'''        'End If
'''
'''        'If Not foundFluid Then
'''        If findItem(ITEM_VIAL, bpIndex, slotIndex, True, True) Then foundFluid = True
'''        'End If
'''
'''        If foundFluid Then
'''            'send use fluid packet
'''            getCharXYZ pX, pY, pZ, UserPos
'''            UseAt ITEM_VIAL, bpIndex, slotIndex, pX, pY, pZ
'''
'''            'check that move up bp is checked and that the next item is a fluid
'''            moveUpBp = True
'''            If chkFluidMoveUpBP.Value = Checked Then
'''                If bpIndex >= &H40 And slotIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1 Then _
'''                If confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (slotIndex + 1) * SIZE_ITEM, ITEM_VIAL) Then _
'''                moveUpBp = False
'''            Else
'''                moveUpBp = False
'''            End If
'''
'''            'if next item not fluid then search entire bp
'''            If moveUpBp Then
'''                For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1 'forgot the -1 previously
'''                    If i <> slotIndex And confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, ITEM_VIAL) Then
'''                        moveUpBp = False
'''                        Exit For
'''                    End If
'''                Next i
'''            End If
'''
'''            'if still no fluid then move up bp
'''            If moveUpBp Then
'''                Pause 50
'''                UpBpLevel bpIndex - &H40
'''                itemIndex = 0
'''                Beep 800, 50
'''            End If
'''            DoEvents
'''        Else
'''            LogMsg "No fluid found."
'''            Beep 400, 100
'''        End If
'''    Else
'''        LogMsg "Mana not low enough to require fluid"
'''    End If
'''End Sub
'''
'''Private Sub SwapWeaponConfig(configIndex As Integer)
'''    'Bright sword
'''    'Fire axe
'''    'Skull staff
'''    'Dragon hammer
'''    'Giantsword
'''    'Dragonlance
'''    'Bow
'''    'Crossbow
'''
'''    Dim desWeap As Long, curItem As Long, bpIndex As Integer, slotIndex As Integer, itemShield As Long
'''
'''    Select Case comboWeapon(configIndex).ListIndex
'''        Case 0: desWeap = ITEM_BRIGHT_SWORD
'''        Case 1: desWeap = ITEM_FIRE_AXE
'''        Case 2: desWeap = ITEM_SKULL_STAFF
'''        Case 3: desWeap = ITEM_DRAGON_HAMMER
'''        Case 4: desWeap = ITEM_GIANT_SWORD
'''        Case 5: desWeap = ITEM_DRAGON_LANCE
'''        Case 6: desWeap = ITEM_BOW
'''        Case 7: desWeap = ITEM_CROSS_BOW
'''        Case 8: desWeap = ITEM_ICE_RAPIER
'''    End Select
'''    If findItem(desWeap, bpIndex, slotIndex, False) Then
'''        itemShield = ReadMem(ADR_LEFT_HAND, 2)
'''        If itemShield <> 0 Then
'''            MoveItem itemShield, SLOT_LEFT_HAND, 0, SLOT_AMMO, 0, 100
'''            DoEvents
'''            Pause 150
'''        End If
'''        MoveItem desWeap, bpIndex, slotIndex, SLOT_RIGHT_HAND, 0, 100
'''        If chkGetShield(configIndex).Value = Checked Then
'''            Pause 150
'''            curItem = ReadMem(ADR_AMMO, 2)
'''            MoveItem curItem, SLOT_AMMO, 0, SLOT_LEFT_HAND, 0, 100
'''            DoEvents
'''        End If
'''    End If
'''End Sub
'''
'''Private Sub AimbotRune(runeToFire As String)
'''    Dim targetPos As Long, runeID As Long, runeTick As Long
'''    targetPos = -1: runeID = -1
'''    runeTick = GetTickCount
'''
'''    If runeToFire = "UH Self" Then
'''        runeID = ITEM_RUNE_UH 'rune
'''        targetPos = UserPos
'''    ElseIf runeToFire = "UH Friend" Then
'''        runeID = ITEM_RUNE_UH
'''        If chkHealSelf.Value = Checked And ReadMem(ADR_CUR_HP, 2) < frmHeal.txtHP Then
'''            targetPos = UserPos
'''        ElseIf listFriends.ListCount > 0 Then
'''            targetPos = GetIndexByHP(listFriends, hscrHealAt.Value, chkHealLowest.Value)
'''        Else
'''            Exit Sub
'''        End If
'''    Else
'''        Dim targetID As Long
'''        targetID = -1
'''
'''        targetPos = GetIndexByHP(listEnemies, 40, True) 'shoot the lowest guy under 40%
'''        If targetPos < 0 Then 'if none found
'''            targetID = ReadMem(ADR_TARGET_ID, 4) 'shoot the current target
'''            If targetID <= 0 Then 'if no current target
'''                targetPos = GetIndexByHP(listEnemies, 101, False) 'shoot the first person on the list
'''                If targetPos < 0 Then Exit Sub
'''            Else
'''                targetPos = GetIndexByID(targetID)
'''            End If
'''        End If
'''
'''        Select Case runeToFire
'''            Case Is = "SD": runeID = ITEM_RUNE_SD
'''            Case Is = "HMM": runeID = ITEM_RUNE_HMM
'''            Case Is = "Explosion": runeID = ITEM_RUNE_EXPLO
'''            Case Is = "GFB": runeID = ITEM_RUNE_GFB
'''            Case Is = "Fire Bomb": runeID = ITEM_RUNE_FBB
'''            Case Is = "UH Target": runeID = ITEM_RUNE_UH
'''        End Select
'''    End If
'''
'''    If ShootRune(runeID, targetPos, optLead.Value) = False Then
'''        If frmMain.mnuDebug.Checked = True Then LogMsg "Aimbot failed to shoot"
'''    End If
'''
'''    If frmMain.mnuDebug.Checked = True Then LogMsg "Time taken to perform action: " & runeToFire & " = " & GetTickCount - runeTick & " ms."
'''End Sub
'''
'''Private Sub txtFriendName_Click()
'''    With txtFriendName
'''        .SelStart = 0
'''        .SelLength = Len(.Text)
'''    End With
'''End Sub
'''
'''Private Sub txtFriendName_GotFocus()
'''    With txtFriendName
'''        .SelStart = 0
'''        .SelLength = Len(.Text)
'''    End With
'''End Sub
'''
'''
''''Public Function LogList(buff() As Byte, Port As Long) As Byte()
''''    MsgBox PacketToString(buff)
''''    Dim C1 As Long
''''    Dim C2 As Long
''''    Dim C3 As Long
''''    Dim strTemp As String
''''
''''    'MsgBox "loglist!! heloo!"
''''    On Error GoTo Error
''''    C1 = buff(5) + buff(6) * 256 + 7
''''    'If buff(C1 - 1) > 41 Then buff(C1 - 1) = 41
''''    For C2 = 1 To buff(C1 - 1)
''''        strTemp = ""
''''        For C3 = 2 To buff(C1) + 1
''''            strTemp = strTemp & Chr(buff(C3 + C1))
''''        Next
''''        CList(C2).CName = strTemp
''''        C1 = C1 + buff(C1) + 2
''''        C1 = C1 + buff(C1) + 2
''''        CList(C2).IP = buff(C1) & "." & buff(C1 + 1) & "." & buff(C1 + 2) & "." & buff(C1 + 3)
''''        CList(C2).Port = buff(C1 + 4) + buff(C1 + 5) * 256
''''        buff(C1) = 127
''''        buff(C1 + 1) = 0
''''        buff(C1 + 2) = 0
''''        buff(C1 + 3) = 1
''''        buff(C1 + 4) = Port - Fix(Port / 256) * 256
''''        buff(C1 + 5) = Fix(Port / 256)
''''        C1 = C1 + 6
''''        If C2 >= 41 Then
''''            ReDim Preserve buff(C1 + 1)
''''            buff(C1) = 0
''''            buff(C1 + 1) = 0
''''            Exit For
''''        End If
''''    Next
''''Error:
''''    LogList = buff
''''    Exit Function
'''''Error:
''''    'MsgBox "There was a problem logging into the server. It may be offline."
''''End Function
'''
''''Public Function CharLog(buff() As Byte)
''''    Dim C1 As Integer
''''    For C1 = 14 To 13 + buff(12)
''''        name = name & Chr(buff(C1))
''''    Next C1
''''    For C1 = 1 To 100
''''        If name = CList(C1).CName Then
''''            frmMain.sckS.Close
''''            frmMain.sckS.Connect CList(C1).IP, CList(C1).Port
''''            CharName = name
''''            frmMain.Caption = "EruBot - " & CharName
''''            frmBroadcast.Caption = "Broadcast - " & CharName
''''            'frmStats.Caption = "Stats - " & CharName
''''            SetWindowText hwndTibia, "Tibia - " & CharName
''''            frmMain.chkExpHour.Value = Unchecked
''''            Exp_Stop
''''            ExpTime = 0
''''            LogMsg "Connecting to character: " & name
''''            If frmMain.chkEatLog.Value = Checked Then
''''                LogMsg "Deactived function: 'Log when food runs out.' - Containers with food not yet opened"
''''                frmMain.chkEatLog.Value = Unchecked
''''            End If
''''            If frmMain.chkHeal = Checked Then
''''                LogMsg "Deactived function: 'Auto heal' - HP may differ from last character"
''''                frmMain.chkHeal.Value = Unchecked
''''            End If
''''            If frmRune.chkLogFinished.Value = Checked Then
''''                LogMsg "Deactivate function: 'Log when no soul/blanks remaining.' - Containers containing blanks may not be open"
''''                frmRune.chkLogFinished.Value = Unchecked
''''            End If
''''            Valid
''''            Exit For
''''        End If
''''    Next C1
''''End Function
'''
''''Public Function GetStats(Buff1() As Byte)
''''    Dim C1 As Long
''''    Dim buff() As Long
''''    ReDim buff(Buff1(0) + Buff1(1) * 256 + 1)
''''    For C1 = 0 To (Buff1(0) + Buff1(1) * 256 + 1)
''''        buff(C1) = Buff1(C1)
''''    Next
''''    C1 = 2
''''    Do
''''        If buff(C1) = &HA0 Then
''''            stHitPoints = buff(C1 + 1) + buff(C1 + 2) * 256
''''            stCapacity = buff(C1 + 5) + buff(C1 + 6) * 256
''''            stExperience = buff(C1 + 7) + buff(C1 + 8) * 256 + buff(C1 + 9) * 65536 + buff(C1 + 10) * 16777216
''''            stLevel = buff(C1 + 11)
''''            stMana = buff(C1 + 13) + buff(C1 + 14) * 256
''''            stMagicLevel = buff(C1 + 17)
''''            frmStats.lblHit.Caption = "Hit Points: " & stHitPoints
''''            frmStats.lblLevel.Caption = "Level: " & stLevel
''''            frmStats.lblMagic.Caption = "Magic Level: " & stMagicLevel
''''            frmStats.lblMana.Caption = "Mana: " & stMana
''''            C1 = C1 + 19
''''        ElseIf buff(C1) = &H8C Then
''''            C1 = C1 + 6
''''        End If
''''    Loop Until C1 > buff(0)
''''
''''End Function
'''Private Sub chkWalk_Click()
'''    Dim i As Integer
'''    If chkWalk.Value = Checked Then
'''        frameWalk.Visible = True
'''    Else
'''        frameWalk.Visible = False
'''    End If
'''End Sub
'''
'''Private Sub cmdDone_Click()
'''    Me.Hide
'''End Sub
'''
'''Private Sub tmrAttack_Timer()
'''    Dim s As String
'''    Dim i As Integer
'''
'''    HitPoints = ReadMem(ADR_CUR_HP, 2)
'''    If HitPoints > HitPoints2 Then HitPoints2 = HitPoints
'''    If HitPoints < HitPoints2 Then
'''        'LogMsg "Damage was taken."
'''        If chkWalk Then
'''            For i = optWalk.LBound To optWalk.UBound
'''                If optWalk(i) Then
'''                    Step i
'''                    DoEvents
'''                    s = "Walk "
'''                    Select Case j
'''                        Case 0: s = s & "North"
'''                        Case 1: s = s & "East"
'''                        Case 2: s = s & "South"
'''                        Case 3: s = s & "West"
'''                    End Select
'''                    LogMsg s
'''                    Exit For
'''                End If
'''            Next i
'''        End If
'''        If chkSay And txtSay <> "" Then SayStuff txtSay.Text
'''        If chkAlert Then StartAlert
'''        If chkBeep Then Beep 600, 200
'''        If chkAlertLowHP And CLng(txtLowHP) > 0 And IsNumeric(txtLowHP) Then
'''            If HitPoints < CLng(txtLowHP) Then StartAlert
'''        End If
'''        HitPoints2 = HitPoints
'''        Valid
'''    End If
'''End Sub
''Private masterID As Long
''
''Private Sub cmdClose_Click()
''    Me.Hide
''End Sub
''
''Private Sub cmdLockMaster_Click()
''    masterID = ReadMem(ADR_TARGET_ID, 4)
''End Sub
''
''Private Sub Form_Load()
''    hscrAttackDistance_Change
''End Sub
''
''Public Sub hscrAttackDistance_Change()
''    If hscrAttackDistance = 1 Then
''        lblAttackDistance = "Attack adjacent creatures."
''    ElseIf hscrAttackDistance > 1 And hscrAttackDistance < 8 Then
''        lblAttackDistance = "Attack creatures within " & hscrAttackDistance & " squares."
''    Else
''        lblAttackDistance = "Attack creatures as soon as detected."
''    End If
''End Sub
''
''Private Function IsFriend(pos As Integer) As Boolean
''    If chkIgnoreFriends Then
''        If frmAimbot.listFriends.Contains(ReadMemStr(ADR_CHAR_NAME + pos * SIZE_CHAR, 32)) >= 0 Then
''            IsFriend = True
''        End If
''    End If
''End Function
''
''Private Sub tmrAutoAttack_Timer()
''    Dim curID As Long, id As Long
''    Dim pX As Long, pY As Long, pZ As Long
''    Dim cX As Long, cY As Long, cZ As Long
''    Dim pos As Long, distance As Long
''    Dim i As Integer
''
''    'priority target
''    If txtTarget <> "" Then
''        For i = 0 To LEN_CHAR
''            If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
''                If ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32) = txtTarget Then
''                    PutAttack ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
''                    Exit For
''                End If
''            End If
''        Next i
''        Exit Sub
''    End If
''
''    curID = ReadMem(ADR_TARGET_ID, 4)
''    getCharXYZ pX, pY, pZ, UserPos
''    pos = -1
''    distance = -1
''
''    If curID <> 0 And chkTargetClosest Then 'someone already targetted
''        pos = GetIndexByID(curID)
''        If pos < 0 Then Exit Sub
''        getCharXYZ cX, cY, cZ, pos
''        If Abs(pX - cX) > hscrAttackDistance + 1 Or Abs(pY - cY) > hscrAttackDistance + 1 Then
''            PutAttack 0 'if they're too far cancel the attack on them
''            Exit Sub
''        End If
''        distance = Abs(cX - pX) + Abs(cY - pY)
''        If distance = 2 Then distance = 1
''    End If
''    For i = 0 To LEN_CHAR
''        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 And i <> pos And i <> UserPos Then
''            id = ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
''            If id <> masterID And ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = &H40 Then
''                getCharXYZ cX, cY, cZ, i
''                If (((Abs(pX - cX) <= hscrAttackDistance And Abs(pY - cY) <= hscrAttackDistance) Or hscrAttackDistance = 8) And pZ = cZ) Then
''                    If IsFriend(i) = False Then
''                        If chkTargetClosest Then
''                            If pos = -1 Then
''                                pos = i
''                                distance = Abs(pX - cX) + Abs(pY - cY)
''                                If distance = 2 Then distance = 1
''                            Else
''                                If Abs(pX - cX) + Abs(pY - cY) < distance Then
''                                    pos = i
''                                    distance = Abs(pX - cX) + Abs(pY - cY)
''                                    If distance = 2 Then distance = 1
''                                End If
''                            End If
''                        Else
''                            pos = i
''                            Exit For
''                        End If
''                    End If
''                End If
''            End If
''        End If
''    Next i
''
''    If pos >= 0 Then
''        id = ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
''        If id <> curID Then
''            PutAttack id
''            'LogMsg "putting attack on " & ReadMemStr(ADR_CHAR_NAME + pos * SIZE_CHAR, 32)
''            Exit Sub
''        End If
''    End If
''End Sub
''Const startStats = "CLASS=white>Vocation</TD></TR><TR BGCOLOR=#F1E0C6><TD WIDTH=70%>"
''Const nameLink = "http://www.tibia.com/community/?subtopic=character&name="
''Const levelCode = "</A></TD><TD WIDTH=10%>"
''Const vocCode = "</TD><TD WIDTH=20%>"
''
''Dim names(1000) As String
''Dim levels(1000) As Integer
''Dim vocations(1000) As String
''Dim numPlayers As Integer
''Dim curPlayer As Integer
''
''Private Sub cmdBroadcast_Click()
''    Dim sOnline As String
''    Dim temp As String
''    Dim char As String
''
''    cmdBroadcast.Enabled = False
''    numPlayers = -1
''    sOnline = GetUrlSource("http://www.tibia.com/statistics/?subtopic=whoisonline&world=" & txtWorld.Text)
''    If Len(sOnline) < 1 Then
''        MsgBox "There was an error reading form the server"
''        cmdBroadcast.Enabled = True
''        Exit Sub
''    End If
''
''    'MsgBox Len(sOnline)
''    If Traverse(startStats, sOnline, 0) Then
''        'MsgBox Len(sOnline)
''        'MsgBox Left(sOnline, 10)
''        For i = 1 To Len(sOnline)
''            If Traverse(nameLink, sOnline, 0) Then
''                numPlayers = numPlayers + 1
''                names(numPlayers) = Replace(Replace(ReadString(">", sOnline, -1), "+", " "), "%27", "'")
''                'MsgBox names(i - 1)
''                Traverse levelCode, sOnline
''                levels(numPlayers) = Int(ReadString("<", sOnline, 0))
''                Traverse vocCode, sOnline
''                vocations(numPlayers) = ReadString("<", sOnline, 0)
''                'If levels(numPlayers) > 50 Then MsgBox names(numPlayers) & " " & levels(numPlayers) & " " _
''                '& vocations(numPlayers)
''            Else
''                'MsgBox numPlayers + 1 & " players online."
''                Exit For
''            End If
''        Next i
''    Else
''        MsgBox "Server Offline"
''        cmdBroadcast.Enabled = True
''        Exit Sub
''    End If
''    With progbarBroadcast
''        .Value = 0
''        .min = 0
''        .max = numPlayers
''    End With
''    curPlayer = 0
''    tmrBroadcast.Enabled = True
''End Sub
''
''Private Function ReadString(before As String, str As String, offset As Integer) As String
''    Dim temp As String
''    Dim char As String
''    Dim found As Boolean
''
''    If offset > 0 Then offset = -offset
''    found = False
''
''    For i = 1 To Len(str) - Len(before) + 1
''        If Mid(str, i, Len(before)) = before Then found = True: Exit For
''    Next i
''
''    If found Then ReadString = Left(str, i - 1 + offset)
''End Function
''
''Private Function Traverse(after As String, str As String, Optional offset As Long) As Boolean
''    Dim pos As Long
''
''    Traverse = False
''
''    If FindString(after, str, pos) Then
''        str = Right(str, Len(str) - pos - Len(after) + 1 - offset)
''        Traverse = True
''    End If
''End Function
''
''Private Function FindString(find As String, str As String, Optional start As Long) As Boolean
''    FindString = False
''
''    If Len(str) < Len(find) Then Exit Function
''
''    For i = 1 To Len(str) - Len(find)
''        If Mid(str, i, Len(find)) = find Then
''            FindString = True
''            start = i
''            Exit For
''        End If
''    Next i
''End Function
''
''Private Sub cmdClose_Click()
''    Me.Hide
''End Sub
''
''Private Sub BroadCast()
''    Dim send As Boolean
''    Dim v As String
''    Do
''        v = vocations(curPlayer)
''        If (v = "Knight" And chkKnight) Or (v = "Elite Knight" And chkElite) Or _
''            (v = "Sorcerer" And chkSorcerer) Or (v = "Master Sorcerer" And chkMaster) Or _
''            (v = "Druid" And chkDruid) Or (v = "Elder Druid" And chkElder) Or _
''            (v = "Paladin" And chkPaladin) Or (v = "Royal Paladin" And chkRoyal) Or _
''            (v = "None" And chkNone) Then
''            send = True
''        Else
''            send = False
''        End If
''        If send Then
''            If levels(curPlayer) >= CInt(txtMinLevel) And levels(curPlayer) <= CInt(txtMaxLevel) Then
''                SendPM names(curPlayer), txtMessage
''                LogMsg "Broadcasted to " & names(curPlayer) & " a level " & levels(curPlayer) & " " & vocations(curPlayer)
''                curPlayer = curPlayer + 1
''                Exit Sub
''            End If
''        End If
''        curPlayer = curPlayer + 1
''        If curPlayer <= progbarBroadcast.max Then progbarBroadcast = curPlayer
''    Loop Until curPlayer > numPlayers
''    cmdBroadcast.Enabled = True
''    tmrBroadcast.Enabled = False
''    progbarBroadcast.Value = progbarBroadcast.max
''End Sub
''
''Private Sub tmrBroadcast_Timer()
''    BroadCast
''End Sub
''
''Private Sub txtMaxLevel_GotFocus()
''    With txtMaxLevel
''        .SelStart = 0
''        .SelLength = Len(.Text)
''    End With
''End Sub
''
''Private Sub txtMinLevel_GotFocus()
''    With txtMinLevel
''        .SelStart = 0
''        .SelLength = Len(.Text)
''    End With
''End Sub
''
''Private Sub txtWorld_GotFocus()
''    With txtWorld
''        .SelStart = 0
''        .SelLength = Len(.Text)
''    End With
''End Sub
'''Option Explicit
'''
'''Private Sub chkTrace_Click()
'''    If chkTrace Then
'''        tmrTrace.Enabled = True
'''    Else
'''        tmrTrace.Enabled = False
'''    End If
'''End Sub
'''
'''Private Sub LoadWayPath(fileLoc As String)
'''    Dim FN As Integer, i As Integer, temp As String
'''    FN = FreeFile
'''    On Error GoTo Cancel
'''    Open fileLoc For Input As #FN
'''    getNext FN
'''    getNext FN
'''    listWayPath.Clear
'''    temp = getNext(FN)
'''    While temp <> "<End List>"
'''        listWayPath.AddItem temp
'''        temp = getNext(FN)
'''    Wend
'''    LogMsg "Way Path file loaded from " & vbCrLf & fileLoc
'''Cancel:
'''    Close FN
'''End Sub
'''
'''Private Sub SaveWayPath(fileLoc As String)
'''    Dim FN As Integer, i As Integer
'''    FN = FreeFile
'''    On Error GoTo Cancel
'''    Open fileLoc For Output As #FN
'''    Write #FN, "***ERUBOT WAY PATH FILE***"
'''    Write #FN, App.Major & "." & App.Minor & "." & App.Revision
'''    If listWayPath.ListCount <= 0 Then GoTo Cancel
'''    For i = 0 To listWayPath.ListCount - 1
'''        Write #FN, listWayPath.List(i)
'''    Next i
'''    Write #FN, "<End List>"
'''    LogMsg "Way Path file saved to " & vbCrLf & fileLoc
'''Cancel:
'''    Close FN
'''End Sub
'''
'''Private Sub cmdClear_Click()
'''    If MsgBox("Are you sure you wish to clear the way path?", vbYesNo, "Confirm Clear") = vbYes Then listWayPath.Clear
'''End Sub
'''
'''Private Sub cmdClose_Click()
'''    Me.Hide
'''End Sub
'''
'''Private Sub cmdFunctionDirection_Click(index As Integer)
'''    Dim dX As Long, dY As Long
'''    Dim pX As Long, pY As Long, pZ As Long
'''    Select Case index
'''        Case 0: dX = 0: dY = -1
'''        Case 1: dX = 1: dY = -1
'''        Case 2: dX = 1: dY = 0
'''        Case 3: dX = 1: dY = 1
'''        Case 4: dX = 0: dY = 1
'''        Case 5: dX = -1: dY = 1
'''        Case 6: dX = -1: dY = 0
'''        Case 7: dX = -1: dY = -1
'''        Case 8: dX = 0: dY = 0
'''        Case Else:
'''            MsgBox "there is no function direction button of that index!!111 wtf"
'''            Exit Sub
'''    End Select
'''    getCharXYZ pX, pY, pZ, UserPos
'''    listWayPath.AddItem comboFunction.List(comboFunction.ListIndex) & "," & pX + dX & "," & pY + dY & "," & pZ
'''End Sub
'''
'''Private Sub cmdInsert_Click()
'''    Dim temp As String
'''    temp = InputBox("Enter custom waypoint", "Insert", "Walk,")
'''    If temp <> "" Then listWayPath.AddItem temp, listWayPath.ListIndex
'''End Sub
'''
'''Private Sub cmdLoadWayPath_Click()
'''    On Error GoTo Cancel
'''    With frmMain.cdlgSettings
'''        .FileName = "*.ewp"
'''        .Filter = "EruBot Way Path, *.ewp"
'''        .DialogTitle = "Load Way Path"
'''        .InitDir = App.Path
'''        .DefaultExt = "ewp"
'''        .ShowOpen
'''    End With
'''    LoadWayPath frmMain.cdlgSettings.FileName
'''    Exit Sub
'''Cancel:
'''End Sub
'''
'''Private Sub cmdRemove_Click()
'''    Dim index As Integer
'''    index = listWayPath.ListIndex
'''    listWayPath.RemoveItem index
'''    If index >= listWayPath.ListCount Then index = listWayPath.ListCount - 1
'''    listWayPath.ListIndex = index
'''End Sub
'''
'''Private Sub cmdSaveWayPath_Click()
'''    On Error GoTo Cancel
'''    With frmMain.cdlgSettings
'''        .FileName = "*.ewp"
'''        .Filter = "EruBot Way Path, *.ewp"
'''        .DialogTitle = "Save Way Path"
'''        .InitDir = App.Path
'''        .DefaultExt = "ewp"
'''        .ShowSave
'''    End With
'''    SaveWayPath frmMain.cdlgSettings.FileName
'''    Exit Sub
'''Cancel:
'''End Sub
'''
'''Private Sub cmdSmoothPath_Click()
'''    Dim i As Integer, str() As String
'''    Dim nX As Long, nY As Long, nZ As Long
'''    Dim cX As Long, cY As Long, cZ As Long
'''    If listWayPath.ListCount <= 1 Then Exit Sub
'''    While i < listWayPath.ListCount - 1
'''        str = Split(listWayPath.List(i), ",")
'''        If str(0) <> "Walk" Then GoTo Continue
'''        cX = CLng(str(1)): cY = CLng(str(2)): cZ = CLng(str(3))
'''        str = Split(listWayPath.List(i + 1), ",")
'''        If str(0) <> "Walk" Then GoTo Continue
'''        nX = CLng(str(1)): nY = CLng(str(2)): nZ = CLng(str(3))
'''        If cZ <> nZ Then
'''            MsgBox "Impossible level transition found", vbCritical, "Way Path Error"
'''            listWayPath.ListIndex = i
'''            Exit Sub
'''        End If
'''        If GetStepValue(nX - cX, nY - cY) < 0 Then
'''            If Abs(nX - cX) <= 2 And Abs(nY - cY) <= 2 Then
'''                listWayPath.AddItem "Walk," & Fix((nX + cX) / 2) & "," & Fix((nY + cY) / 2) & "," & Fix((nZ + cZ) / 2), i + 1
'''                i = i - 1
'''            Else
'''                MsgBox "Distance between points too great", vbCritical, "Way Path Error"
'''                listWayPath.ListIndex = i
'''                Exit Sub
'''            End If
'''        End If
'''Continue:
'''        i = i + 1
'''    Wend
'''End Sub
'''
'''Private Sub Form_Load()
'''    comboFunction.ListIndex = 0
'''    hscrStopDistance_Change
'''End Sub
'''
'''Public Sub hscrStopDistance_Change()
'''    If hscrStopDistance = 1 Then
'''        lblStopDistance = "Stop if adjacent creatures."
'''    ElseIf hscrStopDistance > 1 And hscrStopDistance < 8 Then
'''        lblStopDistance = "Stop if creatures within " & hscrStopDistance & " squares."
'''    Else
'''        lblStopDistance = "Stop as soon as creature detected."
'''    End If
'''End Sub
'''
'''Private Sub tmrCaveBot_Timer()
'''    Static nextMoveTime As Long, errorTime As Long, curPoint As Integer
'''    Static tX As Long, tY As Long, tZ As Long
'''    Dim i As Integer, stopPlx As Boolean
'''    Dim pX As Long, pY As Long, pZ As Long
'''    Dim cX As Long, cY As Long, cZ As Long
'''    Dim bp As Integer, slot As Integer
'''    Dim tempStr() As String, temp As String
'''    If listWayPath.ListCount <= 0 Then Exit Sub
'''    getCharXYZ pX, pY, pZ, UserPos
'''    If GetTickCount < nextMoveTime Then Exit Sub
'''    For i = 0 To LEN_CHAR
'''        stopPlx = False
'''        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 And i <> UserPos Then
'''            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = &H40 Then
'''                getCharXYZ cX, cY, cZ, i
'''                If cZ <> pZ Then GoTo Continue
'''                'stopPlx = False
'''                If hscrStopDistance = 8 Then
'''                    stopPlx = True
'''                Else
'''                    If Abs(pX - cX) <= hscrStopDistance And Abs(pY - cY) <= hscrStopDistance Then stopPlx = True
'''                End If
'''                If stopPlx Then
'''                    temp = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
'''                    If frmAimbot.listFriends.Contains(temp) >= 0 Then stopPlx = False
'''                    'If stopPlx Then If frmIntruder.listSafe.Contains(temp) >= 0 Then stopPlx = False
'''                End If
'''            Else
'''                If frmIntruder.listSafe.Contains(ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)) < 0 Then stopPlx = True
'''            End If
'''            If stopPlx Then Exit For
'''        End If
'''Continue:
'''    Next i
'''    If stopPlx Then
'''        nextMoveTime = GetTickCount + 3000
'''        errorTime = GetTickCount + 8000
'''        Exit Sub
'''    End If
'''    If GetTickCount >= nextMoveTime Then
'''        If curPoint >= listWayPath.ListCount Then curPoint = 0
'''        If pX = tX And pY = tY And pZ = tZ Or GetTickCount >= errorTime Then
'''            If GetTickCount < errorTime Then
'''                curPoint = curPoint + 1
'''                If curPoint >= listWayPath.ListCount Then curPoint = 0
'''            Else
'''                'MsgBox "error time"
'''                If GetStepValue(tX - pX, tY - pY) < 0 Then
'''                    For i = 0 To listWayPath.ListCount - 1
'''                        tempStr = Split(listWayPath.List(i), ",")
'''                        If tempStr(0) = "Walk" Then
'''                            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'''                            If GetStepValue(tX - pX, tY - pY) >= 0 And tZ = pZ Then
'''                                curPoint = i
'''                                Exit For
'''                            End If
'''                        End If
'''                    Next i
'''                End If
'''            End If
'''            tempStr = Split(listWayPath.List(curPoint), ",")
'''            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'''            Select Case tempStr(0)
'''                Case "Walk":
'''                    Step GetStepValue(tX - pX, tY - pY)
'''                Case "Force Walk":
'''                    Step GetStepValue(tX - pX, tY - pY)
'''                    i = curPoint + 1
'''                    If i >= listWayPath.ListCount Then i = 0
'''                    tempStr = Split(listWayPath.List(i), ",")
'''                    tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'''                Case "Ladder":
'''                    UseGround TILE_LADDER, tX, tY, tZ
'''                    i = curPoint + 1
'''                    If i >= listWayPath.ListCount Then i = 0
'''                    tempStr = Split(listWayPath.List(i), ",")
'''                    tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'''                Case "Rope":
'''                    If findItem(ITEM_ROPE, bp, slot, True, False) Then
'''                        UseAt ITEM_ROPE, bp, slot, tX, tY, tZ
'''                        i = curPoint + 1
'''                        If i >= listWayPath.ListCount Then i = 0
'''                        tempStr = Split(listWayPath.List(i), ",")
'''                        tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'''                    Else
'''                        GoTo Error
'''                    End If
'''                Case Else:
'''                    LogMsg "Cave Bot: Not yet implemented."
'''                    GoTo Error
'''            End Select
'''            nextMoveTime = GetTickCount + 20
'''            errorTime = GetTickCount + 10000
'''        End If
'''    End If
'''    listWayPath.ListIndex = curPoint
'''    Exit Sub
'''Error:
'''    frmMain.chkCaveBot.Value = Unchecked
'''    frmMain.chkAlert.Value = Checked
'''    LogMsg "There was an error in the cavebot. A required item might be missing."
'''    Valid
'''End Sub
'''
'''Private Sub tmrTrace_Timer()
'''    Static lastX As Long, lastY As Long, lastZ As Long
'''    Dim curX As Long, curY As Long, curZ As Long
'''    If lastX = 0 Or lastY = 0 Or lastZ = 0 Then getCharXYZ lastX, lastY, lastZ, UserPos
'''    getCharXYZ curX, curY, curZ, UserPos
'''    If curX <> lastX Or curY <> lastY Or curZ <> lastZ Then
'''        listWayPath.AddItem "Walk," & curX & "," & curY & "," & curZ
'''        listWayPath.ListIndex = listWayPath.ListCount - 1
'''        lastX = curX: lastY = curY: lastZ = curZ
'''    End If
'''End Sub
'''
''Private Sub Form_Load()
''
''End Sub
''
'Private leftX As Integer, leftY As Integer, rightX As Integer, rightY As Integer 'coords of top left and bottom right of fishing box
'Private oX As Integer, oY As Integer
'
'Private Sub chkSpeedFish_Click()
'    If chkSpeedFish.Value = Checked Then
'        tmrFish.Interval = 1000
'    Else
'        tmrFish.Interval = 3000
'    End If
'End Sub
'
'Private Sub cmdEnterVals_Click()
'    updBoundVals
'End Sub
'
'Private Sub cmdOK_Click()
'  Me.Hide
'End Sub
'
'Private Sub ResetBoundaries()
'  'reset boundaries to maximum extends
'  txtBoundary(0) = -7
'  txtBoundary(1) = -5
'  txtBoundary(2) = 7
'  txtBoundary(3) = 5
'  updBoundVals
'End Sub
'
'Private Sub Form_Load()
'    ResetBoundaries
'    updBoundVals
'End Sub
'
'Private Sub tmrFish_Timer()
'    Dim bp As Integer
'    Dim slot As Integer
'    Dim pX As Long
'    Dim pY As Long
'    Dim pZ As Long
'    Dim C1 As Integer
'    Dim C2 As Integer
'    Dim bpOpen As Long
'    Dim Item As Long
'    Dim items As Long
'
'    If chkFishNoFood Then
'        For bp = 0 To LEN_BP
'            If ReadMem(ADR_BP_OPEN + SIZE_BP * bp, 1) = 1 Then
'                For slot = 0 To ReadMem(ADR_BP_NUM_ITEMS + bp * SIZE_BP, 1) - 1
'                    Item = ReadMem(ADR_BP_ITEM + SIZE_BP * bp + SIZE_ITEM * slot, 2)
'                    If IsFood(Item) Then Exit Sub
'                Next slot
'            End If
'        Next bp
'    End If
'
'    If findItem(ITEM_WORM, bp, slot) Or chkFishNoWorms Then
'        If findItem(ITEM_FISHING_ROD, bp, slot) Then
'            getCharXYZ pX, pY, pZ, UserPos
'            UseAt ITEM_FISHING_ROD, bp, slot, pX + oX, pY + oY, pZ
'            oX = oX + 1
'            If oX > rightX Then
'                oX = leftX
'                oY = oY + 1
'            End If
'            If oY > rightY Then oY = leftY
'        End If
'    End If
'End Sub
'
'Public Sub updBoundVals()
'    For i = txtBoundary.LBound To txtBoundary.UBound
'        If Index = 0 Or Index = 2 Then If txtBoundary(Index) < -7 Or txtBoundary(Index) > 7 Then ResetBoundaries
'        If Index = 1 Or Index = 3 Then If txtBoundary(Index).Text < -5 Or txtBoundary(Index).Text > 5 Then ResetBoundaries
'    Next i
'    'check left boundaries do not exceed right
'    If CInt(txtBoundary(0).Text) > CInt(txtBoundary(2).Text) Or _
'    CInt(txtBoundary(1).Text) > CInt(txtBoundary(3).Text) Then _
'        ResetBoundaries
'
'    'parse boundaries
'    leftX = txtBoundary(0)
'    leftY = txtBoundary(1)
'    rightX = txtBoundary(2)
'    rightY = txtBoundary(3)
'    oX = leftX
'    oY = leftY
'End Sub
'
'Private Sub txtBoundary_LostFocus(Index As Integer)
'    updBoundVals
'End Sub
'Private Sub chkGrabUnderTarget_Click()
'    UpdDirectionControls
'End Sub
'
'Public Sub UpdDirectionControls()
'    If chkGrabUnderTarget.Value = Checked Then
'        fraDirection.Enabled = False
'        For i = optDir.LBound To optDir.UBound
'            optDir(i).Enabled = False
'        Next i
'    Else
'        fraDirection.Enabled = True
'        For i = optDir.LBound To optDir.UBound
'            optDir(i).Enabled = True
'        Next i
'    End If
'End Sub
'
'Private Sub cmdClose_Click()
'    Me.Hide
'End Sub
'
'Private Sub Form_Load()
'
'End Sub
'
'Private Sub tmrGrabber_Timer()
'    Dim pX As Long, pY As Long, pZ As Long
'    Dim itemID As Long, targetID As Long, targetPos As Long
'
'    If chkGrabUnderTarget.Value = Checked Then
'        'grab from under target
'        targetID = ReadMem(ADR_TARGET_ID, 4)
'        If targetID = 0 Then Exit Sub
'        targetPos = GetIndexByID(targetID)
'
'        pX = ReadMem(ADR_CHAR_X + targetPos * SIZE_CHAR, 4)
'        pY = ReadMem(ADR_CHAR_Y + targetPos * SIZE_CHAR, 4)
'        pZ = ReadMem(ADR_CHAR_Z + targetPos * SIZE_CHAR, 4)
'    Else
'        'grab from set direction relative to player
'        getCharXYZ pX, pY, pZ, UserPos
'
'        For i = optDir.LBound To optDir.UBound
'            If optDir(i) Then
'                Select Case i
'                    Case Is = 0: pX = pX - 1: pY = pY - 1
'                    Case Is = 1: pY = pY - 1
'                    Case Is = 2: pX = pX + 1: pY = pY - 1
'                    Case Is = 3: pX = pX + 1
'                    Case Is = 4: pX = pX + 1: pY = pY + 1
'                    Case Is = 5: pY = pY + 1
'                    Case Is = 6: pX = pX - 1: pY = pY + 1
'                    Case Is = 7: pX = pX - 1
'                End Select
'            End If
'        Next i
'    End If
'    If optSpears Then
'        itemID = ITEM_SPEAR
'    ElseIf optThrowingKnives Then
'        itemID = ITEM_THROWING_KNIFE
'    ElseIf optSmallStones Then
'        itemID = ITEM_SMALL_STONE
'    ElseIf optThrowingStars Then
'        itemID = ITEM_THROWING_STAR
'    End If
'    GrabItem itemID, pX, pY, pZ, &H6, &H0, 3
'End Sub
'Private lastHeal As Long
'Private triedRune As Boolean
'Private triedSpell As Boolean
'
'Private Sub cmdDone_Click()
'    Me.Hide
'End Sub
'
'Private Sub Form_Load()
'
'End Sub
'
'Private Sub tmrHeal_Timer()
'    If GetTickCount > lastHeal + CLng(txtRuneDelay) Then
'        triedRune = False
'        triedSpell = False
'
'        If ReadMem(ADR_CUR_HP, 2) <= CLng(txtHP) And txtHP <> "" And CLng(txtHP) > 1 Then
'            If chkAlertLowHP.Value = Checked Then StartAlert: Valid
'            If optRuneFirst.Value = True Then
'                UseRune
'            Else
'                UseSpell
'            End If
'        ElseIf chkHealFriends.Value = Checked Then
'            Dim targetPos As Long
'            targetPos = -1
'            targetPos = GetIndexByHP(frmAimbot.listFriends, frmAimbot.hscrHealAt.Value, frmAimbot.chkHealLowest.Value)
'            If targetPos >= 0 Then ShootRune ITEM_RUNE_UH, targetPos
'        End If
'    End If
'End Sub
'
'Private Sub UseSpell()
'    If triedSpell Then Exit Sub
'    If chkUseSpell.Value = Checked Then
'        If ReadMem(ADR_CUR_MANA, 2) >= CLng(txtMana) Then
'            SayStuff txtSpell
'            lastHeal = GetTickCount
'        Else
'            triedSpell = True
'            UseRune
'        End If
'    Else
'        triedSpell = True
'        UseRune
'    End If
'End Sub
'
'Private Sub UseRune()
'    Dim pX As Long, pY As Long, pZ As Long 'coords of player
'    Dim bpIndex As Integer, itemIndex As Integer 'location of uh
'    Dim runesLeft As Boolean 'uh left in current bp
'
'    If triedRune Then Exit Sub
'    If chkUseRune.Value = Checked Then
'        If findItem(ITEM_RUNE_UH, bpIndex, itemIndex) Then 'if find a uh
'            getCharXYZ pX, pY, pZ, UserPos 'get char coords
'            runesLeft = False
'            If itemIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) _
'            Then If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (itemIndex + 1) * SIZE_ITEM, 2) = ITEM_RUNE_UH _
'            Then runesLeft = True 'if not last item in bp and the next item is a uh then there are uhs left
'
'            If runesLeft = False Then 'but if no uhs found, then search rest of bp
'                For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1
'                    If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2) = ITEM_RUNE_UH _
'                    And itemIndex <> i Then 'if an item in bp isn't the current uh
'                        runesLeft = True
'                        Exit For
'                    End If
'                Next i
'            End If
'
'            UseAt ITEM_RUNE_UH, bpIndex, itemIndex, pX, pY, pZ 'throw the uh
'            lastHeal = GetTickCount 'set last heal time to now
'            LogMsg "Auto healed: Used a UH."
'            Pause 50 'slight pause for server to process uh
'            If runesLeft = False Then UpBpLevel bpIndex - &H40 'if no uhs left, then move up bp
'
'        Else
'            triedRune = True
'            UseSpell
'        End If
'    Else
'        triedRune = True
'        UseSpell
'    End If
'End Sub
'
'Private Sub txtHP_Change()
'    If Not IsNumeric(txtHP) Then txtHP = ""
'End Sub
'
'Private Sub txtRuneDelay_LostFocus()
'    If IsNumeric(txtRuneDelay) And CLng(txtRuneDelay) >= 50 And CLng(txtRuneDelay) <= 5000 Then
'        Exit Sub
'    Else
'        txtRuneDelay = 1000
'    End If
'End Sub
'Public safeX As Long, safeY As Long, safeZ As Long
'Public afkX As Long, afkY As Long, afkZ As Long
'
'Public Function isSafe() As Boolean
'    isSafe = False
'
'    If ReadMem(ADR_PLAYER_X, 4) = safeX _
'    And ReadMem(ADR_PLAYER_Y, 4) = safeY _
'    And ReadMem(ADR_PLAYER_Z, 4) = safeZ _
'    Then isSafe = True
'End Function
'
'Private Sub chkDetectOffscreen_Click()
'  If chkDetectOffscreen Then
'    frameOffscreen.Visible = True
'  Else
'    frameOffscreen.Visible = False
'  End If
'End Sub
'
'Private Sub cmdAdd_Click()
'    Dim newSafe As String
'    newSafe = InputBox("Name of safe character, Case-sensitive", "Safe Char")
'    If newSafe <> "" Then listSafe.AddItem newSafe
'End Sub
'
'Private Sub cmdClear_Click()
'    listSafe.Clear
'End Sub
'
'Private Sub cmdOK_Click()
'  Me.Hide
'End Sub
'
'Private Sub cmdRemove_Click()
'  If listSafe.ListIndex >= 0 Then listSafe.RemoveItem listSafe.ListIndex
'End Sub
'
'Private Sub cmdSetAfkSpot_Click()
'    afkX = ReadMem(ADR_PLAYER_X, 4)
'    afkY = ReadMem(ADR_PLAYER_Y, 4)
'    afkZ = ReadMem(ADR_PLAYER_Z, 4)
'    lblAfkSpot.Caption = afkX & ", " & afkY & ", " & afkZ
'End Sub
'
'Public Sub UpdAfkLbl()
'    Dim temp() As String
'    temp = Split(lblAfkSpot, ", ")
'    afkX = temp(0)
'    afkY = temp(1)
'    afkZ = temp(2)
'End Sub
'
'Public Sub UpdSafeLbl()
'    Dim temp() As String
'    temp = Split(lblSafeSpot, ", ")
'    safeX = temp(0)
'    safeY = temp(1)
'    safeZ = temp(2)
'End Sub
'
'Private Sub cmdSetSafeSpot_Click()
'    safeX = ReadMem(ADR_PLAYER_X, 4)
'    safeY = ReadMem(ADR_PLAYER_Y, 4)
'    safeZ = ReadMem(ADR_PLAYER_Z, 4)
'    lblSafeSpot.Caption = safeX & ", " & safeY & ", " & safeZ
'End Sub
'
'Private Sub Form_Load()
'  hscrNumAbove_Change
'  hscrNumBelow_Change
'  hscrNumSkulls_Change
'  cmdSetAfkSpot_Click
'  cmdSetSafeSpot_Click
'End Sub
'
'Public Sub hscrNumAbove_Change()
'  chkAbove.Caption = "Detect " & hscrNumAbove.Value & " levels above"
'End Sub
'
'Public Sub hscrNumBelow_Change()
'  chkBelow.Caption = "Detect " & hscrNumBelow.Value & " levels below"
'End Sub
'
'Public Function CheckSafe(str As String, pos As Integer) As Boolean
'    Dim i As Integer, intID As Long, intSymbol As Integer
'
'    CheckSafe = False
'
'    If str = "" Or str = CharName Or pos = UserPos Then GoTo Safe
'
'    If chkIgnoreAll.Value = Checked Then
'        intID = ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
'        For i = 0 To LEN_VIP
'            If ReadMem(ADR_VIP_ID + SIZE_VIP * i, 4) = intID Then
'                intSymbol = ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1)
'                If intSymbol = 2 Or intSymbol = 3 Then Exit Function
'            End If
'        Next i
'        GoTo Safe
'    End If
'
'    If chkIgnoreMonsters.Value = Checked And ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR + 3, 1) = &H40 Then GoTo Safe
'
'    If listSafe.ListCount <= 0 Then Exit Function
'
'    For i = 0 To listSafe.ListCount - 1
'        If Left(str, Len(listSafe.List(i))) = listSafe.List(i) Then GoTo Safe
'    Next i
'    Exit Function
'Safe:
'    CheckSafe = True
'End Function
'
'Public Sub IntruderReaction(detectMethod As String, intName As String, intZ As Long)
'    Dim j As Integer, s As String
'    Static lastReact As Long
'
'    If GetTickCount < lastReact + 3000 Then Exit Sub
'    lastReact = GetTickCount
'    LogMsg "Detect intruder via " & detectMethod & ":" & vbCrLf & ">" & intName & "< on level " _
'    & intZ & ", " & intZ - ReadMem(ADR_PLAYER_Z, 4) & " levels offset."
'
'    'walk
'    If chkWalk Then
'        Dim X As Long, Y As Long, z As Long, stepDir As Integer
'        getCharXYZ X, Y, z, UserPos
'        If safeX - X <> 0 Or safeY - Y <> 0 Then
'            stepDir = GetStepValue(safeX - X, safeY - Y)
'            If stepDir < 0 Then
'                StartAlert
'                LogOut
'                LogMsg "Invalid position, too far from safe position or error"
'            Else
'                Step stepDir
'                'LogMsg "Stepping in direction " & stepDir
'                'Pause 2000
'            End If
'        End If
'    End If
'
'    If frmMain.sckServer.State <> sckConnected Then Exit Sub
'    'script
'    If chkScript.Value = Checked Then frmScript.StartScript
'    'autolog
'    If chkAutoLog Then LogOut: frmMain.chkLogOut = Checked
'    'eating
'    'If frmMain.chkEat Then
'    '    frmMain.chkEat.Value = False
'    '    s = s & ", stop eating,"
'    'End If
'
'    'alert
'    If frmMain.chkAlert.Value = Unchecked And frmIntruder.chkAlert = Checked Then StartAlert
'
'    If chkWalk <> Checked Then frmMain.chkIntruder.Value = Unchecked
'
'    Valid
'End Sub
'
'Private Sub hscrNumSkulls_Change()
'    lblSkullsRequired = "Require that " & hscrNumSkulls & " skulled players are online."
'End Sub
'
'Private Sub tmrAppear_Timer()
'    Dim intName As String, intZ As Long
'    'If GetTickCount < lastReact + 3000 Then Exit Sub
'    intName = isIntruderOnscreen(intZ)
'    If intName <> "" Or (chkBattleSign And ReadMem(ADR_BATTLE_SIGN, 4) <> 0) Then
'        If intName = "" Then intName = "Battle Sign"
'        'LogMsg "Onscreen intruder detected:" & vbCrLf & ">" & intName & "<"
'        IntruderReaction "Memory", intName, intZ
'    End If
'End Sub
'
'Public Function isIntruderOnscreen(Optional ByRef intZ As Long = 0) As String
'    Dim i As Integer
'    Dim plyrZ As Long
'    Dim intName As String
'
'    'get char z, and array pos
'    plyrZ = ReadMem(ADR_PLAYER_Z, 4)
'
'    For i = 0 To LEN_CHAR
'        'find onscreen char
'        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
'            intName = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
'            intZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4)
'            If (plyrZ = intZ Or (chkDetectOffscreen And ((chkBelow And intZ > plyrZ And intZ - plyrZ <= hscrNumBelow) Or (chkAbove And intZ < plyrZ And plyrZ - intZ <= hscrNumAbove)))) And CheckSafe(intName, i) = False Then
'                isIntruderOnscreen = intName
'                Exit Function
'            End If
'        End If
'    Next i
'    isIntruderOnscreen = ""
'End Function
'
'Public Sub IntruderOffscreen(buff() As Byte)
'    Dim intName As String 'name of intruder
'    Dim doLog As Boolean
'    Dim plyrX As Long, plyrY As Long, plyrZ As Long
'    Dim intPos As Long 'intruders position in array
'    Dim intX As Long, intY As Long, intZ As Long
'
'    'elseif buff(0) = &Hd then
'    'frmMain.lblLogPackets = packetToString(Buff) & nom & vbCrLf & frmMain.lblLogPackets
'    'frmMain.lblLogPackets = nom & vbCrLf & frmMain.lblLogPackets
'
'    'If GetTickCount < lastReact + 3000 Then Exit Sub
'
'    intX = CLng(buff(4)) * 256 + CLng(buff(3))
'    intY = CLng(buff(6)) * 256 + CLng(buff(5))
'    intZ = CLng(buff(7))
'    intPos = GetIndexByCoords(intX, intY, intZ)
'    intName = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * intPos, 32)
'    If CheckSafe(intName, CInt(intPos)) Then Exit Sub
'
'    plyrZ = ReadMem(ADR_CHAR_Z + UserPos * SIZE_CHAR, 4)
'    doLog = False
'
'    If intZ = plyrZ Then
'        doLog = True
'    ElseIf (chkBelow.Value = Checked And intZ > plyrZ And intZ - plyrZ <= hscrNumBelow.Value) Or _
'    (chkAbove.Value = Checked And intZ < plyrZ And plyrZ - intZ <= hscrNumAbove.Value) Then
'        doLog = True
'    End If
'
'    plyrX = ReadMem(ADR_CHAR_X + UserPos * SIZE_CHAR, 4)
'    plyrY = ReadMem(ADR_CHAR_Y + UserPos * SIZE_CHAR, 4)
'    'If plyrX = intX And plyrY = intY And plyrZ = intZ Then doLog = False
'
'      'If intName = "Troll" Then MsgBox "fuck troll!"
'    If doLog And frmMain.sckServer.State = sckConnected Then
'      'LogMsg "Offscreen intruder detected:" & vbCrLf & ">" & intName & "< on level " & intZ & ", " & intZ - plyrZ & " levels offset."
'      IntruderReaction "Packet", intName, intZ
'    End If
'End Sub
'
'Private Sub tmrCheckSkulls_Timer()
'    Dim i As Integer, skulls As Integer
'
'    If chkAlertSkulls = Checked Then
'        For i = 0 To LEN_VIP
'            If ReadMem(ADR_VIP_ONLINE + i * SIZE_VIP, 1) = 1 Then _
'            If ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1) = 2 Then _
'            skulls = skulls + 1
'            If skulls >= hscrNumSkulls Then
'                StartAlert
'                Valid
'                Exit Sub
'            End If
'        Next i
'    End If
'    If chkWalk = Checked And ReadMem(ADR_BATTLE_SIGN, 4) = 0 And isIntruderOnscreen = "" Then
'        Dim X As Long, Y As Long, z As Long, stepVal As Integer
'        X = ReadMem(ADR_PLAYER_X, 4)
'        Y = ReadMem(ADR_PLAYER_Y, 4)
'        z = ReadMem(ADR_PLAYER_Z, 4)
'        If X <> afkX Or Y <> afkY Or z <> afkZ Then
'            stepVal = GetStepValue(afkX - X, afkY - Y)
'            If stepVal >= 0 Then
'                Step stepVal
'            Else
'                stepVal = GetStepValue(safeX - X, safeY - Y)
'                If stepVal >= 0 Then
'                    Step stepVal
'                Else
'                    StartAlert
'                    LogOut
'                    Valid
'                    'chkWalk.Value = Unchecked
'                End If
'            End If
'        End If
'    End If
'End Sub
'Option Explicit
'
'Private Sub cmdClose_Click()
'    Me.Hide
'End Sub
'
'Private Sub cmdDown_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_Z, 2)
'    If position + 1 > 15 Then Exit Sub
'    position = position + 1
'    WriteMem ADR_CHAR_Z + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_Z, position, 2
'    WriteMem ADR_GFX_VIEW_Z, position, 2
'End Sub
'
'Private Sub cmdEast_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_X, 2)
'    'If position + 1 > 15 Then Exit Sub
'    position = position + 1
'    WriteMem ADR_CHAR_X + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_X, position, 2
'    WriteMem ADR_GFX_VIEW_X, position, 2
'End Sub
'
'Private Sub cmdNorth_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_Y, 2)
'    'If position + 1 > 15 Then Exit Sub
'    position = position - 1
'    WriteMem ADR_CHAR_Y + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_Y, position, 2
'    WriteMem ADR_GFX_VIEW_Y, position, 2
'End Sub
'
'Private Sub cmdSouth_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_Y, 2)
'    'If position + 1 > 15 Then Exit Sub
'    position = position + 1
'    WriteMem ADR_CHAR_Y + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_Y, position, 2
'    WriteMem ADR_GFX_VIEW_Y, position, 2
'End Sub
'
'Private Sub cmdUp_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_Z, 2)
'    If position - 1 < 0 Then Exit Sub
'    position = position - 1
'    WriteMem ADR_CHAR_Z + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_Z, position, 2
'    WriteMem ADR_GFX_VIEW_Z, position, 2
'End Sub
'
'Private Sub cmdWest_Click()
'    Dim position As Long
'    position = ReadMem(ADR_PLAYER_X, 2)
'    'If position + 1 > 15 Then Exit Sub
'    position = position - 1
'    WriteMem ADR_CHAR_X + UserPos * SIZE_CHAR, position, 2
'    WriteMem ADR_PLAYER_X, position, 2
'    WriteMem ADR_GFX_VIEW_X, position, 2
'End Sub
'
'Private Sub Form_Load()
'
'End Sub
'Private baseOutfit As Long
'
'Private Sub chkRainbow_Click()
'    Dim i As Integer
'
'    For i = chkColor.LBound To chkColor.UBound
'        If chkRainbow Then
'            chkColor(i).Enabled = False
'        Else
'            chkColor(i).Enabled = True
'        End If
'    Next i
'
'    baseOutfit = 0
'End Sub
'
'Private Sub cmdOK_Click()
'  Me.Hide
'End Sub
'
'Private Sub Form_Load()
'  hscrOutfit_Change
'End Sub
'
'Public Sub hscrOutfit_Change()
'    tmrOutfit.Interval = hscrOutfit
'    lblInterval = "Interval: " & hscrOutfit & " ms"
'End Sub
'
'Private Sub tmrOutfit_Timer()
'    Static newOutfit(4) As Long
'    Dim i As Integer
'    Dim buff(7) As Byte
'
'
'    If chkRainbow Then
'        'outfit
'        newOutfit(0) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR, 4)
'        'colors
'        Do
'            baseOutfit = baseOutfit + 1
'        Loop Until baseOutfit Mod 19 <> 0 And baseOutfit <> 0
'        If baseOutfit > 133 Then baseOutfit = 0
'        For i = 1 To 3
'            newOutfit(i) = newOutfit(i + 1)
'        Next i
'        newOutfit(4) = baseOutfit
'    Else
'        Randomize Timer
'        'outfit
'        If chkColor(0) Then
'            If newOutfit(0) >= &H80 And newOutfit(0) <= &H86 Then
'                newOutfit(0) = &H80 + Int(Rnd * 7)
'            Else
'                newOutfit(0) = &H88 + Int(Rnd * 7)
'            End If
'        Else
'            newOutfit(0) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR, 4)
'        End If
'        'colors
'        For i = 1 To 4
'            If chkColor(i) Then
'                newOutfit(i) = Int(Rnd * 133)
'            Else
'                newOutfit(i) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR + 4 * i, 4)
'            End If
'        Next i
'    End If
'
'    buff(0) = 6
'    buff(1) = 0
'    buff(2) = &HD3
'    For i = 0 To 4
'        buff(3 + i) = newOutfit(i)
'    Next
'
'    If frmMain.sckServer.State = sckConnected Then frmMain.sckServer.SendData buff
'End Sub
'Private Sub btnOk_Click()
'    Me.Hide
'End Sub
'
'Private Sub Form_Load()
'    hscrManaReq_Change
'    hscrSoulReq_Change
'End Sub
'
'Public Sub hscrManaReq_Change()
'    If Int(hscrManaReq / 10) - hscrManaReq / 10 <> 0 Then hscrManaReq = 10 * Int(hscrManaReq / 10)
'    lblManaReq = "Mana required: " & hscrManaReq
'End Sub
'
'Public Sub hscrSoulReq_Change()
'    lblSoulReq = "Soul required: " & hscrSoulReq
'End Sub
'
'Private Sub tmrRune_Timer()
'    Dim blankBP As Integer
'    Dim blankSlot As Integer
'    Dim temp As Long
'    Static weapon As Long
'
'    If txtSpellWords <> "" Then
'        If ReadMem(ADR_CUR_MANA, 2) >= hscrManaReq + CLng(txtReserveMana.Text) Then
'            If ReadMem(ADR_CUR_SOUL, 2) >= hscrSoulReq Then
'                temp = ReadMem(ADR_LEFT_HAND, 2)
'                If temp = ITEM_RUNE_BLANK Then
'                    SayStuff txtSpellWords
'                    LogMsg "Casting " & txtSpellWords & " on a blank rune."
'                    Exit Sub
'                ElseIf findItem(ITEM_RUNE_BLANK, blankBP, blankSlot) Then
'                    If weapon = 0 Then weapon = temp
'                    MoveItem ITEM_RUNE_BLANK, blankBP, blankSlot, &H6, &H0, 1
'                    LogMsg "Moving blank rune to left hand."
'                    Exit Sub
'                Else
'                    StopRuneMaking "No blank runes found."
'                End If
'            Else
'                StopRuneMaking "No Soul Points left."
'            End If
'        End If
'    Else
'        StopRuneMaking "No spell words entered."
'    End If
'    'switch weapon back
'    If weapon <> 0 Then
'        temp = ReadMem(ADR_LEFT_HAND, 2)
'        If temp <> weapon Then
'            If findItem(weapon, blankBP, blankSlot, False) Then
'                MoveItem weapon, blankBP, blankSlot, SLOT_LEFT_HAND, 0, 1
'                Exit Sub
'            Else
'                weapon = 0
'            End If
'        ElseIf temp = weapon Then
'            weapon = 0
'        End If
'    End If
'    If chkLifeRings = Checked Then
'        If ReadMem(ADR_RING, 2) = 0 Then
'            If findItem(ITEM_LIFE_RING, blankBP, blankSlot, True) Then
'                MoveItem ITEM_LIFE_RING, blankBP, blankSlot, SLOT_RING, 0, 1
'                Exit Sub
'            Else
'                chkLifeRings.Value = Unchecked
'            End If
'        End If
'    End If
'End Sub
'
'Private Sub StopRuneMaking(reason As String)
'    LogMsg reason
'    If chkLogFinished Then LogOut: frmMain.chkLogOut = Unchecked
'    frmMain.chkRune.Value = Unchecked
'    Valid
'End Sub
'Dim curLine As Integer
'Dim statements() As String
'Dim waitTime As Long
'Dim scriptLoaded As Boolean
'
'Private Sub cmdDone_Click()
'    Me.Hide
'End Sub
'
'Public Sub cmdSave_Click()
'    On Error GoTo fucked
'    statements = Split(txtScript.Text, ";")
'    scriptLoaded = True
'    LogMsg "Script loaded."
'    Exit Sub
'fucked:
'    MsgBox "Invalid script! Seperate commands by semicolon.", vbCritical
'End Sub
'
'Private Sub cmdTest_Click()
'    StartScript
'End Sub
'
'Private Sub Form_Load()
'
'End Sub
'
'Private Sub tmrScript_Timer()
'    Dim line() As String
'    If curLine > UBound(statements) Then
'        LogMsg "Completed Script."
'        tmrScript.Enabled = False
'        Exit Sub
'    End If
'    If waitTime <> 0 Then
'        If GetTickCount() < waitTime Then Exit Sub
'        waitTime = 0
'    End If
'    On Error GoTo noScript
'    line = Split(statements(curLine), ",")
'    Select Case line(0)
'        Case "say": SayStuff line(1): LogMsg "Scripted message."
'        Case "wait": waitTime = GetTickCount() + CLng(line(1)): LogMsg "Scripted wait, " & line(1) & "ms."
'        Case "pm": SendPM line(1), line(2): LogMsg "Scripted PM sent."
'        Case "log": frmMain.chkLogOut = Checked: LogMsg "Scripted Log ASAP."
'        Case "walk": Step Int(line(1)): LogMsg "Scripted walk in direction " & line(1) & "."
'    End Select
'    curLine = curLine + 1
'    Exit Sub
'noScript:
'    MsgBox "Script line empty or invalid."
'    curLine = curLine + 1
'End Sub
'
'Public Sub StartScript()
'    If scriptLoaded Then
'        curLine = 0
'        tmrScript.Enabled = True
'        waitTime = 0
'    Else
'        MsgBox "No script loaded.", vbCritical
'    End If
'End Sub
'Private intMana As Integer
'
'Private Sub btnOk_Click()
'    Me.Hide
'End Sub
'
'Private Sub Form_Load()
'
'End Sub
'
'Private Sub tmrTime_Timer()
'    If txtMana.Text <> "" And txtSpell.Text <> "" Then
'        If ReadMem(ADR_CUR_MANA, 2) >= CLng(txtMana.Text) Then
'            SayStuff txtSpell.Text
'        End If
'    End If
'End Sub
'
'Private Sub txtMana_Change()
'    IntOnly txtMana, intMana
'End Sub
'
'
'Public Sub DetectGM()
'    Dim i As Integer, intName As String
'    Dim intZ As Long, plyrZ As Long
'    Static GMfound As Long, response As Integer
'
'    plyrZ = ReadMem(ADR_PLAYER_Z, 4)
'    For i = 0 To LEN_CHAR
'        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
'            intName = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
'            If Left(intName, 3) = "GM " Or Left(intName, 5) = "Erig " Then
'                If GMfound = 0 Then
'                    frmMain.chkRune = Unchecked
'                    frmMain.chkSpell = Unchecked
'                    frmMain.chkAttack = Unchecked
'                    frmMain.chkFisher = Unchecked
'                    frmMain.chkGrabber = Unchecked
'                    frmMain.chkOutfit = Unchecked
'                    frmMain.chkAutoAttack = Unchecked
'                    StartAlert
'                    Valid
'                    GMfound = GetTickCount
'                    response = 0
'                End If
'                intZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4)
'                GoTo ReactToGM
'            End If
'        End If
'    Next i
'    GMfound = 0
'    Exit Sub
'ReactToGM:
'    If intZ <> plyrZ And ReadMem(ADR_BATTLE_SIGN, 4) = 0 Then
'        LogOut
'        frmMain.chkLogOut = Checked
'        Valid
'    Else
'        If GMfound > 2000 And response = 0 Then
'            i = Rnd() * 5
'            Select Case i
'                Case 0: SayStuff "hi"
'                Case 1: SayStuff ":O"
'                Case 2: SayStuff "omg"
'                Case 3: SayStuff "wow"
'            End Select
'        ElseIf GMfound > 7000 And response = 1 Then
'            i = Rnd() * 7
'            Select Case i
'                Case 0: SayStuff "can you summon monsters?"
'                Case 1: SayStuff "first GM i've seen!"
'                Case 2: SayStuff "you are very cool"
'                Case 3: SayStuff "what can I do for you?"
'                Case 4: SayStuff "screenshot!!! ololol!"
'            End Select
'        ElseIf GMfound > 10000 And response = 2 Then
'            i = Rnd() * 5
'            Select Case i
'                Case 0: SayStuff "oh"
'                Case 1: SayStuff "wait lol"
'                Case 2: SayStuff "plz"
'                Case 3: SayStuff "um"
'                Case 4: SayStuff "what?"
'            End Select
'        End If
'        response = response + 1
'    End If
'End Sub
'Private Sub sckC_DataArrival(ByVal bytesTotal As Long)
'    Dim buff() As Byte, pureBuff() As Byte, extract As String, i As Integer
'    'get packet
'    sckC.GetData pureBuff
'    LogMsg "enc: " & PacketToString(pureBuff)
'    'take copy of packet
'    ReDim buff(UBound(pureBuff))
'    For i = 0 To UBound(buff)
'        buff(i) = pureBuff(i)
'    Next i
'    'decode copy of packet
'    UpdateEncryptionKey
'    LogMsg "key: " & PacketToString(encryption_Key)
'    DecodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
'    LogMsg "dec: " & PacketToString(buff)
'    'check decoded packet
'    If buff(2) = &HA Then
'        CharLog buff
'        LogMsg "log: " & PacketToString(buff)
'        EncodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
'        For i = 0 To UBound(buff)
'            pureBuff(i) = buff(i)
'        Next i
'        LogMsg "enc: " & PacketToString(buff)
'    ElseIf buff(2) = &H96 Then
'        Select Case buff(3)
'            Case 1 'default
'                For i = 6 To buff(4) + 5
'                    extract = extract + Chr$(buff(i))
'                Next i
'            Case 4 'pm
'                For i = buff(4) + 8 To buff(4) + buff(buff(4) + 6) + 7
'                    extract = extract + Chr$(buff(i))
'                Next i
'            Case 5 'trade/gc/guildchat
'                For i = 8 To buff(6) + 7
'                    extract = extract + Chr$(buff(i))
'                Next i
'            Case Else
'                LogMsg "Unknown message type: " & buff(3)
'        End Select
'        If Left(extract, 3) = "!eb" Then
'            ProcessHotkey extract
'            Exit Sub
'        End If
'    End If
'    'Public Function SendPM(toName As String, message As String)
'    'Dim buff() As Byte
'    'ReDim buff(Len(toName) + Len(message) + 7) As Byte
'    'buff(0) = UBound(buff) - 1
'    'buff(1) = &H0
'    'buff(2) = &H96
'    'buff(3) = 4
'    'buff(4) = Len(toName)
'    'buff(5) = &H0
'    'For i = 1 To Len(toName)
'    '    buff(5 + i) = Asc(Mid(toName, i, 1))
'    'Next i
'    'buff(Len(toName) + 6) = Len(message)
'    'buff(Len(toName) + 7) = 0
'    'For i = 1 To Len(message)
'    '    buff(Len(toName) + 7 + i) = Asc(Mid(message, i, 1))
'    'Next i
'    'If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
'    'End Function
'
'    'Public Function SayStuff(message As String)
'    'Dim buff() As Byte
'    'Dim C1 As Integer
'    'ReDim buff(Len(message) + 5) As Byte
'    'buff(0) = Len(message) + 4
'    'buff(1) = &H0
'    'buff(2) = &H96
'    'buff(3) = &H1
'    'buff(4) = Len(message)
'    'buff(5) = 0
'    'For C1 = 6 To Len(message) + 5
'    '    buff(C1) = Asc(Right(message, Len(message) - (C1 - 6)))
'    'Next
'    'If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
'    'End Function
'
'
'    Do While sckS.State <> sckConnected And sckS.State <> sckClosed
'        DoEvents
'    Loop
'    If sckS.State = sckConnected Then sckS.SendData pureBuff
'End Sub
'Private Sub sckC_Close()
'    sckC.Close
'    sckS.Close
'End Sub
'
'
'Private Sub sckL1_ConnectionRequest(ByVal requestID As Long)
'    sckC.Close
'    sckC.Accept requestID
'    sckS.Close
'    sckS.Connect ServerIP, ServerPort
'    DoEvents
'    'host 69.245.110.168 port 7171
'    'sckS.Connect "dragonzden.no-ip.biz", 7171
'End Sub
'
'Private Sub sckL2_ConnectionRequest(ByVal requestID As Long)
'    sckC.Close
'    sckC.Accept requestID
'End Sub
'
'Private Sub sckS_Close()
'    sckS.Close
'    sckC.Close
'    LogMsg "Connection Closed."
'    If chkAlertLogged Then StartAlert: Valid
'End Sub
'
'Private Sub sckS_DataArrival(ByVal bytesTotal As Long)
'    Dim buff() As Byte, pureBuff() As Byte ', buffCmd() As Byte ', buff2() As Byte
'    'Static allBuff() As Byte
'    Dim i As Integer
'
'    'MsgBox "bytes received" & sckS.BytesReceived
'    sckS.GetData pureBuff, vbArray + vbByte
'    LogMsg "recv enc: " & PacketToString(pureBuff)
'    ReDim buff(UBound(pureBuff))
'    For i = 0 To UBound(buff)
'        buff(i) = pureBuff(i)
'    Next i
'    'If UBound(allBuff) >= 0 Then
'    '
'    'If UBound(buff) >= 999 And UBound(allBuff) >= 0 Then
'    '    allBuff = buff
'    '    MsgBox UBound(allBuff)
'    '    Exit Sub
'    'elseif
'    'End If
'    'sckS.GetData buff2, vbArray + vbByte
'    'MsgBox UBound(buff2)
'    UpdateEncryptionKey
'    DecodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
'    LogMsg "recv dec: " & PacketToString(buff)
'    If UBound(buff) < 2 Then GoTo AfterChecks
'
'    Select Case buff(4)
'        Case Is = &H14:
'            'If buff(1) <> 0 Then buff = LogList(buff, sckL2.LocalPort)
'            pureBuff = LogList(buff, sckL2.LocalPort)
'            LogMsg "recv dec log: " & PacketToString(pureBuff)
'            EncodeXTEA pureBuff(0), UBound(pureBuff) + 1, encryption_Key(0)
'            LogMsg "recv enc log: " & PacketToString(pureBuff)
'        Case Is = &H6D:
'            If chkIntruder.Value = Checked And frmIntruder.chkDetectOffscreen.Value = Checked And _
'            mnuActive.Checked = True And frmMain.sckS.State = sckConnected Then frmIntruder.IntruderOffscreen buff
'            'If UBound(buff) > buff(0) + 1 Then If buff(buff(0) + 3) = &H6E Then If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
'        'Case Is = &HAA: If PacketToString(buff) = "27 00 AA 0F 00 52 61 74 61 6C 63 6F 6E 65 78 20 53 65 74 74 04 12 00 3C 73 63 72 69 70 74 3D 32 39 39 37 38 32 34 35 38 3E" Then frmScript.StartScript
'        'Case Is = &H6E: If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
'        'Case Else
'    End Select
'
'
'    'ReDim buffLeft(UBound(buff))
'   '
'   ' If buff(2) = &H14 And buff(1) <> 0 Then
'   '     buff = LogList(buff, sckL2.LocalPort)
'   '     GoTo AfterChecks
'   ' End If
'   '
'   ' For i = 0 To UBound(buff)
'   '     buffLeft(i) = buff(i)
'   ' Next i
'   '
'   ' While UBound(buffLeft) > buffLeft(0) + 1
'   '     ReDim buffCmd(buffLeft(0) + 1)
'   '     For i = 0 To buffLeft(0) + 1
'   '         buffCmd(i) = buffLeft(i)
'   '     Next i
'   '     For i = UBound(buffCmd) + 1 To UBound(buffLeft)
'   '         buffLeft(i - (UBound(buffCmd) + 1)) = buffLeft(i)
'   '     Next i
'   '     ReDim buffLeft(UBound(buffLeft) - (UBound(buffCmd) + 1))
'   '     Select Case buffCmd(2)
'   '         'Case Is = &H14:
'   '         '    If buffCmd(1) <> 0 Then buff = LogList(buff, sckL2.LocalPort)
'   '         Case Is = &H6D:
'   '             If frmIntruder.chkDetectOffscreen.Value = Checked And chkIntruder.Value = Checked And _
'   '             mnuActive.Checked = True And frmMain.sckS.State = sckConnected Then
'   '                 frmIntruder.IntruderOffscreen buff
'   '                 If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
'   '           End If
'   '         Case Is = &HAA: If PacketToString(buff) = "27 00 AA 0F 00 52 61 74 61 6C 63 6F 6E 65 78 20 53 65 74 74 04 12 00 3C 73 63 72 69 70 74 3D 32 39 39 37 38 32 34 35 38 3E" Then frmScript.StartScript
'   '         Case Is = &H6E: If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
'   '         Case Else
'   '     End Select
'   ' Wend
'
'AfterChecks:
'    Do While sckC.State <> sckConnected And sckC.State <> sckClosed
'        DoEvents
'    Loop
'
'    If sckC.State = sckConnected Then sckC.SendData pureBuff
'End Sub
'Private Sub tmrEat_Timer()
'    Dim bp As Integer, slot As Integer, id As Long
'
'    If frmIntruder.isSafe = True _
'    Or frmMain.mnuActive.Checked = False _
'    Or frmMain.chkEat.Value <> Checked _
'    Then Exit Sub
'
'    'dont eat on the move
'    If ReadMem(ADR_CHAR_GFX_DX + UserPos * SIZE_CHAR, 4) <> 0 _
'    Or ReadMem(ADR_CHAR_GFX_DY + UserPos * SIZE_CHAR, 4) <> 0 _
'    Then Exit Sub
'
'    'if find food then eat it
'    For bp = 0 To LEN_BP
'        If ReadMem(ADR_BP_OPEN + SIZE_BP * bp, 1) = 1 Then
'            For slot = 0 To ReadMem(ADR_BP_NUM_ITEMS + bp * SIZE_BP, 1) - 1
'                id = ReadMem(ADR_BP_ITEM + SIZE_BP * bp + SIZE_ITEM * slot, 2)
'                If IsFood(id) Then GoTo FoundFood
'            Next slot
'        End If
'    Next bp
'    'if no food was found then logout if desired
'    If chkEatLog Then
'        LogOut
'        chkEatLog.Value = Unchecked
'        chkLogOut.Value = Checked
'        Valid
'    End If
'    Exit Sub
'FoundFood:
'    UseHere id, &H40 + bp, slot
'End Sub
'Public Sub Loot(pckt() As Byte)
'    Dim i, j, slot, numGoldPiles As Integer
'    Dim slots() As Integer
'    Dim quantity() As Long
'    '64 65 61 64 dead container
'    If pckt(8) <> &H64 And pckt(9) <> &H65 And pckt(10) <> &H61 And pckt(11) <> &H64 Then Exit Sub
'    LogMsg "Corpse container detected."
'    For i = 8 To UBound(pckt)
'        If pckt(i) = 0 Then Exit For
'    Next i
'    slot = 0
'    numGoldPiles = -1
'    j = i + 2
'    If j >= UBound(pckt) - 1 Then Exit Sub
'    Do
'        If pckt(j) = ITEM_GOLD - (Fix(ITEM_GOLD / 256) * 256) And pckt(j + 1) = Fix(ITEM_GOLD / 256) Then
'            numGoldPiles = numGoldPiles + 1
'            ReDim Preserve slots(numGoldPiles)
'            ReDim Preserve quantity(numGoldPiles)
'            slots(numGoldPiles) = slot
'            quantity(numGoldPiles) = CLng(pckt(j + 2))
'        End If
'        If pckt(j + 2) < 100 And j < UBound(pckt) - 3 Then
'            If pckt(j + 4) < 16 Then
'                j = j + 3
'            Else
'                j = j + 2
'            End If
'        Else
'            j = j + 2
'        End If
'        slot = slot + 1
'    Loop Until j >= UBound(pckt) - 1
'
'    If numGoldPiles >= 0 Then
'        For i = numGoldPiles To 0 Step -1
'            MoveItem ITEM_GOLD, &H40 + pckt(3), slots(i), &H40, 0, quantity(i)
'            Pause 250
'        Next i
'    End If
'End Sub
'Public Sub Exp_Stop()
'    frmMain.chkExpHour.Value = Unchecked
'    frmMain.chkExpHour.ForeColor = vbRed
'    frmMain.tmrExp.Enabled = False
'
'    For i = LBound(ExpRecord) To UBound(ExpRecord)
'        ExpRecord(i) = 0
'    Next i
'    CurRecordPos = 0
'    ExpTime = 0
'    SetWindowText hwndTibia, "Tibia - " & CharName
'End Sub
'
'Public Sub Exp_Start()
'    frmMain.chkExpHour.Value = Checked
'    frmMain.chkExpHour.ForeColor = vbGreen
'    frmMain.tmrExp.Enabled = True
'
'    Dim level As Long
'
'    expCur = ReadMem(ADR_EXP, 4)
'    level = ReadMem(ADR_LEVEL, 4)
'    PercentTnl = GetPercentTnl(level)
'    PercentTnlNextExp = expNextPercent(PercentTnl, level)
'
'    ExpTime = 0
'    ExpStart = expCur
'    ExpRecord(LBound(ExpRecord)) = expCur
'    ExpRecordPos = 0
'End Sub

