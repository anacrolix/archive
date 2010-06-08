VERSION 5.00
Begin VB.Form frmCharacters 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Characters"
   ClientHeight    =   5850
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   13920
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5850
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
   Begin EruBot.listFancy listFriends 
      Height          =   5295
      Left            =   3480
      TabIndex        =   1
      Top             =   0
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   9340
      Title           =   "Friends"
      Caption         =   "Friends"
      ListIndex       =   -1
   End
   Begin EruBot.listFancy listEnemies 
      Height          =   5295
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   9340
      Title           =   "Enemies"
      Caption         =   "Enemies"
      ListIndex       =   -1
   End
   Begin EruBot.listFancy listSafe 
      Height          =   5295
      Left            =   6960
      TabIndex        =   3
      Top             =   0
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   9340
      Title           =   "Safe List"
      Caption         =   "Safe List"
      ListIndex       =   -1
      Prioritized     =   0   'False
   End
   Begin EruBot.listFancy listIntruders 
      Height          =   5295
      Left            =   10440
      TabIndex        =   4
      Top             =   0
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   9340
      Title           =   "Standard Intruders"
      Caption         =   "Standard Intruders"
      ListIndex       =   -1
      Prioritized     =   0   'False
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
