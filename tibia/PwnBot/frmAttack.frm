VERSION 5.00
Begin VB.Form frmAttack 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Attack Settings"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2160
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   2160
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdIgnoreCurrent 
      Caption         =   "Ignore Current Target"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1440
      Width           =   1815
   End
   Begin VB.TextBox txtStopHp 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   1440
      TabIndex        =   7
      Text            =   "5"
      Top             =   1080
      Width           =   495
   End
   Begin VB.CheckBox chkStopHp 
      Caption         =   "Stop if hp% < "
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1080
      Width           =   1815
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   600
      TabIndex        =   5
      Top             =   1800
      Width           =   975
   End
   Begin VB.CheckBox chkIgnoreList 
      Caption         =   "Use Ignore List"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   2175
   End
   Begin VB.TextBox txtRange 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   1440
      TabIndex        =   2
      Text            =   "5"
      Top             =   120
      Width           =   495
   End
   Begin VB.CheckBox chkLimitRange 
      Caption         =   "Limit Range"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1215
   End
   Begin VB.CheckBox chkIgnoreMonsters 
      Caption         =   "Ignore Monsters"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   600
      Width           =   2295
   End
   Begin VB.CheckBox chkClosest 
      Caption         =   "Closest"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   2175
   End
End
Attribute VB_Name = "frmAttack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub cmdIgnoreCurrent_Click()
    UpdateCharMem
    If charMem.followID <> 0 Then
        attack_ignore_id = charMem.followID
    ElseIf charMem.attackID <> 0 Then
        attack_ignore_id = charMem.attackID
    End If
End Sub

Private Sub FormSettingsIni(save As Boolean)
    ControlSettingsIni save, Me.chkLimitRange, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtRange, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkClosest, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkIgnoreMonsters, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkIgnoreList, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkStopHp, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtStopHp, BotIniPath, Me.name
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub

Private Sub txtRange_Change()
    TextBox_ForceBoundedLong txtRange, 1, 9, 5
End Sub

Private Sub txtRange_GotFocus()
    TextBox_SelectAll txtRange
End Sub

Private Sub txtStopHp_Change()
    TextBox_ForceBoundedLong txtStopHp, 0, 100, 25
End Sub

Private Sub txtStopHp_GotFocus()
    TextBox_SelectAll txtStopHp
End Sub
