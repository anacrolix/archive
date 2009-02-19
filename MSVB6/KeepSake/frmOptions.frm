VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Options 
   Caption         =   "Options Menu"
   ClientHeight    =   2415
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   3435
   LinkTopic       =   "Form2"
   ScaleHeight     =   161
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   229
   StartUpPosition =   2  'CenterScreen
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2640
      Top             =   1800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   495
      Left            =   840
      TabIndex        =   4
      Top             =   1800
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.CommandButton QuitButton 
      Caption         =   "Quit Game"
      Height          =   750
      Left            =   1800
      TabIndex        =   3
      Top             =   960
      Width           =   1500
   End
   Begin VB.CommandButton SaveButton 
      Caption         =   "Save Game"
      Enabled         =   0   'False
      Height          =   750
      Left            =   120
      TabIndex        =   2
      Top             =   960
      Width           =   1500
   End
   Begin VB.CommandButton LoadButton 
      Caption         =   "Load Game"
      Height          =   750
      Left            =   1800
      TabIndex        =   1
      Top             =   120
      Width           =   1500
   End
   Begin VB.CommandButton NewButton 
      Caption         =   "New Game"
      Height          =   750
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1500
   End
End
Attribute VB_Name = "Options"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CancelButton_Click()
Me.Hide
End Sub

Private Sub LoadButton_Click()
Call LoadGame
End Sub

Private Sub NewButton_Click()
Call NewGame
End Sub

Private Sub QuitButton_Click()
Call CleanExit
End Sub

Private Sub SaveButton_Click()
Call SaveGame
End Sub
