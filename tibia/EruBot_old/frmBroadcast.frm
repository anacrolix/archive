VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmBroadcast 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Broadcast"
   ClientHeight    =   5505
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3030
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5505
   ScaleWidth      =   3030
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrBroadcast 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   2520
      Top             =   2160
   End
   Begin MSComctlLib.ProgressBar progbarBroadcast 
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   5160
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   450
      _Version        =   393216
      Appearance      =   1
      Scrolling       =   1
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1560
      TabIndex        =   17
      Top             =   4680
      Width           =   1095
   End
   Begin VB.TextBox txtMessage 
      Height          =   2055
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   16
      Top             =   2520
      Width           =   2775
   End
   Begin VB.CommandButton cmdBroadcast 
      Caption         =   "Broadcast!"
      Height          =   375
      Left            =   360
      TabIndex        =   15
      Top             =   4680
      Width           =   1095
   End
   Begin VB.TextBox txtMaxLevel 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   1920
      TabIndex        =   14
      Text            =   "999"
      Top             =   2160
      Width           =   615
   End
   Begin VB.TextBox txtMinLevel 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   840
      TabIndex        =   12
      Text            =   "11"
      Top             =   2160
      Width           =   615
   End
   Begin VB.Frame fraVocations 
      Caption         =   "Vocations"
      Height          =   1575
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   2775
      Begin VB.CheckBox chkNone 
         Caption         =   "None"
         Height          =   255
         Left            =   120
         TabIndex        =   19
         Top             =   1200
         Width           =   855
      End
      Begin VB.CheckBox chkRoyal 
         Caption         =   "Royal Paladin"
         Height          =   255
         Left            =   1200
         TabIndex        =   10
         Top             =   960
         Width           =   1455
      End
      Begin VB.CheckBox chkPaladin 
         Caption         =   "Paladin"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   960
         Width           =   1455
      End
      Begin VB.CheckBox chkElite 
         Caption         =   "Elite Knight"
         Height          =   255
         Left            =   1200
         TabIndex        =   8
         Top             =   720
         Width           =   1455
      End
      Begin VB.CheckBox chkKnight 
         Caption         =   "Knight"
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   720
         Width           =   1455
      End
      Begin VB.CheckBox chkMaster 
         Caption         =   "Master Sorcerer"
         Height          =   255
         Left            =   1200
         TabIndex        =   6
         Top             =   480
         Width           =   1455
      End
      Begin VB.CheckBox chkSorcerer 
         Caption         =   "Sorcerer"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   480
         Width           =   1455
      End
      Begin VB.CheckBox chkElder 
         Caption         =   "Elder Druid"
         Height          =   255
         Left            =   1200
         TabIndex        =   4
         Top             =   240
         Value           =   1  'Checked
         Width           =   1455
      End
      Begin VB.CheckBox chkDruid 
         Caption         =   "Druid"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Value           =   1  'Checked
         Width           =   1455
      End
   End
   Begin VB.TextBox txtWorld 
      Height          =   285
      Left            =   840
      TabIndex        =   0
      Text            =   "Dolera"
      Top             =   120
      Width           =   2055
   End
   Begin VB.Label Label3 
      Caption         =   "to"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   1560
      TabIndex        =   13
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "Levels"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   2160
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "World:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   615
   End
End
Attribute VB_Name = "frmBroadcast"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Const startStats = "CLASS=white>Vocation</TD></TR><TR BGCOLOR=#F1E0C6><TD WIDTH=70%>"
Const nameLink = "http://www.tibia.com/community/?subtopic=character&name="
Const levelCode = "</A></TD><TD WIDTH=10%>"
Const vocCode = "</TD><TD WIDTH=20%>"

Dim names(1000) As String
Dim levels(1000) As Integer
Dim vocations(1000) As String
Dim numPlayers As Integer
Dim curPlayer As Integer

Private Sub cmdBroadcast_Click()
    Dim sOnline As String
    Dim temp As String
    Dim char As String
    
    cmdBroadcast.Enabled = False
    numPlayers = -1
    sOnline = GetUrlSource("http://www.tibia.com/statistics/?subtopic=whoisonline&world=" & txtWorld.Text)
    If Len(sOnline) < 1 Then
        MsgBox "There was an error reading form the server"
        cmdBroadcast.Enabled = True
        Exit Sub
    End If
    
    'MsgBox Len(sOnline)
    If Traverse(startStats, sOnline, 0) Then
        'MsgBox Len(sOnline)
        'MsgBox Left(sOnline, 10)
        For i = 1 To Len(sOnline)
            If Traverse(nameLink, sOnline, 0) Then
                numPlayers = numPlayers + 1
                names(numPlayers) = Replace(Replace(ReadString(">", sOnline, -1), "+", " "), "%27", "'")
                'MsgBox names(i - 1)
                Traverse levelCode, sOnline
                levels(numPlayers) = Int(ReadString("<", sOnline, 0))
                Traverse vocCode, sOnline
                vocations(numPlayers) = ReadString("<", sOnline, 0)
                'If levels(numPlayers) > 50 Then MsgBox names(numPlayers) & " " & levels(numPlayers) & " " _
                '& vocations(numPlayers)
            Else
                'MsgBox numPlayers + 1 & " players online."
                Exit For
            End If
        Next i
    Else
        MsgBox "Server Offline"
        cmdBroadcast.Enabled = True
        Exit Sub
    End If
    With progbarBroadcast
        .Value = 0
        .Min = 0
        .Max = numPlayers
    End With
    curPlayer = 0
    tmrBroadcast.Enabled = True
End Sub

Private Function ReadString(before As String, str As String, offset As Integer) As String
    Dim temp As String
    Dim char As String
    Dim found As Boolean
    
    If offset > 0 Then offset = -offset
    found = False
    
    For i = 1 To Len(str) - Len(before) + 1
        If Mid(str, i, Len(before)) = before Then found = True: Exit For
    Next i
    
    If found Then ReadString = Left(str, i - 1 + offset)
End Function

Private Function Traverse(after As String, str As String, Optional offset As Long) As Boolean
    Dim pos As Long
    
    Traverse = False
    
    If FindString(after, str, pos) Then
        str = Right(str, Len(str) - pos - Len(after) + 1 - offset)
        Traverse = True
    End If
End Function

Private Function FindString(find As String, str As String, Optional start As Long) As Boolean
    FindString = False
    
    If Len(str) < Len(find) Then Exit Function
    
    For i = 1 To Len(str) - Len(find)
        If Mid(str, i, Len(find)) = find Then
            FindString = True
            start = i
            Exit For
        End If
    Next i
End Function

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub BroadCast()
    Dim send As Boolean
    Dim v As String
    Do
        v = vocations(curPlayer)
        If (v = "Knight" And chkKnight) Or (v = "Elite Knight" And chkElite) Or _
            (v = "Sorcerer" And chkSorcerer) Or (v = "Master Sorcerer" And chkMaster) Or _
            (v = "Druid" And chkDruid) Or (v = "Elder Druid" And chkElder) Or _
            (v = "Paladin" And chkPaladin) Or (v = "Royal Paladin" And chkRoyal) Or _
            (v = "None" And chkNone) Then
            send = True
        Else
            send = False
        End If
        If send Then
            If levels(curPlayer) >= CInt(txtMinLevel) And levels(curPlayer) <= CInt(txtMaxLevel) Then
                SendPM names(curPlayer), txtMessage
                AddStatusMessage "Broadcasted to " & names(curPlayer) & " a level " & levels(curPlayer) & " " & vocations(curPlayer)
                curPlayer = curPlayer + 1
                Exit Sub
            End If
        End If
        curPlayer = curPlayer + 1
        If curPlayer <= progbarBroadcast.Max Then progbarBroadcast = curPlayer
    Loop Until curPlayer > numPlayers
    cmdBroadcast.Enabled = True
    tmrBroadcast.Enabled = False
    progbarBroadcast.Value = progbarBroadcast.Max
End Sub

Private Sub tmrBroadcast_Timer()
    BroadCast
End Sub

Private Sub txtMaxLevel_GotFocus()
    With txtMaxLevel
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtMinLevel_GotFocus()
    With txtMinLevel
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtWorld_GotFocus()
    With txtWorld
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub
