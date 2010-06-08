VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "PwnBot"
   ClientHeight    =   4425
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   2985
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4425
   ScaleWidth      =   2985
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdCharSpySettings 
      Caption         =   "Settings"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   28
      Top             =   4080
      Width           =   975
   End
   Begin VB.CheckBox chkCharSpy 
      Caption         =   "Char Spy"
      Height          =   255
      Left            =   1200
      TabIndex        =   27
      Top             =   4080
      Width           =   1695
   End
   Begin VB.Timer tmrHotkey 
      Interval        =   5
      Left            =   4080
      Top             =   3360
   End
   Begin VB.Timer tmrValues 
      Interval        =   1
      Left            =   3480
      Top             =   3360
   End
   Begin VB.CommandButton cmdLogAsap 
      Caption         =   "LOG ME"
      Height          =   255
      Left            =   2160
      TabIndex        =   24
      Top             =   3720
      Width           =   735
   End
   Begin VB.CommandButton cmdLogOutSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   23
      Top             =   3720
      Width           =   975
   End
   Begin VB.CheckBox chkLogOut 
      Caption         =   "Log Out"
      Height          =   255
      Left            =   1200
      TabIndex        =   22
      Top             =   3720
      Width           =   1455
   End
   Begin VB.CommandButton cmdReadItemValue 
      Caption         =   "Ammo Slot Item Value"
      Height          =   495
      Left            =   1920
      TabIndex        =   10
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton cmdXRay 
      Caption         =   "XRay"
      Height          =   375
      Left            =   2280
      TabIndex        =   21
      Top             =   840
      Width           =   615
   End
   Begin VB.CheckBox chkStepper 
      Caption         =   "Stepper"
      Height          =   255
      Left            =   1200
      TabIndex        =   20
      Top             =   3360
      Width           =   1335
   End
   Begin VB.CommandButton cmdStepperSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   3360
      Width           =   975
   End
   Begin VB.CommandButton cmdSpellSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   3000
      Width           =   975
   End
   Begin VB.CheckBox chkSpells 
      Caption         =   "Spells/Runes"
      Height          =   255
      Left            =   1200
      TabIndex        =   17
      Top             =   3000
      Width           =   1575
   End
   Begin VB.CheckBox chkEat 
      Caption         =   "Eat"
      Height          =   255
      Left            =   1200
      TabIndex        =   16
      Top             =   2640
      Width           =   1335
   End
   Begin VB.CommandButton cmdEatSettings 
      Caption         =   "Settings"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   2640
      Width           =   975
   End
   Begin VB.CommandButton cmdAutoAttackSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2280
      Width           =   975
   End
   Begin VB.CheckBox chkAutoAttack 
      Caption         =   "Auto Attack"
      Height          =   255
      Left            =   1200
      TabIndex        =   13
      Top             =   2280
      Width           =   1575
   End
   Begin VB.CheckBox chkAlert 
      Caption         =   "Alert"
      Height          =   255
      Left            =   1200
      TabIndex        =   12
      Top             =   1920
      Width           =   1095
   End
   Begin VB.CommandButton cmdAlertSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1920
      Width           =   975
   End
   Begin VB.CommandButton cmdLootSettings 
      Caption         =   "Settings"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   975
   End
   Begin VB.CheckBox chkLoot 
      Caption         =   "Loot"
      Height          =   255
      Left            =   1200
      TabIndex        =   8
      Top             =   1560
      Width           =   1575
   End
   Begin VB.CommandButton cmdWarBotSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1200
      Width           =   975
   End
   Begin VB.CheckBox chkWarBot 
      Caption         =   "War Bot"
      Height          =   255
      Left            =   1200
      TabIndex        =   6
      Top             =   1200
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.CommandButton cmdExperienceSettings 
      Caption         =   "Settings"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   975
   End
   Begin VB.CheckBox chkExperience 
      Caption         =   "Exp/Hr"
      Height          =   255
      Left            =   1200
      TabIndex        =   4
      Top             =   840
      Value           =   1  'Checked
      Width           =   1455
   End
   Begin VB.CommandButton cmdVisualSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   975
   End
   Begin VB.CheckBox chkAdjustVisuals 
      Caption         =   "Adjust Visuals"
      Height          =   255
      Left            =   1200
      TabIndex        =   2
      Top             =   480
      Value           =   1  'Checked
      Width           =   1335
   End
   Begin VB.Timer tmrAction 
      Interval        =   50
      Left            =   2400
      Top             =   1800
   End
   Begin VB.CommandButton cmdRecordPacketSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   975
   End
   Begin VB.CheckBox chkRecordPackets 
      Caption         =   "Record Packets"
      Height          =   255
      Left            =   1200
      TabIndex        =   0
      Top             =   120
      Width           =   1575
   End
   Begin MSComDlg.CommonDialog cdlgClient 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "exe"
      DialogTitle     =   "Find Tibia client"
      FileName        =   "Tibia.exe"
      Filter          =   "*.exe"
      InitDir         =   "App.Path"
   End
   Begin MSWinsockLib.Winsock sckLoginListener 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckGameClient 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckGameServer 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckGameListener 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckLoginClient 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckLoginServer 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label lblADR_GAME_STATUS 
      Caption         =   "Label2"
      Height          =   255
      Left            =   4800
      TabIndex        =   26
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "ADR_GAME_STATUS"
      Height          =   255
      Left            =   3120
      TabIndex        =   25
      Top             =   120
      Width           =   1695
   End
   Begin VB.Line Line1 
      X1              =   3000
      X2              =   3000
      Y1              =   120
      Y2              =   3960
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdPacketSettings_Click()
    frmPacket.Show
End Sub

Private Sub cmdWatchPacketSettings_Click()
    frmPacket.Show
End Sub

Private Sub chkAdjustVisuals_Click()
    modifytibiacode
End Sub

Private Sub cmdAlertSettings_Click()
    frmAlert.Show
End Sub

Private Sub cmdAutoAttackSettings_Click()
    frmAttack.Show
End Sub

Private Sub cmdLogAsap_Click()
    bLogOut = True
End Sub

Private Sub cmdLogOutSettings_Click()
    frmLogOut.Show
End Sub

Private Sub cmdReadItemValue_Click()
    Log FEEDBACK, "Item value: " & ReadMem(ADR_AMMO, 2)
End Sub

Private Sub cmdRecordPacketSettings_Click()
    frmPacket.Show
End Sub

Private Sub cmdSpellSettings_Click()
    frmSpell.Show
End Sub

Private Sub cmdStepperSettings_Click()
    frmStepper.Show
End Sub

Private Sub cmdVisualSettings_Click()
    frmVisuals.Show
End Sub

Private Sub cmdWarBotSettings_Click()
    frmWarBot.Show
End Sub

Private Sub cmdXRay_Click()
    If IsGameActive = False Then Exit Sub
    If GetPlayerIndex < 0 Then Exit Sub
    UpdateCharMem 25
    Dim i As Long
    For i = 0 To LEN_TILE_Z - 1
        SeeThrough_Z i, TILE_TRANSPARENT
    Next i
'    SeeThrough_Z charMem.char(GetPlayerIndex).z, TILE_TRANSPARENT
End Sub

Private Sub Form_Resize()
    If Me.WindowState = 1 Then
        frmAlert.Hide
        frmAttack.Hide
        frmLogOut.Hide
        frmPacket.Hide
        frmSpell.Hide
        frmStepper.Hide
        frmVisuals.Hide
        frmWarBot.Hide
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Shutdown
End Sub

Private Sub sckGameClient_Close()
    DisconnectGame
End Sub

Private Sub sckGameClient_DataArrival(ByVal bytesTotal As Long)
    Dim tick As Long
    tick = GetTickCount
    'get the packet
    Dim buff() As Byte, decBuff() As Byte
    sckGameClient.GetData buff
    'decode packet
    decBuff = buff
    DecipherXteaPacket decBuff(0), UBound(decBuff) + 1, xteaKey(0)
    'check for outgoing hotkey commands
    If UBound(decBuff) < 9 Then GoTo DontBlock 'at least 10 bytes for valid packet
    If IsServerReplied Then
        If decBuff(4) = &H96 Then
            Dim extract As String, strStart As Long, strEnd As Long
            Select Case decBuff(5)
                Case 1 'default
                    strStart = 8
                    strEnd = decBuff(6) + decBuff(7) * &H100 + 7
                    For i = strStart To strEnd
                        extract = extract + Chr$(decBuff(i))
                    Next i
                Case 3 'shout
                    GoTo DontBlock
                Case 4 'pm
                    strStart = decBuff(6) + decBuff(7) * &H100 + 10
                    strEnd = decBuff(6) + decBuff(7) * &H100 + decBuff(decBuff(6) + decBuff(7) * &H100 + 8) + 9
                    For i = strStart To strEnd
                        extract = extract + Chr$(decBuff(i))
                    Next i
                Case 5 'trade/gamechat/guildchat
                    strStart = 10
                    strEnd = decBuff(8) + decBuff(9) * &H100 + 9
                    For i = strStart To strEnd
                        extract = extract + Chr$(decBuff(i))
                    Next i
    '            Case Else
    '                MsgBox "sent unknown packet channel " & decBuff(5)
            End Select
            If Left(extract, Len(HOTKEY_PREFIX)) = HOTKEY_PREFIX Then
                DoHotkey Right(extract, Len(extract) - Len(HOTKEY_PREFIX))
                Exit Sub
            End If
        ElseIf decBuff(4) = &H1E And bLogOut Then
            Log FEEDBACK, "Keep alive packet blocked."
            Exit Sub
        ElseIf decBuff(4) = &H84 Or decBuff(4) = &H83 And UBound(decBuff) > 11 Then
            UpdateCharMem
            If charMem.magic < 15 And decBuff(10) = GetByte(0, ITEM_RUNE_SD) And decBuff(11) = GetByte(1, ITEM_RUNE_SD) Then
                decBuff(10) = GetByte(0, ITEM_RUNE_EXPLO)
                decBuff(11) = GetByte(1, ITEM_RUNE_EXPLO)
            End If
            buff = decBuff
            EncipherXteaPacket buff(0), UBound(buff) + 1, xteaKey(0)
        ElseIf (decBuff(4) = &HA1 Or decBuff(4) = &HA2 Or decBuff(4) = &HBE) Then
            Dim new_target_id As Long, tarIndex As Long
            On Error GoTo DontBlock
            If decBuff(4) = &HBE Then
                new_target_id = 0
            Else
                For i = 0 To 3
                    If i = 3 And decBuff(i + 5) > &H7F Then GoTo DontBlock
                    new_target_id = new_target_id + decBuff(i + 5) * &H100 ^ i
                Next i
            End If
            If new_target_id <> 0 Then
                If GetChar_ById(new_target_id) >= 0 Then
                    If IsMonster(GetChar_ById(new_target_id)) Then
                        new_target_id = 0
                    End If
                End If
            End If
            If new_target_id <> 0 And decBuff(4) <> &HBE Then
                If decBuff(4) = &HA1 And new_target_id <> lock_attack_id Then
                    lock_attack_id = new_target_id
                    lock_attack_name = ""
                    lock_follow_id = 0
                    tarIndex = GetChar_ById(new_target_id)
                    If tarIndex >= 0 Then Log FEEDBACK, "Locked attack on " & TrimCStr(charMem.char(tarIndex).name) & "."
                ElseIf decBuff(4) = &HA2 And new_target_id <> lock_follow_id Then
                    lock_follow_id = new_target_id
                    lock_attack_name = ""
                    lock_attack_id = 0
                    tarIndex = GetChar_ById(new_target_id)
                    If tarIndex >= 0 Then Log FEEDBACK, "Locked follow on " & TrimCStr(charMem.char(tarIndex).name) & "."
                End If
            Else
                If lock_attack_id <> 0 Or lock_follow_id <> 0 Or lock_attack_name <> "" Then Log FEEDBACK, "Lock cancelled."
                lock_attack_id = 0
                lock_follow_id = 0
                lock_attack_name = ""
            End If
        End If
    End If

DontBlock:
    'forward packet
    If sckGameServer.State = sckConnected Then
        sckGameServer.SendData buff
    Else
        DisconnectGame
    End If
    'allow packet to go throo
'    DoEvents
Block:
    If IsServerReplied = False Then
        WriteToINI LoginIniPath, playerName, "rsa login packet", ByteArrayToString(buff)
        WriteToINI LoginIniPath, playerName, "xtea key", ByteArrayToString(xteaKey)
        WriteToINI LoginIniPath, playerName, "tibia version", 781
    End If
    'record packet
    If chkRecordPackets Then
        If IsServerReplied And frmPacket.chkShowClientPackets Then
            frmPacket.OutgoingClientPacket decBuff
        ElseIf IsServerReplied = False And frmPacket.chkShowLoginPackets Then
            frmPacket.OutgoingClientPacket buff
        End If
    End If
'    If GetTickCount - tick > 1 Then PutDefaultTab "slow send"
End Sub

Private Sub sckGameClient_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    DisconnectGame
End Sub

Private Sub sckGameListener_ConnectionRequest(ByVal requestID As Long)
    Dim loginChar As Integer
    'close existing server connections
    DisconnectGame
    'connect to correct server
    loginChar = ReadMem(ADR_LOGIN_CHAR_INDEX, 4)
    sckGameServer.Connect LoginListChars(loginChar).IP, LoginListChars(loginChar).Port
    Dim timeOutTick As Long
    timeOutTick = GetTickCount + 3000
    Do While sckGameServer.State <> sckConnected And sckGameServer.State <> sckClosed
        DoEvents
        If GetTickCount > timeOutTick Then GoTo TimeOut
    Loop
    If sckGameServer.State <> sckConnected Then
        MsgBox "Failed to connect to game server."
        GoTo TimeOut
    End If
    'create proxy bridge
    timeOutTick = GetTickCount + 3000
    While sckGameClient.State <> sckClosed
        DoEvents
        If GetTickCount > timeOutTick Then GoTo TimeOut
    Wend
    sckGameClient.Accept requestID
    playerName = LoginListChars(loginChar).name
    'Log DEBUGGING, ""
    Log DEBUGGING, String(80, "*"), False, False
    Log DEBUGGING, "LOGGED IN.", True, True
    Log DEBUGGING, String(80, "*"), False, False
    UpdateWindowText
    UpdateXteaKey
    Exit Sub
TimeOut:
    DisconnectGame
End Sub

Private Sub sckGameServer_Close()
    DisconnectGame
End Sub

Private Sub sckGameServer_DataArrival(ByVal bytesTotal As Long)
    Dim tick As Long
    tick = GetTickCount
    Dim buff() As Byte, decBuff() As Byte
    'get packet from server
    If sckGameServer.State = sckConnected Then sckGameServer.GetData buff
    'update key on first reply
    If IsServerReplied = False Then UpdateXteaKey
    'record packets
    If chkRecordPackets Then
        If (modSck.IsServerReplied And frmPacket.chkShowServerPackets) _
        Or (modSck.IsServerReplied = False And frmPacket.chkShowLoginPackets) Then
            decBuff = buff
            DecipherXteaPacket decBuff(0), UBound(decBuff) + 1, xteaKey(0)
            frmPacket.IncomingServerPacket decBuff
        End If
    End If
    'forward packet to client
    If sckGameClient.State = sckConnected Then
        sckGameClient.SendData buff
    Else
        DisconnectGame
    End If
    'update first reply received
    modSck.ReplyReceived
'    If GetTickCount - tick > 1 Then PutDefaultTab "slow recv"
End Sub

Private Sub sckGameServer_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    DisconnectGame
End Sub

Private Sub sckLoginClient_Close()
'    DisconnectGame
    DisconnectLogin
End Sub

Private Sub sckLoginClient_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckLoginClient.GetData buff
    Do While sckLoginServer.State <> sckConnected And sckLoginServer.State <> sckClosed
        DoEvents
    Loop
    If sckLoginServer.State = sckConnected Then sckLoginServer.SendData buff
End Sub

Private Sub sckLoginListener_ConnectionRequest(ByVal requestID As Long)
    DisconnectLogin
    sckLoginServer.Connect ServerIP, ServerPort
    While sckLoginServer.State <> sckConnected
        DoEvents
        If sckLoginServer.State = sckClosed Then
            DisconnectLogin
            Exit Sub
        End If
    Wend
    sckLoginClient.Accept requestID
End Sub

Private Sub sckLoginServer_Close()
    DisconnectLogin
End Sub

Private Sub sckLoginServer_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckLoginServer.GetData buff
    UpdateXteaKey
    DecipherXteaPacket buff(0), UBound(buff) + 1, xteaKey(0)
    buff = LoginListPacket(buff, sckGameListener.LocalPort)
    EncipherXteaPacket buff(0), UBound(buff) + 1, xteaKey(0)
    If sckLoginClient.State = sckConnected Then sckLoginClient.SendData buff
End Sub

Private Sub tmrAction_Timer()
    DoActions
End Sub

Private Sub tmrHotkey_Timer()
    If GetForegroundWindow <> hwndClient Then Exit Sub
    If GetPressedKey(vbKeyDelete) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "delete")
    If GetPressedKey(vbKeyPageDown) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "pagedown")
    If GetPressedKey(vbKeyPageUp) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "pageup")
    If GetPressedKey(vbKeyHome) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "home")
    If GetPressedKey(vbKeyEnd) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "home")
    If GetPressedKey(vbKeyInsert) Then DoHotkey ReadFromINI(HotkeyIniPath, "hotkeys", "home")
    'If GetPressedKey(vbkeyleftmousebutton) Then blah
End Sub

Private Function GetPressedKey(key As Long) As Boolean
    Static keysDown(&H7F) As Boolean
    GetPressedKey = False
    If keysDown(key) = False And GetAsyncKeyState(key) Then
        keysDown(key) = True
        GetPressedKey = True
    Else
        If GetAsyncKeyState(key) = 0 Then keysDown(key) = False
    End If
End Function

Private Sub tmrValues_Timer()
    lblADR_GAME_STATUS = ReadMem(ADR_GAME_STATUS)
End Sub
