VERSION 5.00
Begin VB.Form frmHack 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EruHax 0.1"
   ClientHeight    =   5610
   ClientLeft      =   45
   ClientTop       =   735
   ClientWidth     =   5565
   Icon            =   "frmHack.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5610
   ScaleWidth      =   5565
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdRestartExpHour 
      Caption         =   "Restart"
      Height          =   255
      Left            =   2760
      TabIndex        =   12
      Top             =   1440
      Width           =   735
   End
   Begin VB.Timer timerExpHour 
      Interval        =   3600
      Left            =   2040
      Top             =   120
   End
   Begin VB.CheckBox chkExpHour 
      Caption         =   "Calculate Exp/Hour"
      Height          =   255
      Left            =   2760
      TabIndex        =   9
      Top             =   840
      Value           =   1  'Checked
      Width           =   2535
   End
   Begin VB.CheckBox chkUpdateBattleList 
      Caption         =   "Update Battle List from memory"
      Height          =   255
      Left            =   2760
      TabIndex        =   8
      Top             =   480
      Width           =   2535
   End
   Begin VB.Timer timerBattleList 
      Interval        =   5000
      Left            =   2400
      Top             =   480
   End
   Begin VB.TextBox txtBattleList 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3135
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   7
      Top             =   2400
      Width           =   5295
   End
   Begin VB.CheckBox chkCloseWithTibia 
      Caption         =   "Close EruHax when Tibia exits"
      Height          =   255
      Left            =   2760
      TabIndex        =   6
      Top             =   120
      Value           =   1  'Checked
      Width           =   2535
   End
   Begin VB.Timer timerLight 
      Interval        =   1000
      Left            =   2400
      Top             =   2520
   End
   Begin VB.Frame fraLight 
      Caption         =   "Light"
      Height          =   1335
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   2535
      Begin VB.HScrollBar hscrLightAmount 
         Height          =   255
         LargeChange     =   3
         Left            =   120
         Max             =   15
         TabIndex        =   3
         Top             =   840
         Value           =   9
         Width           =   2295
      End
      Begin VB.CheckBox chkAdjustLight 
         Caption         =   "Adjust Light"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   480
         Value           =   1  'Checked
         Width           =   2055
      End
      Begin VB.Label lblAmountLight 
         Caption         =   "Current Light Level: "
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   240
         Width           =   2055
      End
   End
   Begin VB.CommandButton cmdHackName 
      Caption         =   "Hack Onscreen Name"
      Height          =   495
      Left            =   360
      TabIndex        =   0
      Top             =   1800
      Width           =   2055
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "Exit"
      Height          =   495
      Left            =   2760
      TabIndex        =   5
      Top             =   1800
      Width           =   2055
   End
   Begin VB.Label lblExpHourOutput 
      Caption         =   "20k/hr"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3600
      TabIndex        =   11
      Top             =   1200
      Width           =   1335
   End
   Begin VB.Label lblExpHour 
      Caption         =   "Exp/Hour:"
      Height          =   255
      Left            =   2760
      TabIndex        =   10
      Top             =   1200
      Width           =   735
   End
   Begin VB.Menu mnuIconRight 
      Caption         =   "right"
      Visible         =   0   'False
      Begin VB.Menu mnuIconShow 
         Caption         =   "Show"
      End
      Begin VB.Menu mnuIconExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuMinimizeToTray 
      Caption         =   "Minimize to Tray"
   End
End
Attribute VB_Name = "frmHack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub chkExpHour_Click()
If chkExpHour Then
  startExp = Memory_ReadLong(ADDRESS_EXPERIENCE)
  timePassed = 0
  lblExpHourOutput.Visible = True
Else
  lblExpHourOutput.Visible = False
  expPerHour = 0
  lblExpHourOutput.Caption = ""
End If
End Sub

Private Sub chkUpdateBattleList_Click()
  If chkUpdateBattleList = False Then
    txtBattleList.Text = ""
    txtBattleList.Enabled = False
  Else
    txtBattleList.Enabled = True
  End If
End Sub

Private Sub cmdExit_Click()
End
End Sub

Private Sub cmdHackName_Click()
Call Hack_Name
End Sub

Private Sub cmdRestartExpHour_Click()
  startExp = Memory_ReadLong(ADDRESS_EXPERIENCE)
  timePassed = 0
End Sub

Private Sub Form_Load()
Me.Caption = "EruHax v. " & App.Major & "." & App.Minor & "." & App.Revision
Start
lblExpHourOutput.Caption = ""
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim frm_x As Long
    frm_x = x / Screen.TwipsPerPixelX
    Select Case frm_x
            'Case WM_LBUTTONDOWN 'Left Button Click on the Icon
            '            SetForegroundWindow Me.hwnd
            '            PopupMenu mnuleft 'Menu Named mnuleft, visible property will be false
            Case WM_RBUTTONDOWN 'Right Button Click on the Icon
                        SetForegroundWindow Me.hwnd
                        PopupMenu mnuIconRight 'Menu Named mnuRight, visible property will be false

    End Select
End Sub

Private Sub Form_Unload(Cancel As Integer)
  hide_icon
End Sub

Private Sub mnuIconExit_Click()
  Unload Me
End Sub

Private Sub mnuIconShow_Click()
  Me.WindowState = 0
  Me.Show
  hide_icon
End Sub

Private Sub mnuMinimizeToTray_Click()
  Me.Hide
  Display_Icon Me
End Sub

Private Sub timerBattleList_Timer()
  If chkUpdateBattleList And Me.Visible And Me.WindowState = 0 Then txtBattleList = Get_BattleListReadout
End Sub

Private Sub timerExpHour_Timer()
  If chkExpHour Then
    currentExp = Memory_ReadLong(ADDRESS_EXPERIENCE)
    If currentExp > startExp Then timePassed = timePassed + 1
    If timePassed <> 0 Then
      expPerHour = (currentExp - startExp) / timePassed
    Else
      expPerHour = 0
    End If
    lblExpHourOutput = Round(expPerHour, 1) & "k/hr"
  End If
End Sub

Private Sub timerLight_Timer()
  Static tibiaBefore As Boolean
  lblAmountLight = "Current Light Level: " & Hack_Light(hscrLightAmount.Value, chkAdjustLight.Value)
  If tibiaBefore = False And Tibia_Hwnd <> 0 Then tibiaBefore = True
  If chkCloseWithTibia And Tibia_Hwnd = 0 And tibiaBefore Then Unload Me
End Sub



Public Sub hide_icon()
  Shell_NotifyIcon NIM_DELETE, nid 'Delete the icon from tray
End Sub
