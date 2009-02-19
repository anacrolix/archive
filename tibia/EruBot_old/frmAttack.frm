VERSION 5.00
Begin VB.Form frmAttack 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Attack Reaction"
   ClientHeight    =   2055
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2760
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2055
   ScaleWidth      =   2760
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkAlert 
      Caption         =   "Alert"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton cmdDone 
      Caption         =   "Close"
      Height          =   375
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   1095
   End
   Begin VB.Timer tmrAttack 
      Enabled         =   0   'False
      Interval        =   200
      Left            =   840
      Top             =   960
   End
   Begin VB.CheckBox chkWalk 
      Caption         =   "Walk"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   480
      Width           =   735
   End
   Begin VB.TextBox txtSay 
      Height          =   285
      Left            =   720
      TabIndex        =   7
      Top             =   120
      Width           =   1935
   End
   Begin VB.CheckBox chkSay 
      Caption         =   "Say"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Width           =   615
   End
   Begin VB.Frame frameWalk 
      Caption         =   "Walk Direction"
      Height          =   1455
      Left            =   1320
      TabIndex        =   1
      Top             =   480
      Visible         =   0   'False
      Width           =   1335
      Begin VB.OptionButton optWalk 
         Caption         =   "N"
         Height          =   375
         Index           =   0
         Left            =   480
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   240
         Value           =   -1  'True
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "E"
         Height          =   375
         Index           =   1
         Left            =   840
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   600
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "S"
         Height          =   375
         Index           =   2
         Left            =   480
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   960
         Width           =   375
      End
      Begin VB.OptionButton optWalk 
         Caption         =   "W"
         Height          =   375
         Index           =   3
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   600
         Width           =   375
      End
   End
   Begin VB.CheckBox chkBeep 
      Caption         =   "Beep"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Width           =   735
   End
End
Attribute VB_Name = "frmAttack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdDone_Click()
    Me.Hide
End Sub

Private Sub tmrAttack_Timer()
    Dim s As String
    Dim i As Integer
    
    HitPoints = ReadMem(ADR_CUR_HP, 2)
    If HitPoints > HitPoints2 Then HitPoints2 = HitPoints
    If HitPoints < HitPoints2 Then
        AddStatusMessage "Damage was taken."
        If chkWalk Then
            For i = optWalk.LBound To optWalk.UBound
                If optWalk(i) Then
                    Step i
                    s = "Walk "
                    Select Case j
                        Case 0: s = s & "North"
                        Case 1: s = s & "East"
                        Case 2: s = s & "South"
                        Case 3: s = s & "West"
                    End Select
                    AddStatusMessage s
                    Exit For
                End If
            Next i
        End If
        If chkSay Then SayStuff txtSay.Text
        If chkAlert Then StartAlert
        If chkBeep Then Beep 600, 200
        HitPoints2 = HitPoints
    End If
End Sub
