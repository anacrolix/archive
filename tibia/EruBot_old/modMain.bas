Attribute VB_Name = "modMain"
'Public Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
'Public Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
'Public Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
'Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal Msg As Any, ByVal wParam As Any, ByVal lParam As Any) As Long

Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long
'Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function GetForegroundWindow Lib "user32" () As Long
Public Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long

'Public Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
'Public Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal sURL As String, ByVal sHeaders As String, ByVal lHeadersLength As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
'Public Declare Function InternetReadFile Lib "wininet.dll" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
'Public Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
'
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
'Public Declare Function SetActiveWindow Lib "user32" (ByVal hwnd As Long) As Long

Public Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Public Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long

'int _stdcall UpdateCharacterMemory(HANDLE hProcTibia) {
Public Declare Function UpdateCharacterMemory Lib "erudll.dll" (ByVal hProcess As Long) As Integer
'int _stdcall ReadMemory(HANDLE hProcTibia, DWORD address, DWORD length, long* val) {
Public Declare Function ReadMemory Lib "erudll.dll" (ByVal hProcess As Long, ByVal address As Long, ByVal length As Long, ByRef buffer As Long) As Integer
'int _stdcall WriteMemory(HANDLE hProcTibia, DWORD address, DWORD length, long val) {
Public Declare Function WriteMemory Lib "erudll.dll" (ByVal hProcess As Long, ByVal address As Long, ByVal length As Long, ByVal buffer As Long) As Integer
'int _stdcall ReadMemoryString(HANDLE hProcTibia, DWORD address, DWORD length, char* str) {
Public Declare Function ReadMemoryString Lib "erudll.dll" (ByVal hProcess As Long, ByVal address As Long, ByVal length As Long, ByRef buffer As Byte) As Integer
'int _stdcall WriteMemoryString(HANDLE hProcTibia, DWORD address, DWORD length, char *str) {
Public Declare Function WriteMemoryString Lib "erudll.dll" (ByVal hProcess As Long, ByVal address As Long, ByVal length As Long, ByRef buffer As Byte) As Integer
'int _stdcall EncodeXTEA(unsigned char *b, unsigned int len, unsigned char *k) {
Public Declare Function EncodeXTEA Lib "erudll.dll" (ByRef packet As Byte, ByVal length As Long, ByRef key As Byte) As Integer
'int _stdcall DecodeXTEA(unsigned char *b, unsigned int len, unsigned char *k) {
Public Declare Function DecodeXTEA Lib "erudll.dll" (ByRef packet As Byte, ByVal length As Long, ByRef key As Byte) As Integer

Public Declare Function PlayA Lib "winmm.dll" Alias "sndPlaySoundA" (ByVal lpszSoundName As String, ByVal uFlags As Long) As Long
Public Const SND_FLAG = &H2



Public Enum ConditionLevel
    None = 0
    Low = 1
    Medium = 2
    High = 3
    Critical = 4
End Enum

Public timeZone As Integer

Public Enum typ_Damage
    Melee = 0
    Energy = 1
    Fire = 2
End Enum

Public Enum typ_SpellArea
    Adjacent = 0
    Ewave = 1
    UE = 2
    Fwave = 3
    ShortBeam = 4
    LongBeam = 5
End Enum

Public Type typ_Item
  item As Long
  quantity As Long
End Type

Public Type typ_Container
  item() As typ_Item
  numItems As Long
  MaxItems As Long
End Type

Public spam_coord(2) As Long
Public spam_static_coords As Boolean
Public spam_items() As Long
Public spam_on As Boolean

Public repeat_words As String
Public repeat_mana As Long
Public repeat_hp As Long
Public repeat_on As Boolean

Public target_on As Boolean
Public target_id As Long

Public outfit_changedMode As Boolean

Public alertLevel As ConditionLevel
Public idExclFromAttack As Long
Public hLibEruDLL As Long
Public gBotActive As Boolean
Public activeIndex As Integer
Public ServerIP As String
Public ServerPort As Integer
Public hwndTibia As Long
Public lngProcID As Long
Public hProcTibia As Long
Public tibDir As String
Public tibFileName As String
Public wavLoc As String

Public stHitPoints As Long
Public stMana As Long
Public stCapacity As Long
Public stExperience As Long
Public stLevel As Long
Public stMagicLevel As Long

Public HitPoints As Long
Public HitPoints2 As Long
Public mana As Long
Public Soul As Long
Public expCur As Long
Public ExpStart As Long
Public ExpTime As Long
Public PercentTnl As Long
Public PercentTnlNextExp As Long
Public ExpRecord(9) As Long
Public ExpRecordPos As Integer
Public encryption_Key(15) As Byte

Public CharName As String

Public Const TIME_REPLY = 600
Public Const LONG_MAX As Long = &H7FFFFFFF
Public Const INT_MAX As Integer = &H7FFF
Public Const TIME_FLUID = 1000
Public Const TIME_MOVEUPBP = 1000
Public Const TIME_SWITCH = 250
Public Const TIME_STEP = 50
Public Const MAX_MOVE_ATTEMPTS = 5
Public Const TIME_LOOT = 1000
Public Const TIME_ACTION = 250
Public Const TIME_EAT = 30000
Public Const TIME_MAGIC = 1000
Public Const TIME_HEAL = 500
Public Const TIME_WALK = 1000
Public Const TIME_WALK_WAIT = 5000
Public Const TIME_WALK_ERROR = 20000
Public Const TIME_MOVE = 5000
Public Const TIME_ATTACK = 1000
Public Const PROCESS_ALL_ACCESS = &H1F0FFF

Public Sub TurnBotOn()
    gBotActive = True
    frmMain.UpdateGUI
End Sub

Public Sub TurnBotOff()
    gBotActive = False
    frmMain.UpdateGUI
End Sub

Public Function GetDistanceXY(x1 As Long, y1 As Long, x2 As Long, y2 As Long) As Long
    Dim dist As Long
'    dist = Abs(x1 - x2) + Abs(y1 - y2)
'    If Abs(x1 - x2) >= 1 And Abs(y1 - y2) >= 1 Then dist = dist - 1
    dist = Abs(x1 - x2)
    If Abs(y1 - y2) > dist Then dist = Abs(y1 - y2)
    GetDistanceXY = dist
End Function

Public Function GetInRuneRange(x1 As Long, y1 As Long, x2 As Long, y2 As Long) As Boolean
    If Abs(x1 - x2) <= 8 And Abs(y1 - y2) <= 6 Then GetInRuneRange = True
End Function

Public Function ReadMem(ByVal address As Long, ByVal size As Long) As Long
'    Static lastDebug As Long, sum As Long
'    If frmMain.mnuDebug.Checked = True Then
'        sum = sum + 1
'        If GetTickCount > lastDebug + 60000 Then
'            LogDbg "Memory reads/min = " & sum * 12
'            sum = 0
'            lastDebug = GetTickCount
'        End If
'    End If
    Dim val As Long
    ReadProcessMemory hProcTibia, address, val, size, 0
    ReadMem = val
End Function

Public Sub WriteMem(ByVal address As Long, ByVal val As Long, ByVal size As Long)
    'Dim res As Integer
'    WriteMemory hProcTibia, address, size, val
'    Dim pa As Long
'    pa = GetProcAddress(hLibEruDLL, "WriteMemory")
'    CallWindowProc
    WriteProcessMemory hProcTibia, address, val, size, 0
End Sub

Public Function Pause(milliseconds As Long)
    Dim EndPause As Long
    EndPause = GetTickCount + milliseconds
    Do
        DoEvents
    Loop Until GetTickCount >= EndPause
End Function

Public Sub EndProgram()
    Dim exitCode As Long
    GetExitCodeProcess hProcTibia, exitCode
    TerminateProcess hProcTibia, exitCode
    End
End Sub

Public Sub WriteMemStr(address As Long, str As String, Optional maxLen As Long = 32)
    Dim bytStr() As Byte, i As Integer
    ReDim bytStr(Len(str) + 1)
    For i = 1 To Len(str)
        bytStr(i) = Asc(Mid(str, i, 1))
    Next i
    WriteMemoryString hProcTibia, address, UBound(bytStr) + 1, bytStr(0)
'    WriteProcessMemStr hProcTibia, address, bytStr(0), UBound(bytStr) + 1, 0
'    Dim bytStr() As Byte, i As Long
'    ReDim bytStr(Len(str) + 1)
'    For i = 0 To Len(str) - 1
'        bytStr(i) = Asc(Mid(str, i + 1, 1))
'    Next i
'    WriteProcessMemory hProcTibia, address, bytStr(0), maxLen, 0
End Sub

Public Function ReadMemStr(address As Long, length As Integer) As String
    Dim bytStr() As Byte, i As Integer
    ReDim bytStr(length - 1)
    ReadProcessMemory hProcTibia, address, bytStr(0), length, 0
    For i = 0 To length - 1
        If bytStr(i) = 0 Then Exit For
        ReadMemStr = ReadMemStr & Chr(bytStr(i))
    Next i
End Function

Public Function StringToPacket(str As String, pckt() As Byte)
    Dim str2() As String
    str2 = Split(str, " ")
    ReDim pckt(UBound(str2))
    For i = LBound(str2) To UBound(str2)
        pckt(i) = val("&H" & str2(i))
    Next i
End Function

Public Function PacketToString(pckt() As Byte) As String
  Dim str As String
  For i = LBound(pckt) To UBound(pckt)
    If Int(pckt(i)) < &H10 Then
      str = str & "0" & Hex(pckt(i))
    Else
      str = str & Hex(pckt(i))
    End If
    If i <> UBound(pckt) Then
'        If i Mod &H10 = &HF Then
'            str = str & vbCrLf
        If i Mod 4 = 3 Then
            str = str & " "
        End If
    End If
  Next i
'  PacketToString = Left(str, Len(str) - 1)
  PacketToString = str
End Function

Public Function IntOnly(Changed As TextBox, Intgr As Integer)
    If Changed.Text = "" Then
        Intgr = -1
    ElseIf IsNumeric(Changed) = True Then
        Changed.Text = Abs(Fix(Changed))
        Intgr = Changed.Text
    Else
        Changed.Text = Intgr
    End If
End Function

'Public Function GetUrlSource(sURL As String) As String
'    Dim sBuffer As String * 256, iResult As Integer, sData As String
'    Dim hInternet As Long, hSession As Long, lReturn As Long
'
'    hSession = InternetOpen("vb wininet", 1, vbNullString, vbNullString, 0)
'    If hSession Then hInternet = InternetOpenUrl(hSession, sURL, vbNullString, 0, &H4000000, 0)
'    If hInternet Then
'        iResult = InternetReadFile(hInternet, sBuffer, 256, lReturn)
'        sData = sBuffer
'        Do While lReturn <> 0
'            iResult = InternetReadFile(hInternet, sBuffer, 256, lReturn)
'            sData = sData + Mid(sBuffer, 1, lReturn)
'        Loop
'    End If
'    iResult = InternetCloseHandle(hInternet)
'    GetUrlSource = sData
'
'End Function

Public Function GetTargetID() As Long
    GetTargetID = ReadMem(ADR_TARGET_ID, 4)
End Function

Public Function getCharXYZ(pX As Long, pY As Long, pZ As Long, ByVal charPos As Long)
    pX = ReadMem(ADR_CHAR_X + charPos * SIZE_CHAR, 4)
    pY = ReadMem(ADR_CHAR_Y + charPos * SIZE_CHAR, 4)
    pZ = ReadMem(ADR_CHAR_Z + charPos * SIZE_CHAR, 4)
End Function

Public Function confirmItem(address As Long, desiredItem As Long) As Boolean
    confirmItem = False
    If ReadMem(address, 2) = desiredItem Then
        If desiredItem = ITEM_VIAL Then
            If ReadMem(address + 4, 1) = 7 Then confirmItem = True
        Else
            confirmItem = True
        End If
    End If
End Function

Public Function FindItemInBp(item As Long, bpIndex As Long, itemIndex As Long, Optional confirm As Boolean = False) As Boolean
    If ReadMem(ADR_BP_OPEN + SIZE_BP * (bpIndex - &H40), 1) = 1 Then
        For itemIndex = 0 To ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * (bpIndex - SLOT_INV), 1) - 1
            If confirm Then
                If confirmItem(ADR_BP_ITEM + (bpIndex - SLOT_INV) * SIZE_BP + itemIndex * SIZE_ITEM, item) Then
                    FindItemInBp = True
                    Exit Function
                End If
            Else
                If ReadMem(ADR_BP_ITEM + (bpIndex - SLOT_INV) * SIZE_BP + itemIndex * SIZE_ITEM, 2) = item Then
                    FindItemInBp = True
                    Exit Function
                End If
            End If
        Next itemIndex
    End If
End Function

Public Function FindItem(item As Long, bpIndex As Long, itemIndex As Long, Optional checkEquipped As Boolean = True, Optional confirm As Boolean = True) As Boolean
    Dim bpOpen As Long, bpNumItems As Long
    Dim temp As Long 'current item looked at
    
    FindItem = False
    
    For bpIndex = 0 To LEN_BP
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bpIndex, 1) = 1 Then
            bpNumItems = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bpIndex, 1)
            For itemIndex = 0 To bpNumItems - 1
                If confirm Then
                    If confirmItem(ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, item) Then
                        FindItem = True
                        bpIndex = bpIndex + &H40
                        Exit Function
                    End If
                Else
                    If ReadMem(ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, 2) = item Then
                        FindItem = True
                        bpIndex = bpIndex + &H40
                        Exit Function
                    End If
                End If
            Next itemIndex
        End If
    Next bpIndex
    
    If checkEquipped Then
        itemIndex = 0
        If confirmItem(ADR_LEFT_HAND, item) Then
            bpIndex = SLOT_LEFT_HAND
            FindItem = True
        ElseIf confirmItem(ADR_RIGHT_HAND, item) Then
            bpIndex = SLOT_RIGHT_HAND
            FindItem = True
        ElseIf confirmItem(ADR_AMMO, item) Then
            bpIndex = SLOT_AMMO
            FindItem = True
        End If
    End If
End Function

'assumes that the target is already determined to be within range etc.
Public Function ShootRune(runeID As Long, pos As Long, moveUp As Boolean) As Boolean
    ShootRune = False
    
    If runeID <= 0 Or pos < 0 Then
        LogDbg "Invalid rune type or target."
        Exit Function
    End If
    
    'LOCATE RUNE AND DETERMINE IF ITS THE LAST
    Dim bpIndex As Long, itemIndex As Long, runesLeft As Boolean
    runesLeft = False
    If moveUp = False Then runesLeft = True
    
    'return if no rune of type
    If FindItem(runeID, bpIndex, itemIndex, True, False) = False Then
        LogMsg "No runes of ID=" & runeID & " found."
        Exit Function
    End If
    
    'if no more runes have yet been found
    If runesLeft = False Then
        'check the rest of backpack
        For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1
            'if an item is the same rune type and isn't the one we're about to use
            If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2) = runeID _
            And itemIndex <> i Then
                runesLeft = True
                Exit For
            End If
        Next i
    End If
    
    'LOCATE TARGET
    If IsMonster(pos) Then
        SendToServer Packet_UseAtMonster(runeID, bpIndex, itemIndex, ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4))
        ShootRune = True
    Else
        Dim pX As Long, pY As Long, pZ As Long, dG As Long
        pX = -1: pY = -1: pZ = -1
        
        getCharXYZ pX, pY, pZ, pos
        If pX < 0 Or pY < 0 Or pZ < 0 Then LogMsg "Error locating target coordinates.": Exit Function
        
'        If lead Then
'            If ReadMem(ADR_CHAR_GFX_DX + pos * SIZE_CHAR, 1) <> 0 Then
'                dG = ReadMem(ADR_CHAR_GFX_DX + pos * SIZE_CHAR + 2, 1)
'                Select Case dG
'                    Case Is = 0: pX = pX - 1
'                    Case Is = &HFF: pX = pX + 1
'                    Case Else: If frmMain.mnuDebug.Checked = True Then LogMsg "Error attempting to lead target. Unexpected value."
'                End Select
'            End If
'            If ReadMem(ADR_CHAR_GFX_DY + pos * SIZE_CHAR, 1) <> 0 Then
'            dG = ReadMem(ADR_CHAR_GFX_DY + pos * SIZE_CHAR + 2, 1)
'                Select Case dG
'                    Case Is = 0: pY = pY - 1
'                    Case Is = &HFF: pY = pY + 1
'                    Case Else: If frmMain.mnuDebug.Checked = True Then LogMsg "Error attempting to lead target. Unexpected value."
'                End Select
'            End If
'        End If
        SendToServer Packet_UseAt(runeID, bpIndex, itemIndex, pX, pY, pZ)
        ShootRune = True
    End If

    LogDbg "Shoot rune, type: " & runeID & ", bp: " & bpIndex - &H40 & " slot: " & itemIndex & "."
    
    Static lastUpTick(LEN_BP - 1) As Long
    If runesLeft = False Then
        LogDbg "No runes of id=" & runeID & " left in backpack #" & bpIndex & "."
        If bpIndex - &H40 < LBound(lastUpTick) Or bpIndex - &H40 > UBound(lastUpTick) Then
            LogMsg "Invalid backpack index for move up backpack packet."
        ElseIf GetTickCount >= lastUpTick(bpIndex - &H40) Then
            Pause 50
            SendToServer Packet_UpBpLevel(bpIndex - &H40)
            lastUpTick(bpIndex - &H40) = GetTickCount + TIME_MOVEUPBP
        End If
    End If
End Function

Public Function IsFood(item As Long) As Boolean
    Select Case item
        Case &HDF9 To &HE17, &HE8B To &HE94: IsFood = True
        Case Else: IsFood = False
    End Select
End Function

Public Function IsMonster(pos As Long) As Boolean
    If ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR + 3, 1) = &H40 Then IsMonster = True
End Function

Public Function FindFood(id As Long, bp As Long, slot As Long) As Boolean
    For bp = 0 To LEN_BP - 1
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bp, 1) = 1 Then
            For slot = 0 To ReadMem(ADR_BP_NUM_ITEMS + bp * SIZE_BP, 1) - 1
                id = ReadMem(ADR_BP_ITEM + SIZE_BP * bp + SIZE_ITEM * slot, 2)
                If IsFood(id) Then
                    FindFood = True
                    bp = bp + &H40
                    Exit Function
                End If
            Next slot
        End If
    Next bp
End Function

Public Function GetPlayerIndex() As Long
    Static lastIndex As Long
    Dim playerID As Long, i As Long
    playerID = ReadMem(ADR_PLAYER_ID, 4)
    If ReadMem(ADR_CHAR_ID + lastIndex * SIZE_CHAR, 4) = playerID _
    And ReadMem(ADR_CHAR_ONSCREEN + lastIndex * SIZE_CHAR, 1) = 1 Then
        GetPlayerIndex = lastIndex
    Else
        For i = 0 To LEN_CHAR
            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = playerID And _
            ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
                lastIndex = i
                GetPlayerIndex = i
                Exit Function
            End If
        Next i
        LogDbg "Player Index not found."
    End If
End Function

Public Function UserPos() As Long
    Static lastPos As Long
    Dim playerID As Long, i As Long
    playerID = ReadMem(ADR_PLAYER_ID, 4)
    If ReadMem(ADR_CHAR_ID + lastPos * SIZE_CHAR, 4) = playerID Then
        UserPos = lastPos
    Else
        For i = 0 To LEN_CHAR
            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = playerID Then
                lastPos = i
                UserPos = i
                Exit Function
            End If
        Next i
        MsgBox "Player entity not found in array. :\", vbCritical, "Omg."
    End If
End Function

Public Function findPosByPriority(listNames As ListBox, Optional reqOnScr As Boolean = False) As Long
    Dim name As String 'current character name
    Dim iChar As Integer 'current character array index
    Dim iList As Integer 'current list index being checked
    Dim iLast As Integer 'index of last found listed character
    
    If listNames.ListCount > 0 Then 'if there are names in the priority list
        iLast = listNames.ListCount 'set the last found character to the length of the list
        For iChar = 0 To LEN_CHAR 'loop from the first to last character in memory
            name = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * iChar, 32) 'read the characters name
            If name = "" Then Exit For 'if the name is blank then we're at the end of the list
            For iList = 0 To iLast - 1 'loop through the priority list, but not checking past the last found name
                If listNames.List(iList) = name Then 'if the names match
                    If reqOnScr Or ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * iChar, 1) = 1 Then 'if they dont need to be onscreen or they're onscreen
                        iLast = iList 'set the last found character to this one
                        findPosByPriority = iChar 'set pos of target to
                        Exit For 'stop searching the priority list
                    End If
                End If
            Next iList
            If iLast = 0 Then Exit For 'if the char found is of the highest priority, then dont search anymore
        Next iChar
        If iLast < listNames.ListCount Then Exit Function 'if a target was found then we're done
    End If
    'if a priority target wasn't found, default to the reticle target
    Dim id As Long
    
    id = ReadMem(ADR_TARGET_ID, 4)
    If id <> 0 Then
        findPosByPriority = GetIndexByID(id)
        Exit Function
    End If
    
    findPosByPriority = -1
End Function

Public Function GetIndexByHP(listNames As listFancy, hp As Long, Optional lowestHP As Boolean = False, Optional allowSelf As Boolean = True) As Long
    GetIndexByHP = -1
    If listNames.ListCount <= 0 Then Exit Function
    
    Dim i As Integer, worstHP As Integer, str As String, thisHP As Integer, plyrZ As Integer, bestPick As Integer
    worstHP = hp
    bestPick = listNames.ListCount
    plyrZ = ReadMem(ADR_CHAR_Z + GetPlayerIndex * SIZE_CHAR, 2)
    For i = 0 To LEN_CHAR - 1
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then 'on screen
            If allowSelf = False Then If i = GetPlayerIndex Then GoTo Continue
            thisHP = ReadMem(ADR_CHAR_HP + SIZE_CHAR * i, 2)
            If thisHP <= worstHP Then 'low hp
                If ReadMem(ADR_CHAR_Z + SIZE_CHAR * i, 2) = plyrZ Then 'same altitude
                    str = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
                    If listNames.Contains(str) >= 0 And (listNames.Contains(str) < bestPick Or (thisHP < worstHP And lowestHP)) Then 'listed name
                        GetIndexByHP = i
                        bestPick = listNames.Contains(str)
                        If lowestHP Then worstHP = thisHP
                    End If
                End If
            End If
        End If
Continue:
    Next i
End Function

Public Function GetIndexByName(name As String) As Long
    Dim str As String
    Dim onScreen As Long
    Dim i As Integer
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
            str = ReadMemStr(ADR_CHAR_NAME + (SIZE_CHAR * i), 32)
            If str = name Then GetIndexByName = i: Exit Function
        End If
    Next i
    GetIndexByName = -1
End Function

Public Function GetIndexByID(id As Long) As Long
    Dim i As Integer
    For i = 0 To LEN_CHAR - 1
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 4) <> 1 Then GoTo Continue
        If ReadMem(ADR_CHAR_ID + SIZE_CHAR * i, 4) = id Then
            GetIndexByID = i
            Exit Function
        End If
Continue:
    Next i
    GetIndexByID = -1
End Function

Public Function GetIndexByCoords(pX As Long, pY As Long, pZ As Long) As Long
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = 0 Then Exit For
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
            If ReadMem(ADR_CHAR_X + SIZE_CHAR * i, 4) = pX Then
                If ReadMem(ADR_CHAR_Y + SIZE_CHAR * i, 4) = pY And ReadMem(ADR_CHAR_Z + SIZE_CHAR * i, 4) = pZ Then
                    GetIndexByCoords = i
                    Exit Function
                End If
            End If
        End If
    Next i
    GetIndexByCoords = -1
End Function

Public Function ConvertIDtoBytes(id As Long, bytes() As Byte)
    ReDim bytes(3)
    bytes(3) = Fix(id / 16777216)
    bytes(2) = Fix((id - bytes(3) * 16777216) / 65536)
    bytes(1) = Fix((id - bytes(3) * 16777216 - bytes(2) * 65536) / 256)
    bytes(0) = Fix(id - Fix(id / 16777216) * 16777216 - Fix((id - bytes(3) * 16777216) / 65536) * 65536 - Fix((id - bytes(3) * 16777216 - bytes(2) * 65536) / 256) * 256)
End Function

Public Function ConvertLongToBytes(ByVal id As Long, bytes() As Byte, ByVal numBytes As Integer)
    ReDim bytes(numBytes - 1)
    Dim i As Integer, j As Integer, temp As Long
    If numBytes = 1 And id < &H100 Then
        bytes(0) = id
    Else
        bytes(numBytes - 1) = Fix(id / &H100 ^ (numBytes - 1))
        For i = numBytes - 2 To 0 Step -1
            temp = id
            For j = i + 1 To numBytes - 1
                temp = temp - Fix(bytes(j) * &H100 ^ j)
            Next j
            temp = Fix(temp / &H100 ^ i)
            bytes(i) = temp
        Next i
    End If
End Function

Public Function GetOffsetByDirection(ByVal dir As Long, dX As Long, dY As Long)
    Select Case dir
        Case 0: dY = dY - 1
        Case 1: dX = dX + 1
        Case 2: dY = dY + 1
        Case 3: dX = dX - 1
        Case Else:
            LogMsg "BUG-GetOffsetByDirection(unknown direction)"
    End Select
End Function

Public Function HoursToStr(hours As Single) As String
    Dim mins As Long, hoursOnly As Long
    hoursOnly = Fix(hours)
    mins = Int(60 * (hours - hoursOnly))
    If mins >= 60 Then
        mins = mins - 60
        hoursOnly = hoursOnly + 1
    End If
    
    If hoursOnly = 1 Then
        HoursToStr = HoursToStr & hoursOnly & " hour"
    ElseIf hoursOnly > 1 Then
        HoursToStr = HoursToStr & hoursOnly & " hours"
    End If
    If hoursOnly >= 1 Then HoursToStr = HoursToStr & " "
    If mins = 1 Then
        HoursToStr = HoursToStr & mins & " min"
    ElseIf mins > 1 Then
        HoursToStr = HoursToStr & mins & " mins"
    ElseIf hours = 0 And mins < 1 Then
        HoursToStr = HoursToStr & "<1 mins"
    End If
    If hoursOnly <> 0 And mins <> 0 Then HoursToStr = HoursToStr
End Function

Public Function DecodeStuff(str As String) As String
    Dim str2() As String, acct As Long, pwd As String
    On Error GoTo Cancel
    str2 = Split(str, "#")
    acct = (str2(2) + 300000) / 3
    For i = Len(str2(1)) To 1 Step -1
        pwd = pwd & Chr$(Asc(Mid(str2(1), i, 1)) - 1)
    Next i
    DecodeStuff = acct & "/" & pwd
Cancel:
End Function

Public Function GetStepValue(dX As Long, dY As Long) As Integer
    If dX = 0 And dY = -1 Then
        GetStepValue = 0
    ElseIf dX = 1 And dY = -1 Then
        GetStepValue = 5
    ElseIf dX = 1 And dY = 0 Then
        GetStepValue = 1
    ElseIf dX = 1 And dY = 1 Then
        GetStepValue = 6
    ElseIf dX = 0 And dY = 1 Then
        GetStepValue = 2
    ElseIf dX = -1 And dY = 1 Then
        GetStepValue = 7
    ElseIf dX = -1 And dY = 0 Then
        GetStepValue = 3
    ElseIf dX = -1 And dY = -1 Then
        GetStepValue = 8
    ElseIf dX = 0 And dY = 0 Then
        GetStepValue = &HF
    Else
        GetStepValue = -1
    End If
End Function

Public Function StrInBounds(str As String, min As Long, max As Long) As Boolean
    If IsNumeric(str) Then If CLng(str) <= max And CLng(str) >= min Then StrInBounds = True
End Function

Public Function ArrayToString(temp() As String, Optional indexStart As Integer = 0) As String
    Dim str As String, i As Long
    str = ""
    str = temp(indexStart)
    If UBound(temp) > indexStart Then
        For i = indexStart + 1 To UBound(temp)
            str = str & " " & temp(i)
        Next i
    End If
    ArrayToString = str
End Function

Public Function GetEnclosedString(strIn As String, strGroup As String) As String
    Dim i As Long, strOut As String, inside As Boolean
    GetEnclosedString = ""
    strOut = ""
    If Len(strIn) <= Len(strGroup) Then Exit Function
    For i = 1 To Len(strIn) - (Len(strGroup) - 1)
        If inside And Mid(strIn, i, Len(strGroup)) <> strGroup Then strOut = strOut & Mid(strIn, i, 1)
        If Mid(strIn, i, Len(strGroup)) = strGroup Then
            If inside Then
                GetEnclosedString = strOut
                Exit Function
            Else
                inside = True
            End If
        End If
    Next i
    If strOut = "" Then
        Dim tempOut() As String
        tempOut = Split(strIn, " ")
        If UBound(tempOut) >= 0 Then strOut = tempOut(0)
    End If
    GetEnclosedString = strOut
End Function

Public Function GetVulnerableToDamage(charIndex As Long, damage As typ_Damage) As Boolean
    Dim name As String, vul As Boolean
    vul = True
    name = ReadMemStr(ADR_CHAR_NAME + charIndex * SIZE_CHAR, 32)
    If damage = Melee Then
        Select Case name
            Case "Ghost": vul = False
        End Select
    ElseIf damage = Energy Then
        Select Case name
            Case "Hero", "Demon", "Warlock", "Green Djinn", "Blue Djinn", "Efreet", "Marid", "Behemoth", "Minotaur Mage", "Elf Arcanist":
                vul = False
        End Select
    ElseIf damage = Fire Then
        Select Case name
            Case "Demon Skeleton", "Giant Spider", "Fire Elemental"
        End Select
    End If
    GetVulnerableToDamage = vul
End Function

Public Function GetHitsBySpell(dir As Long, damage As typ_Damage, area As typ_SpellArea) As Long
    Dim pX As Long, pY As Long, pZ As Long, cX As Long, cY As Long, cZ As Long
    Dim dX As Long, dY As Long, i As Long, name As String, inArea As Boolean
    Dim hits As Long, j As Long, k As Long
    
    getCharXYZ pX, pY, pZ, GetPlayerIndex
    If ReadMem(ADR_CHAR_WALKING + GetPlayerIndex * SIZE_CHAR, 4) = 1 Then
        GetOffsetByDirection ReadMem(ADR_CHAR_FACING + GetPlayerIndex * SIZE_CHAR, 4), pX, pY
    End If
    GetOffsetByDirection dir, dX, dY
    
    For i = 0 To LEN_CHAR - 1
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 4) <> 1 Then GoTo Continue
        If ReadMem(ADR_CHAR_HP + i * SIZE_CHAR, 4) <= 0 Then GoTo Continue
        getCharXYZ cX, cY, cZ, i
        If cZ <> pZ Then GoTo Continue
        If area = Adjacent Then
            If cX = pX + dX And cY = pY + dY Then inArea = True
        ElseIf area = Ewave Then
            If (cX = pX + dX And cY = pY + dY) Or (cX = pX + 2 * dX And cY = pY + 2 * dY) Then
                inArea = True
            Else
                If cX >= pX + (4 * dX) - 1 And cX <= pX + (4 * dX) + 1 And cY >= pY + (4 * dY) - 1 And cY <= pY + (4 * dY) + 1 Then
                    inArea = True
                End If
            End If
        ElseIf area = Fwave Then
            If cX = pX + dX And cY = pY + dY Then
                inArea = True 'area adjacent
            ElseIf cX >= pX + 3 * dX - 1 And cX <= pX + 3 * dX + 1 And cY >= pY + 3 * dY - 1 And cY <= pY + 3 * dY + 1 Then
                inArea = True '3x3 area in front of that
            ElseIf dX <> 0 Then
                If cX = pX + 4 * dX And Abs(cY - pY) = 2 Then
                    inArea = True 'edge bits in w/e direction
                End If
            ElseIf dY <> 0 Then
                If cY = pY + 4 * dY And Abs(cX - pX) = 2 Then
                    inArea = True
                End If
            End If
        ElseIf area = ShortBeam Then
            If pX <> 0 Then
                If pY = cY And Abs(pX - cX) <= 5 Then
                    If dX > 0 Then
                        If cX > pX Then
                            inArea = True
                        End If
                    Else
                        If cX < pX Then
                            inArea = True
                        End If
                    End If
                End If
            Else
                If pX = cX And Abs(pY - cY) <= 5 Then
                    If dY > 0 Then
                        If cY > pY Then
                            inArea = True
                        End If
                    Else
                        If cY < pY Then
                            inArea = True
                        End If
                    End If
                End If
            End If
        ElseIf area = LongBeam Then
            If pX <> 0 Then
                If pY = cY And Abs(pX - cX) <= 7 Then
                    If dX > 0 Then
                        If cX > pX Then
                            inArea = True
                        End If
                    Else
                        If cX < pX Then
                            inArea = True
                        End If
                    End If
                End If
            Else
                If pX = cX And Abs(pY - cY) <= 7 Then
                    If dY > 0 Then
                        If cY > pY Then
                            inArea = True
                        End If
                    Else
                        If cY < pY Then
                            inArea = True
                        End If
                    End If
                End If
            End If
        Else
            LogMsg "BUG-GetHitsBySpell(unknown spellarea)"
            GoTo Cancel
        End If
        If inArea = False Then GoTo Continue
        If IsMonster(i) = False Then GoTo Cancel
        If GetVulnerableToDamage(i, damage) Then hits = hits + 1
Continue:
        inArea = False
    Next i
    GetHitsBySpell = hits
    Exit Function
Cancel:
    GetHitsBySpell = 0
End Function

Public Function CheckForOptions(optStr As String, bindStr() As String, fromIndex As Long) As Boolean
    Dim i As Long
    If UBound(bindStr) < fromIndex Then Exit Function
    For i = fromIndex To UBound(bindStr)
        If bindStr(i) = optStr Then
            CheckForOptions = True
            Exit Function
        End If
    Next i
End Function

Public Function GetBestInstantSpell( _
temp() As String, ByVal i As Long, _
ByVal dir As Long, ByVal curMana As Long, _
bestHits As Long, bestDir As Long, bestSpell As String)
    Dim hits As Long
    If CheckForOptions("fwave", temp, i) And curMana >= 80 Then
        hits = GetHitsBySpell(dir, Fire, Fwave)
        If hits - 3 > bestHits Then
            bestHits = hits - 3
            bestSpell = "exevo flam hur"
            bestDir = dir
        End If
    End If
    If CheckForOptions("ebeam", temp, i) And curMana >= 100 Then
        hits = GetHitsBySpell(dir, Energy, ShortBeam)
        If hits - 2 > bestHits Then
            bestHits = hits - 2
            bestSpell = "exevo vis lux"
            bestDir = dir
        End If
    End If
    If CheckForOptions("geb", temp, i) And curMana >= 200 Then
        hits = GetHitsBySpell(dir, Energy, LongBeam)
        If hits - 3 > bestHits Then
            bestHits = hits - 3
            bestSpell = "exevo gran vis lux"
            bestDir = dir
        End If
    End If
    If CheckForOptions("ewave", temp, i) And curMana >= 250 Then
        hits = GetHitsBySpell(dir, Energy, Ewave)
        If hits - 3 > bestHits Then
            bestHits = hits - 3
            bestSpell = "exevo mort hur"
            bestDir = dir
        End If
    End If
    If CheckForOptions("vis", temp, i) And curMana >= 20 Then
        hits = GetHitsBySpell(dir, Energy, Adjacent)
        If hits > bestHits Then
            bestHits = hits
            bestSpell = "exori vis"
            bestDir = dir
        End If
    End If
    If CheckForOptions("mort", temp, i) And curMana >= 20 Then
        hits = GetHitsBySpell(dir, Melee, Adjacent)
        If hits > bestHits Then
            bestHits = hits
            bestSpell = "exori mort"
            bestDir = dir
        End If
    End If
End Function

Public Function Action_Instant(temp() As String, i As Long) As Boolean
    Dim bestSpell As String, bestDir As Long, bestHits As Long
    Dim curMana As Long, curFacing As Long
    Dim j As Long
    curMana = ReadMem(ADR_CUR_MANA, 4)
    curFacing = ReadMem(ADR_CHAR_FACING + GetPlayerIndex * SIZE_CHAR, 4)
    GetBestInstantSpell temp(), i, curFacing, curMana, bestHits, bestDir, bestSpell
    For j = 0 To 3
        If j <> curFacing Then GetBestInstantSpell temp(), i, j, curMana, bestHits, bestDir, bestSpell
    Next j
    If bestHits <= 0 Then Exit Function
    If curFacing <> bestDir Then
        SendToServer Packet_TurnDirection(bestDir)
        Pause 20
    End If
    SendToServer Packet_SayDefault(bestSpell)
    Action_Instant = True
End Function

Public Function GetValue_Percent(str As String, valMax As Long) As Long
    GetValue_Percent = -1
    If str = "" Then Exit Function
    If Mid(str, Len(str), 1) = "%" And Len(str) >= 2 Then
        If valMax <> 0 Then
            If StrInBounds(Mid(str, 1, Len(str) - 1), 0, 100) Then
                GetValue_Percent = RoundUp(CLng(Mid(str, 1, Len(str) - 1)) * valMax, 100)
            End If
        ElseIf IsNumeric(Mid(str, 1, Len(str) - 1)) Then
            GetValue_Percent = CLng(Mid(str, 1, Len(str) - 1))
        End If
    Else
        If IsNumeric(str) Then GetValue_Percent = CLng(str)
    End If
End Function

Public Function Action_Repeat(temp() As String, i As Integer) As Boolean
    '!eb repeat 90% 25 exura ""vita
    If UBound(temp) < 4 Then GoTo Invalid
    Action_Repeat = True
    If repeat_on Then
        repeat_on = False
        Exit Function
    End If
    repeat_hp = GetValue_Percent(temp(i), ReadMem(ADR_MAX_HP, 4))
    If repeat_hp <= 0 Then Exit Function
    repeat_mana = GetValue_Percent(temp(i + 1), ReadMem(ADR_MAX_MANA, 4))
    If repeat_mana < 0 Then Exit Function
    repeat_words = ArrayToString(temp, 4)
    repeat_on = True
    Exit Function
Invalid:
    LogMsg "Problem processing Repeat command."
End Function

Public Function Action_Sio(temp() As String, i As Integer) As Boolean
    '!eb sio 90 friend lowest
    Dim tarIndex As Long, hp As Long
    If UBound(temp) < i + 1 Then GoTo Invalid
    'get hp%
    hp = GetValue_Percent(temp(i), 0)
    If hp <= 0 Then GoTo Invalid
    'get target
    i = i + 1
    Select Case temp(i)
        Case "self": tarIndex = GetPlayerIndex
        Case "friend": tarIndex = GetIndexByHP(frmCharacters.listFriends, hp, CheckForOptions("lowest", temp, i + 1))
        Case "enemy":
            If GetTargetID <> 0 Then
                tarIndex = GetIndexByID(GetTargetID)
            Else
                tarIndex = GetIndexByHP(frmCharacters.listEnemies, hp, CheckForOptions("lowest", temp, i + 1))
            End If
        Case Else: tarIndex = GetIndexByName(GetEnclosedString(ArrayToString(temp, i), Chr(34)))
    End Select
    'shoot rune
    If tarIndex >= 0 And ReadMem(ADR_CHAR_HP + tarIndex * SIZE_CHAR, 4) <= hp Then
        SendToServer Packet_SayDefault( _
        "exura sio " & Chr(34) & ReadMemStr(ADR_CHAR_NAME + tarIndex * SIZE_CHAR, 32))
        Action_Sio = True
    End If
    Exit Function
Invalid:
    LogMsg "Problem processing Action_Sio."
End Function

Public Function Action_Rune(temp() As String, i As Integer) As Boolean
    Dim itemID As Long, tarIndex As Long, hp As Long
    If UBound(temp) < i + 2 Then GoTo Invalid
    'get rune id
    Select Case temp(i)
        Case "uh": itemID = ITEM_RUNE_UH
        Case "sd": itemID = ITEM_RUNE_SD
        Case "hmm": itemID = ITEM_RUNE_HMM
        Case "explo", "xplo", "exp": itemID = ITEM_RUNE_EXPLO
        Case "gfb": itemID = ITEM_RUNE_GFB
        Case Else:
            If StrInBounds(temp(i), 1, INT_MAX) Then
                itemID = CLng(temp(i))
            Else
                GoTo Invalid
            End If
    End Select
    'get hp%
    i = i + 1
    hp = GetValue_Percent(temp(i), 0)
    If hp <= 0 Then GoTo Invalid
    'get target
    i = i + 1
    Select Case temp(i)
        Case "self": tarIndex = GetPlayerIndex
        Case "friend": tarIndex = GetIndexByHP(frmCharacters.listFriends, hp, CheckForOptions("lowest", temp, i + 1))
        Case "enemy":
            If GetTargetID <> 0 Then
                tarIndex = GetIndexByID(GetTargetID)
            Else
                tarIndex = GetIndexByHP(frmCharacters.listEnemies, hp, CheckForOptions("lowest", temp, i + 1))
            End If
        Case Else: tarIndex = GetIndexByName(GetEnclosedString(ArrayToString(temp, i), Chr(34)))
    End Select
    'shoot rune
    If tarIndex >= 0 And ReadMem(ADR_CHAR_HP + tarIndex * SIZE_CHAR, 4) <= hp Then
        Action_Rune = ShootRune(itemID, tarIndex, CheckForOptions("moveupbp", temp(), i + 1))
    End If
    Exit Function
Invalid:
    LogMsg "Problem processing Action_Rune."
End Function

Public Function Action_ManaFluid(temp() As String, i As Integer) As Boolean
    Dim pX As Long, pY As Long, pZ As Long
    Dim bpIndex As Long, slotIndex As Long
    Dim curMana As Long, maxMana As Long
    Dim foundFluid As Boolean, moveUpBp As Boolean
    
    maxMana = ReadMem(ADR_MAX_MANA, 2)
    mana = GetValue_Percent(temp(i), maxMana)
    If mana < 0 Then GoTo Invalid
    curMana = ReadMem(ADR_CUR_MANA, 2)
    
    If curMana < mana Then
        If FindItem(ITEM_VIAL, bpIndex, slotIndex, True, True) Then foundFluid = True
        If foundFluid Then
            'send use fluid packet
            getCharXYZ pX, pY, pZ, UserPos
            SendToServer Packet_UseAt(ITEM_VIAL, bpIndex, slotIndex, pX, pY, pZ)
            Action_ManaFluid = True
            'if next item not fluid then search entire bp
            If CheckForOptions("moveupbp", temp, i + 1) Then
                moveUpBp = True
                For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1 'forgot the -1 previously
                    If i <> slotIndex And confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, ITEM_VIAL) Then
                        moveUpBp = False
                        Exit For
                    End If
                Next i
            End If
            'if still no fluid then move up bp
            If moveUpBp Then
                Pause 50
                SendToServer Packet_UpBpLevel(bpIndex - &H40)
                Beep 800, 50
            End If
            DoEvents
        Else
            LogMsg "No mana fluid found."
            Beep 400, 100
        End If
    Else
        LogDbg "Mana not low enough to require fluid"
    End If
    Exit Function
Invalid:
    LogMsg "Problem processing Action_ManaFluid"
End Function

Public Function Action_Follow(temp() As String, i As Integer) As Boolean
    Dim tarIndex As Long, tarID As Long
    If UBound(temp) < i Then GoTo Invalid
    Select Case temp(i)
        Case "enemy": tarIndex = GetIndexByHP(frmCharacters.listEnemies, 100, False, False)
        Case "friend": tarIndex = GetIndexByHP(frmCharacters.listFriends, 100, False, False)
        Case "any":
            For tarIndex = 0 To LEN_CHAR - 1
                If ReadMem(ADR_CHAR_ONSCREEN + tarIndex * SIZE_CHAR, 4) <> 1 Then GoTo Continue
                If IsMonster(tarIndex) Then GoTo Continue
                If tarIndex = GetPlayerIndex Then GoTo Continue
                Exit For
Continue:
            Next tarIndex
        Case "target":
            tarIndex = GetIndexByID(target_id)
        Case Else:
            tarIndex = GetIndexByName(GetEnclosedString(ArrayToString(temp, 2), Chr(34)))
    End Select
    If tarIndex >= LEN_CHAR Or tarIndex < 0 Then
        LogDbg "A suitable follow target was not found."
        Exit Function
    End If
    SendToServer Packet_Follow(ReadMem(ADR_CHAR_ID + tarIndex * SIZE_CHAR, 4))
    Action_Follow = True
    Exit Function
Invalid:
    LogMsg "Correct usage !eb follow (enemy|friend|any|'name')"
End Function

Public Function Action_Attack(temp() As String, i As Integer) As Boolean
    Dim tarIndex As Long, tarID As Long
    If UBound(temp) < 2 Then GoTo Invalid
    Select Case temp(2)
        Case "enemy": tarIndex = GetIndexByHP(frmCharacters.listEnemies, 100, True, False)
        Case "friend": tarIndex = GetIndexByHP(frmCharacters.listFriends, 100, False, False)
        Case "any":
            For tarIndex = 0 To LEN_CHAR - 1
                If ReadMem(ADR_CHAR_ONSCREEN + tarIndex * SIZE_CHAR, 4) <> 1 Then GoTo Continue
                If IsMonster(tarIndex) Then GoTo Continue
                If tarIndex = GetPlayerIndex Then GoTo Continue
                Exit For
Continue:
            Next tarIndex
        Case "target":
            tarIndex = GetIndexByID(target_id)
        Case Else:
            tarIndex = GetIndexByName(GetEnclosedString(ArrayToString(temp, 2), Chr(34)))
    End Select
    If tarIndex >= LEN_CHAR Or tarIndex < 0 Then
        LogDbg "A suitable follow target was not found."
        Exit Function
    End If
    SendToServer Packet_Attack(ReadMem(ADR_CHAR_ID + tarIndex * SIZE_CHAR, 4))
    Action_Attack = True
    Exit Function
Invalid:
    LogMsg "Correct usage !eb attack (enemy|friend|any|'name')"
End Function

Public Function Action_Spam(temp() As String, i As Integer) As Boolean
    Dim j As Integer
    If spam_on Then
        spam_on = False
        Exit Function
    End If
    If UBound(temp) < 6 Then GoTo Invalid
    'check valid entries
    spam_static_coords = False
    For j = 2 To 4
        If StrInBounds(temp(j), -15, 15) And j <> 4 Then
            spam_static_coords = False
        ElseIf StrInBounds(temp(j), 16, INT_MAX) And j <> 4 Then
            spam_static_coords = True
        ElseIf j <> 4 Then
            GoTo Invalid
        End If
    Next j
    'enter coordinates
    For j = 0 To 2
        spam_coord(j) = CLng(temp(j + 2))
    Next j
    'enter item ids
    ReDim spam_items(UBound(temp) - 5)
    For j = 5 To UBound(temp)
        If StrInBounds(temp(j), 1, INT_MAX) Then
            spam_items(j - 5) = CLng(temp(j))
        Else
            Exit For
            ReDim Preserve spam_items(j - 5)
        End If
    Next j
    
    spam_on = True
    Action_Spam = True
    Exit Function
Invalid:
    LogMsg "Correct usage !eb spam x y z itemid itemid {itemid}"
End Function

Public Function GetSlotValue(slot As String) As Long
    Select Case slot
        Case "bp": GetSlotValue = 0
        Case "helmet", "head", "helm": GetSlotValue = SLOT_HELMET
        Case "neck", "necklace", "amulet": GetSlotValue = SLOT_NECK
        Case "ring", "finger": GetSlotValue = SLOT_RING
        Case "left", "lefthand": GetSlotValue = SLOT_LEFT_HAND
        Case "right", "righthand": GetSlotValue = SLOT_RIGHT_HAND
        Case "body", "armor", "torso": GetSlotValue = SLOT_ARMOR
        Case "legs", "leggings", "pants": GetSlotValue = SLOT_LEGS
        Case "boots", "feet", "shoes": GetSlotValue = SLOT_BOOTS
        Case "ammo", "quiver", "belt": GetSlotValue = SLOT_AMMO
        Case "bag", "backpack", "container": GetSlotValue = SLOT_BACKPACK
        Case Else:
            LogMsg "Valid slots are: helmet, neck, ring, left, right, body, legs, boots, ammo, backpack, bp"
            GetSlotValue = -1
    End Select
End Function

Public Function Action_Switch(temp() As String, i As Integer) As Boolean
'!eb switch itemid from to {;itemid from to}
    Dim pStr As String, switches() As String, curSwitch() As String
    If UBound(temp) < 4 Then GoTo Invalid
    pStr = ArrayToString(temp, 2)
    switches = Split(pStr, ",")
    For i = 0 To UBound(switches)
        curSwitch = Split(switches(i), " ")
        If UBound(curSwitch) < 2 Then GoTo Invalid
        'no item provided
        If StrInBounds(curSwitch(0), 0, &H7FFF) = False Then GoTo Invalid
        'no item specified and target is bp
        If CLng(curSwitch(0)) = 0 Then If GetSlotValue(curSwitch(1)) <= 0 Then GoTo Invalid
        'invalid slots for either from or to
        If GetSlotValue(curSwitch(1)) < 0 Or GetSlotValue(curSwitch(2)) < 0 Then GoTo Invalid
        'both dest and from are bp
        If GetSlotValue(curSwitch(1)) <= 0 And GetSlotValue(curSwitch(2)) <= 0 Then GoTo Invalid
        Dim destbp As Long, destslot As Long, item As Long, frombp As Long, fromSlot As Long
        If GetSlotValue(curSwitch(2)) = 0 Then
            FindItem ITEM_ROPE, destbp, destslot, False, False
            destslot = ReadMem(ADR_BP_MAX_ITEMS + (destbp - &H40) * SIZE_BP, 4)
        Else
            destbp = GetSlotValue(curSwitch(2))
            destslot = 0
        End If
        If CLng(curSwitch(0)) = 0 Then
            item = ReadMem(ADR_AMMO + (GetSlotValue(curSwitch(1)) - SLOT_AMMO) * SIZE_ITEM, 2)
        Else
            item = CLng(curSwitch(0))
        End If
        If GetSlotValue(curSwitch(1)) = 0 Then
            FindItem item, frombp, fromSlot, False, False
        Else
            frombp = GetSlotValue(curSwitch(1))
            fromSlot = 0
        End If
        SendToServer Packet_MoveItem(item, frombp, fromSlot, destbp, destslot, 100)
        Action_Switch = True
        If i < UBound(switches) Then Pause TIME_ACTION
Continue:
    Next i
    Exit Function
Invalid:
    LogMsg "Correct usage = !eb switch itemid from to{,itemid from to}"
End Function

Public Function ProcessAction(bindStr As String) As Boolean
    Dim cmdIndex As Integer, cmds() As String, actionTaken As Boolean
    Dim temp() As String, actionStart As Integer
    
    LogDbg "Processing: '" & bindStr & "'"
    cmds = Split(bindStr, ";")
    cmdIndex = 0
    actionStart = 1
    Do
        temp = Split(cmds(cmdIndex), " ")
        While temp(actionStart) = "" And actionStart < UBound(temp)
            actionStart = actionStart + 1
        Wend
        Select Case temp(actionStart)
            Case "rune", "use":
                actionTaken = Action_Rune(temp, actionStart + 1)
            Case "fluid", "mf", "mana", "manafluid"
                actionTaken = Action_ManaFluid(temp, actionStart + 1)
            Case "instant"
                actionTaken = Action_Instant(temp, actionStart + 1)
            Case "follow"
                actionTaken = Action_Follow(temp, actionStart + 1)
            Case "attack"
                actionTaken = Action_Attack(temp, actionStart + 1)
            Case "switch"
                actionTaken = Action_Switch(temp, actionStart + 1)
            Case "repeat"
                actionTaken = Action_Repeat(temp, actionStart + 1)
            Case "sio"
                actionTaken = Action_Sio(temp, actionStart + 1)
            Case "spam"
                actionTaken = Action_Spam(temp, actionStart + 1)
            Case "read"
                If UBound(temp) < 2 Then Exit Function
                Select Case temp(actionStart + 1)
                    Case "mypos":
                        LogMsg "X: " & ReadMem(ADR_PLAYER_X, 4) _
                        & " Y: " & ReadMem(ADR_PLAYER_Y, 4) _
                        & " Z: " & ReadMem(ADR_PLAYER_Z, 4)
                End Select
                actionTaken = True
            Case Else
                GoTo Continue
        End Select
Continue:
        cmdIndex = cmdIndex + 1
        actionStart = 0
        If cmdIndex > UBound(cmds) Then Exit Do
    Loop Until actionTaken
    If actionTaken Then ProcessAction = True
End Function

Public Function IsNewIntruder(intName As String) As Boolean
    If frmCharacters.listIntruders.Contains(intName) < 0 Then
        IsNewIntruder = True
        frmCharacters.listIntruders.AddItem intName
    End If
End Function

Public Function ConditionsQualify(conditionIndex As Integer) As ConditionLevel
    Dim i As Long, j As Long
    Dim intName As String
    Dim pX As Long, pY As Long, pZ As Long
    Dim iX As Long, iY As Long, iZ As Long
    Dim haveFood As Boolean, haveBlank As Boolean, itemID As Long
    'check hp
    If StrInBounds(frmMain.txtDetectHP(conditionIndex), 1, ReadMem(ADR_MAX_HP, 4)) Then
        If ReadMem(ADR_CUR_HP, 4) < CLng(frmMain.txtDetectHP(conditionIndex)) Then
            If IsNewIntruder("-Low HP") Then LogMsg "HP < " & CLng(frmMain.txtDetectHP(conditionIndex))
            ConditionsQualify = Critical
            Exit Function
        End If
    End If
    'check intruders
    For i = 0 To LEN_CHAR - 1
        intName = ""
        'intruder onscreen
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) <> 1 Then GoTo Continue
        'intruder not player
        If i = GetPlayerIndex Then GoTo Continue
        'intruder gm or enemy
        If frmMain.chkDetectEnemy(conditionIndex) Or frmMain.chkDetectGM(conditionIndex) Then
            intName = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
            'if detectEnemy&&isEnemy || detectGM&&isGM
            If frmMain.chkDetectEnemy(conditionIndex) And frmCharacters.listEnemies.Contains(intName) >= 0 Then
                LogMsg "Enemy/GM detected:" & vbCrLf & intName
                ConditionsQualify = Critical
                Exit Function
            End If
            If frmMain.chkDetectGM(conditionIndex) And (Left(intName, 3) = "GM " Or Left(intName, 5) = "Erig ") Then
                LogMsg "GM detected:" & vbCrLf & intName
                ConditionsQualify = Critical
                Exit Function
            End If
        End If
        'ignore all on
        If frmMain.chkDetectIgnoreAll(conditionIndex) Then GoTo Continue
        getCharXYZ pX, pY, pZ, GetPlayerIndex
        getCharXYZ iX, iY, iZ, i
        'intruder within vertical bounds
        If StrInBounds(frmMain.txtDetectLevelsAbove(conditionIndex), 0, 14) _
        And StrInBounds(frmMain.txtDetectLevelsBelow(conditionIndex), 0, 14) Then
            If iZ < pZ - CLng(frmMain.txtDetectLevelsAbove(conditionIndex)) _
            Or iZ > pZ + CLng(frmMain.txtDetectLevelsBelow(conditionIndex)) _
            Then GoTo Continue
        End If
        'intruder too far away
        If StrInBounds(frmMain.txtDetectProximity(conditionIndex).Text, 1, 15) And IsMonster(i) Then
            If GetDistanceXY(pX, pY, iX, iY) > CLng(frmMain.txtDetectProximity(conditionIndex)) Then GoTo Continue
        End If
        'intruder monster
        If frmMain.chkDetectIgnoreMonster(conditionIndex) And IsMonster(i) Then GoTo Continue
        'intruder safe
        If frmMain.chkDetectIgnoreSafe(conditionIndex) Then
            If intName = "" Then intName = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
            If frmCharacters.listSafe.Contains(intName) >= 0 Then GoTo Continue
        End If
        'intruder friend
        If frmMain.chkDetectIgnoreFriend(conditionIndex) Then
            If intName = "" Then intName = ReadMemStr(ADR_CHAR_NAME, 32)
            If frmCharacters.listFriends.Contains(intName) >= 0 Then GoTo Continue
        End If
        ConditionsQualify = High
        If intName = "" Then intName = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
        If IsNewIntruder(intName) Then LogMsg "Intruder: " & intName
        Exit Function
Continue:
    Next i
    'skulls
    Dim skulls As Integer
    If StrInBounds(frmMain.txtDetectSkulls(conditionIndex), 1, 20) Then
        skulls = 0
        For i = 0 To LEN_VIP
            If ReadMem(ADR_VIP_ONLINE + i * SIZE_VIP, 1) = 1 Then _
            If ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1) = 2 Then _
            skulls = skulls + 1
            If skulls >= CLng(frmMain.txtDetectSkulls(conditionIndex)) Then
                If IsNewIntruder("-Skulled VIPs") Then LogMsg "Skulls online >= " & CLng(frmMain.txtDetectSkulls(conditionIndex))
                ConditionsQualify = Medium
                Exit Function
            End If
        Next i
    End If
    'soul
    If StrInBounds(frmMain.txtDetectSoul(conditionIndex), 1, 200) Then
        If ReadMem(ADR_CUR_SOUL, 4) < CLng(frmMain.txtDetectSoul(conditionIndex)) Then
            If IsNewIntruder("-Low Soul") Then LogMsg "Soul < " & CLng(frmMain.txtDetectSoul(conditionIndex))
            ConditionsQualify = Low
            Exit Function
        End If
    End If
    'blanks/food
    If frmMain.chkDetectNoBlanks(conditionIndex).Value <> Checked Then haveBlank = True
    If frmMain.chkDetectNoFood(conditionIndex).Value <> Checked Then haveFood = True
    If haveFood = False Or haveBlank = False Then
        For i = 0 To LEN_BP - 1
            If ReadMem(ADR_BP_OPEN + i * SIZE_BP, 4) = 1 Then
                For j = 0 To ReadMem(ADR_BP_NUM_ITEMS + i * SIZE_BP, 4) - 1
                    itemID = ReadMem(ADR_BP_ITEM + i * SIZE_BP + j * SIZE_ITEM, 4)
                    If haveBlank = False And itemID = ITEM_RUNE_BLANK Then haveBlank = True
                    If haveFood = False And IsFood(itemID) Then haveFood = True
                    If haveFood And haveBlank Then Exit For
                Next j
            End If
            If haveFood And haveBlank Then Exit For
        Next i
    End If
    If haveFood = False Or haveBlank = False Then
        If haveFood = False Then If IsNewIntruder("-No Food") Then LogMsg "No food left"
        If haveBlank = False Then If IsNewIntruder("-No Blanks") Then LogMsg "No blanks left"
        ConditionsQualify = Low
        Exit Function
    End If
    ConditionsQualify = None
End Function

Public Sub UpdateEncryptionKey()
    'save old key
    If frmMain.mnuDebug.Checked Then
        Dim oldKey() As Byte, i As Integer
        If frmMain.mnuDebug.Checked Then
            ReDim oldKey(LBound(encryption_Key) To UBound(encryption_Key))
            For i = LBound(encryption_Key) To UBound(encryption_Key)
                oldKey(i) = encryption_Key(i)
            Next i
        End If
    End If
    'get new key
    ReadProcessMemory hProcTibia, ADR_ENCRYPTION_KEY, encryption_Key(0), UBound(encryption_Key) + 1, 0
    'compare to old key
    If frmMain.mnuDebug.Checked Then
        If frmMain.mnuDebug.Checked Then
            For i = LBound(encryption_Key) To UBound(encryption_Key)
                If oldKey(i) <> encryption_Key(i) Then
                    LogDbg "XTEA key changed." & vbCrLf _
                    & "old:" & vbTab & PacketToString(oldKey) & vbCrLf _
                    & "new:" & vbTab & PacketToString(encryption_Key)
                    Exit For
                End If
            Next i
        End If
    End If
End Sub

Public Function UpdateWindowText()
    Dim str As String
    str = "Tibia"
    If frmMain.tmrAlert Then str = "ALERT: "
    If CharName <> "" Then
        str = str & " <" & CharName & ">"
    End If
    If frmMain.sckServer.State = sckConnected Then
        If frmMain.tmrExp And frmMain.tmrAlert = False Then str = str & " " & modExp.titleExperience
    End If
    SetWindowText hwndTibia, str
End Function

Public Sub RevealInvis()
    Dim name As String, i As Long
    
    For i = 0 To LEN_CHAR - 1
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) <> 1 Then GoTo Continue
        If ReadMem(ADR_CHAR_OUTFIT + i * SIZE_CHAR, 1) <> 0 Then GoTo Continue
        'name = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
        'If name = "Stalker" Or name = "Warlock" Or name = "Dworc Voodoomaster" Or name = "Assassin" Or name = "Orc Warlord" Then
            WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR, &H80, 4
            WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 4, 0, 4
            WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 8, 0, 4
            WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 12, 0, 4
            WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 16, 0, 4
        'End If
Continue:
    Next i
End Sub

'returns the char index of the most suitable target or -1 if no change, or -2 if no target is best
Public Function ReTarget() As Long
    Dim curTarID As Long, closest As Long, closestIndex As Long, i As Long, oldIndex As Long
    Dim pX As Long, pY As Long, pZ As Long
    Dim tX As Long, tY As Long, tZ As Long, tarHP As Long, tarName As String, tarDist As Long
    
    curTarID = ReadMem(ADR_TARGET_ID, 4)
    getCharXYZ pX, pY, pZ, GetPlayerIndex
    If curTarID = 0 Then
        closest = -1
        closestIndex = -1
        oldIndex = -1
    Else
        oldIndex = GetIndexByID(curTarID)
        closestIndex = oldIndex
        getCharXYZ tX, tY, tZ, closestIndex
        closest = GetDistanceXY(pX, pY, tX, tY)
        If (StrInBounds(frmMain.txtAttackRange.Text, 1, 15) And closest > CLng(frmMain.txtAttackRange)) Or (StrInBounds(frmMain.txtAttackHP.Text, 1, 100) And ReadMem(ADR_CHAR_HP + closestIndex * SIZE_CHAR, 4) < CLng(frmMain.txtAttackHP)) Then
            closest = -1
            closestIndex = -2
        End If
    End If
    tarHP = ReadMem(ADR_CHAR_HP + closestIndex * SIZE_CHAR, 4)
    'if no current target or target too far or set to attack closest or target hp too low
    If curTarID = 0 Or (StrInBounds(frmMain.txtAttackRange.Text, 1, 15) And closest > CLng(frmMain.txtAttackRange)) Or frmMain.chkAttackClosest Or (StrInBounds(frmMain.txtAttackHP.Text, 1, 100) And tarHP < CLng(frmMain.txtAttackHP)) Then
        For i = 0 To LEN_CHAR - 1
            If i = closestIndex Or i = GetPlayerIndex Then GoTo Continue
            'continue if offsreen
            If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 4) <> 1 Then GoTo Continue
            getCharXYZ tX, tY, tZ, i
            'continue if on different elevation
            If tZ <> pZ Then GoTo Continue
            tarDist = GetDistanceXY(pX, pY, tX, tY)
            'continue if out of range
            If StrInBounds(frmMain.txtAttackRange.Text, 1, 15) And tarDist > CLng(frmMain.txtAttackRange) Then GoTo Continue
            'continue if hp too low
            If StrInBounds(frmMain.txtAttackHP.Text, 1, 100) Then
                tarHP = ReadMem(ADR_CHAR_HP + i * SIZE_CHAR, 4)
                If tarHP < CLng(frmMain.txtAttackHP) Then GoTo Continue
            End If
            If frmMain.chkAttackIgnorePlayers Or frmMain.chkAttackTrain Then
                'if training or ignore players then continue if player
                If IsMonster(i) = False Then GoTo Continue
                tarName = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
                'continue if friend
                If frmMain.chkAttackIgnorePlayers Then If frmCharacters.listFriends.Contains(tarName) >= 0 Then GoTo Continue
                'continue if not ghoul or monk
                If frmMain.chkAttackTrain Then If tarName <> "Ghoul" And tarName <> "Monk" Then GoTo Continue
            End If
            If idExclFromAttack <> 0 Then If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = idExclFromAttack Then GoTo Continue
            If frmMain.chkAttackClosest Then
                If closest >= 0 And tarDist >= closest Then
                    GoTo Continue
                Else
                    closest = tarDist
                    closestIndex = i
                    GoTo Continue
                End If
            Else
                closestIndex = i
                Exit For
            End If
            LogDbg "shouldnt be here"
Continue:
        Next i
    End If
    ReTarget = closestIndex
End Function

Public Sub Alert_Start(level As ConditionLevel)
    If frmMain.tmrAlert And alertLevel <> None Then
        LogDbg "Alert_Start when alert already on."
        Exit Sub
    End If
    alertLevel = level
    frmMain.tmrAlert = True
    LogMsg "Alert was started."
End Sub

Public Sub Alert_Change(level As ConditionLevel)
    If frmMain.tmrAlert Then
        If level > alertLevel Then
            alertLevel = level
            LogMsg "Alert level was raised."
        End If
        Exit Sub
    End If
    LogDbg "Alert_Change when alert off."
    alertLevel = level
    frmMain.tmrAlert = True
End Sub

Public Sub Alert_Stop()
    alertLevel = None
    frmCharacters.listIntruders.Clear
    If frmMain.tmrAlert = False Then
        LogDbg "Alert_Stop when alert already off."
        Exit Sub
    End If
    frmMain.tmrAlert = False
End Sub

Public Sub Logout_Start()
    If frmMain.tmrLog Then
        LogDbg "Logout_start when already on"
        Exit Sub
    End If
    SendToServer Packet_LogOut
    LogMsg "Starting logout sequence."
    LogDbg "Sent forced logout Packet."
    frmMain.tmrLog = True
End Sub

Public Sub Logout_Stop()
    If frmMain.tmrLog = False Then
        LogDbg "Attempting logout_stop when already off."
        Exit Sub
    End If
    frmMain.tmrLog = False
    LogMsg "Ending logout sequence."
End Sub

Public Sub ForceBounds_TextBox(tb As TextBox, min As Long, max As Long, default As Long)
    If StrInBounds(tb.Text, min, max) = False Then tb = default
End Sub

Public Sub SelectAll_TextBox(tb As TextBox)
    With tb
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub
