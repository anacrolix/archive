VERSION 5.00
Begin VB.Form frmIntruder 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Intruder Reaction"
   ClientHeight    =   4665
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   8040
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4665
   ScaleWidth      =   8040
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrCheckSkulls 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   720
      Top             =   4080
   End
   Begin VB.Frame frameVIP 
      Caption         =   "VIP Checker"
      Height          =   1215
      Left            =   120
      TabIndex        =   23
      Top             =   2880
      Width           =   3855
      Begin VB.HScrollBar hscrNumSkulls 
         Height          =   255
         Left            =   120
         Max             =   10
         Min             =   1
         TabIndex        =   25
         Top             =   840
         Value           =   1
         Width           =   2415
      End
      Begin VB.CheckBox chkAlertSkulls 
         Caption         =   "Alert when skulls online"
         Height          =   255
         Left            =   120
         TabIndex        =   24
         Top             =   240
         Width           =   2415
      End
      Begin VB.Label lblSkullsRequired 
         Caption         =   "Require that # skulls are online."
         Height          =   255
         Left            =   120
         TabIndex        =   26
         Top             =   600
         Width           =   3615
      End
   End
   Begin VB.CheckBox chkScript 
      Caption         =   "Run Script"
      Height          =   255
      Left            =   2520
      TabIndex        =   19
      Top             =   120
      Width           =   1455
   End
   Begin VB.Frame frameSafeList 
      Caption         =   "Safe List"
      Height          =   3975
      Left            =   4080
      TabIndex        =   15
      Top             =   120
      Width           =   3855
      Begin VB.CheckBox chkIgnoreAll 
         Caption         =   "Ignore all *except* skull and spark players"
         Height          =   255
         Left            =   120
         TabIndex        =   27
         Top             =   3600
         Width           =   3495
      End
      Begin VB.CheckBox chkIgnoreMonsters 
         Caption         =   "Ignore Monsters"
         Height          =   375
         Left            =   2760
         TabIndex        =   22
         Top             =   1680
         Width           =   975
      End
      Begin VB.CommandButton cmdClear 
         Caption         =   "Clear"
         Height          =   375
         Left            =   2760
         TabIndex        =   20
         Top             =   1200
         Width           =   975
      End
      Begin VB.ListBox listSafe 
         Height          =   3180
         ItemData        =   "frmIntruder.frx":0000
         Left            =   120
         List            =   "frmIntruder.frx":0002
         TabIndex        =   18
         Top             =   240
         Width           =   2535
      End
      Begin VB.CommandButton cmdAdd 
         Caption         =   "Add"
         Height          =   375
         Left            =   2760
         TabIndex        =   17
         Top             =   240
         Width           =   975
      End
      Begin VB.CommandButton cmdRemove 
         Caption         =   "Remove"
         Height          =   375
         Left            =   2760
         TabIndex        =   16
         Top             =   720
         Width           =   975
      End
   End
   Begin VB.CheckBox chkAutoLog 
      Caption         =   "Auto Log"
      Height          =   255
      Left            =   1200
      TabIndex        =   14
      Top             =   120
      Width           =   1095
   End
   Begin VB.CheckBox chkWalk 
      Caption         =   "Walk"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   600
      Width           =   1215
   End
   Begin VB.CheckBox chkDetectOffscreen 
      Caption         =   "Detect Offscreen"
      Height          =   255
      Left            =   1680
      TabIndex        =   12
      Top             =   600
      Width           =   2175
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "Close"
      Height          =   375
      Left            =   3480
      TabIndex        =   11
      Top             =   4200
      Width           =   975
   End
   Begin VB.Frame frameOffscreen 
      Caption         =   "Offscreen Options"
      Height          =   1815
      Left            =   1560
      TabIndex        =   6
      Top             =   960
      Visible         =   0   'False
      Width           =   2415
      Begin VB.HScrollBar hscrNumAbove 
         Height          =   255
         Left            =   120
         Max             =   14
         TabIndex        =   10
         Top             =   1440
         Value           =   1
         Width           =   2175
      End
      Begin VB.HScrollBar hscrNumBelow 
         Height          =   255
         Left            =   120
         Max             =   14
         TabIndex        =   9
         Top             =   600
         Value           =   1
         Width           =   2175
      End
      Begin VB.CheckBox chkAbove 
         Caption         =   "Detect Level above"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   1080
         Width           =   2175
      End
      Begin VB.CheckBox chkBelow 
         Caption         =   "Detect Level below"
         Height          =   255
         Left            =   120
         TabIndex        =   7
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
      Left            =   120
      Top             =   4080
   End
   Begin VB.Frame frameWalk 
      Caption         =   "Walk Direction"
      Height          =   1815
      Left            =   120
      TabIndex        =   1
      Top             =   960
      Visible         =   0   'False
      Width           =   1335
      Begin VB.CheckBox chkWalkDouble 
         Caption         =   "2 Steps"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   1440
         Width           =   1095
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "W"
         Height          =   375
         Index           =   3
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   600
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "S"
         Height          =   375
         Index           =   2
         Left            =   480
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   960
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "E"
         Height          =   375
         Index           =   1
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   600
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "N"
         Height          =   375
         Index           =   0
         Left            =   480
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   240
         Value           =   -1  'True
         Width           =   375
      End
   End
   Begin VB.CheckBox chkAlert 
      Caption         =   "Alert"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   855
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
Private Sub chkDetectOffscreen_Click()
  If chkDetectOffscreen Then
    frameOffscreen.Visible = True
  Else
    frameOffscreen.Visible = False
  End If
End Sub

Private Sub chkWalk_Click()
  If chkWalk Then
    frameWalk.Visible = True
  Else
    frameWalk.Visible = False
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

Private Sub Form_Load()
  hscrNumAbove_Change
  hscrNumBelow_Change
  hscrNumSkulls_Change
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
    
    If str = "" Or str = CharName Or pos = UserPos Then GoTo IsSafe
    
    If chkIgnoreAll.Value = Checked Then
        intID = ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
        For i = 0 To LEN_VIP
            If ReadMem(ADR_VIP_ID + SIZE_VIP * i, 4) = intID Then
                intSymbol = ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1)
                If intSymbol = 2 Or intSymbol = 3 Then Exit Function
            End If
        Next i
        GoTo IsSafe
    End If
    
    If chkIgnoreMonsters.Value = Checked And ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR + 3, 1) = &H40 Then GoTo IsSafe
            
    If listSafe.ListCount <= 0 Then Exit Function
    
    For i = 0 To listSafe.ListCount - 1
        If Left(str, Len(listSafe.List(i))) = listSafe.List(i) Then GoTo IsSafe
    Next i
    Exit Function
IsSafe:
    CheckSafe = True
End Function

Public Sub IntruderReaction()
    Dim j As Integer
    Dim s As String
    
    If frmMain.sckS.State <> sckConnected Then Exit Sub
    'script
    If chkScript.Value = Checked Then frmScript.StartScript
    'autolog
    If chkAutoLog Then LogOut: frmMain.StartLogOut
    'walk
    If chkWalk Then
        For j = optWalk.LBound To optWalk.UBound
            If optWalk(j) Then
                Step j
                s = "Walk "
                Select Case j
                    Case 0: s = s & "North"
                    Case 1: s = s & "East"
                    Case 2: s = s & "South"
                    Case 3: s = s & "West"
                End Select
                
                AddStatusMessage s
                Exit For
            End If
        Next j
        'frmIntruder.chkWalk.Value = False
        s = s & " and deactivate further walking."
    End If
    'eating
    If frmMain.chkEat Then
        frmMain.chkEat.Value = False
        s = s & ", stop eating,"
    End If
    
    'alert
    If frmMain.chkAlert.Value = Unchecked And frmIntruder.chkAlert = Checked Then StartAlert
    
    frmMain.chkIntruder.Value = Unchecked
    Valid
End Sub

Private Sub hscrNumSkulls_Change()
    lblSkullsRequired = "Require that " & hscrNumSkulls & " skulled players are online."
End Sub

Private Sub tmrAppear_Timer()
    Dim i As Integer
    Dim charZ As Long
    Dim intName As String
    
    'get char z, and array pos
    charZ = ReadMem(ADR_CHAR_Z + UserPos * SIZE_CHAR, 4)
    
    For i = 0 To LEN_CHAR
        'find onscreen char
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
            intName = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
            If charZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4) And CheckSafe(intName, i) = False Then
                AddStatusMessage "Onscreen intruder detected:" & vbCrLf & ">" & intName & "<"
                IntruderReaction
                Exit For
            End If
        End If
    Next i
End Sub

Public Sub IntruderOffscreen(buff() As Byte)
    Dim intName As String 'name of intruder
    Dim doLog As Boolean
    Dim plyrZ As Long 'players z coord
    Dim plyrX As Long
    Dim plyrY As Long
    Dim intPos As Long 'intruders position in array
    Dim intX As Long 'intruders x coord
    Dim intY As Long
    Dim intZ As Long
    
    'elseif buff(0) = &Hd then
    'frmMain.lblLogPackets = packetToString(Buff) & nom & vbCrLf & frmMain.lblLogPackets
    'frmMain.lblLogPackets = nom & vbCrLf & frmMain.lblLogPackets
    
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
      AddStatusMessage "Offscreen intruder detected:" & vbCrLf & ">" & intName & "< on level " & intZ & ", " & intZ - plyrZ & " levels offset."
      IntruderReaction
    End If
End Sub

Private Sub tmrCheckSkulls_Timer()
    Dim i As Integer, skulls As Integer
    
    If chkAlertSkulls = Unchecked Then Exit Sub
    
    For i = 0 To LEN_VIP
        If ReadMem(ADR_VIP_ONLINE + i * SIZE_VIP, 1) = 1 Then _
        If ReadMem(ADR_VIP_SYMBOL + i * SIZE_VIP, 1) = 2 Then _
        skulls = skulls + 1
        If skulls >= hscrNumSkulls Then
            StartAlert
            Exit Sub
        End If
    Next i
End Sub
