Attribute VB_Name = "modPwnBot"
Public Const TIME_VISUAL = 250
Public Const TIME_CHARSPY = 50
Public Const TIME_EXP = 2000
Public Const TIME_MAGIC = 1050
Public Const TIME_ACTION = 200
Public Const TIME_BRIEF = 25
Public Const TIME_LOOT = 300
Public Const TIME_CHARMEM_DEFAULT = 25 'frmMain.tmrAction.Interval \ 2
Public Const TIME_ECHO = 650 + TIME_CHARMEM_DEFAULT + TIME_ACTION
Public Const TIME_ALERT = 500
Public Const TIME_ALERT_REASONS = 20000
Public Const TIME_REPEAT = 1200
Public Const TIME_EAT = 30000
Public Const TIME_LOCK = 400
Public Const TIME_STEP = 500
Public Const TIME_LOGOUTPACKET_INTERVAL = 2000
Public Const TIME_WAIT_RETARGET = 5000

Public Const ServerIP = "server.tibia.com"
Public Const ServerPort = 7171
Public Const BOT_NAME = "EruBot"
Public Const HOTKEY_PREFIX = "!"

Public nextActionTick As Long
Public nextMagicTick As Long
Public nextVisualTick As Long
Public nextCharSpyTick As Long
Public nextLootTick As Long
Public nextAlertTick As Long
Public nextExpTick As Long

Public nextAttackTick As Long
Public attack_ignore_id As Long

Public nextSpellTick As Long
Public nextEatTick As Long

Public nextLockTick As Long
Public lock_attack_id As Long
Public lock_attack_name As String
Public lock_follow_id As Long

Public nextRepeatTick As Long
Public repeat_words As String
Public repeat_mana As Long
Public repeat_hp As Long

Public nextStepperTick As Long
Public safeX As Long, safeY As Long, safeZ As Long
Public sitX As Long, sitY As Long, sitZ As Long

Public bLogOut As Boolean
Public bAlert As Boolean

Public BotIniPath As String
Public ListIniPath As String
Public LoginIniPath As String
Public DataIniPath As String
Public HotkeyIniPath As String
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
    DataIniPath = App.Path & "\data.ini"
    HotkeyIniPath = App.Path & "\hotkey.ini"
    
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
    
    ModifyTibiaCode
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

Public Function CheckAlert(ByRef strTrig As String) As Boolean
    strTrig = ""
    Dim charIndex As Integer 'charindex
    If frmAlert.chkDisconnect And IsGameActive = False Then
        CheckAlert = True
        strTrig = "Disconnected"
        Exit Function
    End If
    UpdateCharMem
    If GetPlayerIndex < 0 Then Exit Function
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
            If NameInList(ListIniPath, "char lists", "always alert", TrimCStr(.name)) _
                Or StrCmp_Tibia("gm~", TrimCStr(.name)) _
                Then GoTo AddChar
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
    If charMem.conditionIndicator And CONDITION_MASK_SWORDS And frmStepper.chkIgnoreBattleSign <> Checked Then
        CheckStepper = True
        Exit Function
    End If
    For charIndex = 0 To LEN_CHAR - 1
        With charMem.char(charIndex)
            If .onScreen <> 1 Then GoTo NextChar
            If charIndex = GetPlayerIndex Then GoTo NextChar
            If frmStepper.chkIgnoreMonsters And IsMonster(charIndex) Then GoTo NextChar
            If charMem.char(GetPlayerIndex).z - .z > CLng(frmStepper.txtLevelsAbove) Then GoTo NextChar
            If .z - charMem.char(GetPlayerIndex).z > CLng(frmStepper.txtLevelsBelow) Then GoTo NextChar
            If frmStepper.chkTrigPlayerSpeed And (.speed - 218) \ 2 < CLng(frmStepper.txtEquivSpeed) Then GoTo NextChar
            If NameInList(ListIniPath, "char lists", "stepper safe list", TrimCStr(.name)) Then GoTo NextChar
            If frmStepper.chkIgnoreDifAltList _
                Then If .z <> charMem.char(GetPlayerIndex).z _
                Then If NameInList(ListIniPath, "char lists", "stepper offlevel safe list", TrimCStr(.name)) _
                Then GoTo NextChar
            'if frmstepper.chkignore
            Static lastRet As Boolean
            If lastRet = False Then
                Log DEBUGGING, TrimCStr(.name) & " triggered stepper"
                lastRet = True
            End If
            CheckStepper = True
            Exit Function
        End With
NextChar:
    Next charIndex
    lastRet = False
End Function

Public Sub DoActions()

    'no attached client to operate on
    If hProcClient = 0 Then Exit Sub
    
    'important variables
    Dim bWindowTextChanged As Boolean
    Dim curTick As Long
    curTick = GetTickCount
    Dim gmPresent As Boolean 'TO DO
    gmPresent = IsGmPresent
    
    'VISUAL
    
    If IsGameActive And frmMain.chkAdjustVisuals And gmPresent = False _
        And curTick >= nextVisualTick _
    Then
        nextVisualTick = curTick + TIME_VISUAL
        DoVisuals
    End If
    
    'CHAR SPY
    
    If IsGameActive And frmMain.chkCharSpy _
        And curTick >= nextCharSpyTick _
    Then
        nextCharSpyTick = curTick + TIME_CHARSPY
        DoCharSpy
    Else
        CharSpy_ClearMem
    End If
    
    'ALERT
    
    Static nextAlertTickReasons As Long
    
    If frmMain.chkAlert Then
        If curTick >= nextAlertTick Then
            Dim reasons As String
            If CheckAlert(reasons) Then
                bAlert = True
                nextAlertTick = curTick + TIME_ALERT
                frmAlert.lblAlertReasons = reasons
                If curTick >= nextAlertTickReasons And frmAlert.chkShowReasonsInClient Then
                    nextAlertTickReasons = curTick + TIME_ALERT_REASONS
                    Log FEEDBACK, reasons
                End If
            End If
        End If
    Else
        bAlert = False
    End If
    
    'EXPERIENCE
    
    'shutdown
    If frmMain.chkExperience <> Checked Or IsGameActive = False Then
        If modExp.GetState <> Stopped Then bWindowTextChanged = True
        modExp.SetState Stopped
    'set starting up
    ElseIf frmMain.chkExperience And IsGameActive And modExp.GetState = Stopped Then
        'If modExp.GetState <> Starting Then bWindowTextChanged = True
        modExp.SetState Starting
        nextExpTick = curTick + TIME_ECHO
    'finish starting up
    ElseIf frmMain.chkExperience And IsGameActive _
        And modExp.GetState = Starting And curTick >= nextExpTick _
    Then
        modExp.SetState Running
        modExp.ResetStats
        nextExpTick = curTick + TIME_EXP
        bWindowTextChanged = True
    'update statistics
    ElseIf frmMain.chkExperience And IsGameActive _
        And modExp.GetState = Running And curTick >= nextExpTick _
    Then
        modExp.Update
        bWindowTextChanged = True
        nextExpTick = curTick + TIME_EXP
    End If
    
    'LOG OUT
    
    Static nextLogOutPacketTick As Long
    If IsGameActive And frmMain.chkLogOut Then
        If bLogOut Then
            'UpdateCharMem 'frmMain.tmrAction.Interval \ 2
            If charMem.conditionIndicator And CONDITION_MASK_SWORDS Then
            ElseIf curTick >= nextLogOutPacketTick And frmLogOut.chkLogByUndeath = Unchecked And gmPresent = False Then
                SendToServer Packet_LogOut
                nextLogOutPacketTick = curTick + TIME_LOGOUTPACKET_INTERVAL
                nextActionTick = curTick + TIME_BRIEF
            End If
        Else
            If (frmLogOut.chkSwords.value = Checked And (charMem.conditionIndicator And CONDITION_MASK_SWORDS)) _
                Or (frmLogOut.chkSoulBelow And charMem.soul < CLng(frmLogOut.txtSoul)) _
                Or gmPresent _
                Then LogOut_On False
        End If
    Else
        bLogOut = False
    End If
    
    'STEPPER
    
    Static stepperReturnToSitTick As Long
    If IsGameActive And frmMain.chkStepper _
        And curTick >= nextActionTick And curTick >= nextStepperTick _
        And safeX <> 0 And safeY <> 0 And sitX <> 0 And sitY <> 0 _
        And GetDir_CompassStr(frmStepper.txtSafeDir) <> -1 _
        And GetDir_CompassStr(frmStepper.txtSitDir) <> -1 _
        And gmPresent = False _
    Then
        'UpdateCharMem
        With charMem.char(GetPlayerIndex)
            If CheckStepper Or bLogOut Then
                If .x <> safeX Or .y <> safeY Or .z <> safeZ Then
                    If .x = sitX And .y = sitY And .z = sitZ Then
                        SendToServer Packet_Step(GetDir_CompassStr(frmStepper.txtSafeDir))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_STEP + TIME_ECHO
                        Log FEEDBACK, "Stepper - Moving " & frmStepper.txtSafeDir & " from sit spot to safe spot."
                    ElseIf .z = safeZ And Get_TibiaDir_dXdY(safeX - .x, safeY - .y) <> -1 Then
                        SendToServer Packet_Step(Get_TibiaDir_dXdY(safeX - .x, safeY - .y))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_ECHO + TIME_STEP
                        Log FEEDBACK, "Stepper - Moving to safe spot."
                    ElseIf .z = sitZ And Get_TibiaDir_dXdY(sitX - .x, sitY - .y) <> -1 Then
                        SendToServer Packet_Step(Get_TibiaDir_dXdY(sitX - .x, sitY - .y))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_ECHO + TIME_STEP
                        Log FEEDBACK, "Stepper - Moving to sit spot."
                    Else
                        Log FEEDBACK, "Stepper - Route to safe spot not found."
                        nextStepperTick = curTick + TIME_ECHO
                    End If
                    stepperReturnToSitTick = curTick + TIME_WAIT_RETARGET
                End If
            ElseIf curTick >= stepperReturnToSitTick And bLogOut = False Then
                If .x <> sitX Or .y <> sitY Or .z <> sitZ Then
                    If .x = safeX And .y = safeY And .z = safeZ Then
                        SendToServer Packet_Step(GetDir_CompassStr(frmStepper.txtSitDir))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_ECHO + TIME_STEP
                        Log FEEDBACK, "Stepper - Moving " & frmStepper.txtSitDir & " from safe spot to sit spot."
                    ElseIf .z = sitZ And Get_TibiaDir_dXdY(sitX - .x, sitY - .y) <> -1 Then
                        SendToServer Packet_Step(Get_TibiaDir_dXdY(sitX - .x, sitY - .y))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_ECHO + TIME_STEP
                        Log FEEDBACK, "Stepper - Moving to sit spot."
                    ElseIf .z = safeZ And Get_TibiaDir_dXdY(safeX - .x, safeY - .y) <> -1 Then
                        SendToServer Packet_Step(Get_TibiaDir_dXdY(safeX - .x, safeY - .y))
                        nextActionTick = curTick + TIME_ACTION
                        nextStepperTick = curTick + TIME_ECHO + TIME_STEP
                        Log FEEDBACK, "Stepper - Moving to safe spot."
                    Else
                        Log FEEDBACK, "Stepper - Route to sit spot not found."
                        nextStepperTick = curTick + TIME_ECHO
                    End If
                End If
            End If
        End With
    End If
    
    'MAGIC/WARBOT
    
    Dim combatModeIndex As Long, combatModeName As String
    'determine current combat mode
    For combatModeIndex = frmWarBot.optCombatMode.LBound To frmWarBot.optCombatMode.UBound
        If frmWarBot.optCombatMode(combatModeIndex).value = True Then Exit For
    Next combatModeIndex
    'if warbot is switched on
    If IsGameActive And frmMain.chkWarBot And curTick >= nextMagicTick And curTick >= nextActionTick _
        And combatModeIndex <= frmWarBot.optCombatMode.UBound _
    Then
        Select Case combatModeIndex
            Case 0: combatModeName = "war"
            Case 1: combatModeName = "hunt"
        End Select
        'UpdateCharMem
        'uh self
        If frmWarBot.chkUhSelf(combatModeIndex) _
            And charMem.char(GetPlayerIndex).hp < CLng(frmWarBot.txtUhSelfHp(combatModeIndex)) _
            And curTick >= nextMagicTick And curTick >= nextActionTick _
        Then
            SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.playerID)
            nextMagicTick = curTick + TIME_MAGIC
            nextActionTick = curTick + TIME_ACTION
            Log FEEDBACK, "UHed self at " & charMem.hpCur & " (" & charMem.char(GetPlayerIndex).hp & "%) hp."
        End If
        'uh a friend
        Dim targetList() As typ_Char_List, charIndex As Long
        If frmWarBot.chkUhFriends(combatModeIndex) _
            And curTick >= nextMagicTick And curTick >= nextActionTick _
        Then
            targetList = LoadCharHpList(ListIniPath, "hp lists", "uh friends " & combatModeName)
            If Not ((Not targetList) = -1&) Then
            'If UBound(targetList) >= 0 Then
'            If IsEmptyArray(targetList) = False Then
                charIndex = GetBestChar_ByHpList(targetList)
                If charIndex >= 0 Then
                    SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.char(charIndex).id, 0, 0)
                    nextMagicTick = curTick + TIME_MAGIC
                    nextActionTick = curTick + TIME_ACTION
                    Log FEEDBACK, "UHed " & TrimCStr(charMem.char(charIndex).name & " at " & charMem.char(charIndex).hp & "% hp.")
                End If
            Else
                Log CRITICAL, "Uh friends " & combatModeName & " list empty. Function deactivated."
                frmWarBot.chkUhFriends(combatModeIndex).value = Unchecked
            End If
        End If
    End If
    
    'REPEAT
    
    If IsGameActive _
        And curTick >= nextRepeatTick And nextRepeatTick <> 0 And curTick >= nextMagicTick _
    Then
        'UpdateCharMem
        If repeat_words = "" _
            Or (charMem.char(GetPlayerIndex).hp >= repeat_hp And repeat_hp <> 0) _
            Or charMem.manaCur < repeat_mana _
        Then
            repeat_words = ""
            repeat_mana = 0
            repeat_hp = 0
            nextRepeatTick = 0
            Log FEEDBACK, "Repeat deactivated"
        Else
            nextMagicTick = curTick + TIME_MAGIC
            nextRepeatTick = curTick + TIME_REPEAT
            nextActionTick = curTick + TIME_ACTION
            SendToServer Packet_SayDefault(repeat_words)
        End If
    End If
    
    'LOCK ON
    
    Dim putLock As Boolean, lockIndex As Long
    If IsGameActive _
        And curTick >= nextLockTick And curTick >= nextActionTick _
        And (lock_attack_id <> 0 Or lock_follow_id <> 0 Or lock_attack_name <> "") _
    Then
        'UpdateCharMem
        If charMem.attackID = 0 And (lock_attack_id <> 0 Or lock_attack_name <> "") Then
            If lock_attack_id <> 0 Then
                lockIndex = GetChar_ById(lock_attack_id)
            Else
                Debug.Assert lock_attack_name <> ""
                lockIndex = GetChar_ByName(lock_attack_name)
            End If
            If lockIndex >= 0 Then
                SendToServer Packet_Attack(lock_attack_id)
                WriteMem ADR_ATTACK_ID, lock_attack_id
                charMem.attackID = lock_attack_id
                putLock = True
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
            nextLockTick = curTick + TIME_LOCK
            nextActionTick = curTick + TIME_BRIEF
        End If
    End If
    
    'AUTO ATTACK
    
    If IsGameActive And frmMain.chkAutoAttack And gmPresent = False And bLogOut = False _
        And curTick >= nextAttackTick And curTick >= nextActionTick _
    Then
        Dim resDoAttack As Long
        resDoAttack = DoAttack
        Select Case resDoAttack
            Case 1: nextAttackTick = curTick + TIME_ECHO
                nextActionTick = curTick + TIME_BRIEF
        End Select
    End If
    
    'LOOT
    
    If IsGameActive And frmMain.chkLoot And gmPresent = False And bLogOut = False _
        And curTick >= nextLootTick And curTick >= nextActionTick _
    Then
        Dim resGrabLoot As Long
        resGrabLoot = modLoot.GrabLoot(curTick)
        Select Case resGrabLoot
            'no item was found
            Case 0: nextLootTick = curTick + TIME_LOOT
            'an item was taken
            Case 1: nextLootTick = curTick + TIME_LOOT
                nextActionTick = curTick + TIME_ACTION
            'a bp was opened or closed
            Case 2: nextLootTick = curTick + TIME_ECHO
                nextActionTick = curTick + TIME_ACTION
            Case 3: nextLootTick = curTick + TIME_ECHO * 5
                Log FEEDBACK, "No loot container marker found."
            Case Else
                Log CRITICAL, "grabloot() returned unexpected value"
        End Select
    End If
    
    'SPELL/RUNE
    
    'spells part
    If IsGameActive And frmMain.chkSpells And frmSpell.chkCastSpell And gmPresent = False And bLogOut = False _
        And curTick >= nextMagicTick And curTick >= nextActionTick And curTick >= nextSpellTick _
    Then
        'UpdateCharMem
        If charMem.manaCur >= CLng(frmSpell.txtSpellMana) _
            And charMem.soul >= CLng(frmSpell.txtSpellSoul) _
            And Trim(frmSpell.txtSpellWords) <> "" _
        Then
            SendToServer Packet_SayDefault(frmSpell.txtSpellWords)
            nextMagicTick = curTick + TIME_MAGIC
            nextActionTick = curTick + TIME_ACTION
            nextSpellTick = curTick + TIME_ECHO
        End If
    End If

    'rune part
    Static spellLastItem As typ_Item
    If IsGameActive And frmMain.chkSpells And frmSpell.chkMakeRune And bLogOut = False And gmPresent = False _
        And curTick >= nextMagicTick And curTick >= nextActionTick And curTick >= nextSpellTick _
    Then
        'UpdateCharMem
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
            'enuff mana, soul and no blank
            If charMem.manaCur >= CLng(frmSpell.txtRuneMana) _
                And charMem.soul >= CLng(frmSpell.txtRuneSoul) _
                And curHandItem.id <> ITEM_RUNE_BLANK _
            Then
                'look for a blank
                If FindItem_Inventory(ITEM_RUNE_BLANK, 0, locIndex, slotIndex) Then
                    SendToServer Packet_MoveItem(ITEM_RUNE_BLANK, locIndex + SLOT_INV, slotIndex, curHandSlot, 0, 1)
                    nextActionTick = curTick + TIME_ACTION
                    nextSpellTick = curTick + TIME_ECHO
                    If spellLastItem.id = 0 And curHandItem.id <> 0 Then spellLastItem = curHandItem
                    Log DEBUGGING, "Putting blank rune to hand."
                Else 'no blank found
                    If spellLastItem.id = 0 Then
'                        frmSpell.chkMakeRune.value = Unchecked
                        Log FEEDBACK, "No blank runes found. Rune maker disabled."
                        If frmMain.chkLogOut And frmLogOut.chkNoBlanks And bLogOut = False Then
                            LogOut_On Not gmPresent
                            nextActionTick = curTick + TIME_BRIEF
                        End If
                    Else
                        GoTo Spell_PutBackOriginalItem
                    End If
                End If
            ElseIf charMem.manaCur >= CLng(frmSpell.txtRuneMana) And curHandItem.id = ITEM_RUNE_BLANK Then
                SendToServer Packet_SayDefault(frmSpell.txtRuneWords)
                nextActionTick = curTick + TIME_ACTION
                nextMagicTick = curTick + TIME_MAGIC
                nextSpellTick = curTick + TIME_ECHO
            'not enough mana and there was an item earlier
            ElseIf charMem.manaCur < CLng(frmSpell.txtRuneMana) And spellLastItem.id <> 0 And curHandItem.id <> spellLastItem.id Then
Spell_PutBackOriginalItem:
                If FindItem_Inventory(spellLastItem.id, spellLastItem.extra1, locIndex, slotIndex) Then
                    SendToServer Packet_MoveItem(spellLastItem.id, locIndex + SLOT_INV, slotIndex, curHandSlot, 0, spellLastItem.extra1)
                    nextActionTick = curTick + TIME_ACTION
                    nextSpellTick = curTick + TIME_ECHO
                    Log DEBUGGING, "Putting original item back to hand."
                Else
                    Log DEBUGGING, "Original item not found."
                    spellLastItem.id = 0
                    spellLastItem.extra1 = 0
                End If
            ElseIf charMem.manaCur < CLng(frmSpell.txtRuneMana) And spellLastItem.id = curHandItem.id Then
                spellLastItem.id = 0
                spellLastItem.extra1 = 0
            ElseIf charMem.soul < CLng(frmLogOut.txtSoul) And frmMain.chkLogOut And frmLogOut.chkSoulBelow And bLogOut = False Then
                Log FEEDBACK, "Not enough soul."
                LogOut_On Not gmPresent
                nextActionTick = curTick + TIME_BRIEF
            End If
        End If
    End If
    
    'EAT
    
    If IsGameActive And frmMain.chkEat And bLogOut = False And IsAtSafeSpot = False And bLogOut = False _
        And curTick >= nextEatTick And curTick >= nextActionTick _
    Then
        Dim resEatFood As Long
        resEatFood = DoEatFood
        Select Case resEatFood
            Case 1, 2: nextActionTick = curTick + TIME_ACTION
                nextEatTick = curTick + TIME_EAT
            Case Else:
                If bLogOut = False And frmMain.chkLogOut And frmLogOut.chkNoFood Then
                    Log FEEDBACK, "No food found."
                    LogOut_On Not gmPresent
                    nextaction = curTick + TIME_BRIEF
                End If
        End Select
    End If
    
EndActions:
    If bWindowTextChanged Then UpdateWindowText
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

Public Function IsAtSafeSpot() As Boolean
    UpdateCharMem
    If GetPlayerIndex < 0 Then Exit Function
    With charMem.char(GetPlayerIndex)
        If .x = safeX And .y = safeY And .z = safeZ Then IsAtSafeSpot = True
    End With
End Function

Public Function IsValidAutoAttackTarget(charIndex As Long) As Boolean
    With charMem.char(charIndex)
        'not around
        If .onScreen <> 1 Then Exit Function
        'not same z
        If .z <> charMem.char(GetPlayerIndex).z Then Exit Function
        'not self
        If charIndex = GetPlayerIndex Then Exit Function
        'ignore id
        If charMem.char(charIndex).id = attack_ignore_id Then Exit Function
        'ignore monsters
        If (frmAttack.chkIgnoreMonsters And IsMonster(charIndex)) Or IsMonster(charIndex) = False Then Exit Function
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
        If frmAttack.chkClosest.value <> Checked _
            Then If IsValidAutoAttackTarget(curIndex) _
            Then Exit Function
    End If
    Dim bestIndex As Long, bestRange As Long, curRange As Long
    bestIndex = -1
    bestRange = CLng(frmAttack.txtRange) + 1
    For i = 0 To LEN_CHAR - 1
        If IsValidAutoAttackTarget(i) = False Then GoTo NextChar
        If frmAttack.chkClosest.value <> Checked Then
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
        Log DEBUGGING, "Cancelled attack on " & TrimCStr(charMem.char(curIndex).name)
    Else
        tarID = charMem.char(bestIndex).id
        Log DEBUGGING, "Put attack on " & TrimCStr(charMem.char(bestIndex).name)
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
    Log CRITICAL, "ERROR WHILE ADJUSTING VISUALS."
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
    Log FEEDBACK, "In memory: " & str
End Sub

Public Function DoStrike(strikeType As String) As Boolean
    
End Function

Public Sub DoHotkey(msg As String)
    UpdateCharMem
    Dim str() As String, i As Long
    str = Split(msg, " ")
    If UBound(str) < 0 Then GoTo Error
    While str(i) = ""
        i = i + 1
        If i > UBound(str) Then GoTo Error
    Wend
    If Left(str(i), Len(HOTKEY_PREFIX)) = HOTKEY_PREFIX Then str(i) = Right(str(i), Len(str(i)) - Len(HOTKEY_PREFIX))
    str(i) = LCase(str(i))
    If str(i) = "rune" Then
        i = i + 1
        If str(i) = "uh" Then
            SendToServer Packet_UseAt(ITEM_RUNE_UH, 0, charMem.playerID)
        ElseIf str(i) = "sd" And charMem.magic >= 15 Then
            SendToServer Packet_UseAt(ITEM_RUNE_SD, 0, charMem.attackID)
        ElseIf str(i) = "hmm" Then
            SendToServer Packet_UseAt(ITEM_RUNE_HMM, 0, charMem.attackID)
        ElseIf str(i) = "explo" Or str(i) = "sd" Then
            SendToServer Packet_UseAt(ITEM_RUNE_EXPLO, 0, charMem.attackID)
        Else
            GoTo Error
        End If
        GoTo Success
    ElseIf str(i) = "strike" Then
        i = i + 1
        Dim strikeDir As Long
        strikeDir = -1
        UpdateCharMem 2
        For i = i To UBound(str)
            If str(i) = "vis" And charMem.manaCur >= 20 Then
                strikeDir = GetValidStrikeDir(DAMAGE_ENERGY, False)
            ElseIf str(i) = "mort" And charMem.manaCur >= 20 Then
                strikeDir = GetValidStrikeDir(DAMAGE_FORCE, False)
            ElseIf str(i) = "flam" And charMem.manaCur >= 20 Then
                strikeDir = GetValidStrikeDir(DAMAGE_FIRE, False)
            End If
            If strikeDir >= 0 Then Exit For
        Next i
        If strikeDir < 0 Then
            Log DEBUGGING, "No valid strike targets"
            Exit Sub
        End If
        If charMem.char(GetPlayerIndex).facing <> strikeDir Then
            SendToServer Packet_FaceDirection(strikeDir)
            Delay 50
        End If
        SendToServer Packet_SayDefault("exori " & str(i))
        GoTo Success
    ElseIf str(i) = "loot" Then
        If frmMain.chkLoot Then
            frmMain.chkLoot.value = Unchecked
        Else
            frmMain.chkLoot.value = Checked
        End If
        GoTo Success
    ElseIf str(i) = "lock" Then
        Dim charIndex As Long, targetName As String
        targetName = Trim(StrCatArray(str, i + 1, " "))
        If targetName = "" Then
            Log FEEDBACK, "No target is specified."
            GoTo Success
        End If
        charIndex = GetChar_ByName(targetName)
        If charIndex >= 0 Then
            Log FEEDBACK, "Locked attack on " & TrimCStr(charMem.char(charIndex).name) & "."
            lock_attack_id = charMem.char(charIndex).id
            lock_follow_id = 0
            nextLockTick = GetTickCount + TIME_LOCK
            SendToServer Packet_Attack(lock_attack_id)
            charMem.attackID = lock_attack_id
            WriteMem ADR_ATTACK_ID, lock_attack_id
        Else
            Log FEEDBACK, "Storing lock name on " & targetName
            lock_attack_name = targetName
            lock_attack_id = 0
            lock_follow_id = 0
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
        If StrIsBoundedLong(str(i), 0, 99) And StrIsBoundedLong(str(i + 1), 0, INT_MAX) And nextRepeatTick = 0 Then
            UpdateCharMem
            repeat_hp = CLng(str(i))
            repeat_mana = CLng(str(i + 1))
            If (charMem.char(GetPlayerIndex).hp < repeat_hp Or repeat_hp = 0) _
            And (charMem.manaCur >= repeat_mana Or repeat_mana = 0) Then
                repeat_words = StrCatArray(str, i + 2, " ")
                nextRepeatTick = GetTickCount + TIME_MAGIC / 2
                GoTo Success
            End If
        End If
        If nextRepeatTick <> 0 Then
            nextRepeatTick = 0
            Log FEEDBACK, "Repeat deactivated"
        End If
        repeat_words = "(stub)"
        repeat_hp = INT_MAX
        repeat_mana = INT_MAX
        Exit Sub
    End If
    Log FEEDBACK, "Command unrecognized."
    Exit Sub
Success:
'    PutDefaultTab "Command was success = " & msg
    Exit Sub
Error:
    Log FEEDBACK, "Command failed = " & msg
End Sub

Public Sub Shutdown(Optional endClient As Boolean = True)
    If endClient And hProcClient <> 0 Then
        Dim exitCode As Long
        GetExitCodeProcess hProcClient, exitCode
        TerminateProcess hProcClient, exitCode
        CloseHandle hProcClient
    End If
    Unload frmAlert
    Unload frmAttack
    Unload frmLogOut
    Unload frmPacket
    Unload frmSpell
    Unload frmStepper
    Unload frmVisuals
    Unload frmWarBot
    Unload frmMain
    End
End Sub

Public Sub Evrebot_doXRay()
    Dim seeID As Integer
    If ReadMem(ADR_SEE_Z) = Z_GROUND_LEVEL Then Exit Sub
    seeID = ReadMem(ADR_SEE_ID, 2)
    If seeID = 0 Then Exit Sub
    Evrebot_replaceTiles seeID, TILE_TRANSPARENT
End Sub

Public Sub SeeThrough_Z(ByVal z As Long, ByVal newTileId As Integer)
    Dim mapPointer As Long, playerTileIndex As Long, playerZIndex As Long, zIndex As Long
    mapPointer = ReadMem(ADR_MAP_POINTER)
    playerTileIndex = GetTile_Char(charMem.char(GetPlayerIndex).id)
    Debug.Print "player tile index " & playerTileIndex
    playerZIndex = playerTileIndex \ (LEN_TILE_X * LEN_TILE_Y)
    Debug.Print "player z index " & playerZIndex
    Debug.Print "tile obj count " & ReadMem(mapPointer + playerTileIndex * SIZE_TILE + OS_TILE_NUM_OBJ)
    zIndex = playerZIndex + (charMem.char(GetPlayerIndex).z - z) Mod LEN_TILE_Z
    If zIndex < 0 Then zIndex = zIndex + LEN_TILE_Z
    For tileIndex = zIndex * LEN_TILE_X * LEN_TILE_Y To (zIndex + 1) * LEN_TILE_X * LEN_TILE_Y
        tileId = ReadMem(mapPointer + tileIndex * SIZE_TILE + OS_TILE_OBJ_ID, 2)
        If tileId = 0 Then GoTo NextTile
        WriteMem mapPointer + tileIndex * SIZE_TILE + OS_TILE_OBJ_ID, newTileId, 2
        'WriteMem mapPointer + tileIndex * SIZE_TILE + OS_TILE_NUM_OBJ, 2, 2
NextTile:
    Next tileIndex
End Sub

Public Sub Evrebot_replaceTiles(oldTileId As Integer, newTileId As Integer)
    Dim mapPointer As Long, tileIndex As Long, tileId As Integer
    mapPointer = ReadMem(ADR_MAP_POINTER)
    For tileIndex = 0 To LEN_TILE_ALL - 1
        tileId = ReadMem(mapPointer + tileIndex * SIZE_TILE + OS_TILE_OBJ_ID, 2)
        If tileId = 0 Then GoTo NextTile
        If tileId = oldTileId Then
            WriteMem mapPointer + tileIndex * SIZE_TILE + OS_TILE_OBJ_ID, newTileId, 2
        End If
NextTile:
    Next tileIndex
End Sub

'void CTibia::doXRay()
'{
'    // read see z-axis
'    int seeZ = getSeeZ();
'
'    // default z-axis does not work
'    if (seeZ == Z_AXIS_DEFAULT)
'        return;
'
'    // read see id
'    int seeId = getSeeId();
'    if (seeId == 0)
'        return;
'
'    // replace last seen tile id with transparent tile id
'    doReplaceTile(static_cast<Tile_t>(seeId), TILE_TRANSPARENT);
'}
'
'void CTibia::doReplaceTile(Tile_t oldTileId, Tile_t newTileId)
'{
'    // get map begin by reading map pointer
'    int mapBegin = getMapPointer();
'
'    // search through map data
'    for(int i = mapBegin; i < mapBegin + (STEP_MAP_TILE * MAX_MAP_TILES); i += STEP_MAP_TILE)
'    {
'        // get tile id from current tile data
'        int j = i + OFFSET_MAP_TILE_ID;
'
'        // read tile id
'        int tileId = Trainer.readBytes(j, 2);
'
'        // skip blank ids
'        if (tileId == 0)
'            continue;
'
'        // tile id matches old tile id
'        if (tileId == oldTileId)
'        {
'            // replace current tile id with new tile id
'            Trainer.writeBytes(j, newTileId, 2);
'        }
'    } // for
'}

Public Sub LogOut_On(tryImmediately As Boolean)
    If bLogOut = False And IsGameActive Then
        Log FEEDBACK, "Attempting to logout."
        If tryImmediately And frmLogOut.chkLogByUndeath.value = Unchecked _
            Then SendToServer Packet_LogOut
        bLogOut = True
    End If
End Sub


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

Public Sub ModifyTibiaCode()
    If frmMain.chkAdjustVisuals And frmVisuals.chkShowNames Then
        WriteNops ADR_SHOW_NAMES, 2
        WriteNops ADR_SHOW_NAMES_EX, 2
    Else
        WriteProcessMemory hProcClient, ADR_SHOW_NAMES, SHOW_NAMES_DEFAULT, 2, 0
        WriteProcessMemory hProcClient, ADR_SHOW_NAMES_EX, SHOW_NAMES_EX_DEFAULT, 2, 0
    End If
End Sub
