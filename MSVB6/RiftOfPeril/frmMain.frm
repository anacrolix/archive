VERSION 5.00
Begin VB.MDIForm frmMain 
   Appearance      =   0  'Flat
   BackColor       =   &H8000000C&
   Caption         =   "Rift Of Peril"
   ClientHeight    =   7230
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   9000
   LinkTopic       =   "MDIForm1"
   Moveable        =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox pcbGfx 
      Align           =   1  'Align Top
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   4530
      Left            =   0
      Picture         =   "frmMain.frx":0000
      ScaleHeight     =   298
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   596
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   9000
   End
   Begin VB.Menu mnu_Game 
      Caption         =   "&Game"
      Begin VB.Menu mnu_Game_New 
         Caption         =   "&New"
      End
      Begin VB.Menu mnu_Game_Load 
         Caption         =   "&Load"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_Save 
         Caption         =   "&Save"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_SaveAs 
         Caption         =   "Save &As"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_Exit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private apiMaxRECT As RECT
Private Sub MDIForm_Load()
    lRet = SystemParametersInfo(SPI_GETWORKAREA, vbNull, apiMaxRECT, 0)
    If lRet <> 1 Then MsgBox "Call to SystemParametersInfo failed.", 16, "Problem"
    With Me
        .Left = apiMaxRECT.Left * Screen.TwipsPerPixelX
        .Top = apiMaxRECT.Top * Screen.TwipsPerPixelY
        .Height = (apiMaxRECT.Bottom - apiMaxRECT.Top) * Screen.TwipsPerPixelX
        .Width = (apiMaxRECT.Right - apiMaxRECT.Left) * Screen.TwipsPerPixelY
        .WindowState = 2
    End With
End Sub

Private Sub MDIForm_Resize()
    If Me.WindowState = 0 Then
        lRet = SystemParametersInfo(SPI_GETWORKAREA, vbNull, apiMaxRECT, 0)
        If lRet <> 1 Then MsgBox "Call to SystemParametersInfo failed.", 16, "Problem"
    End If
        'With Me
        '    .Left = apiMaxRECT.Left * Screen.TwipsPerPixelX
        '    .Top = apiMaxRECT.Top * Screen.TwipsPerPixelY
        '    .Height = (apiMaxRECT.Bottom - apiMaxRECT.Top) * Screen.TwipsPerPixelX
        '    .Width = (apiMaxRECT.Right - apiMaxRECT.Left) * Screen.TwipsPerPixelY
        '    '.WindowState = 2
        'End With
    'End If
    'AlreadyResizing = False
    CenterScreen
    DrawView
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    CleanExit Cancel
End Sub

Private Sub mnu_Game_Exit_Click()
    CleanExit
End Sub

Private Sub mnu_Game_New_Click()
    NewGame
End Sub
