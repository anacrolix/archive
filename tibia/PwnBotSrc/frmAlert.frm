VERSION 5.00
Begin VB.Form frmAlert 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Alert Settings"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2595
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   2595
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkIgnoreOfflevelSafeList 
      Caption         =   "Ignore Offlevel Safe  list"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1560
      Width           =   2415
   End
   Begin VB.CheckBox chkShowReasonsInClient 
      Caption         =   "Show reasons in client"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   2040
      Width           =   2175
   End
   Begin VB.CheckBox chkBeep 
      Caption         =   "Beep on Alert"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1800
      Width           =   1935
   End
   Begin VB.Timer tmrAlert 
      Interval        =   1000
      Left            =   2160
      Top             =   2160
   End
   Begin VB.CheckBox chkIgnoreSafeList 
      Caption         =   "Ignore Safe list"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1320
      Width           =   2175
   End
   Begin VB.TextBox txtLevelsBelow 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   1200
      TabIndex        =   4
      Text            =   "0"
      Top             =   960
      Width           =   495
   End
   Begin VB.TextBox txtLevelsAbove 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   1200
      TabIndex        =   3
      Text            =   "0"
      Top             =   600
      Width           =   495
   End
   Begin VB.CheckBox chkIgnoreMonsters 
      Caption         =   "Ignore Monsters"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Width           =   2535
   End
   Begin VB.CheckBox chkOnlyUseAlwaysList 
      Caption         =   "Only use the ""Always alert"" list"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   840
      TabIndex        =   0
      Top             =   3120
      Width           =   975
   End
   Begin VB.Label Label3 
      Caption         =   "Alert reasons:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   2280
      Width           =   975
   End
   Begin VB.Label lblAlertReasons 
      Height          =   495
      Left            =   120
      TabIndex        =   9
      Top             =   2520
      Width           =   2415
   End
   Begin VB.Label Label2 
      Caption         =   "Levels below"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   960
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Levels above"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   600
      Width           =   975
   End
End
Attribute VB_Name = "frmAlert"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdHide_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    chkOnlyUseAlwaysList = ReadFromINI(BotIniPath, "alert settings", "only on always", 0)
    chkIgnoreMonsters = ReadFromINI(BotIniPath, "alert settings", "ignore monsters", 1)
    txtLevelsAbove = ReadFromINI(BotIniPath, "alert settings", "levels above", 0)
    txtLevelsBelow = ReadFromINI(BotIniPath, "alert settings", "levels below", 0)
    chkIgnoreSafeList = ReadFromINI(BotIniPath, "alert settings", "ignore safe list", 1)
    chkBeep = ReadFromINI(BotIniPath, "alert settings", "beep on alert", 1)
    chkShowReasonsInClient = ReadFromINI(BotIniPath, "alert settings", "show reasons in client", 0)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    WriteToINI BotIniPath, "alert settings", "only on always", chkOnlyUseAlwaysList
    WriteToINI BotIniPath, "alert settings", "ignore monsters", chkIgnoreMonsters
    WriteToINI BotIniPath, "alert settings", "levels above", txtLevelsAbove
    WriteToINI BotIniPath, "alert settings", "levels below", txtLevelsBelow
    WriteToINI BotIniPath, "alert settings", "ignore safe list", chkIgnoreSafeList
    WriteToINI BotIniPath, "alert settings", "beep on alert", chkBeep
    WriteToINI BotIniPath, "alert settings", "show reasons in client", chkShowReasonsInClient
End Sub

Private Sub tmrAlert_Timer()
    If alertOn And chkBeep Then Beep 400, 100
End Sub

Private Sub txtLevelsAbove_Change()
    TextBox_BoundStr txtLevelsAbove, 0, 15, 0
End Sub

Private Sub txtLevelsAbove_GotFocus()
    TextBox_SelectAll txtLevelsAbove
End Sub

Private Sub txtLevelsBelow_Change()
    TextBox_BoundStr txtLevelsBelow, 0, 15, 0
End Sub

Private Sub txtLevelsBelow_GotFocus()
    TextBox_SelectAll txtLevelsBelow
End Sub
