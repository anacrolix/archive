VERSION 5.00
Begin VB.Form frmStepper 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Stepper Settings"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2850
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   2850
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtLevelsBelow 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   2160
      TabIndex        =   18
      Text            =   "1"
      Top             =   2760
      Width           =   495
   End
   Begin VB.TextBox txtLevelsAbove 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   840
      TabIndex        =   15
      Text            =   "1"
      Top             =   2760
      Width           =   495
   End
   Begin VB.TextBox txtEquivSpeed 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   2280
      TabIndex        =   10
      Text            =   "71"
      Top             =   2280
      Width           =   495
   End
   Begin VB.CheckBox chkIgnoreMonsters 
      Caption         =   "Ignore monsters"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2520
      Width           =   2655
   End
   Begin VB.CheckBox chkTrigPlayerSpeed 
      Caption         =   "Ignore !=Z player speed <"
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
      Top             =   480
      Width           =   1215
   End
   Begin VB.TextBox txtSafeDir 
      Height          =   285
      Left            =   1560
      TabIndex        =   5
      Top             =   1200
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
      Top             =   3120
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "Z below:"
      Height          =   255
      Left            =   1440
      TabIndex        =   17
      Top             =   2760
      Width           =   615
   End
   Begin VB.Label Label3 
      Caption         =   "Z above:"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   2760
      Width           =   735
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
        lblSafeSpotCoords = "(" & .x & "," & .y & "," & .z & ")"
    End With
    GuessSitDirs
End Sub

Private Sub FormSettingsIni(save As Boolean)
    ControlSettingsIni save, Me.chkIgnoreSafeList, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkIgnoreDifAltList, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkIgnoreBattleSign, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkTrigPlayerSpeed, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtEquivSpeed, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkIgnoreMonsters, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtLevelsAbove, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtLevelsBelow, BotIniPath, Me.name
End Sub

Private Sub GuessSitDirs()
    If safeZ <> sitZ Then Exit Sub
    Dim dir As Long
    dir = Get_TibiaDir_dXdY(sitX - safeX, sitY - safeY)
    If dir < 0 Then Exit Sub
    txtSitDir = Get_CompassStr_TibiaDir(dir)
    dir = Get_TibiaDir_dXdY(safeX - sitX, safeY - sitY)
    txtSafeDir = Get_CompassStr_TibiaDir(dir)
End Sub

Private Sub cmdSetSitSpot_Click()
    If IsGameActive = False Then Exit Sub
    UpdateCharMem
    With charMem.char(GetPlayerIndex)
        sitX = .x
        sitY = .y
        sitZ = .z
        lblSitSpotCoords = "(" & .x & "," & .y & "," & .z & ")"
    End With
    GuessSitDirs
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub

Private Sub txtEquivSpeed_Change()
    TextBox_ForceBoundedLong txtEquivSpeed, 0, INT_MAX, DEFAULT_PLAYER_SPEED
End Sub

Private Sub txtEquivSpeed_GotFocus()
    TextBox_SelectAll txtEquivSpeed
End Sub

Private Sub txtLevelsAbove_Change()
    TextBox_ForceBoundedLong txtLevelsAbove, 0, 15, 1
End Sub

Private Sub txtLevelsAbove_GotFocus()
    TextBox_SelectAll txtLevelsAbove
End Sub

Private Sub txtLevelsBelow_Change()
    TextBox_ForceBoundedLong txtLevelsBelow, 0, 15, 1
End Sub

Private Sub txtLevelsBelow_GotFocus()
    TextBox_SelectAll txtLevelsBelow
End Sub

Private Sub txtSafeDir_GotFocus()
    TextBox_SelectAll txtSafeDir
End Sub

Private Sub txtSafeDir_LostFocus()
    TextBox_ForceDirStr txtSafeDir, ""
End Sub

Private Sub txtSitDir_GotFocus()
    TextBox_SelectAll txtSitDir
End Sub

Private Sub txtSitDir_LostFocus()
    TextBox_ForceDirStr txtSitDir, ""
End Sub
