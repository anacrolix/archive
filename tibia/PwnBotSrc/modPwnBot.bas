Attribute VB_Name = "modPwnBot"
Public Const TIME_VISUAL = 250
Public Const TIME_EXP = 2000
Public Const TIME_MAGIC = 1050
Public Const TIME_ACTION = 125
Public Const TIME_LOOT = 250
Public Const TIME_CHARMEM_DEFAULT = 50
Public Const TIME_ECHO = 700 + TIME_CHARMEM_DEFAULT
Public Const TIME_ALERT = 500
Public Const TIME_ALERT_REASONS = 20000
Public Const TIME_REPEAT = 1150
Public Const TIME_EAT = 30000
Public Const TIME_LOCK = 500
Public Const TIME_STEP = 50
Public Const TIME_WAIT_RETARGET = 5000

Public Const ServerIP = "server2.tibia.com"
Public Const ServerPort = 7171
Public Const BOT_NAME = "PwnBot"
Public Const HOTKEY_PREFIX = "!"

Public nextAction As Long
Public nextMagic As Long
Public nextVisual As Long
Public nextLoot As Long
Public nextAlert As Long
Public nextExp As Long
Public nextRepeat As Long
Public nextAttack As Long
Public nextSpell As Long
Public nextEat As Long
Public lock_attack_id As Long
Public lock_follow_id As Long
Public nextLock As Long
Public repeat_words As String
Public repeat_mana As Long
Public repeat_hp As Long
Public alertOn As Boolean

Public nextStepperTick As Long
Public safeX As Long, safeY As Long, safeZ As Long
Public sitX As Long, sitY As Long, sitZ As Long

Public BotIniPath As String
Public ListIniPath As String
Public LoginIniPath As String
Public gameActive As Boolean
Public playerName As String
Public xteaKey(15) As Byte
Public hwndClient As Long
Public hProcClient As Long
Public clientFileName As String
Public clientDir As String

Public Sub Main()
    Const MAX_EXISTING_CLIENTS = 20
    Dim tibFileName As String, hDesktop As Long, hWndTemp As Long
    Dim strWndName As String * 9, hWndExistingClients(MAX_EXISTING_CLIENTS - 1) As Long
    Dim wndCount As Long, i As Integer, foundNewClient As Boolean
    'startup settings
    BotIniPath = App.Path & "\pwnbot.ini"
    ListIniPath = App.Path & "\lists.ini"
    LoginIniPath = App.Path & "\login.ini"
    
    frmMain.Caption = BOT_NAME & " " & App.Major & "." & App.Minor & "." & App.Revision
    Load frmAlert
    Load frmAttack
    Load frmMain
    Load frmPacket
    Load frmWarBot
    frmMain.Show
    
    'locate client
    With frmMain.cdlgClient
        .fileName = "Tibia.exe"
        .Filter = "Tibia clients, *.exe"
        .DialogTitle = "Locate Tibia.exe"
        .InitDir = App.Path
        .DefaultExt = "exe"
    End With
    
    Do
        tibFileName = ReadFromINI(App.Path & "\pwnbot.ini", "Client", "FilePath")
        If tibFileName = "" Or dir(tibFileName) = "" Then LocateTibia
    Loop Until dir(tibFileName) <> "" And tibFileName <> ""
    
    'get existing clients
    hDesktop = GetDesktopWindow()
    hWndTemp = GetWindow(hDesktop, 5)
    Do While hWndTemp <> 0
        GetWindowText hWndTemp, strWndName, Len(strWndName)
        If strWndName = "Tibia   " & vbNullChar Then
            hWndExistingClients(i) = hWndTemp
            i = i + 1
        End If
        hWndTemp = GetWindow(hWndTemp, 2)
    Loop
    
    'start client
    clientFileName = tibFileName
    clientDir = Mid(tibFileName, 1, Len(tibFileName) - Len(dir(tibFileName)))
    ShellExecute 0, "open", clientFileName, 0, clientDir, 3
    If CheckIfIniKeyExists(BotIniPath, "Client", "LoadTime") = False Then _
    WriteToINI BotIniPath, "Client", "LoadTime", 3000
    Delay CLng(ReadFromINI(App.Path & "\pwnbot.ini", "Client", "LoadTime", 3000))
    'get new client window handle
    hDesktop = GetDesktopWindow()
    hWndTemp = GetWindow(hDesktop, 5)
    foundNewClient = False
    Do While foundNewClient = False
        If hWndTemp = 0 Then
            MsgBox "Tibia client did not load."
            Shutdown
        End If
        GetWindowText hWndTemp, strWndName, Len(strWndName)
        If strWndName = "Tibia   " & vbNullChar Then
            foundNewClient = True
            For i = 0 To MAX_EXISTING_CLIENTS - 1
                If hWndTemp = hWndExistingClients(i) Then
                    foundNewClient = False
                    Exit For
                End If
            Next
            If foundNewClient = True Then hwndClient = hWndTemp
        End If
        If foundNewClient = False Then hWndTemp = GetWindow(hWndTemp, 2)
    Loop

    'get class name
'    Dim className As String * 32
'    GetClassName hwndClient, className, 32
'    MsgBox className

    'get process handle
    Dim pid As Long
    GetWindowThreadProcessId hwndClient, pid
    hProcClient = OpenProcess(PROCESS_ALL_ACCESS, False, pid)
    
    'start listen sockets
    frmMain.sckLoginListener.Listen
    frmMain.sckGameListener.Listen
    
    'change login addresses
    For i = 0 To LEN_LOGIN_SERVER - 1
        WriteMemStr ADR_LOGIN_SERVER_IP + SIZE_LOGIN_SERVER * i, "localhost"
        WriteMem ADR_LOGIN_SERVER_PORT + SIZE_LOGIN_SERVER * i, frmMain.sckLoginListener.LocalPort, 2
    Next i
End Sub

Public Function LoadCharHpList(fileName As String, section As String, key As String) As typ_Char_List()
    If CheckIfIniKeyExists(fileName, section, key) = False Then
        WriteToINI fileName, section, key, ""
        Exit Function
    End If
    Dim str1() As String, str2() As String, i As Integer, dimmed As Boolean
    Dim ret() As typ_Char_List
    On Error GoTo Cancel
    str1 = Split(ReadFromINI(fileName, section, key), ";")
    If UBound(str1) < 0 Then GoTo Cancel
    For i = LBound(str1) To UBound(str1)
        str2 = Split(str1(i), ",")
        If UBound(str2) <> 1 Then GoTo NextChar
        str2(0) = Trim(str2(0))
        If IsNumericBounded(str2(1), 0, 100) Or Len(str2(0)) > 32 Then GoTo NextChar
        If dimmed Then
            ReDim Preserve ret(UBound(ret) + 1)
        Else
            ReDim ret(0)
            dimmed = True
        End If
        ret(UBound(ret)).name = str2(0)
        ret(UBound(ret)).hp = CLng(str2(1))
NextChar:
    Next i
'    Dim msg As String
'    For i = LBound(ret) To UBound(ret)
'        msg = msg & ret(i).name & ", " & ret(i).hp & vbCrLf
'    Next i
'    PutDefaultTab msg
    LoadCharHpList = ret
    Exit Function
Cancel:
End Function

Public Sub LocateTibia()
    On Error GoTo Cancel
    frmMain.cdlgClient.ShowOpen
    If frmMain.cdlgClient.FileTitle = "" Then GoTo Cancel
    WriteToINI App.Path & "\pwnbot.ini", "Client", "FilePath", frmMain.cdlgClient.fileName
    Exit Sub
Cancel:
    MsgBox "There was an error locating a tibia client.", vbCritical, "Error"
    End
End Sub

Public Function ReadMemCpy(ByVal address As Long, ByVal size As Long, ByRef toVar)

End Function

Public Sub WriteMemCpy(ByVal address As Long, ByVal size As Long, ByRef fromVar)

End Sub

Public Function ReadMem(ByVal address As Long, Optional ByVal size As Long = 4) As Long
    Dim val As Long
    ReadProcessMemory hProcClient, address, val, size, 0
    ReadMem = val
End Function

Public Sub WriteMem(ByVal address As Long, ByVal val As Long, Optional ByVal size As Long = 4)
    WriteProcessMemory hProcClient, address, val, size, 0
End Sub

Public Sub WriteMemStr(address As Long, str As String)
    Dim byteStr() As Byte, i As Integer
    ReDim byteStr(Len(str))
    For i = 0 To Len(str) - 1
        byteStr(i) = CByte(Asc(Mid(str, i + 1, 1)))
    Next i
    WriteProcessMemory hProcClient, address, byteStr(0), UBound(byteStr) + 1, 0
End Sub

Public Function ReadMemStr(address As Long, length As Integer) As String
    Dim byteStr() As Byte, i As Integer
    ReDim byteStr(length - 1)
    ReadProcessMemory hProcClient, address, byteStr(0), length, 0
    For i = 0 To length - 1
        If byteStr(i) = 0 Then Exit For
        ReadMemStr = ReadMemStr & Chr(byteStr(i))
    Next i
End Function

Public Sub UpdateXteaKey()
    ReadProcessMemory hProcClient, ADR_ENCRYPTION_XTEA_KEY, xteaKey(0), 16, 0
End Sub

Public Sub UpdateWindowText()
    Dim strClient As String, strBot As String
    strClient = "Tibia"
    strBot = BOT_NAME
    If playerName <> "" Then
        If frmMain.sckGameServer.State <> sckConnected Then
            strClient = strClient & " (dc)"
            strBot = "(dc) "
        End If
        strClient = strClient & " <" & playerName & ">"
        strBot = "<" & playerName & ">"
    End If
    If modExp.GetState = Running Then
        strClient = strClient & " " & RoundUp(modExp.GetExpTnl, 1000) & "k tnl (" & RoundUp(modExp.GetExpPerHour, 1000) & "k/hr)"
    End If
    SetWindowText hwndClient, strClient
    frmMain.Caption = strBot
End Sub

Public Function NameInList(fileName As String, section As String, key As String, name As String) As Boolean
    If CheckIfIniKeyExists(fileName, section, key) = False Then
        WriteToINI fileName, section, key, ""
        GoTo Cancel
    End If
    Dim str1() As String, str2 As String, i As Integer
    On Error GoTo Cancel
    str1 = Split(ReadFromINI(fileName, section, key), ";")
    If UBound(str1) < 0 Then GoTo Cancel
    For i = LBound(str1) To UBound(str1)
        str2 = Trim(str1(i))
        If str2 = "" Then GoTo NextValue
        If StrCmp_Tibia(str2, name) = False Then GoTo NextValue
        NameInList = True
        Exit Function
NextValue:
    Next i
    Exit Function
Cancel:
End Function

Public Function CheckAlert(ByRef strTrig As String) As Boolean
    strTrig = ""
    Dim charIndex As Integer 'charindex
    UpdateCharMem
    For charIndex = 0 To LEN_CHAR - 1
        With charMem.char(charIndex)
            'ignore offscreen
            If .onScreen <> 1 Then GoTo NextChar
            'ignore self
            If charIndex = GetPlayerIndex Then GoTo NextChar
            'ignore different altitudes
            If .z > charMem.char(GetPlayerIndex).z + CLng(frmAlert.txtLevelsBelow) Then GoTo NextChar
            If .z < charMem.char(GetPlayerIndex).z - CLng(frmAlert.txtLevelsAbove) Then GoTo NextChar
            'if in always list
            If NameInList(ListIniPath, "char lists", "always alert", TrimCStr(.name)) Then GoTo AddChar
            'if only using always list try next
            If frmAlert.chkOnlyUseAlwaysList Then GoTo NextChar
            'if monster and ignoring monsters
            If GetByte(3, .id) = &H40 And frmAlert.chkIgnoreMonsters Then GoTo NextChar
            If frmAlert.chkIgnoreSafeList _
            Then If NameInList(ListIniPath, "char lists", "safe list", TrimCStr(.name)) _
            Then GoTo NextChar
            If frmAlert.chkIgnoreOfflevelSafeList _
            Then If NameInList(ListIniPath, "char lists", "offlevel safe list", TrimCStr(.name)) _
            Then GoTo NextChar
AddChar:
            CheckAlert = True
            If strTrig <> "" Then strTrig = strTrig & ", "
            strTrig = strTrig & TrimCStr(.name) & " " & charMem.char(GetPlayerIndex).z - .z
            GoTo NextChar
        End With
NextChar:
    Next charIndex
End Function

Public Function CheckStepper() As Boolean
    Dim charIndex As Long
    UpdateCharMem
    For charIndex = 0 To LEN_CHAR - 1
        With charMem.char(charIndex)
            If .onScreen <> 1 Then GoTo NextChar
            If charIndex = GetPlayerIndex Then GoTo NextChar
            If .z <> charMem.char(GetPlayerIndex).z Then GoTo NextChar
            If NameInList(ListIniPath, "char lists", "stepper safe list", TrimCStr(.name)) Then GoTo NextChar
            If NameInList(ListIniPath, "char lists", "stepper different z safe list", TrimCStr(.name)) Then GoTo NextChar
            CheckStepper = True
            Exit Function
        End With
NextChar:
    Next charIndex
End Function

Public Function IsMonster(charIndex As Long) As Boolean
    If GetByte(3, charMem.char(charIndex).id) = &H40 Then IsMonster = True
End Function

Public Sub DoActions()
    'check connected and active
    If (frmMain.sckGameServer.State <> sckConnected Or frmMain.sckGameClient.State <> sckConnected) _
    And IsServerReplied Then
        MsgBox "game active while not connected."
    End If
    If hProcClient = 0 Then Exit Sub
    
    'important variables
    Dim curTick As Long, changedWindowText As Boolean
    curTick = GetTickCount
    
    'VISUAL
    If IsGameActive And frmMain.chkAdjustVisuals And (curTick >= nextVisual Or IsCharMemRecent(TIME_VISUAL)) Then
        nextVisual = curTick + TIME_VISUAL
        UpdateCharMem
        DoVisuals
    End If
    
    'ALERT
    Static nextAlertReasons As Long
    If (frmMain.chkAlert.Value <> Checked Or IsGameActive = False) And alertOn Then
        alertOn = False
    ElseIf (curTick >= nextAlert Or IsCharMemRecent(TIME_ALERT)) _
    And frmMain.chkAlert And IsGameActive Then
        Dim reasons As String
        If CheckAlert(reasons) Then
            alertOn = True
            nextAlert = curTick + TIME_ALERT
            frmAlert.lblAlertReasons = reasons
            If curTick >= nextAlertReasons And frmAlert.chkShowReasonsInClient Then
                nextAlertReasons = curTick + TIME_ALERT_REASONS
                PutDefaultTab reasons
            End If
        End If
    End If
    
    'EXPERIENCE
    'shutdown
    If frmMain.chkExperience.Value <> Checked Or IsGameActive = False Then
        If modExp.GetState <> Stopped Then changedWindowText = True
        modExp.SetState Stopped
    'set starting up
    ElseIf frmMain.chkExperience And IsGameActive And modExp.GetState = Stopped Then
        modExp.SetState Starting
        nextExp = curTick + TIME_ECHO
    'finish starting up
    ElseIf frmMain.chkExperience And IsGameActive And modExp.GetState = Starting And curTick >= nextExp Then
        modExp.SetState Running
        modExp.ResetStats
        nextExp = curTick + TIME_EXP
        changedWindowText = True
    'update statistics
    ElseIf frmMain.chkExperience And IsGameActive And modExp.GetState = Running And curTick >= nextExp Then
        modExp.Update
        changedWindowText = True
        nextExp = curTick + TIME_EXP
    End If
    
    'STEPPER
    Static stepperReturnToSitTick As Long
    If IsGameActive And frmMain.chkStepper _
    And curTick >= nextAction And curTick >= nextStepperTick _
    And safeX <> 0 And safeY <> 0 And sitX <> 0 And sitY <> 0 _
    And GetDir_CompassStr(frmStepper.txtSafeDir) <> -1 _
    And GetDir_CompassStr(frmStepper.txtSitDir) <> -1 Then
        UpdateCharMem
        With charMem.char(GetPlayerIndex)
            If CheckStepper Then
                If .x <> safeX Or .y <> safeY Or .z <> safeZ Then
                    If .x = sitX And .y = sitY And .z = sitZ Then
                        SendToServer Packet_Step(GetDir_CompassStr(frmStepper.txtSafeDir))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    ElseIf .z = safeZ And GetDir_dXdY(safeX - .x, safeY - .y) <> -1 Then
                        SendToServer Packet_Step(GetDir_dXdY(safeX - .x, safeY - .y))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    ElseIf .z = sitZ And GetDir_dXdY(sitX - .x, sitY - .y) <> -1 Then
                        SendToServer Packet_Step(GetDir_dXdY(sitX - .x, sitY - .y))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    Else
                        PutDefaultTab "Stepper - Route to safe position not found."
                        nextStepperTick = GetTickCount + TIME_ECHO
                    End If
                Else
                    stepperReturnToSitTick = GetTickCount + TIME_WAIT_RETARGET
                End If
            ElseIf curTick >= stepperReturnToSitTick Then
                If .x <> sitX Or .y <> sitY Or .z <> sitZ Then
                    If .x = safeX And .y = safeY And .z = safeZ Then
                        SendToServer Packet_Step(GetDir_CompassStr(frmStepper.txtSitDir))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    ElseIf .z = sitZ And GetDir_dXdY(sitX - .x, sitY - .y) <> -1 Then
                        SendToServer Packet_Step(GetDir_dXdY(sitX - .x, sitY - .y))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    ElseIf .z = safeZ And GetDir_dXdY(safeX - .x, safeY - .y) <> -1 Then
                        SendToServer Packet_Step(GetDir_dXdY(safeX - .x, safeY - .y))
                        nextAction = GetTickCount + TIME_ACTION
                        nextStepperTick = GetTickCount + TIME_ECHO + TIME_STEP
                    Else
                        PutDefaultTab "Stepper - Route to sit position not found."
                        nextStepperTick = GetTickCount + TIME_ECHO
                    End If
                End If
            End If
        End With
    End If
    
    'MAGIC
    Dim combatModeIndex As Long, combatModeName As String
    For combatModeIndex = frmWarBot.optCombatMode.LBound To frmWarBot.optCombatMode.UBound
        If frmWarBot.optCombatMode(combatModeIndex).Value = True Then Exit For
    Next combatModeIndex
    If IsGameActive And frmMain.chkWarBot.Value And curTick >= nextMagic And curTick >= nextAction _
    And combatModeIndex <= frmWarBot.optCombatMode.UBound Then
        Select Case combatModeIndex
            Case 0: combatModeName = "war"
            Case 1: combatModeName = "hunt"
        End Select
        UpdateCharMem
        'uh self
        If frmWarBot.chkUhSelf(combatModeIndex) _
        And charMem.char(GetPlayerIndex).hp < CLng(frmWarBot.txtUhSelfHp(combatModeIndex)) _
        And curTick >= nextMagic And curTick >= nextAction Then
            SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.playerID)
            nextMagic = curTick + TIME_MAGIC
            nextAction = curTick + TIME_ACTION
        End If
        'uh a friend
        Dim targetList() As typ_Char_List, charIndex As Long
        If frmWarBot.chkUhFriends(combatModeIndex) And curTick >= nextMagic And curTick >= nextAction Then
            targetList = LoadCharHpList(ListIniPath, "hp lists", "uh friends " & combatModeName)
            If Not ((Not targetList) = -1&) Then
                charIndex = GetBestChar_ByHpList(targetList)
                If charIndex >= 0 Then
                    SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.char(charIndex).id)
                    nextMagic = curTick + TIME_MAGIC
                    nextAction = curTick + TIME_ACTION
                    PutDefaultTab "UHed " & TrimCStr(charMem.char(charIndex).name)
                End If
            Else
                NotifyUser "Uh friends " & combatModeName & " list empty. Function deactivated."
                frmWarBot.chkUhFriends(combatModeIndex).Value = Unchecked
            End If
        End If
    End If
    
    'REPEAT
    If IsGameActive And curTick >= nextRepeat And nextRepeat <> 0 And curTick >= nextMagic Then
        UpdateCharMem
        If repeat_words = "" Or _
        (charMem.char(GetPlayerIndex).hp >= repeat_hp And repeat_hp <> 0) _
        Or charMem.manaCur < repeat_mana Then
            repeat_words = ""
            repeat_mana = 0
            repeat_hp = 0
            nextRepeat = 0
            PutDefaultTab "Repeat deactivated"
        Else
            nextMagic = curTick + TIME_MAGIC
            nextRepeat = curTick + TIME_REPEAT
            nextAction = curTick + TIME_ACTION
            SendToServer Packet_SayDefault(repeat_words)
        End If
    End If
    
    'LOCK ON
    Dim putLock As Boolean, lockIndex As Long
    If IsGameActive And curTick >= nextLock And curTick >= nextAction And (lock_attack_id <> 0 Or lock_follow_id <> 0) Then
        UpdateCharMem
        If charMem.attackID = 0 And lock_attack_id <> 0 Then
            lockIndex = GetChar_ById(lock_attack_id)
            If lockIndex >= 0 Then
                If charMem.char(lockIndex).onScreen = 1 Then
                    SendToServer Packet_Attack(lock_attack_id)
                    WriteMem ADR_ATTACK_ID, lock_attack_id
                    charMem.attackID = lock_attack_id
                    putLock = True
                End If
            End If
        ElseIf charMem.followID = 0 And lock_follow_id <> 0 Then
            lockIndex = GetChar_ById(lock_follow_id)
            If lockIndex >= 0 Then
                If charMem.char(lockIndex).onScreen = 1 Then
                    SendToServer Packet_Follow(lock_follow_id)
                    WriteMem ADR_FOLLOW_ID, lock_follow_id
                    charMem.followID = lock_follow_id
                    putLock = True
                End If
            End If
        End If
        If putLock Then
            nextLock = GetTickCount + TIME_LOCK
            nextAction = GetTickCount + frmMain.tmrAction.Interval / 2
        End If
    End If
    
    'AUTO ATTACK
    If IsGameActive And curTick >= nextAttack And curTick >= nextAction And frmMain.chkAutoAttack Then
        Dim resDoAttack As Long
        resDoAttack = DoAttack
        Select Case resDoAttack
            Case 1: nextAttack = GetTickCount + TIME_ECHO
                nextAction = GetTickCount + frmMain.tmrAction.Interval / 2
        End Select
    End If
    
    'LOOT
    If IsGameActive And frmMain.chkLoot And curTick >= nextLoot And curTick >= nextAction Then
        Dim resGrabLoot As Long
        resGrabLoot = modLoot.GrabLoot(curTick)
        Select Case resGrabLoot
            'no item was found
            Case 0: nextLoot = curTick + TIME_LOOT
            'an item was taken
            Case 1: nextLoot = curTick + TIME_LOOT
                nextAction = curTick + TIME_ACTION
            'a bp was opened or closed
            Case 2: nextLoot = curTick + TIME_ECHO
                nextAction = curTick + TIME_ACTION
            Case 3: nextLoot = curTick + TIME_LOOT * 5
                PutDefaultTab "No loot container marker found."
            Case Else
                ReportBug "grabloot() returned unexpected value"
        End Select
    End If
    
    Static spellLastItem As typ_Item
    'SPELL/RUNE
    If IsGameActive And frmMain.chkSpells And frmSpell.chkMakeRune _
    And curTick >= nextMagic And curTick >= nextAction And curTick >= nextSpell Then
        UpdateCharMem
        'rune maker active
        If Trim(frmSpell.txtRuneWords) <> "" And frmSpell.chkMakeRune Then
            Dim curHandItem As typ_Item, curHandSlot As Long
            Dim locIndex As Long, slotIndex As Long
            If frmSpell.optLeftHand Then 'left hand selected
                ReadProcessMemory hProcClient, ADR_LEFT_HAND, curHandItem, Len(curHandItem), 0
                curHandSlot = SLOT_LEFT_HAND
            Else 'right hand selected
                ReadProcessMemory hProcClient, ADR_RIGHT_HAND, curHandItem, Len(curHandItem), 0
                curHandSlot = SLOT_RIGHT_HAND
            End If
            'enuff mana and no blank
            If charMem.manaCur >= CLng(frmSpell.txtRuneMana) And curHandItem.id <> ITEM_RUNE_BLANK Then
                'look for a blank
                If FindItem_Inventory(ITEM_RUNE_BLANK, 0, locIndex, slotIndex) Then
                    SendToServer Packet_MoveItem(ITEM_RUNE_BLANK, locIndex + SLOT_INV, slotIndex, curHandSlot, 0, 1)
                    nextAction = GetTickCount + TIME_ACTION
                    nextSpell = GetTickCount + TIME_ECHO
                    If spellLastItem.id = 0 And curHandItem.id <> 0 Then spellLastItem = curHandItem
                    PutDefaultTab "Putting blank rune to hand."
                Else 'no blank found
                    If spellLastItem.id = 0 Then
                        frmSpell.chkMakeRune.Value = Unchecked
                        PutDefaultTab "No blank runes found. Rune maker disabled."
                    Else
                        GoTo Spell_PutBackOriginalItem
                    End If
                End If
            ElseIf charMem.manaCur >= CLng(frmSpell.txtRuneMana) And curHandItem.id = ITEM_RUNE_BLANK Then
                SendToServer Packet_SayDefault(frmSpell.txtRuneWords)
                nextAction = GetTickCount + TIME_ACTION
                nextMagic = GetTickCount + TIME_MAGIC
                nextSpell = GetTickCount + TIME_ECHO
            'no enough mana and there was an item earlier
            ElseIf charMem.manaCur < CLng(frmSpell.txtRuneMana) And spellLastItem.id <> 0 And curHandItem.id <> spellLastItem.id Then
Spell_PutBackOriginalItem:
                If FindItem_Inventory(spellLastItem.id, spellLastItem.extra1, locIndex, slotIndex) Then
                    SendToServer Packet_MoveItem(spellLastItem.id, locIndex + SLOT_INV, slotIndex, curHandSlot, 0, spellLastItem.extra1)
                    nextAction = GetTickCount + TIME_ACTION
                    nextSpell = GetTickCount + TIME_ECHO
                    PutDefaultTab "Putting original item back to hand."
                Else
                    PutDefaultTab "Original item not found."
                    spellLastItem.id = 0
                    spellLastItem.extra1 = 0
                End If
            ElseIf charMem.manaCur < CLng(frmSpell.txtRuneMana) And spellLastItem.id = curHandItem.id Then
                spellLastItem.id = 0
                spellLastItem.extra1 = 0
            End If
        End If
    End If
    
    'spells part
    If IsGameActive And frmMain.chkSpells And frmSpell.chkCastSpell _
    And curTick >= nextMagic And curTick >= nextAction And curTick >= nextSpell Then
        UpdateCharMem
        If charMem.manaCur >= CLng(frmSpell.txtSpellMana) _
        And frmSpell.txtSpellWords <> "" Then
            SendToServer Packet_SayDefault(frmSpell.txtSpellWords)
            nextMagic = GetTickCount + TIME_MAGIC
            nextAction = GetTickCount + TIME_ACTION
            nextSpell = GetTickCount + TIME_ECHO
        End If

    End If
    
    'EAT
    If IsGameActive And frmMain.chkEat And curTick >= nextEat And curTick >= nextAction Then
        Dim resEatFood As Long
        resEatFood = DoEatFood
        Select Case resEatFood
            Case 1, 2: nextAction = curTick + TIME_ACTION
                nextEat = curTick + TIME_EAT
        End Select
    End If
    
EndActions:
    If changedWindowText Then UpdateWindowText
End Sub

'change target
'new target
'cancel target

'0=no food
'1=ate a food, no shift
'2=ate food, may cause backpack to shift
Public Function DoEatFood() As Long
    Dim bp As Long, slot As Long, id As Long
    For bp = 0 To LEN_BP - 1
        If ReadMem(ADR_BP_OPEN + bp * SIZE_BP) <> 1 Then GoTo NextBp
        For slot = 0 To ReadMem(ADR_BP_NUM_ITEMS + bp * SIZE_BP) - 1
            id = ReadMem(ADR_BP_ITEM + bp * SIZE_BP + slot * SIZE_ITEM)
            If IsFood(id) = False Then GoTo NextSlot
            GoTo FoundFood
NextSlot:
        Next slot
NextBp:
    Next bp
    Exit Function
FoundFood:
    If ReadMem(ADR_BP_ITEM_QUANTITY + bp * SIZE_BP + slot * SIZE_ITEM) > 1 Then
        DoEatFood = 1
    Else
        DoEatFood = 2
    End If
    SendToServer Packet_UseHere(id, bp + SLOT_INV, slot)
'    PutDefaultTab "Ate a food. (" & bp + SLOT_INV & ", " & slot & ")"
End Function

Public Function GetXySeperation(char1 As Long, char2 As Long) As Long
    Dim sepTotal As Long, sepX As Long, sepY As Long
    sepX = Abs(charMem.char(char1).x - charMem.char(char2).x)
    sepY = Abs(charMem.char(char1).y - charMem.char(char2).y)
    sepTotal = sepX + sepY
    If sepX > 0 And sepY > 0 Then sepTotal = sepTotal - 1
    GetXySeperation = sepTotal
End Function

Public Function StrCmp_Tibia(ByVal str1 As String, ByVal str2 As String) As Boolean
    Dim tildeIndex As Long
    str1 = LCase(str1)
    str2 = LCase(str2)
    tildeIndex = InStr(1, str1, "~")
    If tildeIndex > 0 Then
        If Left(str1, tildeIndex - 1) <> Left(str2, tildeIndex - 1) Then Exit Function
    Else
        If str1 <> str2 Then Exit Function
    End If
    StrCmp_Tibia = True
End Function

Public Function IsValidAutoAttackTarget(charIndex As Long) As Boolean
    With charMem.char(charIndex)
        'not around
        If .onScreen <> 1 Then Exit Function
        'not same z
        If .z <> charMem.char(GetPlayerIndex).z Then Exit Function
        'not self
        If charIndex = GetPlayerIndex Then Exit Function
        'ignore monsters
        If frmAttack.chkIgnoreMonsters And IsMonster(charIndex) Then Exit Function
        'out of range
        If frmAttack.chkLimitRange _
            Then If GetXySeperation(charIndex, GetPlayerIndex) > CLng(frmAttack.txtRange) _
            Then Exit Function
        'in ignore list
        If frmAttack.chkIgnoreList _
            Then If NameInList(ListIniPath, "auto attack", "ignore list", TrimCStr(.name)) _
            Then Exit Function
        'hp below setting
        If frmAttack.chkStopHp And .hp < CLng(frmAttack.txtStopHp) Then Exit Function
    End With
    IsValidAutoAttackTarget = True
End Function

'0 = no change
'1 = change
Public Function DoAttack() As Long
    UpdateCharMem
    Dim curIndex As Long, i As Long
    curIndex = -1
    If charMem.attackID <> 0 Then
        curIndex = GetChar_ById(charMem.attackID)
        If frmAttack.chkClosest.Value <> Checked _
            Then If IsValidAutoAttackTarget(curIndex) _
            Then Exit Function
    End If
    Dim bestIndex As Long, bestRange As Long, curRange As Long
    bestIndex = -1
    bestRange = CLng(frmAttack.txtRange) + 1
    For i = 0 To LEN_CHAR - 1
        If IsValidAutoAttackTarget(i) = False Then GoTo NextChar
        If frmAttack.chkClosest.Value <> Checked Then
            bestIndex = i
            Exit For
        End If
        curRange = GetXySeperation(i, GetPlayerIndex)
        If curRange < bestRange Then
            bestIndex = i
            bestRange = curRange
        End If
NextChar:
    Next i
    
    Dim tarID As Long
    If (bestIndex = -1 And curIndex = -1) Or bestIndex = curIndex Then
        Exit Function
    ElseIf bestIndex = -1 And curIndex <> -1 Then
        tarID = 0
        PutDefaultTab "Cancelled attack on " & TrimCStr(charMem.char(curIndex).name)
    Else
        tarID = charMem.char(bestIndex).id
        PutDefaultTab "Put attack on " & TrimCStr(charMem.char(bestIndex).name)
    End If
    
    SendToServer Packet_Attack(tarID)
    WriteMem ADR_ATTACK_ID, tarID
    charMem.attackID = tarID
    DoAttack = 1
End Function

Public Function GetBestChar_ByHpList(charHpList() As typ_Char_List) As Long
    Dim i As Long, j As Long, best_i As Long, best_j As Long
    best_j = UBound(charHpList) + 1
    best_i = -1
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .id = 0 Then GoTo Done
            If .onScreen <> 1 Then GoTo Next_i
            If .z <> charMem.char(GetPlayerIndex).z Then GoTo Next_i
            Dim thisName As String
            thisName = Left(.name, InStr(1, .name, Chr$(0&)) - 1)
            For j = LBound(charHpList) To UBound(charHpList)
                If j >= best_j Then GoTo Next_i
                If .hp >= charHpList(j).hp Then GoTo Next_j
                If thisName <> Trim(charHpList(j).name) Then GoTo Next_j
                best_j = j
                best_i = i
Next_j:
            Next j
        End With
Next_i:
    Next i
Done:
    GetBestChar_ByHpList = best_i
End Function

Public Function GetChar_ById(id As Long) As Long
    Dim i As Long
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .id = id Then
                GetChar_ById = i
                Exit Function
            End If
        End With
    Next i
    GetChar_ById = -1
End Function

Public Function GetChar_ByName(name As String) As Long

End Function

Public Function GetPlayerIndex() As Long
    Static lastIndex As Long
    If lastIndex >= 0 Then
        If charMem.playerID = charMem.char(lastIndex).id Then
            GetPlayerIndex = lastIndex
            Exit Function
        End If
    End If
    lastIndex = GetChar_ById(charMem.playerID)
    GetPlayerIndex = lastIndex
End Function

Public Sub AdjustAddons()
    Dim charIndex As Long
    charIndex = GetPlayerIndex
    With charMem.char(charIndex)
        If .id <> 0 And .addons <> &HFF Then
            WriteMem ADR_CHAR_OUTFIT + 20 + charIndex * SIZE_CHAR, &HFF
        End If
    End With
End Sub

Public Sub DoVisuals()
    On Error GoTo Error
    Dim charIndex As Long
    For charIndex = 0 To LEN_CHAR - 1
        With charMem.char(charIndex)
            If .onScreen <> 1 Then GoTo NextChar
            If .lightColor <> LIGHT_WHITE Or .lightIntensity <> LIGHT_FULL Then
                If (frmVisuals.chkLightEveryone And charIndex <> GetPlayerIndex) Or (frmVisuals.chkLightPlayer And charIndex = GetPlayerIndex) Then
                    charMem.char(charIndex).lightIntensity = LIGHT_FULL
                    charMem.char(charIndex).lightColor = LIGHT_WHITE
                    WriteProcessMemory hProcClient, ADR_CHAR_LIGHT + charIndex * SIZE_CHAR, .lightIntensity, 8, 0
                End If
            End If
            If (frmVisuals.chkAllAddonsEveryone And charIndex <> GetPlayerIndex) Or (frmVisuals.chkAllAddonsPlayer And charIndex = GetPlayerIndex) Then
                If .addons <> ADDONS_MAX And IsMonster(charIndex) = False Then
                    .addons = ADDONS_MAX
                    WriteMem ADR_CHAR_ADDONS + charIndex * SIZE_CHAR, ADDONS_MAX
                End If
            End If
            If frmVisuals.chkShowlInvisible _
            And IsMonster(charIndex) _
            And .outfit = 0 Then
                .outfit = OUTFIT_MALE_OLD
                .head = OUTFIT_COLOR_WHITE
                .body = OUTFIT_COLOR_RED
                .legs = OUTFIT_COLOR_RED
                .feet = OUTFIT_COLOR_BLACK
                .addons = 0
                WriteProcessMemory hProcClient, ADR_CHAR_OUTFIT + charIndex * SIZE_CHAR, .outfit, 24, 0
            End If
        End With
NextChar:
    Next charIndex
    Exit Sub
Error:
    PutDefaultTab "ERROR WHILE ADJUSTING VISUALS."
End Sub

Public Sub DoWho(ByVal speed As Boolean, monsters As Boolean)
    Dim str As String, i As Long, pZ As Long
    UpdateCharMem
    pZ = charMem.char(GetPlayerIndex).z
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> 1 Then GoTo NextChar
            If monsters = False And IsMonster(i) Then GoTo NextChar
            If str <> "" Then str = str & "; "
            str = str & TrimCStr(.name) & " ["
            If .z <> pZ Then
                str = str & "z: " & StrSign(pZ - .z)
                If speed Then str = str & ", "
            End If
            If speed Then str = str & "spd: " & (.speed - 218) \ 2 & "(" & .speed & ")"
            str = str & "]"
        End With
NextChar:
    Next i
    PutDefaultTab "In memory: " & str
End Sub

Public Sub DoHotkey(msg As String)
    UpdateCharMem
    Dim str() As String, i As Long
    str = Split(msg, " ")
    If UBound(str) < 0 Then GoTo Error
    While str(i) = ""
        i = i + 1
        If i > UBound(str) Then GoTo Error
    Wend
    str(i) = LCase(str(i))
    If str(i) = "rune" Then
        i = i + 1
        If str(i) = "uh" Then
            SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.playerID)
            GoTo Success
        End If
    ElseIf str(i) = "loot" Then
        If frmMain.chkLoot Then
            frmMain.chkLoot.Value = Unchecked
        Else
            frmMain.chkLoot.Value = Checked
        End If
        GoTo Success
    ElseIf str(i) = "lock" Then
        Dim charIndex As Long, targetName As String
        targetName = Trim(StrCatArray(str, i + 1, " "))
        If targetName = "" Then
            PutDefaultTab "No target is specified."
            GoTo Success
        End If
        For charIndex = 0 To LEN_CHAR - 1
            If StrCmp_Tibia(targetName, TrimCStr(charMem.char(charIndex).name)) Then Exit For
        Next charIndex
        If charIndex < LEN_CHAR Then
            PutDefaultTab "Locked attack on " & TrimCStr(charMem.char(charIndex).name) & "."
            lock_attack_id = charMem.char(charIndex).id
            lock_follow_id = 0
            nextLock = GetTickCount + TIME_LOCK
            SendToServer Packet_Attack(lock_attack_id)
            charMem.attackID = lock_attack_id
            WriteMem ADR_ATTACK_ID, lock_attack_id
        Else
            PutDefaultTab "Target character not found."
        End If
        GoTo Success
    ElseIf str(i) = "who" Then
        Dim showSpeed As Boolean, showMonster As Boolean
        For i = i + 1 To UBound(str)
            str(i) = LCase(str(i))
            If str(i) = "speed" Then showSpeed = True
            If Left(str(i), 7) = "monster" Then showMonster = True
        Next i
        DoWho showSpeed, showMonster
        GoTo Success
    ElseIf str(i) = "repeat" Then
        i = i + 1
        If StrInBounds(str(i), 0, 99) And StrInBounds(str(i + 1), 0, INT_MAX) And nextRepeat = 0 Then
            UpdateCharMem
            repeat_hp = CLng(str(i))
            repeat_mana = CLng(str(i + 1))
            If (charMem.char(GetPlayerIndex).hp < repeat_hp Or repeat_hp = 0) _
            And (charMem.manaCur >= repeat_mana Or repeat_mana = 0) Then
                repeat_words = StrCatArray(str, i + 2, " ")
                nextRepeat = GetTickCount + TIME_MAGIC / 2
                GoTo Success
            End If
        End If
        If nextRepeat <> 0 Then
            nextRepeat = 0
            PutDefaultTab "Repeat deactivated"
        End If
        repeat_words = "(stub)"
        repeat_hp = INT_MAX
        repeat_mana = INT_MAX
        Exit Sub
    End If
    PutDefaultTab "Command unrecognized."
    Exit Sub
Success:
'    PutDefaultTab "Command was success = " & msg
    Exit Sub
Error:
    PutDefaultTab "Command failed = " & msg
End Sub

Public Sub PutDefaultTab(msg As String)
    SendToClient Packet_ReceiveMessage("", 0, 4, msg)
End Sub

Public Sub ReportBug(strBug As String)
    If IsGameActive Then
        PutDefaultTab "BUG: " & strBug
    Else
        MsgBox "BUG: " & strBug, vbCritical, "Error detected!"
    End If
End Sub

Public Sub NotifyUser(strNotify As String)
    If IsGameActive Then
        PutDefaultTab strNotify
    Else
        MsgBox strNotify
    End If
End Sub

Public Sub Shutdown(Optional endClient As Boolean = True)
    If endClient And hProcClient <> 0 Then
        Dim exitCode As Long
        GetExitCodeProcess hProcClient, exitCode
        TerminateProcess hProcClient, exitCode
        CloseHandle hProcClient
    End If
    Unload frmAlert
    Unload frmPacket
    Unload frmVisuals
    Unload frmWarBot
    Unload frmMain
    End
End Sub

Public Function GetDir_dXdY(dX As Long, dY As Long) As Long
    Dim ret As Long
    If dX = 0 And dY = -1 Then
        ret = DIR_NORTH
    ElseIf dX = 1 And dY = 0 Then
        ret = DIR_EAST
    ElseIf dX = 0 And dY = 1 Then
        ret = DIR_SOUTH
    ElseIf dX = -1 And dY = 0 Then
        ret = DIR_WEST
    ElseIf dX = 1 And dY = -1 Then
        ret = DIR_NORTH_EAST
    ElseIf dX = 1 And dY = 1 Then
        ret = DIR_SOUTH_EAST
    ElseIf dX = -1 And dY = 1 Then
        ret = DIR_SOUTH_WEST
    ElseIf dX = -1 And dY = -1 Then
        ret = DIR_NORTH_WEST
    Else
        ret = -1
    End If
    GetDir_dXdY = ret
End Function

Public Function GetDir_CompassStr(ByVal vbstrDir As String) As Long
    Dim str As String, ret As Long
    str = LCase(vbstrDir)
    Select Case str
        Case "n", "north": ret = DIR_NORTH
        Case "ne", "north east", "northeast": ret = DIR_NORTH_EAST
        Case "e", "east": ret = DIR_EAST
        Case "se", "south east", "southeast": ret = DIR_SOUTH_EAST
        Case "s", "south": ret = DIR_SOUTH
        Case "sw", "south west", "southwest": ret = DIR_SOUTH_WEST
        Case "w", "west": ret = DIR_WEST
        Case "nw", "north west", "northwest": ret = DIR_NORTH_WEST
        Case Else: ret = -1
    End Select
    GetDir_CompassStr = ret
End Function
