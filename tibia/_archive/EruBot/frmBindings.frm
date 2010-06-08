VERSION 5.00
Begin VB.Form frmBindings 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Key Bindings"
   ClientHeight    =   6360
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4665
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6360
   ScaleWidth      =   4665
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrBindings 
      Interval        =   4
      Left            =   3120
      Top             =   5880
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1680
      TabIndex        =   32
      Top             =   5880
      Width           =   1335
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   15
      Left            =   1080
      TabIndex        =   31
      Top             =   5520
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   14
      Left            =   1080
      TabIndex        =   29
      Top             =   5160
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   13
      Left            =   1080
      TabIndex        =   27
      Top             =   4800
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   12
      Left            =   1080
      TabIndex        =   25
      Top             =   4440
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   11
      Left            =   1080
      TabIndex        =   23
      Top             =   4080
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   10
      Left            =   1080
      TabIndex        =   21
      Top             =   3720
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   9
      Left            =   1080
      TabIndex        =   19
      Top             =   3360
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   8
      Left            =   1080
      TabIndex        =   17
      Top             =   3000
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   7
      Left            =   1080
      TabIndex        =   15
      Top             =   2640
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   6
      Left            =   1080
      TabIndex        =   13
      Top             =   2280
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   5
      Left            =   1080
      TabIndex        =   11
      Top             =   1920
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   4
      Left            =   1080
      TabIndex        =   9
      Top             =   1560
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   3
      Left            =   1080
      TabIndex        =   7
      Top             =   1200
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   2
      Left            =   1080
      TabIndex        =   5
      Top             =   840
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   1
      Left            =   1080
      TabIndex        =   3
      Top             =   480
      Width           =   3495
   End
   Begin VB.TextBox txtAction 
      BorderStyle     =   0  'None
      Height          =   285
      Index           =   0
      Left            =   1080
      TabIndex        =   1
      Top             =   120
      Width           =   3495
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 9"
      Height          =   285
      Index           =   15
      Left            =   120
      TabIndex        =   30
      Top             =   5520
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 8"
      Height          =   285
      Index           =   14
      Left            =   120
      TabIndex        =   28
      Top             =   5160
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 7"
      Height          =   285
      Index           =   13
      Left            =   120
      TabIndex        =   26
      Top             =   4800
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 6"
      Height          =   285
      Index           =   12
      Left            =   120
      TabIndex        =   24
      Top             =   4440
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 5"
      Height          =   285
      Index           =   11
      Left            =   120
      TabIndex        =   22
      Top             =   4080
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 4"
      Height          =   285
      Index           =   10
      Left            =   120
      TabIndex        =   20
      Top             =   3720
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 3"
      Height          =   285
      Index           =   9
      Left            =   120
      TabIndex        =   18
      Top             =   3360
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 2"
      Height          =   285
      Index           =   8
      Left            =   120
      TabIndex        =   16
      Top             =   3000
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 1"
      Height          =   285
      Index           =   7
      Left            =   120
      TabIndex        =   14
      Top             =   2640
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Num 0"
      Height          =   285
      Index           =   6
      Left            =   120
      TabIndex        =   12
      Top             =   2280
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Page Up"
      Height          =   285
      Index           =   5
      Left            =   120
      TabIndex        =   10
      Top             =   1920
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Page Down"
      Height          =   285
      Index           =   4
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Home"
      Height          =   285
      Index           =   3
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "End"
      Height          =   285
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Insert"
      Height          =   285
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1000
   End
   Begin VB.Label lblKey 
      Caption         =   "Delete"
      Height          =   285
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1000
   End
End
Attribute VB_Name = "frmBindings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim keysDown(&H7F) As Boolean

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    cmdClose.Left = (Me.Width - cmdClose.Width) / 2
End Sub

Private Sub tmrBindings_Timer()
    On Error Resume Next
    'if this client not active window
    If GetForegroundWindow <> hwndTibia Then Exit Sub
    If frmMain.sckServer.State <> sckConnected Then Exit Sub
    'check above arrow keys
    If GetPressedKey(vbKeyDelete) Then KeyDown vbKeyDelete: Exit Sub
    If GetPressedKey(vbKeyPageDown) Then KeyDown vbKeyPageDown: Exit Sub
    If GetPressedKey(vbKeyHome) Then KeyDown vbKeyHome: Exit Sub
    If GetPressedKey(vbKeyPageUp) Then KeyDown vbKeyPageUp: Exit Sub
    If GetPressedKey(vbKeyInsert) Then KeyDown vbKeyInsert: Exit Sub
    If GetPressedKey(vbKeyEnd) Then KeyDown vbKeyEnd: Exit Sub
    'check numpad
    Dim key As Long
    For key = vbKeyNumpad0 To vbKeyNumpad9
        If GetPressedKey(key) Then KeyDown key
    Next key
End Sub

Private Function GetPressedKey(key As Long) As Boolean
    GetPressedKey = False
    If keysDown(key) = False And GetAsyncKeyState(key) Then
        keysDown(key) = True
        GetPressedKey = True
    Else
        If GetAsyncKeyState(key) = 0 Then keysDown(key) = False
    End If
End Function

Private Sub KeyDown(key As Long)
    Dim bind As String
    Select Case key
        Case vbKeyDelete: bind = txtAction(0)
        Case vbKeyInsert: bind = txtAction(1)
        Case vbKeyEnd: bind = txtAction(2)
        Case vbKeyHome: bind = txtAction(3)
        Case vbKeyPageDown: bind = txtAction(4)
        Case vbKeyPageUp: bind = txtAction(5)
        Case Else:
            If key >= vbKeyNumpad0 And key <= vbKeyNumpad9 Then
                bind = txtAction(key - vbKeyNumpad0 + 6)
            End If
    End Select
    If bind = "" Then Exit Sub
    If gBotActive And frmMain.chkMainBindings Then ProcessAction bind
End Sub
