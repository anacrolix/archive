VERSION 5.00
Begin VB.Form frmRune 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Rune Maker"
   ClientHeight    =   5760
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5760
   ControlBox      =   0   'False
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   384
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   384
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   375
      Left            =   4560
      TabIndex        =   60
      Top             =   5160
      Width           =   975
   End
   Begin VB.Timer Timer1 
      Interval        =   1000
      Left            =   5160
      Top             =   120
   End
   Begin VB.Timer Timer 
      Left            =   5280
      Top             =   0
   End
   Begin VB.OptionButton optSim 
      BackColor       =   &H00000000&
      Caption         =   "Simple"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   59
      Top             =   4320
      Width           =   1335
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   10
      Left            =   2760
      TabIndex        =   56
      Top             =   4800
      Width           =   735
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   10
      Left            =   1320
      TabIndex        =   55
      Top             =   4800
      Width           =   1335
   End
   Begin VB.OptionButton optAdv 
      BackColor       =   &H00000000&
      Caption         =   "Advanced"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   54
      Top             =   120
      Value           =   -1  'True
      Width           =   1335
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
      Left            =   2280
      TabIndex        =   53
      Top             =   5280
      Width           =   1215
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   9
      Left            =   2760
      TabIndex        =   28
      Top             =   3840
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   8
      Left            =   2760
      TabIndex        =   25
      Top             =   3480
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   7
      Left            =   2760
      TabIndex        =   22
      Top             =   3120
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   6
      Left            =   2760
      TabIndex        =   19
      Top             =   2760
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   5
      Left            =   2760
      TabIndex        =   16
      Top             =   2400
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   4
      Left            =   2760
      TabIndex        =   13
      Top             =   2040
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   3
      Left            =   2760
      TabIndex        =   10
      Top             =   1680
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   2
      Left            =   2760
      TabIndex        =   7
      Top             =   1320
      Width           =   735
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   9
      Left            =   5280
      TabIndex        =   29
      Text            =   "10"
      Top             =   3840
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   8
      Left            =   5280
      TabIndex        =   26
      Text            =   "10"
      Top             =   3480
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   7
      Left            =   5280
      TabIndex        =   23
      Text            =   "10"
      Top             =   3120
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   6
      Left            =   5280
      TabIndex        =   20
      Text            =   "10"
      Top             =   2760
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   5
      Left            =   5280
      TabIndex        =   17
      Text            =   "10"
      Top             =   2400
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   4
      Left            =   5280
      TabIndex        =   14
      Text            =   "10"
      Top             =   2040
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   3
      Left            =   5280
      TabIndex        =   11
      Text            =   "10"
      Top             =   1680
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   2
      Left            =   5280
      TabIndex        =   8
      Text            =   "10"
      Top             =   1320
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   1
      Left            =   5280
      TabIndex        =   5
      Text            =   "10"
      Top             =   960
      Width           =   375
   End
   Begin VB.TextBox txtPriority 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   0
      Left            =   5280
      TabIndex        =   2
      Text            =   "10"
      Top             =   600
      Width           =   375
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   9
      Left            =   1320
      TabIndex        =   27
      Top             =   3840
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   8
      Left            =   1320
      TabIndex        =   24
      Top             =   3480
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   0
      Left            =   1320
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   1
      Left            =   1320
      TabIndex        =   3
      Top             =   960
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   2
      Left            =   1320
      TabIndex        =   6
      Top             =   1320
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   3
      Left            =   1320
      TabIndex        =   9
      Top             =   1680
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   4
      Left            =   1320
      TabIndex        =   12
      Top             =   2040
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   5
      Left            =   1320
      TabIndex        =   15
      Top             =   2400
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   6
      Left            =   1320
      TabIndex        =   18
      Top             =   2760
      Width           =   1335
   End
   Begin VB.TextBox txtSpell 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   7
      Left            =   1320
      TabIndex        =   21
      Top             =   3120
      Width           =   1335
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   0
      Left            =   2760
      TabIndex        =   1
      Top             =   600
      Width           =   735
   End
   Begin VB.TextBox txtMana 
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Index           =   1
      Left            =   2760
      TabIndex        =   4
      Top             =   960
      Width           =   735
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Mana"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   2760
      TabIndex        =   58
      Top             =   4560
      Width           =   735
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Spell"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   1320
      TabIndex        =   57
      Top             =   4560
      Width           =   1335
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Priority"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   5040
      TabIndex        =   52
      Top             =   360
      Width           =   855
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   9
      Left            =   3600
      TabIndex        =   51
      Top             =   3840
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   8
      Left            =   3600
      TabIndex        =   50
      Top             =   3480
      Width           =   1695
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 9"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   9
      Left            =   240
      TabIndex        =   49
      Top             =   3480
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 10"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   8
      Left            =   240
      TabIndex        =   48
      Top             =   3840
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   47
      Top             =   600
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 2"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   46
      Top             =   960
      Width           =   2175
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   3600
      TabIndex        =   45
      Top             =   600
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   3600
      TabIndex        =   44
      Top             =   960
      Width           =   1695
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 3"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   43
      Top             =   1320
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 4"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   240
      TabIndex        =   42
      Top             =   1680
      Width           =   2175
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   3600
      TabIndex        =   41
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   3600
      TabIndex        =   40
      Top             =   1680
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   3600
      TabIndex        =   39
      Top             =   2040
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   3600
      TabIndex        =   38
      Top             =   2400
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   3600
      TabIndex        =   37
      Top             =   2760
      Width           =   1695
   End
   Begin VB.Label lblRunes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Blanks Left: "
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   3600
      TabIndex        =   36
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 5"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   240
      TabIndex        =   35
      Top             =   2040
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 6"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   240
      TabIndex        =   34
      Top             =   2400
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 7"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   240
      TabIndex        =   33
      Top             =   2760
      Width           =   2175
   End
   Begin VB.Label lblBP 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Backpack 8"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   240
      TabIndex        =   32
      Top             =   3120
      Width           =   2175
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Spell"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   1320
      TabIndex        =   31
      Top             =   360
      Width           =   1335
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Mana"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   2760
      TabIndex        =   30
      Top             =   360
      Width           =   735
   End
End
Attribute VB_Name = "frmRune"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private strMana(10) As Integer
Private strPrior(9) As Integer
Private RPos As Integer
Private Rune(9, 29) As Boolean
Private items As Long
Private items2 As Long
Private TotalRune As Long
Private C1 As Integer
Private C2 As Integer
Private C3 As Integer
Private bpopen As Long
Private ltemp As Long
Private Sub Command1_Click()
    Me.Hide
End Sub

Private Sub Timer_Timer()
    Dim C4 As Integer
    Dim TempLong As Integer
    Memory Thwnd, adrMana, Mana, 2, RMem
    If optAdv = True Then
        If txtSpell(RPos).Text <> "" And txtMana(RPos).Text <> "" Then
            If Mana >= txtMana(RPos).Text Then
                For C3 = 0 To 20
                    If Rune(RPos, C3) = True Then Exit For
                    If C3 = 20 Then Exit For
                Next
                If C1 <> 20 Then
                    Do
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                        MoveItem items2, &H5, &H0, &HA, &H0
                        Pause 200
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                    Loop Until items2 = 0
                    TempLong = &H40 + RPos
                    MoveItem &H8D4, TempLong, C3, &H5, &H0
                    C4 = 0
                    Do
                        Pause 100
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                        C4 = C4 + 1
                    Loop Until items2 = &H8D4 Or C4 >= 15
                    If items2 = &H8D4 Then
                        Do
                            SayStuff txtSpell(RPos).Text
                            Pause 300
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                        Loop Until items2 <> &H8D4
                        Do
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                            MoveItem items2, &H5, &H0, TempLong, &H0
                            Pause 200
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                        Loop Until items2 = 0
                    End If
                    Do
                        Memory Thwnd, adrAmmo, items2, 2, RMem
                        MoveItem items2, &HA, &H0, &H5, &H0
                        Pause 200
                        Memory Thwnd, adrAmmo, items2, 2, RMem
                    Loop Until 0 = items2
                    CheckBP
                    Pause 200
                End If
            End If
        End If
    Else
        If txtSpell(10).Text <> "" And txtMana(10).Text <> "" Then
            If Mana >= txtMana(10).Text Then
                ltemp = 0
                For C1 = 0 To 9
                    Memory Thwnd, adrBPOpen + (BPDist * C1), bpopen, 1, RMem
                    If bpopen = 1 Then
                        Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
                        For C2 = 0 To items - 1
                            Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), ltemp, 2, RMem
                            If ltemp = &H8D4 Then Exit For
                        Next
                        If ltemp = &H8D4 Then Exit For
                    End If
                Next
                If ltemp = &H8D4 Then
                    Do
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                        MoveItem items2, &H5, &H0, &HA, &H0
                        Pause 200
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                    Loop Until items2 = 0
                    TempLong = &H40 + C1
                    MoveItem &H8D4, TempLong, C2, &H5, &H0
                    C4 = 0
                    Do
                        Pause 100
                        Memory Thwnd, adrRightHand, items2, 2, RMem
                        C4 = C4 + 1
                    Loop Until items2 = &H8D4 Or C4 >= 15
                    If items2 = &H8D4 Then
                        Do
                            SayStuff txtSpell(10).Text
                            Pause 300
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                        Loop Until items2 <> &H8D4
                        Do
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                            MoveItem items2, &H5, &H0, TempLong, &H0
                            Pause 200
                            Memory Thwnd, adrRightHand, items2, 2, RMem
                        Loop Until items2 = 0
                    End If
                    Do
                        Memory Thwnd, adrAmmo, items2, 2, RMem
                        MoveItem items2, &HA, &H0, &H5, &H0
                        Pause 200
                        Memory Thwnd, adrAmmo, items2, 2, RMem
                    Loop Until 0 = items2
                    CheckBP
                    Pause 200
                End If
            End If
        End If
    End If
End Sub

Private Sub Timer1_Timer()
    CheckBP
End Sub

Private Sub txtMana_Change(Index As Integer)
    IntOnly txtMana(Index), strMana(Index)
End Sub

Private Sub txtPriority_Change(Index As Integer)
    IntOnly txtPriority(Index), strPrior(Index)
    If txtPriority(Index).Text = "" Then txtPriority(Index).Text = "0"
    If txtPriority(Index).Text > 10 Or txtPriority(Index).Text < 0 Then txtPriority(Index).Text = "0"
End Sub

Private Function DisableBP(Index As Integer)
    frmRune.lblBP(Index).Enabled = False
    frmRune.lblRunes(Index).Enabled = False
    frmRune.txtSpell(Index).Enabled = False
    frmRune.txtSpell(Index).Text = ""
    frmRune.txtMana(Index).Enabled = False
    frmRune.txtMana(Index).Text = ""
    frmRune.txtPriority(Index).Enabled = False
    frmRune.txtPriority(Index).Text = "10"
End Function

Private Function EnableBP(Index As Integer)
    frmRune.lblBP(Index).Enabled = True
    frmRune.lblRunes(Index).Enabled = True
    frmRune.txtSpell(Index).Enabled = True
    frmRune.txtMana(Index).Enabled = True
    frmRune.txtPriority(Index).Enabled = True
End Function

Private Function CheckBP()
    Dim C5 As Integer
    Dim C6 As Integer
    TotalRune = 0
    For C5 = 0 To 9
        items = 0
        Memory Thwnd, adrBPOpen + (BPDist * C5), bpopen, 1, RMem
        If bpopen = 1 Then
            Runes = 0
            Memory Thwnd, adrBPItems + (BPDist * C5), items, 1, RMem
            EnableBP C5
            For C6 = 0 To items - 1
                DoEvents
                Memory Thwnd, adrBPItem + (BPDist * C5) + (12 * C6), ltemp, 2, RMem
                If ltemp = &H8D4 Then
                    Rune(C5, C6) = True
                    Runes = Runes + 1
                    TotalRune = TotalRune + 1
                Else
                    Rune(C5, C6) = False
                End If
            Next
            For C6 = items To 19
                Rune(C5, C6) = False
            Next
            lblRunes(C5).Caption = "Blanks Left: " & Runes & "/" & items
            If Runes = 0 Then
                txtSpell(C5).Text = ""
                txtMana(C5).Text = ""
                txtPriority(C5).Text = "0"
            End If
        Else
            DisableBP C5
            lblRunes(C5).Caption = "Blanks Left: "
        End If
    Next
    For C5 = 1 To 10
        For C6 = 0 To 8
            If txtPriority(C6) = C5 And txtSpell(C6).Text <> "" Then Exit For
        Next
        If txtPriority(C6) = C5 And txtSpell(C6).Text <> "" Then Exit For
    Next
    If TotalRune = 0 And Check1.Value = Checked Then
        Check1.Value = Unchecked
        frmMain.sckS.Close
        frmMain.sckC1.Close
        frmMain.mnuActive.Checked = False
        Valid
    End If
    RPos = C6
End Function
