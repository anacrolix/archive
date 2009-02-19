VERSION 5.00
Begin VB.Form frmSM 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Master/Slave"
   ClientHeight    =   4350
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5055
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9.75
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   290
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   337
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnStartBot 
      Caption         =   "Start Bot"
      Height          =   495
      Left            =   2040
      TabIndex        =   25
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton btnStopBot 
      Caption         =   "Stop Bot"
      Height          =   495
      Left            =   3000
      TabIndex        =   24
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton btnLog 
      Caption         =   "Log Off"
      Height          =   495
      Left            =   3960
      TabIndex        =   23
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton btnFollow 
      Caption         =   "Follow"
      Height          =   495
      Left            =   120
      TabIndex        =   22
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton btnSFollow 
      Caption         =   "Stop Follow"
      Height          =   495
      Left            =   1080
      TabIndex        =   21
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton btnClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   3960
      TabIndex        =   20
      Top             =   3840
      Width           =   975
   End
   Begin VB.TextBox txtMaster 
      Height          =   285
      Left            =   840
      TabIndex        =   18
      Top             =   3960
      Width           =   1455
   End
   Begin VB.CheckBox chSlave 
      BackColor       =   &H00000000&
      Caption         =   "Slave"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   17
      Top             =   3480
      Width           =   1095
   End
   Begin VB.CommandButton btnSend 
      Caption         =   "Send"
      Height          =   375
      Left            =   3960
      TabIndex        =   16
      Top             =   2400
      Width           =   855
   End
   Begin VB.TextBox txtSlaveTalk 
      Height          =   285
      Left            =   720
      TabIndex        =   15
      Top             =   2430
      Width           =   3135
   End
   Begin VB.CommandButton btnMDR 
      Caption         =   "Down Right"
      Height          =   615
      Left            =   4320
      TabIndex        =   12
      Top             =   1680
      Width           =   615
   End
   Begin VB.CommandButton btnMR 
      Caption         =   "Right"
      Height          =   615
      Left            =   4320
      TabIndex        =   11
      Top             =   960
      Width           =   615
   End
   Begin VB.CommandButton btnMD 
      Caption         =   "Down"
      Height          =   615
      Left            =   3600
      TabIndex        =   10
      Top             =   1680
      Width           =   615
   End
   Begin VB.CommandButton btnMDL 
      Caption         =   "Down Left"
      Height          =   615
      Left            =   2880
      TabIndex        =   9
      Top             =   1680
      Width           =   615
   End
   Begin VB.CommandButton btnML 
      Caption         =   "Left"
      Height          =   615
      Left            =   2880
      TabIndex        =   8
      Top             =   960
      Width           =   615
   End
   Begin VB.CommandButton btnMUR 
      Caption         =   "Up Right"
      Height          =   615
      Left            =   4320
      TabIndex        =   7
      Top             =   240
      Width           =   615
   End
   Begin VB.CommandButton btnMU 
      Caption         =   "Up"
      Height          =   615
      Left            =   3600
      TabIndex        =   6
      Top             =   240
      Width           =   615
   End
   Begin VB.CommandButton btnMUL 
      Caption         =   "Up Left"
      Height          =   615
      Left            =   2880
      TabIndex        =   5
      Top             =   240
      Width           =   615
   End
   Begin VB.CommandButton btnRemove 
      Caption         =   "Remove"
      Height          =   375
      Left            =   1560
      TabIndex        =   4
      Top             =   1440
      Width           =   1215
   End
   Begin VB.CommandButton btnAdd 
      Caption         =   "Add"
      Height          =   375
      Left            =   1560
      TabIndex        =   3
      Top             =   960
      Width           =   1215
   End
   Begin VB.TextBox txtSlaveAdd 
      Height          =   285
      Left            =   1560
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.ListBox lstSlaves 
      Height          =   1860
      ItemData        =   "frmSM.frx":0000
      Left            =   120
      List            =   "frmSM.frx":0002
      TabIndex        =   0
      Top             =   360
      Width           =   1335
   End
   Begin VB.Label lblMaster 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Master:"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      TabIndex        =   19
      Top             =   3960
      Width           =   735
   End
   Begin VB.Label lblSay 
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   240
      TabIndex        =   14
      Top             =   2460
      Width           =   855
   End
   Begin VB.Label lblMove 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Move"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   3480
      TabIndex        =   13
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label lblSlaves 
      BackStyle       =   0  'Transparent
      Caption         =   "Slaves"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   855
   End
End
Attribute VB_Name = "frmSM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnAdd_Click()
    lstSlaves.AddItem txtSlaveAdd.Text
End Sub

Private Sub btnClose_Click()
    Me.Hide
End Sub

Private Sub btnFollow_Click()
    MessagePerson lstSlaves.Text, "-follow"
End Sub

Private Sub btnLog_Click()
    MessagePerson lstSlaves.Text, "-logoff"
End Sub

Private Sub btnMD_Click()
    MessagePerson lstSlaves.Text, "-mov:Down"
End Sub

Private Sub btnMDL_Click()
    MessagePerson lstSlaves.Text, "-mov:DownLeft"
End Sub

Private Sub btnMDR_Click()
    MessagePerson lstSlaves.Text, "-mov:DownRight"
End Sub

Private Sub btnML_Click()
    MessagePerson lstSlaves.Text, "-mov:Left"
End Sub

Private Sub btnMR_Click()
    MessagePerson lstSlaves.Text, "-mov:Right"
End Sub

Private Sub btnMU_Click()
    MessagePerson lstSlaves.Text, "-mov:Up"
End Sub

Private Sub btnMUL_Click()
    MessagePerson lstSlaves.Text, "-mov:UpLeft"
End Sub

Private Sub btnMUR_Click()
    MessagePerson lstSlaves.Text, "-mov:UpRight"
End Sub

Private Sub btnRemove_Click()
    lstSlaves.RemoveItem lstSlaves.ListIndex
End Sub

Private Sub btnSend_Click()
    MessagePerson lstSlaves.Text, "-say:" & txtSlaveTalk.Text
End Sub

Private Sub Command1_Click()
    Me.Hide
End Sub

Private Sub btnSFollow_Click()
    MessagePerson lstSlaves.Text, "-stopfollow"
End Sub

Private Sub btnStartBot_Click()
    MessagePerson lstSlaves.Text, "-startbot"
End Sub

Private Sub btnStopBot_Click()
    MessagePerson lstSlaves.Text, "-stopbot"
End Sub
