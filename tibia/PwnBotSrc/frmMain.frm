VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "PwnBot"
   ClientHeight    =   4080
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   2985
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4080
   ScaleWidth      =   2985
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox chkStepper 
      Caption         =   "Stepper"
      Height          =   255
      Left            =   1200
      TabIndex        =   22
      Top             =   3720
      Width           =   1335
   End
   Begin VB.CommandButton cmdStepperSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   21
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton cmdReadItemValue 
      Caption         =   "Ammo Slot Item Value"
      Height          =   495
      Left            =   1920
      TabIndex        =   10
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton cmdSpellSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   20
      Top             =   3360
      Width           =   975
   End
   Begin VB.CheckBox chkSpells 
      Caption         =   "Spells/Runes"
      Height          =   255
      Left            =   1200
      TabIndex        =   19
      Top             =   3360
      Width           =   1575
   End
   Begin VB.CheckBox chkEat 
      Caption         =   "Eat"
      Height          =   255
      Left            =   1200
      TabIndex        =   18
      Top             =   3000
      Width           =   1335
   End
   Begin VB.CommandButton cmdEatSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   3000
      Width           =   975
   End
   Begin VB.CommandButton cmdAutoAttackSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   2640
      Width           =   975
   End
   Begin VB.CheckBox chkAutoAttack 
      Caption         =   "Auto Attack"
      Height          =   255
      Left            =   1200
      TabIndex        =   15
      Top             =   2640
      Width           =   1575
   End
   Begin VB.CheckBox chkAlert 
      Caption         =   "Alert"
      Height          =   255
      Left            =   1200
      TabIndex        =   14
      Top             =   2280
      Width           =   1095
   End
   Begin VB.CommandButton cmdAlertSettings 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   2280
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Settings"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1920
      Width           =   975
   End
   Begin VB.CheckBox chkBlockAlivePackets 
      Caption         =   "Log with swords"
      Height          =   255
      Left            =   1200
      TabIndex        =   11
      Top             =   1920
      Width           =   1575
   End
   Begin VB.CommandButton cmdLootSettings 
      Caption         =   "Settings"
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
      Width           =   1575
   End
   Begin VB.CommandButton cmdExperienceSettings 
      Caption         =   "Settings"
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
      Width           =   2295
   End
   Begin VB.Timer tmrAction 
      Interval        =   50
      Left            =   2400
      Top             =   2160
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
      Width           =   2175
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

Private Sub cmdAlertSettings_Click()
    frmAlert.Show
End Sub

Private Sub cmdAutoAttackSettings_Click()
    frmAttack.Show
End Sub

Private Sub cmdReadItemValue_Click()
    PutDefaultTab "Item value: " & ReadMem(ADR_AMMO, 2)
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

Private Sub Form_Resize()
    If Me.WindowState = 1 Then
        frmAlert.Hide
        frmAttack.Hide
        frmPacket.Hide
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
        ElseIf decBuff(4) = &H1E And chkBlockAlivePackets Then
            Exit Sub
        ElseIf (decBuff(4) = &HA1 Or decBuff(4) = &HA2 Or decBuff(4) = &HBE) Then
            Dim new_target_id As Long, tarIndex As Long
            If decBuff(4) = &HBE Then
                new_target_id = 0
            Else
                For i = 0 To 3
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
                    lock_follow_id = 0
                    tarIndex = GetChar_ById(new_target_id)
                    If tarIndex >= 0 Then PutDefaultTab "Locked attack on " & TrimCStr(charMem.char(tarIndex).name) & "."
                ElseIf decBuff(4) = &HA2 And new_target_id <> lock_follow_id Then
                    lock_follow_id = new_target_id
                    lock_attack_id = 0
                    tarIndex = GetChar_ById(new_target_id)
                    If tarIndex >= 0 Then PutDefaultTab "Locked follow on " & TrimCStr(charMem.char(tarIndex).name) & "."
                End If
            Else
                If lock_attack_id <> 0 Or lock_follow_id <> 0 Then PutDefaultTab "Lock cancelled."
                lock_attack_id = 0
                lock_follow_id = 0
            End If
        End If
    End If

DontBlock:
    'forward packet
    If sckGameServer.State = sckConnected Then sckGameServer.SendData buff
    'allow packet to go throo
'    DoEvents
Block:
    If IsServerReplied = False Then
        WriteToINI LoginIniPath, playerName, "rsa login packet", ByteArrayToString(buff)
        WriteToINI LoginIniPath, playerName, "xtea key", ByteArrayToString(xteaKey)
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

Private Sub sckGameListener_ConnectionRequest(ByVal requestID As Long)
    Dim loginChar As Integer
    
    'close existing server connections
    DisconnectGame
    'connect to correct server
    loginChar = ReadMem(ADR_LOGIN_CHAR_INDEX, 4)
    sckGameServer.Connect LoginListChars(loginChar).IP, LoginListChars(loginChar).Port
    Do While sckGameServer.State <> sckConnected And sckGameServer.State <> sckClosed
        DoEvents
    Loop
    If sckGameServer.State <> sckConnected Then
        MsgBox "Failed to connect to game server."
        Exit Sub
    End If
    
    'create proxy bridge
    While sckGameClient.State <> sckClosed
        DoEvents
    Wend
    sckGameClient.Accept requestID
    playerName = LoginListChars(loginChar).name
    UpdateWindowText
    UpdateXteaKey
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
    If sckGameClient.State = sckConnected Then sckGameClient.SendData buff
    'update first reply received
    modSck.ReplyReceived
'    If GetTickCount - tick > 1 Then PutDefaultTab "slow recv"
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
