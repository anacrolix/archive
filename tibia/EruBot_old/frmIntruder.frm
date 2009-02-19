VERSION 5.00
Begin VB.Form frmIntruder 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Intruder Reaction"
   ClientHeight    =   5025
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   7785
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5025
   ScaleWidth      =   7785
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkIgnoreAll 
      Caption         =   "Ignore all *except* skull and spark players"
      Height          =   255
      Left            =   4080
      TabIndex        =   22
      Top             =   4200
      Width           =   3495
   End
   Begin VB.CheckBox chkIgnoreMonsters 
      Caption         =   "Ignore Monsters"
      Height          =   255
      Left            =   4080
      TabIndex        =   21
      Top             =   3960
      Width           =   3615
   End
   Begin EruBot.listFancy listSafe 
      Height          =   3735
      Left            =   4080
      TabIndex        =   20
      Top             =   120
      Width           =   3615
      _ExtentX        =   6376
      _ExtentY        =   6588
      Title           =   "Safe List"
      Caption         =   "Safe List"
      ListIndex       =   -1
      Prioritized     =   0   'False
   End
   Begin VB.CheckBox chkBattleSign 
      Caption         =   "Detect Battle Sign"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton cmdSetSafeSpot 
      Caption         =   "Set Safe Spot"
      Height          =   375
      Left            =   120
      TabIndex        =   16
      Top             =   2520
      Width           =   1335
   End
   Begin VB.CommandButton cmdSetAfkSpot 
      Caption         =   "Set Afk Spot"
      Height          =   375
      Left            =   120
      TabIndex        =   15
      Top             =   1680
      Width           =   1335
   End
   Begin VB.Timer tmrCheckSkulls 
      Interval        =   2000
      Left            =   5160
      Top             =   4560
   End
   Begin VB.Frame frameVIP 
      Caption         =   "VIP Checker"
      Height          =   1095
      Left            =   120
      TabIndex        =   11
      Top             =   3360
      Width           =   3855
      Begin VB.HScrollBar hscrNumSkulls 
         Height          =   255
         Left            =   120
         Max             =   10
         Min             =   1
         TabIndex        =   13
         Top             =   720
         Value           =   1
         Width           =   2415
      End
      Begin VB.CheckBox chkAlertSkulls 
         Caption         =   "Alert when skulls online"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   240
         Width           =   2415
      End
      Begin VB.Label lblSkullsRequired 
         Caption         =   "Require that # skulls are online."
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   480
         Width           =   3615
      End
   End
   Begin VB.CheckBox chkScript 
      Caption         =   "Run Script"
      Height          =   255
      Left            =   2520
      TabIndex        =   10
      Top             =   120
      Width           =   1455
   End
   Begin VB.CheckBox chkAutoLog 
      Caption         =   "Auto Log"
      Height          =   255
      Left            =   1200
      TabIndex        =   9
      Top             =   120
      Width           =   1095
   End
   Begin VB.CheckBox chkWalk 
      Caption         =   "Walk"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   960
      Width           =   1815
   End
   Begin VB.CheckBox chkDetectOffscreen 
      Caption         =   "Detect Offscreen"
      Height          =   255
      Left            =   2040
      TabIndex        =   7
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "Close"
      Height          =   375
      Left            =   3480
      TabIndex        =   6
      Top             =   4560
      Width           =   975
   End
   Begin VB.Frame frameOffscreen 
      Caption         =   "Offscreen Options"
      Height          =   1815
      Left            =   1560
      TabIndex        =   1
      Top             =   1560
      Visible         =   0   'False
      Width           =   2415
      Begin VB.HScrollBar hscrNumAbove 
         Height          =   255
         Left            =   120
         Max             =   14
         TabIndex        =   5
         Top             =   1440
         Value           =   1
         Width           =   2175
      End
      Begin VB.HScrollBar hscrNumBelow 
         Height          =   255
         Left            =   120
         Max             =   14
         TabIndex        =   4
         Top             =   600
         Value           =   1
         Width           =   2175
      End
      Begin VB.CheckBox chkAbove 
         Caption         =   "Detect Level above"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   1080
         Width           =   2175
      End
      Begin VB.CheckBox chkBelow 
         Caption         =   "Detect Level below"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   2175
      End
      Begin VB.Line Line1 
         X1              =   120
         X2              =   2280
         Y1              =   960
         Y2              =   960
      End
   End
   Begin VB.Timer tmrAppear 
      Enabled         =   0   'False
      Interval        =   150
      Left            =   4560
      Top             =   4560
   End
   Begin VB.CheckBox chkAlert 
      Caption         =   "Alert"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   855
   End
   Begin VB.Label lblSafeSpot 
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Label lblAfkSpot 
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   2160
      Width           =   1335
   End
   Begin VB.Line Line2 
      X1              =   120
      X2              =   3960
      Y1              =   480
      Y2              =   480
   End
End
Attribute VB_Name = "frmIntruder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public safeX As Long, safeY As Long, safeZ As Long
Public afkX As Long, afkY As Long, afkZ As Long

Public Function isSafe() As Boolean
    isSafe = False
    
    If ReadMem(ADR_PLAYER_X, 4) = safeX _
    And ReadMem(ADR_PLAYER_Y, 4) = safeY _
    And ReadMem(ADR_PLAYER_Z, 4) = safeZ _
    Then isSafe = True
End Function

Private Sub chkDetectOffscreen_Click()
  If chkDetectOffscreen Then
    frameOffscreen.Visible = True
  Else
    frameOffscreen.Visible = False
  End If
End Sub

Private Sub cmdAdd_Click()
    Dim newSafe As String
    newSafe = InputBox("Name of safe character, Case-sensitive", "Safe Char")
    If newSafe <> "" Then listSafe.AddItem newSafe
End Sub

Private Sub cmdClear_Click()
    listSafe.Clear
End Sub

Private Sub cmdOK_Click()
  Me.Hide
End Sub

Private Sub cmdRemove_Click()
  If listSafe.ListIndex >= 0 Then listSafe.RemoveItem listSafe.ListIndex
End Sub

Private Sub cmdSetAfkSpot_Click()
    afkX = ReadMem(ADR_PLAYER_X, 4)
    afkY = ReadMem(ADR_PLAYER_Y, 4)
    afkZ = ReadMem(ADR_PLAYER_Z, 4)
    lblAfkSpot.Caption = afkX & ", " & afkY & ", " & afkZ
End Sub

Public Sub UpdAfkLbl()
    Dim temp() As String
    temp = Split(lblAfkSpot, ", ")
    afkX = temp(0)
    afkY = temp(1)
    afkZ = temp(2)
End Sub

Public Sub UpdSafeLbl()
    Dim temp() As String
    temp = Split(lblSafeSpot, ", ")
    safeX = temp(0)
    safeY = temp(1)
    safeZ = temp(2)
End Sub

Private Sub cmdSetSafeSpot_Click()
    safeX = ReadMem(ADR_PLAYER_X, 4)
    safeY = ReadMem(ADR_PLAYER_Y, 4)
    safeZ = ReadMem(ADR_PLAYER_Z, 4)
    lblSafeSpot.Caption = safeX & ", " & safeY & ", " & safeZ
End Sub

Private Sub Form_Load()
  hscrNumAbove_Change
  hscrNumBelow_Change
  hscrNumSkulls_Change
  cmdSetAfkSpot_Click
  cmdSetSafeSpot_Click
End Sub

Public Sub hscrNumAbove_Change()
  chkAbove.Caption = "Detect " & hscrNumAbove.Value & " levels above"
End Sub

Public Sub hscrNumBelow_Change()
  chkBelow.Caption = "Detect " & hscrNumBelow.Value & " levels below"
End Sub

Public Function CheckSafe(str As String, pos As Integer) As Boolean
    Dim i As Integer, intID As Long, intSymbol As Integer
    
    CheckSafe = False
    
    If str = "" Or str = CharName Or pos = UserPos Then GoTo Safe
    
    If chkIgnoreAll.Value = Checked Then
        intID = ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
        For i = 0 To LEN_VIP
            If ReadMem(ADR_VIP_ID + SIZE_VIP * i, 4) = intID Then
                intSymbol = ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1)
                If intSymbol = 2 Or intSymbol = 3 Then Exit Function
            End If
        Next i
        GoTo Safe
    End If
    
    If chkIgnoreMonsters.Value = Checked And ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR + 3, 1) = &H40 Then GoTo Safe
            
    If listSafe.ListCount <= 0 Then Exit Function
    
    For i = 0 To listSafe.ListCount - 1
        If Left(str, Len(listSafe.List(i))) = listSafe.List(i) Then GoTo Safe
    Next i
    Exit Function
Safe:
    CheckSafe = True
End Function

Public Sub IntruderReaction(detectMethod As String, intName As String, intZ As Long)
    Dim j As Integer, s As String
    Static lastReact As Long
    
    If GetTickCount < lastReact + 3000 Then Exit Sub
    lastReact = GetTickCount
    AddStatusMessage "Detect intruder via " & detectMethod & ":" & vbCrLf & ">" & intName & "< on level " _
    & intZ & ", " & intZ - ReadMem(ADR_PLAYER_Z, 4) & " levels offset."
    
    'walk
    If chkWalk Then
        Dim x As Long, y As Long, z As Long, stepDir As Integer
        getCharXYZ x, y, z, UserPos
        If safeX - x <> 0 Or safeY - y <> 0 Then
            stepDir = GetStepValue(safeX - x, safeY - y)
            If stepDir < 0 Then
                StartAlert
                LogOut
                AddStatusMessage "Invalid position, too far from safe position or error"
            Else
                Step stepDir
                'AddStatusMessage "Stepping in direction " & stepDir
                'Pause 2000
            End If
        End If
    End If
    
    If frmMain.sckS.State <> sckConnected Then Exit Sub
    'script
    If chkScript.Value = Checked Then frmScript.StartScript
    'autolog
    If chkAutoLog Then LogOut: frmMain.chkLogOut = Checked
    'eating
    'If frmMain.chkEat Then
    '    frmMain.chkEat.Value = False
    '    s = s & ", stop eating,"
    'End If
    
    'alert
    If frmMain.chkAlert.Value = Unchecked And frmIntruder.chkAlert = Checked Then StartAlert
    
    If chkWalk <> Checked Then frmMain.chkIntruder.Value = Unchecked
    
    Valid
End Sub

Private Sub hscrNumSkulls_Change()
    lblSkullsRequired = "Require that " & hscrNumSkulls & " skulled players are online."
End Sub

Private Sub tmrAppear_Timer()
    Dim intName As String, intZ As Long
    'If GetTickCount < lastReact + 3000 Then Exit Sub
    intName = isIntruderOnscreen(intZ)
    If intName <> "" Or (chkBattleSign And ReadMem(ADR_BATTLE_SIGN, 4) <> 0) Then
        If intName = "" Then intName = "Battle Sign"
        'AddStatusMessage "Onscreen intruder detected:" & vbCrLf & ">" & intName & "<"
        IntruderReaction "Memory", intName, intZ
    End If
End Sub

Public Function isIntruderOnscreen(Optional ByRef intZ As Long = 0) As String
    Dim i As Integer
    Dim plyrZ As Long
    Dim intName As String
    
    'get char z, and array pos
    plyrZ = ReadMem(ADR_PLAYER_Z, 4)
    
    For i = 0 To LEN_CHAR
        'find onscreen char
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
            intName = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
            intZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4)
            If (plyrZ = intZ Or (chkDetectOffscreen And ((chkBelow And intZ > plyrZ And intZ - plyrZ <= hscrNumBelow) Or (chkAbove And intZ < plyrZ And plyrZ - intZ <= hscrNumAbove)))) And CheckSafe(intName, i) = False Then
                isIntruderOnscreen = intName
                Exit Function
            End If
        End If
    Next i
    isIntruderOnscreen = ""
End Function

Public Sub IntruderOffscreen(buff() As Byte)
    Dim intName As String 'name of intruder
    Dim doLog As Boolean
    Dim plyrX As Long, plyrY As Long, plyrZ As Long
    Dim intPos As Long 'intruders position in array
    Dim intX As Long, intY As Long, intZ As Long
    
    'elseif buff(0) = &Hd then
    'frmMain.lblLogPackets = packetToString(Buff) & nom & vbCrLf & frmMain.lblLogPackets
    'frmMain.lblLogPackets = nom & vbCrLf & frmMain.lblLogPackets

    'If GetTickCount < lastReact + 3000 Then Exit Sub
    
    intX = CLng(buff(4)) * 256 + CLng(buff(3))
    intY = CLng(buff(6)) * 256 + CLng(buff(5))
    intZ = CLng(buff(7))
    intPos = findPosByXYZ(intX, intY, intZ)
    intName = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * intPos, 32)
    If CheckSafe(intName, CInt(intPos)) Then Exit Sub
    
    plyrZ = ReadMem(ADR_CHAR_Z + UserPos * SIZE_CHAR, 4)
    doLog = False
    
    If intZ = plyrZ Then
        doLog = True
    ElseIf (chkBelow.Value = Checked And intZ > plyrZ And intZ - plyrZ <= hscrNumBelow.Value) Or _
    (chkAbove.Value = Checked And intZ < plyrZ And plyrZ - intZ <= hscrNumAbove.Value) Then
        doLog = True
    End If
    
    plyrX = ReadMem(ADR_CHAR_X + UserPos * SIZE_CHAR, 4)
    plyrY = ReadMem(ADR_CHAR_Y + UserPos * SIZE_CHAR, 4)
    'If plyrX = intX And plyrY = intY And plyrZ = intZ Then doLog = False
    
      'If intName = "Troll" Then MsgBox "fuck troll!"
    If doLog And frmMain.sckS.State = sckConnected Then
      'AddStatusMessage "Offscreen intruder detected:" & vbCrLf & ">" & intName & "< on level " & intZ & ", " & intZ - plyrZ & " levels offset."
      IntruderReaction "Packet", intName, intZ
    End If
End Sub

Private Sub tmrCheckSkulls_Timer()
    Dim i As Integer, skulls As Integer
    
    If chkAlertSkulls = Checked Then
        For i = 0 To LEN_VIP
            If ReadMem(ADR_VIP_ONLINE + i * SIZE_VIP, 1) = 1 Then _
            If ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1) = 2 Then _
            skulls = skulls + 1
            If skulls >= hscrNumSkulls Then
                StartAlert
                Valid
                Exit Sub
            End If
        Next i
    End If
    If chkWalk = Checked And ReadMem(ADR_BATTLE_SIGN, 4) = 0 And isIntruderOnscreen = "" Then
        Dim x As Long, y As Long, z As Long, stepVal As Integer
        x = ReadMem(ADR_PLAYER_X, 4)
        y = ReadMem(ADR_PLAYER_Y, 4)
        z = ReadMem(ADR_PLAYER_Z, 4)
        If x <> afkX Or y <> afkY Or z <> afkZ Then
            stepVal = GetStepValue(afkX - x, afkY - y)
            If stepVal >= 0 Then
                Step stepVal
            Else
                stepVal = GetStepValue(safeX - x, safeY - y)
                If stepVal >= 0 Then
                    Step stepVal
                Else
                    StartAlert
                    LogOut
                    Valid
                    'chkWalk.Value = Unchecked
                End If
            End If
        End If
    End If
End Sub
