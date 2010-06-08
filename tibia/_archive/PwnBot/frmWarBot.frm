VERSION 5.00
Begin VB.Form frmWarBot 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "War Bot Settings"
   ClientHeight    =   2490
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3705
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2490
   ScaleWidth      =   3705
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fraCombatMode 
      Caption         =   "Mode"
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Width           =   3495
      Begin VB.OptionButton optCombatMode 
         Caption         =   "Hunt"
         Height          =   255
         Index           =   1
         Left            =   1920
         TabIndex        =   8
         Top             =   240
         Value           =   -1  'True
         Width           =   735
      End
      Begin VB.OptionButton optCombatMode 
         Caption         =   "War"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   735
      End
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   1440
      TabIndex        =   0
      Top             =   2040
      Width           =   855
   End
   Begin VB.Frame fraModeOptions 
      Caption         =   "War"
      Height          =   975
      Index           =   0
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   1695
      Begin VB.TextBox txtUhSelfHp 
         Alignment       =   2  'Center
         Height          =   285
         Index           =   0
         Left            =   1080
         TabIndex        =   6
         Text            =   "80"
         Top             =   240
         Width           =   495
      End
      Begin VB.CheckBox chkUhSelf 
         Caption         =   "UH Self"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Value           =   1  'Checked
         Width           =   975
      End
      Begin VB.CheckBox chkUhFriends 
         Caption         =   "UH Friends"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   5
         Top             =   600
         Width           =   1095
      End
   End
   Begin VB.Frame fraModeOptions 
      Caption         =   "Hunt"
      Height          =   975
      Index           =   1
      Left            =   1920
      TabIndex        =   9
      Top             =   960
      Width           =   1695
      Begin VB.CheckBox chkUhFriends 
         Caption         =   "UH Friends"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   12
         Top             =   600
         Width           =   1095
      End
      Begin VB.TextBox txtUhSelfHp 
         Alignment       =   2  'Center
         Height          =   285
         Index           =   1
         Left            =   1080
         TabIndex        =   11
         Text            =   "30"
         Top             =   240
         Width           =   495
      End
      Begin VB.CheckBox chkUhSelf 
         Caption         =   "UH Self"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   10
         Top             =   240
         Value           =   1  'Checked
         Width           =   975
      End
   End
   Begin VB.Label Label1 
      Caption         =   "All values are percentages of that characters maximum health."
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   0
      Width           =   3495
   End
End
Attribute VB_Name = "frmWarBot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub FormSettingsIni(save As Boolean)
    Dim i As Integer
    For i = optCombatMode.LBound To optCombatMode.UBound
        ControlSettingsIni save, Me.optCombatMode(i), BotIniPath, Me.name, "_" & i
        ControlSettingsIni save, Me.chkUhSelf(i), BotIniPath, Me.name, "_" & i
        ControlSettingsIni save, Me.txtUhSelfHp(i), BotIniPath, Me.name, "_" & i
        ControlSettingsIni save, Me.chkUhFriends(i), BotIniPath, Me.name, "_" & i
    Next i
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub

Private Sub txtUhSelfHp_Change(Index As Integer)
    TextBox_ForceBoundedLong txtUhSelfHp(Index), 1, 100, 50
End Sub

Private Sub txtUhSelfHp_GotFocus(Index As Integer)
    TextBox_SelectAll txtUhSelfHp(Index)
End Sub
