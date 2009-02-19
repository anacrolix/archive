Attribute VB_Name = "modPwnBomb"
Public Const MAX_BOMBCHARS = 100
Public Const LEN_XTEA_KEY = 16

Private Type typ_bomb_char
    name As String
    rsa() As Byte
    xtea() As Byte
    serverReplied As Boolean
    serverFirstReplyTick As Long
    nextRuneTick As Long
    sentLogin As Boolean
    copiedOutfit As Boolean
End Type

Public bombing As Boolean
Public bombStartTick As Long
Public hProcClient As Long
Public hwndTibia As Long
Public bombIniPath As String
Public loginIniPath As String
Public datainipath As String
Public bombChars(MAX_BOMBCHARS - 1) As typ_bomb_char
Public bombCharCount As Long

Public Sub Main()
    bombIniPath = App.Path & "\bomb.ini"
    loginIniPath = App.Path & "\login.ini"
    GetClientProcessHandle
    frmMain.Show
End Sub

Public Sub LoadBombChars()
    Debug.Print "Loading characters."
    Dim strName As Long, strChars() As String, charIndex As Long
    bombCharCount = 0
    strChars = Split(ReadFromINI(bombIniPath, "bomb settings", "bomb chars"), ";")
    While bombCharCount < MAX_BOMBCHARS And charIndex <= UBound(strChars)
        'check name
        With bombChars(bombCharCount)
            .name = Trim(strChars(charIndex))
            If Len(.name) > 32 Or .name = "" Then
                MsgBox .name, vbCritical, "Invalid character name"
                GoTo NextBombChar
            End If
            If CheckIfIniKeyExists(loginIniPath, .name, "rsa login packet") = False _
                Or CheckIfIniKeyExists(loginIniPath, .name, "xtea key") = False _
                Then GoTo NextBombChar
            .rsa = HexStringToByteArray(ReadFromINI(loginIniPath, .name, "rsa login packet"))
            If (Not .rsa) = -1& Then
                MsgBox "Invalid RSA login packet provided for " & .name & ".", vbCritical, "Invalid login packet"
                GoTo NextBombChar
            End If
            .xtea = HexStringToByteArray(ReadFromINI(loginIniPath, .name, "xtea key"))
            If (Not .xtea) = -1& Then
                If UBound(.xtea) <> LEN_XTEA_KEY - 1 Then
                    MsgBox "Invalid XTEA key provided for " & .name & ".", vbCritical, "Invalid XTEA key"
                    GoTo NextBombChar
                End If
            End If
            .serverReplied = False
            .serverFirstReplyTick = 0
            .nextRuneTick = 0
            .sentLogin = False
        Debug.Print "Loaded " & .name
        End With
        bombCharCount = bombCharCount + 1
NextBombChar:
    charIndex = charIndex + 1
    Wend
End Sub

Public Sub GetClientProcessHandle()
    Const MAX_CLIENTS = 20
    Dim hDesktop As Long, hTemp As Long, strWindowText As String * 6
    Dim strClassName As String * 12
    Dim windowCount As Integer, hTibia(MAX_CLIENTS - 1) As Long
    Dim hChild As Long
    'close any preexisting handles
    If hProcClient <> 0 Then CloseHandle hProcClient
    'get highest id tibia client
    hDesktop = GetDesktopWindow()
    hTemp = GetWindow(hDesktop, 5)
    Do While hTemp <> 0
        GetWindowText hTemp, strWindowText, Len(strWindowText)
        GetClassName hTemp, strClassName, Len(strClassName)
        If strWindowText = "Tibia" & vbNullChar _
            And strClassName = "TibiaClient" & vbNullChar _
        Then
            hTibia(windowCount) = hTemp
            windowCount = windowCount + 1
        End If
        hTemp = GetWindow(hTemp, 2)
    Loop
'    If windowCount = 0 Then GoTo NoClient
    If windowCount = 0 Then Exit Sub
    hwndTibia = hTibia(windowCount - 1)
    'get process handle to this client
    Dim pid As Long
    GetWindowThreadProcessId hwndTibia, pid
    hProcClient = OpenProcess(PROCESS_ALL_ACCESS, False, pid)
    Exit Sub
NoClient:
    MsgBox "No client found, exiting...", vbCritical, "Error"
    End
End Sub

Public Sub StopBombing()
    If bombing Then Debug.Print "Stopped bombing."
    bombing = False
    Dim i As Integer
    'close all sockets
    For i = frmMain.sckChar.LBound To frmMain.sckChar.UBound
        frmMain.sckChar(i).Close
    Next i
    'wait for sockets to close
    For i = frmMain.sckChar.LBound To frmMain.sckChar.UBound
        While frmMain.sckChar(i).State <> sckClosed
'            DoEvents
        Wend
    Next i
End Sub

Public Sub StartBombing()
    Debug.Print "Started bombing."
    Dim i As Long
    'check for bomb chars
    If bombCharCount < 1 Then
        MsgBox "No bomb characters loaded."
        Exit Sub
    End If
    'check for server ip
    If CheckIfIniKeyExists(bombIniPath, "bomb settings", "server ip") = False _
        Or CheckIfIniKeyExists(bombIniPath, "bomb settings", "server port") = False _
    Then
        MsgBox "No server specified.", vbCritical, "No server"
        Exit Sub
    End If
    'connect to server
    For i = 0 To bombCharCount - 1
        BombSock_Connect i
    Next i
    bombing = True
    bombStartTick = GetTickCount
End Sub

Public Sub UpdateClientCharName()
    Dim charName As String
    UpdateCharMem
    If GetPlayerIndex < 0 Or ReadMem(ADR_GAME_STATUS) <> GAME_STATUS_CONNECTED Then
        charName = "Not logged in!"
    Else
        charName = TrimCStr(charMem.char(GetPlayerIndex).name)
    End If
    SetClientCharName charName
End Sub

Public Sub SetClientCharName(str As String)
    frmMain.lblClientCharName = str
End Sub

Public Sub BombSock_SendRaw(charIndex As Long, buff() As Byte)
    Debug.Assert charIndex >= 0 And charIndex < bombCharCount
    Debug.Assert frmMain.sckChar(charIndex).State = sckConnected
    frmMain.sckChar(charIndex).SendData buff
End Sub

Public Sub BombSock_SendXtea(charIndex As Long, buff() As Byte)
    Debug.Assert (UBound(buff) - 1) Mod 8 = 0
    Debug.Assert UBound(bombChars(charIndex).xtea) + 1 = LEN_XTEA_KEY
    EncipherXteaPacket buff(0), UBound(buff) + 1, bombChars(charIndex).xtea(0)
    Debug.Assert frmMain.sckChar(charIndex).State = sckConnected
    frmMain.sckChar(charIndex).SendData buff
End Sub

Public Sub BombSock_Connect(charIndex As Long)
    Debug.Print bombChars(charIndex).name & " connecting"
    frmMain.sckChar(charIndex).Connect ReadFromINI(bombIniPath, "bomb settings", "server ip"), ReadFromINI(bombIniPath, "bomb settings", "server port")
    With bombChars(charIndex)
        .sentLogin = False
        .serverReplied = False
        .serverFirstReplyTick = 0
        .nextRuneTick = 0
        .copiedOutfit = False
    End With
End Sub

Public Function isBombCharName(name As String) As Boolean
    Dim i As Long
    For i = 0 To bombCharCount - 1
        If name = bombChars(i).name Then Exit For
    Next i
    If i < bombCharCount Then isBombCharName = True
End Function

'gets number of mages that can hit a given character
Public Function bombCharsInRange(charIndex As Long) As Long
    Debug.Assert charIndex >= 0 And charIndex < LEN_CHAR
    UpdateCharMem
    Dim i As Long, ret As Long
    ret = 0
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> CHAR_ONSCREEN Then GoTo NextI
            If isBombCharName(TrimCStr(.name)) = False Then GoTo NextI
            If Abs(.x - charMem.char(charIndex).x) > 7 Then GoTo NextI
            If Abs(.y - charMem.char(charIndex).y) > 5 Then GoTo NextI
            If .z <> charMem.char(charIndex).z Then GoTo NextI
            ret = ret + 1
        End With
NextI:
    Next i
    bombCharsInRange = ret
End Function

Public Function getIdOfBestTarget(c As Long) As Long
    Dim ret As Long, i As Long, bestInRange As Long, bestIndex As Long, isPriorityTarget As Boolean
    bestIndex = LEN_CHAR: bestInRange = 0
    UpdateCharMem
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> CHAR_ONSCREEN Then GoTo NextI
            If i = GetPlayerIndex Then GoTo NextI
            If isBombCharName(TrimCStr(.name)) Or i = c Then GoTo NextI
            If c >= 0 Then
                If Abs(charMem.char(c).x - .x) > 7 Then GoTo NextI
                If Abs(charMem.char(c).y - .y) > 5 Then GoTo NextI
                If charMem.char(c).z <> .z Then GoTo NextI
            End If
            If NameInList(bombIniPath, "bomb settings", "safe list", TrimCStr(.name)) Then GoTo NextI
            Dim inRange As Long
            inRange = bombCharsInRange(i)
            If NameInList(bombIniPath, "bomb settings", "targets", TrimCStr(.name)) Then
                If isPriorityTarget Then
                    If inRange > bestInRange Then
                        bestInRange = inRange
                        bestIndex = i
                    ElseIf inRange = bestInRange And bestIndex < LEN_CHAR Then
                        If .speed > charMem.char(bestIndex).speed Then
                            bestIndex = i
                        End If
                    End If
                ElseIf inRange > 0 Then
                    bestInRange = inRange
                    bestIndex = i
                    isPriorityTarget = True
                End If
            ElseIf isPriorityTarget = False And frmMain.chkKillNonPriorityTargets Then
                If inRange > bestInRange Then
                    bestInRange = inRange
                    bestIndex = i
                ElseIf inRange = bestInRange And bestIndex < LEN_CHAR Then
                    If .speed > charMem.char(bestIndex).speed Then
                        bestIndex = i
                    End If
                End If
            End If
        End With
NextI:
    Next i
    If bestIndex < LEN_CHAR Then
        ret = charMem.char(bestIndex).id
    Else
        ret = -1
    End If
    getIdOfBestTarget = ret
End Function

Public Sub DoBombing()
    If bombing = False Then GoTo Cancel
    If bombCharCount < 1 Then
        MsgBox "No bomb characters specified.", vbCritical
        GoTo Cancel
    End If
    On Error GoTo Cancel
    Dim i As Long
    For i = 0 To bombCharCount - 1
        With bombChars(i)
            If frmMain.sckChar(i).State = sckConnected Then
                If .sentLogin And .serverReplied Then
                    If GetTickCount >= .nextRuneTick Then
                        UpdateCharMem
                        Dim id As Long
                        If frmMain.optSayTarget Then
                            id = getIdOfBestTarget(GetChar_ByName(.name))
                            If id <> -1 Then
                                Debug.Print .name & " doing primary action @ " & GetTickCount - bombStartTick
                                BombSock_SendXtea i, Packet_SayDefault(TrimCStr(charMem.char(GetChar_ById(id)).name))
                                .nextRuneTick = GetTickCount + 3000
                            End If
                        ElseIf frmMain.optShootRune Then
                            id = getIdOfBestTarget(GetChar_ByName(.name))
                            If id <> -1 Then
                                Debug.Print .name & " shooting rune at " & TrimCStr(charMem.char(GetChar_ById(id)).name) & " @ " & GetTickCount - bombStartTick
                                Dim rune As Long
                                If frmMain.optHMM Then
                                    rune = ITEM_RUNE_HMM
                                ElseIf frmMain.optLMM Then
                                    rune = ITEM_RUNE_LMM
                                ElseIf frmMain.optSD Then
                                    rune = ITEM_RUNE_SD
                                End If
                                BombSock_SendXtea i, Packet_UseAt(rune, 0, id)
                                .nextRuneTick = GetTickCount + 1000
                            End If
                        ElseIf frmMain.optSpam And frmMain.txtSpamee <> "" And frmMain.txtSpamMsg <> "" Then
                            BombSock_SendXtea i, Packet_PrivateMessage(frmMain.txtSpamee, frmMain.txtSpamMsg)
                            .nextRuneTick = GetTickCount + 3000
                        ElseIf frmMain.optBestCase Then
                            BombSock_SendXtea i, Packet_SayDefault("exori")
                            .nextRuneTick = GetTickCount + 1000
                        End If
'                        Static hiCount As Long
'                        Dim msg As String
'                        msg = "hunted!"
''                        msg = String(&HF0, "x")
'                        BombSock_SendXtea i, Packet_PrivateMessage("Raamboxx", msg)
'                        .nextRuneTick = GetTickCount + 3500
'                        hiCount = hiCount + 1
                    End If
                    If .copiedOutfit = False And GetPlayerIndex >= 0 And frmMain.chkCopySummonerColors Then
                        Dim outfit(5) As Long, j As Long
                        ReadProcessMemory hProcClient, ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR, outfit(0), Len(outfit(0)) * 6, 0
                        UpdateCharMem
                        j = GetChar_ByName(.name)
                        If j >= 0 Then
                            outfit(0) = charMem.char(j).outfit
                            outfit(5) = 0
                            BombSock_SendXtea i, Packet_ChangeOutfitEx(outfit)
                            .copiedOutfit = True
                        End If
                    End If
                ElseIf .sentLogin = False Then
                    Debug.Print .name & " sending login packet @ " & GetTickCount - bombStartTick
                    BombSock_SendRaw i, .rsa
                    .sentLogin = True
                End If
            ElseIf frmMain.sckChar(i).State = sckClosed Then
                BombSock_Connect i
            ElseIf frmMain.sckChar(i).State = sckClosing Then
                frmMain.sckChar(i).Close
            End If
        End With
'        DoEvents
    Next i
'    For i = 0 To bombCharCount - 1
'        With bombChars(i)
'            If bombChars(i).serverReplied = False Then
'                Exit Sub
'            End If
'        End With
'    Next i
'    Debug.Print GetTickCount
'    StopBombing
'    Debug.Print GetTickCount
'    LoadBombChars
'    Debug.Print GetTickCount
'    StartBombing
'    Debug.Print GetTickCount
    Exit Sub
Cancel:
    StopBombing
End Sub
