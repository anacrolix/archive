VERSION 5.00
Begin VB.Form frmSpell 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Spell Settings"
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3120
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2400
   ScaleWidth      =   3120
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fraRuneHand 
      Caption         =   "Rune Hand"
      Height          =   615
      Left            =   120
      TabIndex        =   11
      Top             =   1680
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
      Height          =   255
      Left            =   1680
      TabIndex        =   10
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CheckBox chkCastSpell 
      Caption         =   "Cast spell"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1320
      Width           =   1335
   End
   Begin VB.TextBox txtSpellWords 
      Height          =   285
      Left            =   120
      TabIndex        =   1
      Text            =   "utevo gran lux"
      Top             =   360
      Width           =   2295
   End
   Begin VB.TextBox txtRuneWords 
      Height          =   285
      Left            =   120
      TabIndex        =   4
      Text            =   "adura vita"
      Top             =   960
      Width           =   2295
   End
   Begin VB.TextBox txtRuneMana 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   2520
      TabIndex        =   3
      Text            =   "400"
      Top             =   960
      Width           =   495
   End
   Begin VB.TextBox txtSpellMana 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   2520
      TabIndex        =   2
      Text            =   "500"
      Top             =   360
      Width           =   495
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   2040
      TabIndex        =   0
      Top             =   1800
      Width           =   735
   End
   Begin VB.Label Label4 
      Caption         =   "Mana"
      Height          =   255
      Left            =   2520
      TabIndex        =   8
      Top             =   720
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "Mana"
      Height          =   255
      Left            =   2520
      TabIndex        =   7
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label2 
      Caption         =   "Rune words"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   720
      Width           =   2295
   End
   Begin VB.Label Label1 
      Caption         =   "Spell words"
      Height          =   255
      Left            =   120
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

Private Sub txtRuneMana_Change()
    TextBox_BoundStr txtRuneMana, 1, INT_MAX, 400
End Sub

Private Sub txtSpellMana_Change()
    TextBox_BoundStr txtSpellMana, 1, INT_MAX, 500
End Sub

Private Sub txtSpellMana_GotFocus()
    TextBox_SelectAll txtSpellMana
End Sub

Private Sub txtSpellWords_GotFocus()
    TextBox_SelectAll txtSpellWords
End Sub
