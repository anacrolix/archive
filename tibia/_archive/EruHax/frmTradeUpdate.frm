VERSION 5.00
Begin VB.Form frmEruHax 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EruHax v. 1.0.0"
   ClientHeight    =   7215
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   10800
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7215
   ScaleWidth      =   10800
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame frameMemory 
      Caption         =   "Memory Read"
      Height          =   6855
      Left            =   4440
      TabIndex        =   14
      Top             =   240
      Width           =   6255
      Begin VB.CheckBox chkMemoryRefresh 
         Caption         =   "Update Memory Read every 10 seconds"
         Height          =   255
         Left            =   120
         TabIndex        =   17
         Top             =   6480
         Width           =   3495
      End
      Begin VB.Timer timerMemoryRefresh 
         Enabled         =   0   'False
         Interval        =   10000
         Left            =   4920
         Top             =   6240
      End
      Begin VB.HScrollBar scrollMemoryRefreshRate 
         Height          =   255
         LargeChange     =   4
         Left            =   120
         Max             =   32
         Min             =   1
         TabIndex        =   16
         Top             =   6120
         Value           =   5
         Width           =   2895
      End
      Begin VB.TextBox txtMemory 
         Height          =   5775
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   15
         Text            =   "frmTradeUpdate.frx":0000
         Top             =   240
         Width           =   6015
      End
   End
   Begin VB.Frame frameHotkey 
      Caption         =   "Trade Hotkey"
      Height          =   4335
      Left            =   120
      TabIndex        =   7
      Top             =   2760
      Width           =   4215
      Begin VB.HScrollBar scrollSayRate 
         Height          =   255
         LargeChange     =   4
         Left            =   120
         Max             =   32
         Min             =   1
         TabIndex        =   12
         Top             =   3600
         Value           =   10
         Width           =   3015
      End
      Begin VB.TextBox txtTradeHotkey 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2535
         Left            =   120
         MaxLength       =   255
         MultiLine       =   -1  'True
         TabIndex        =   11
         Text            =   "frmTradeUpdate.frx":0042
         Top             =   240
         Width           =   3855
      End
      Begin VB.CheckBox chkRepeat 
         Caption         =   "Say this every 32 seconds"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   3960
         Width           =   3015
      End
      Begin VB.CommandButton cmdWriteHotkey 
         Caption         =   "Write to Hotkey"
         Height          =   375
         Left            =   120
         TabIndex        =   9
         Top             =   2880
         Width           =   1695
      End
      Begin VB.CommandButton cmdReadHotkey 
         Caption         =   "Read from Hotkey"
         Height          =   375
         Left            =   2280
         TabIndex        =   8
         Top             =   2880
         Width           =   1695
      End
      Begin VB.Timer timerRepeat 
         Enabled         =   0   'False
         Interval        =   5000
         Left            =   3360
         Top             =   3480
      End
      Begin VB.Label Label1 
         Caption         =   "Repeat Interval"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   3360
         Width           =   2535
      End
   End
   Begin VB.Frame frameLight 
      Caption         =   "Light"
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4215
      Begin VB.Timer timerLightRefresh 
         Enabled         =   0   'False
         Interval        =   1000
         Left            =   1800
         Top             =   1200
      End
      Begin VB.HScrollBar scrollRefreshRate 
         Height          =   255
         LargeChange     =   10
         Left            =   120
         Max             =   200
         Min             =   1
         TabIndex        =   5
         Top             =   1800
         Value           =   10
         Width           =   2175
      End
      Begin VB.CheckBox chkMonsterGlow 
         Caption         =   "Monster Glow"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   1440
         Width           =   2175
      End
      Begin VB.CheckBox chkActivateLight 
         Caption         =   "Activate Light"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   1080
         Width           =   2175
      End
      Begin VB.HScrollBar scrollLightValue 
         Height          =   255
         LargeChange     =   3
         Left            =   120
         Max             =   16
         TabIndex        =   1
         Top             =   360
         Value           =   12
         Width           =   2175
      End
      Begin VB.Label lblRefreshRate 
         Caption         =   "Light Refresh Interval: 1000"
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   2160
         Width           =   2175
      End
      Begin VB.Label lblCurrentPlayerLight 
         Caption         =   "Current Player Light: 9"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   720
         Width           =   1935
      End
   End
End
Attribute VB_Name = "frmEruHax"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub chkActivateLight_Click()
  If chkActivateLight Then
    timerLightRefresh = True
  Else
    timerLightRefresh = False
  End If
End Sub

Private Sub chkMemoryRefresh_Click()
  If chkMemoryRefresh Then
    timerMemoryRefresh.Enabled = True
  Else
    timerMemoryRefresh.Enabled = False
  End If
End Sub

Private Sub chkRepeat_Click()
  If chkRepeat Then
    timerRepeat = True
  Else
    timerRepeat = False
  End If
End Sub

Private Sub cmdReadHotkey_Click()
  txtTradeHotkey.Text = Read_Hotkey
End Sub

Private Sub cmdWriteHotkey_Click()
  Write_Hotkey txtTradeHotkey.Text
End Sub

Private Sub Form_Load()
  'light frame
  cmdReadHotkey_Click
  scrollSayRate_Change
  'memory read frame
  scrollMemoryRefreshRate_Change
  scrollRefreshRate_Change
  'form caption
  Me.Caption = "EruHax v. " & App.Major & "." & App.Minor & "." & App.Revision
End Sub

Private Sub scrollMemoryRefreshRate_Change()
  timerMemoryRefresh.Interval = scrollMemoryRefreshRate * 1000
  chkMemoryRefresh.Caption = "Reread memory every " & scrollMemoryRefreshRate & " seconds"
End Sub

Private Sub scrollRefreshRate_Change()
  lblRefreshRate = "Light Refresh Interval " & scrollRefreshRate * 100 & " ms"
  timerLightRefresh.Interval = scrollRefreshRate * 100
End Sub

Private Sub scrollSayRate_Change()
  timerRepeat.Interval = scrollSayRate.Value * 1000
  chkRepeat.Caption = "Say this every " & scrollSayRate & " seconds"
End Sub

Private Sub timerLightRefresh_Timer()
  Hack_Light scrollLightValue, chkActivateLight
End Sub

Private Sub timerMemoryRefresh_Timer()
  txtMemory.Text = Get_MemoryReadout
End Sub

Private Sub timerRepeat_Timer()
  Say_Hotkey
End Sub
