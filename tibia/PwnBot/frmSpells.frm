VERSION 5.00
Begin VB.Form frmSpell 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Spell Settings"
   ClientHeight    =   2025
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4920
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2025
   ScaleWidth      =   4920
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtRuneSoul 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   4320
      TabIndex        =   16
      Text            =   "3"
      Top             =   960
      Width           =   495
   End
   Begin VB.TextBox txtSpellSoul 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   4320
      TabIndex        =   15
      Text            =   "0"
      Top             =   360
      Width           =   495
   End
   Begin VB.Frame fraRuneHand 
      Caption         =   "Rune Hand"
      Height          =   615
      Left            =   1200
      TabIndex        =   11
      Top             =   1320
      Width           =   1575
      Begin VB.OptionButton optRightHand 
         Caption         =   "Right"
         Height          =   255
         Left            =   720
         TabIndex        =   13
         Top             =   240
         Width           =   735
      End
      Begin VB.OptionButton optLeftHand 
         Caption         =   "Left"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   240
         Value           =   -1  'True
         Width           =   615
      End
   End
   Begin VB.CheckBox chkMakeRune 
      Caption         =   "Make runes"
      Height          =   495
      Left            =   120
      TabIndex        =   10
      Top             =   720
      Width           =   975
   End
   Begin VB.TextBox txtSpellWords 
      Height          =   285
      Left            =   1200
      TabIndex        =   1
      Text            =   "utevo gran lux"
      Top             =   360
      Width           =   2295
   End
   Begin VB.TextBox txtRuneWords 
      Height          =   285
      Left            =   1200
      TabIndex        =   4
      Text            =   "adura vita"
      Top             =   960
      Width           =   2295
   End
   Begin VB.TextBox txtRuneMana 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   3600
      TabIndex        =   3
      Text            =   "400"
      Top             =   960
      Width           =   615
   End
   Begin VB.TextBox txtSpellMana 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   3600
      TabIndex        =   2
      Text            =   "500"
      Top             =   360
      Width           =   615
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   1440
      Width           =   735
   End
   Begin VB.CheckBox chkCastSpell 
      Caption         =   "Cast spell"
      Height          =   495
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "Soul"
      Height          =   255
      Left            =   4320
      TabIndex        =   17
      Top             =   720
      Width           =   495
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      Caption         =   "Soul"
      Height          =   255
      Left            =   4320
      TabIndex        =   14
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      Caption         =   "Mana"
      Height          =   255
      Left            =   3600
      TabIndex        =   8
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Mana"
      Height          =   255
      Left            =   3600
      TabIndex        =   7
      Top             =   120
      Width           =   615
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Rune words"
      Height          =   255
      Left            =   1200
      TabIndex        =   6
      Top             =   720
      Width           =   2295
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Spell words"
      Height          =   255
      Left            =   1200
      TabIndex        =   5
      Top             =   120
      Width           =   2295
   End
End
Attribute VB_Name = "frmSpell"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub FormSettingsIni(save As Boolean)
    ControlSettingsIni save, Me.chkCastSpell, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtSpellWords, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtSpellMana, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtSpellSoul, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkMakeRune, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtRuneWords, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtRuneMana, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtRuneSoul, BotIniPath, Me.name
    ControlSettingsIni save, Me.optLeftHand, BotIniPath, Me.name
    ControlSettingsIni save, Me.optRightHand, BotIniPath, Me.name
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub

Private Sub txtRuneMana_Change()
    TextBox_ForceBoundedLong txtRuneMana, 1, INT_MAX, 400
End Sub

Private Sub txtRuneMana_GotFocus()
    TextBox_SelectAll txtRuneMana
End Sub

Private Sub txtRuneSoul_Change()
    TextBox_ForceBoundedLong txtRuneSoul, 0, 200, 3
End Sub

Private Sub txtRuneSoul_GotFocus()
    TextBox_SelectAll txtRuneSoul
End Sub

Private Sub txtRuneWords_GotFocus()
    TextBox_SelectAll txtRuneWords
End Sub

Private Sub txtSpellMana_Change()
    TextBox_ForceBoundedLong txtSpellMana, 1, INT_MAX, 500
End Sub

Private Sub txtSpellMana_GotFocus()
    TextBox_SelectAll txtSpellMana
End Sub

Private Sub txtSpellSoul_Change()
    TextBox_ForceBoundedLong txtSpellSoul, 0, 200, 0
End Sub

Private Sub txtSpellWords_GotFocus()
    TextBox_SelectAll txtSpellWords
End Sub
