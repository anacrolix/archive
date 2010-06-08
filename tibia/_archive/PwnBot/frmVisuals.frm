VERSION 5.00
Begin VB.Form frmVisuals 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Visual Settings"
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2085
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2400
   ScaleWidth      =   2085
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkShowNames 
      Caption         =   "Always show names"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1560
      Width           =   1935
   End
   Begin VB.CheckBox chkAllAddonsEveryone 
      Caption         =   "All Addons - Everyone"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   2175
   End
   Begin VB.CheckBox chkAllAddonsParty 
      Caption         =   "All Addons - Party"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1080
      Width           =   2055
   End
   Begin VB.CheckBox chkAllAddonsPlayer 
      Caption         =   "All Addons - Self"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Value           =   1  'Checked
      Width           =   1935
   End
   Begin VB.CheckBox chkLightEveryone 
      Caption         =   "Full Light - Everyone"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin VB.CheckBox chkLightPlayer 
      Caption         =   "Full Light - Player"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.CheckBox chkShowlInvisible 
      Caption         =   "Show Invisible"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Value           =   1  'Checked
      Width           =   1455
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   1920
      Width           =   855
   End
End
Attribute VB_Name = "frmVisuals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub FormSettingsIni(save As Boolean)
    ControlSettingsIni save, Me.chkShowlInvisible, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkLightPlayer, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkLightEveryone, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkAllAddonsParty, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkAllAddonsPlayer, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkAllAddonsEveryone, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkShowNames, BotIniPath, Me.name
End Sub

Private Sub chk1_Click()
    ModifyTibiaCode
End Sub

Private Sub chkShowNames_Click()
    ModifyTibiaCode
End Sub

Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub
