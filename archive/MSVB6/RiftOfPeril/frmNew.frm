VERSION 5.00
Begin VB.Form frmNew 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Create New Character"
   ClientHeight    =   4155
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7500
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   277
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   500
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraClass 
      Caption         =   "Class"
      Height          =   1815
      Left            =   6000
      TabIndex        =   16
      Top             =   2160
      Width           =   1335
      Begin VB.OptionButton optClass 
         Caption         =   "Wizard"
         Enabled         =   0   'False
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   23
         Top             =   720
         Width           =   855
      End
      Begin VB.OptionButton optClass 
         Caption         =   "Cleric"
         Enabled         =   0   'False
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   22
         Top             =   480
         Width           =   735
      End
      Begin VB.OptionButton optClass 
         Caption         =   "Fighter"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   18
         Top             =   240
         Width           =   855
      End
   End
   Begin VB.Frame fraRace 
      Caption         =   "Race"
      Height          =   1815
      Left            =   6000
      TabIndex        =   15
      Top             =   240
      Width           =   1335
      Begin VB.OptionButton optRace 
         Caption         =   "Halfling"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   21
         Top             =   960
         Width           =   855
      End
      Begin VB.OptionButton optRace 
         Caption         =   "Elf"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   20
         Top             =   720
         Width           =   855
      End
      Begin VB.OptionButton optRace 
         Caption         =   "Dwarf"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   19
         Top             =   480
         Width           =   855
      End
      Begin VB.OptionButton optRace 
         Caption         =   "Human"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   855
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Re-Roll Stats"
      Height          =   615
      Left            =   240
      TabIndex        =   14
      Top             =   3360
      Width           =   1815
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   0
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   615
      Left            =   4080
      TabIndex        =   1
      Top             =   3360
      Width           =   1815
   End
   Begin VB.CommandButton cmdStartGame 
      Caption         =   "Start Game"
      Height          =   615
      Left            =   2160
      TabIndex        =   0
      Top             =   3360
      Width           =   1815
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   1
      Left            =   1200
      TabIndex        =   3
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   2
      Left            =   2160
      TabIndex        =   4
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   3
      Left            =   3120
      TabIndex        =   5
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   4
      Left            =   4080
      TabIndex        =   6
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin RiftOfPeril.LevelBar lbrStats 
      Height          =   2535
      Index           =   5
      Left            =   5040
      TabIndex        =   7
      Top             =   240
      Width           =   855
      _ExtentX        =   1508
      _ExtentY        =   4471
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "CHA"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   5
      Left            =   5040
      TabIndex        =   13
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "WIS"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   4
      Left            =   4080
      TabIndex        =   12
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "INT"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   3
      Left            =   3120
      TabIndex        =   11
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "CON"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   2
      Left            =   2160
      TabIndex        =   10
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "DEX"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   1
      Left            =   1200
      TabIndex        =   9
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label lblStat 
      Alignment       =   2  'Center
      Caption         =   "STR"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   15.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   0
      Left            =   240
      TabIndex        =   8
      Top             =   2880
      Width           =   855
   End
End
Attribute VB_Name = "frmNew"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCancel_Click()
    Me.Hide
End Sub

Private Sub cmdStartGame_Click()
    Set ChAr = New CCharacter
    For I = 0 To 5
        ChAr.SetActAb Int(I), lbrStats(I).Value1
    Next I
    For I = optRace.LBound To optRace.UBound
        If optRace(I).Value = True Then
            ChAr.Race = Int(I)
            Exit For
        End If
    Next I
        
    GameRunning = True
    Me.Hide
    
End Sub

Private Sub Command1_Click()
    ReRollStats
End Sub

Private Sub Form_Load()
    For I = 0 To 5
        With lbrStats(I)
            .Min1 = 1
            .Min2 = 1
            .Max1 = 20
            .Max2 = 20
        End With
    Next I
    ReRollStats
    optRace(0).Value = True
    optClass(0).Value = True
End Sub

Private Sub ReRollStats()
    For I = 0 To 5
        With lbrStats(I)
            .Value1 = Roll(4, 6, True)
            .Value2 = .Value1
        End With
    Next I
    For I = optRace.LBound To optRace.UBound
        If optRace(I).Value = True Then
            Select Case I
                Case 1: ChangeStat aCon, 2: ChangeStat aCha, -2
                Case 2: ChangeStat aDex, 2: ChangeStat aCon, -2
                Case 3: ChangeStat aDex, 2: ChangeStat aStr, -2
            End Select
        End If
    Next I
End Sub

Private Sub ChangeStat(Index As EnumAbilities, Amount As Integer)
    With lbrStats(Index)
        .Value1 = .Value1 + Amount
        .Value2 = .Value1
    End With
End Sub

Private Sub RemoveAbilityBonuses(NewRace As Integer)
    Static OldRace As EnumRaces
    Select Case OldRace
        Case 1: ChangeStat aCon, -2: ChangeStat aCha, 2
        Case 2: ChangeStat aDex, -2: ChangeStat aCon, 2
        Case 3: ChangeStat aDex, -2: ChangeStat aStr, 2
    End Select
    OldRace = NewRace
End Sub

Private Sub optRace_Click(Index As Integer)
    RemoveAbilityBonuses Index
    Select Case Index
        Case 1: ChangeStat aCon, 2: ChangeStat aCha, -2
        Case 2: ChangeStat aDex, 2: ChangeStat aCon, -2
        Case 3: ChangeStat aDex, 2: ChangeStat aStr, -2
    End Select
End Sub
