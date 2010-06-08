VERSION 5.00
Begin VB.Form frmAttackSetup 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Attack Reaction - Setup"
   ClientHeight    =   4560
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3015
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4560
   ScaleWidth      =   3015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   0
      ItemData        =   "frmAttackSetup.frx":0000
      Left            =   120
      List            =   "frmAttackSetup.frx":0016
      Style           =   2  'Dropdown List
      TabIndex        =   8
      Top             =   120
      Width           =   2775
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Ok"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   960
      TabIndex        =   7
      Top             =   4080
      Width           =   1095
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   1
      ItemData        =   "frmAttackSetup.frx":0046
      Left            =   120
      List            =   "frmAttackSetup.frx":005C
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   600
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   2
      ItemData        =   "frmAttackSetup.frx":008C
      Left            =   120
      List            =   "frmAttackSetup.frx":00A2
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   1080
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   3
      ItemData        =   "frmAttackSetup.frx":00D2
      Left            =   120
      List            =   "frmAttackSetup.frx":00E8
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   1560
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   4
      ItemData        =   "frmAttackSetup.frx":0118
      Left            =   120
      List            =   "frmAttackSetup.frx":012E
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   2040
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   5
      ItemData        =   "frmAttackSetup.frx":015E
      Left            =   120
      List            =   "frmAttackSetup.frx":0174
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   2520
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   6
      ItemData        =   "frmAttackSetup.frx":01A4
      Left            =   120
      List            =   "frmAttackSetup.frx":01BA
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   3000
      Width           =   2775
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Index           =   7
      ItemData        =   "frmAttackSetup.frx":01EA
      Left            =   120
      List            =   "frmAttackSetup.frx":0200
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   3480
      Width           =   2775
   End
End
Attribute VB_Name = "frmAttackSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Dim C1 As Integer
    Me.Hide
    For C1 = 0 To 7
            frmAttack.MoveX(C1).Visible = False
            frmAttack.MoveY(C1).Visible = False
            frmAttack.MoveXl(C1).Visible = False
            frmAttack.MoveYl(C1).Visible = False
            frmAttack.Talklbl(C1).Visible = False
            frmAttack.Talktxt(C1).Visible = False
            frmAttack.PauseBeg(C1).Visible = False
            frmAttack.PauseSec(C1).Visible = False
            frmAttack.Pausetxt(C1).Visible = False
            frmAttack.SBotlbl(C1).Visible = False
            frmAttack.Beeplbl(C1).Visible = False
            frmAttack.btnHere(C1).Visible = False
    Next
    For C1 = 0 To 7
        If Combo1(C1).Text = "Move To" Then
            frmAttack.MoveX(C1).Visible = True
            frmAttack.MoveY(C1).Visible = True
            frmAttack.MoveXl(C1).Visible = True
            frmAttack.MoveYl(C1).Visible = True
            frmAttack.btnHere(C1).Visible = True
        ElseIf Combo1(C1).Text = "Talk" Then
            frmAttack.Talklbl(C1).Visible = True
            frmAttack.Talktxt(C1).Visible = True
        ElseIf Combo1(C1).Text = "Pause" Then
            frmAttack.PauseBeg(C1).Visible = True
            frmAttack.PauseSec(C1).Visible = True
            frmAttack.Pausetxt(C1).Visible = True
        ElseIf Combo1(C1).Text = "Stop Bot" Then
            frmAttack.SBotlbl(C1).Visible = True
        ElseIf Combo1(C1).Text = "Beep" Then
            frmAttack.Beeplbl(C1).Visible = True
        End If
    Next
End Sub

