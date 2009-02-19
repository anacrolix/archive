VERSION 5.00
Begin VB.Form frmLogOut 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Log Out Settings"
   ClientHeight    =   2550
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   1605
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2550
   ScaleWidth      =   1605
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtSoul 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   960
      TabIndex        =   7
      Text            =   "5"
      Top             =   600
      Width           =   495
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   255
      Left            =   480
      TabIndex        =   0
      Top             =   2160
      Width           =   615
   End
   Begin VB.CheckBox chkLogByUndeath 
      Caption         =   "Only log by connection timeout"
      Height          =   615
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   1455
   End
   Begin VB.CheckBox chkNoBlanks 
      Caption         =   "No blanks"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   1335
   End
   Begin VB.CheckBox chkSwords 
      Caption         =   "Battle sign"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   1080
      Width           =   1335
   End
   Begin VB.CheckBox chkNoFood 
      Caption         =   "No food"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   1335
   End
   Begin VB.CheckBox chkSoulBelow 
      Caption         =   "Soul <"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   1575
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Log out asap if"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "frmLogOut"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub FormSettingsIni(save As Boolean)
    ControlSettingsIni save, Me.chkNoFood, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkSoulBelow, BotIniPath, Me.name
    ControlSettingsIni save, Me.txtSoul, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkNoBlanks, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkLogByUndeath, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkSoulBelow, BotIniPath, Me.name
    ControlSettingsIni save, Me.chkSwords, BotIniPath, Me.name
End Sub

Private Sub Form_Load()
    FormSettingsIni False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormSettingsIni True
End Sub

Private Sub txtSoul_Change()
    TextBox_ForceBoundedLong txtSoul, 0, 200, 5
End Sub

Private Sub txtSoul_GotFocus()
    TextBox_SelectAll txtSoul
End Sub
