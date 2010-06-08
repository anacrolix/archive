VERSION 5.00
Begin VB.Form frmPacket 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Packet Watcher"
   ClientHeight    =   6975
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6240
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6975
   ScaleWidth      =   6240
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdClear 
      Caption         =   "<-- Clear"
      Height          =   375
      Left            =   5040
      TabIndex        =   7
      Top             =   1560
      Width           =   855
   End
   Begin VB.CheckBox chkShowLoginPackets 
      Caption         =   "Login"
      Height          =   255
      Left            =   4800
      TabIndex        =   6
      Top             =   1080
      Value           =   1  'Checked
      Width           =   1215
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   5040
      TabIndex        =   4
      Top             =   6480
      Width           =   855
   End
   Begin VB.CheckBox chkShowBotPackets 
      Caption         =   "Bot"
      Height          =   255
      Left            =   4800
      TabIndex        =   3
      Top             =   840
      Value           =   1  'Checked
      Width           =   1215
   End
   Begin VB.CheckBox chkShowClientPackets 
      Caption         =   "Client"
      Height          =   255
      Left            =   4800
      TabIndex        =   2
      Top             =   600
      Value           =   1  'Checked
      Width           =   1335
   End
   Begin VB.CheckBox chkShowServerPackets 
      Caption         =   "Server"
      Height          =   255
      Left            =   4800
      TabIndex        =   1
      Top             =   360
      Value           =   1  'Checked
      Width           =   1455
   End
   Begin VB.TextBox txtRecordedPackets 
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6735
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   120
      Width           =   4575
   End
   Begin VB.Label Label1 
      Caption         =   "Show Packets from"
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
      Left            =   4800
      TabIndex        =   5
      Top             =   120
      Width           =   1575
   End
End
Attribute VB_Name = "frmPacket"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub AddPacket(title As String, buff() As Byte)
    If txtRecordedPackets <> "" Then txtRecordedPackets = txtRecordedPackets & vbCrLf
    txtRecordedPackets = _
    txtRecordedPackets & vbTab & title & " (" & UBound(buff) + 1 & ")" & vbCrLf _
    & PacketToString(buff, Not gameActive)
    txtRecordedPackets.SelStart = Len(txtRecordedPackets)
End Sub

Sub IncomingServerPacket(buff() As Byte)
    AddPacket "Server->Client", buff
End Sub

Sub IncomingBotPacket(buff() As Byte)
    AddPacket "Bot->Client", buff
End Sub

Sub OutgoingClientPacket(buff() As Byte)
    AddPacket "Client->Server", buff
End Sub

Sub OutgoingBotPacket(buff() As Byte)
    AddPacket "Bot->Server", buff
End Sub

Private Sub cmdClear_Click()
    txtRecordedPackets = ""
End Sub

Private Sub cmdHide_Click()
    Me.Hide
End Sub
