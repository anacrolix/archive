VERSION 5.00
Begin VB.Form frmCharacters 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Characters"
   ClientHeight    =   7410
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   13920
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7410
   ScaleWidth      =   13920
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   4200
      TabIndex        =   0
      Top             =   5400
      Width           =   1935
   End
End
Attribute VB_Name = "frmCharacters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    cmdClose.Left = (Me.Width - cmdClose.Width) / 2
    listFriends.Clear
    listEnemies.Clear
    listSafe.Clear
    listIntruders.Clear
End Sub
