VERSION 5.00
Begin VB.Form frmSplash 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Game Title + Version"
   ClientHeight    =   5490
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5880
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   366
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   392
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtLicense 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      Height          =   3855
      Left            =   0
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      Text            =   "frmSplash.frx":0000
      Top             =   0
      Width           =   6000
   End
   Begin VB.CommandButton cmdEnterGame 
      Caption         =   "Enter Game"
      Height          =   495
      Left            =   3120
      TabIndex        =   0
      Top             =   4200
      Width           =   1695
   End
End
Attribute VB_Name = "frmSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdEnterGame_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Me.Caption = modData.SplashTitle
    Me.Width = 500 * Screen.TwipsPerPixelX
    Me.Height = 400 * Screen.TwipsPerPixelY
    txtLicense.Width = Me.ScaleWidth
    txtLicense.Height = Me.ScaleHeight - 50
    txtLicense.Text = DataFile.GetDataString("Splash")
    cmdEnterGame.Left = (Me.ScaleWidth - cmdEnterGame.Width) / 2
    cmdEnterGame.Top = 325
End Sub
