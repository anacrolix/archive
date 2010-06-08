VERSION 5.00
Begin VB.Form frmStepper 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Stepper Settings"
   ClientHeight    =   3105
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2850
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3105
   ScaleWidth      =   2850
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtEquivSpeed 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   2280
      TabIndex        =   10
      Text            =   "71"
      Top             =   2280
      Width           =   495
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Trigger on player speeds >"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   2280
      Width           =   2175
   End
   Begin VB.CheckBox chkIgnoreBattleSign 
      Caption         =   "Ignore battle sign"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   2040
      Width           =   1935
   End
   Begin VB.CheckBox chkIgnoreDifAltList 
      Caption         =   "Ignore different Z list"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1800
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin VB.CheckBox chkIgnoreSafeList 
      Caption         =   "Ignore safe list"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1560
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.TextBox txtSitDir 
      Height          =   285
      Left            =   1560
      TabIndex        =   6
      Top             =   1200
      Width           =   1215
   End
   Begin VB.TextBox txtSafeDir 
      Height          =   285
      Left            =   1560
      TabIndex        =   5
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdSetSitSpot 
      Caption         =   "Set sit spot"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   1095
   End
   Begin VB.CommandButton cmdSetSafeSpot 
      Caption         =   "Set safe spot"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1095
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   960
      TabIndex        =   0
      Top             =   2640
      Width           =   975
   End
   Begin VB.Label Label2 
      Caption         =   "Sit -> Safe direction:"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   1200
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Safe -> Sit direction:"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label lblSitSpotCoords 
      Caption         =   "xxxxx, yyyyy, zz"
      Height          =   255
      Left            =   1320
      TabIndex        =   4
      Top             =   840
      Width           =   2175
   End
   Begin VB.Label lblSafeSpotCoords 
      Caption         =   "xxxxx, yyyyy, zz"
      Height          =   255
      Left            =   1320
      TabIndex        =   3
      Top             =   120
      Width           =   2295
   End
End
Attribute VB_Name = "frmStepper"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Const DEFAULT_PLAYER_SPEED = 71

Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub cmdSetSafeSpot_Click()
    If IsGameActive = False Then Exit Sub
    UpdateCharMem
    With charMem.char(GetPlayerIndex)
        safeX = .x
        safeY = .y
        safeZ = .z
    End With
End Sub

Private Sub cmdSetSitSpot_Click()
    If IsGameActive = False Then Exit Sub
    UpdateCharMem
    With charMem.char(GetPlayerIndex)
        sitX = .x
        sitY = .y
        sitZ = .z
    End With
End Sub

Private Sub Form_Load()
    txtEquivSpeed = DEFAULT_PLAYER_SPEED
End Sub

Private Sub txtEquivSpeed_Change()
    TextBox_BoundStr txtEquivSpeed, 0, INT_MAX, DEFAULT_PLAYER_SPEED
End Sub

Private Sub txtEquivSpeed_GotFocus()
    TextBox_SelectAll txtEquivSpeed
End Sub

Private Sub txtSafeDir_GotFocus()
    TextBox_SelectAll txtSafeDir
End Sub

Private Sub txtSafeDir_LostFocus()
    TextBox_ForceDir txtSafeDir
End Sub

Private Sub txtSitDir_GotFocus()
    TextBox_SelectAll txtSitDir
End Sub

Private Sub txtSitDir_LostFocus()
    TextBox_ForceDir txtSitDir
End Sub
