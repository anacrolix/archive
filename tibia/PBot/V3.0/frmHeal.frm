VERSION 5.00
Begin VB.Form frmHeal 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Heal"
   ClientHeight    =   3465
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2760
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   231
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   184
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer 
      Left            =   2400
      Top             =   0
   End
   Begin VB.OptionButton optSpell 
      BackColor       =   &H00000000&
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
      Height          =   375
      Left            =   1920
      Style           =   1  'Graphical
      TabIndex        =   12
      Top             =   840
      Width           =   735
   End
   Begin VB.OptionButton optRune 
      BackColor       =   &H00000000&
      Caption         =   "Rune"
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
      Left            =   1920
      Style           =   1  'Graphical
      TabIndex        =   11
      Top             =   360
      Value           =   -1  'True
      Width           =   735
   End
   Begin VB.CommandButton btnOk 
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
      TabIndex        =   10
      Top             =   3000
      Width           =   855
   End
   Begin VB.CheckBox chIh 
      BackColor       =   &H00000000&
      Caption         =   "IH"
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
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   1080
      Width           =   495
   End
   Begin VB.CheckBox chUh 
      BackColor       =   &H00000000&
      Caption         =   "UH"
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
      Left            =   960
      Style           =   1  'Graphical
      TabIndex        =   7
      Top             =   1080
      Width           =   495
   End
   Begin VB.TextBox txtHP 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   480
      TabIndex        =   6
      Text            =   "0"
      Top             =   120
      Width           =   615
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
      Left            =   1920
      TabIndex        =   3
      Text            =   "0"
      Top             =   2520
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
      Left            =   480
      TabIndex        =   2
      Top             =   2520
      Width           =   1335
   End
   Begin VB.CheckBox chRuneH 
      BackColor       =   &H00000000&
      Caption         =   "Rune Heal"
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
      TabIndex        =   1
      Top             =   600
      Width           =   1095
   End
   Begin VB.CheckBox chSpellH 
      BackColor       =   &H00000000&
      Caption         =   "Spell Heal"
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
      TabIndex        =   0
      Top             =   1800
      Width           =   1095
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Try First"
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
      Left            =   1800
      TabIndex        =   13
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "HP:"
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
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   735
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
      Left            =   1920
      TabIndex        =   5
      Top             =   2280
      Width           =   735
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
      Left            =   480
      TabIndex        =   4
      Top             =   2280
      Width           =   1335
   End
End
Attribute VB_Name = "frmHeal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private intMana As Integer
Private intHP As Integer
Private Sub btnOk_Click()
    Me.Hide
End Sub

Private Sub Timer_Timer()

    Dim lngx As Long
    Dim lngy As Long
    Dim lngz As Long
    
    Memory Thwnd, adrHitP, HitPoints, 2, RMem
    Memory Thwnd, adrMana, Mana, 2, RMem
    
    If chSpellH.Value = Checked And HitPoints <= txtHP And Mana >= txtMana.Text And optSpell.Value = True Then
        SayStuff txtSpell
        Pause 500
    End If
    Memory Thwnd, adrHitP, HitPoints, 2, RMem
    If chRuneH.Value = Checked And HitPoints <= txtHP Then
        Memory Thwnd, adrXPos, lngx, 2, RMem
        Memory Thwnd, adrYPos, lngy, 2, RMem
        Memory Thwnd, adrZPos, lngz, 2, RMem
        If chIh.Value = Checked Then ShootRune &H8D9, lngx, lngy, lngz
    End If
    Memory Thwnd, adrHitP, HitPoints, 2, RMem
    If chRuneH.Value = Checked And HitPoints <= txtHP Then
        Memory Thwnd, adrXPos, lngx, 2, RMem
        Memory Thwnd, adrYPos, lngy, 2, RMem
        Memory Thwnd, adrZPos, lngz, 2, RMem
        If chUh.Value = Checked Then ShootRune &H8E1, lngx, lngy, lngz
    End If
    Memory Thwnd, adrHitP, HitPoints, 2, RMem
    If chSpellH.Value = Checked And HitPoints <= txtHP And Mana >= txtMana.Text And optRune.Value = True Then
        SayStuff txtSpell
    End If
End Sub

Private Sub txtHP_Change()
    If txtHP = "" Then txtHP = "0"
    IntOnly txtHP, intHP
End Sub

Private Sub txtMana_Change()
    If txtHP = "" Then txtHP = "0"
    IntOnly txtMana, intMana
End Sub
