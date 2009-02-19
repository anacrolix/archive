VERSION 5.00
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   Caption         =   "Keep Sake"
   ClientHeight    =   7095
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   7110
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   473
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   474
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox pcbTemp 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   750
      Left            =   4920
      ScaleHeight     =   750
      ScaleWidth      =   750
      TabIndex        =   5
      Top             =   840
      Visible         =   0   'False
      Width           =   750
   End
   Begin VB.Timer SplashTimer 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   1080
      Top             =   2040
   End
   Begin VB.ListBox List1 
      Height          =   1230
      Left            =   2160
      TabIndex        =   4
      Top             =   4200
      Width           =   1695
   End
   Begin VB.CommandButton PickUpButton 
      Caption         =   "Pick Up"
      Height          =   375
      Left            =   2880
      TabIndex        =   2
      Top             =   1560
      Width           =   1095
   End
   Begin VB.CommandButton ShowHeroButton 
      Caption         =   "Hero"
      Height          =   375
      Left            =   3000
      TabIndex        =   1
      Top             =   600
      Width           =   855
   End
   Begin VB.CommandButton CallOptionsButton 
      Caption         =   "Options"
      Height          =   375
      Left            =   2880
      TabIndex        =   0
      Top             =   3240
      Width           =   1455
   End
   Begin VB.Label ToolTipActivator 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   735
      Left            =   5040
      TabIndex        =   3
      Top             =   960
      Width           =   1095
   End
   Begin VB.Menu mnuGame 
      Caption         =   "&Game"
      Begin VB.Menu mnuGameExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuCharacter 
      Caption         =   "&Character"
   End
   Begin VB.Menu mnuInventory 
      Caption         =   "&Inventory"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CallOptionsButton_Click()
Options.SaveButton.Enabled = True
Options.CancelButton.Visible = True
Options.Show 1 'display the new/options/load/save/quit form
Options.CancelButton.Visible = False
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
Select Case KeyCode
    Case 49 To 52, 54 To 57, 97 To 100, 102 To 105: Call MoveByKeyboard(KeyCode)
    Case vbKeyG: Call PickUpItem
End Select
End Sub

Private Sub Form_Load()
Form1.WindowState = 2
End Sub

Private Sub Form_Unload(Cancel As Integer)
Call CleanExit
End Sub

Private Sub Form_Resize()
Dim lRet As Long ' needed for the call
Dim apiRECT As RECT ' needed for the call

If Form1.WindowState = 2 Then ' user "maximized" the form
' get current useful (minus task bar) screen size
lRet = SystemParametersInfo(SPI_GETWORKAREA, vbNull, apiRECT, 0) ' get the info
If lRet Then ' if call was successful
' note the following line is commented out, you can uncomment it to see the screen area displayed in a message box
' MsgBox "WorkAreaLeft: " & apiRECT.Left & ", WorkAreaTop: " & apiRECT.Top & ", WorkAreaWidth: " & apiRECT.Right - apiRECT.Left & ", WorkAreaHeight: " & apiRECT.Bottom - apiRECT.Top, 64, "Information"
Else
MsgBox "Call to SystemParametersInfo failed.", 16, "Problem"
End If

' the screen.TwipsPerPixel parameters are needed because the forms are sized in twips but the screen sizes are returned in pixels
ScreenMaxHeight% = (apiRECT.Bottom - apiRECT.Top) * Screen.TwipsPerPixelX
ScreenMaxWidth% = (apiRECT.Right - apiRECT.Left) * Screen.TwipsPerPixelY

' now actually size the form
Form1.WindowState = 0 ' turn off "maximized" so we can mess with the form
Form1.Left = apiRECT.Left * Screen.TwipsPerPixelX
Form1.Top = apiRECT.Top * Screen.TwipsPerPixelY
Form1.Height = ScreenMaxHeight%
Form1.Width = ScreenMaxWidth%
End If

' this code is run no matter what size the form is now, find out how much we can see now
NoOfXSqrCanSee% = Int(Form1.ScaleWidth / 50)
NoOfYSqrCanSee% = Int((Form1.ScaleHeight - 25) / 50)
' this code is run no matter what size the form is now, find out how much we can see now

' this code is run no matter what size the form is now, find out how much we can see now

' step 1 - move/scale the buttons
ButtonXSize = Form1.ScaleWidth / 6
CallOptionsButton.Top = Form1.ScaleHeight - 25
CallOptionsButton.Width = ButtonXSize
CallOptionsButton.Left = ButtonXSize * 5
ShowHeroButton.Top = Form1.ScaleHeight - 25
ShowHeroButton.Width = ButtonXSize
ShowHeroButton.Left = ButtonXSize * 4
PickUpButton.Top = Form1.ScaleHeight - 25
PickUpButton.Width = ButtonXSize
PickUpButton.Left = ButtonXSize * 0
' step 2 - move/scale the text window
List1.Left = 0
List1.Width = Form1.ScaleWidth
List1.Top = Form1.ScaleHeight - List1.Height - CallOptionsButton.Height
' step 3 - draw map in new form size
NoOfXSqrCanSee% = Int(Form1.ScaleWidth / 50)
NoOfYSqrCanSee% = Int(List1.Top / 50)
If GameReady Then Call DrawMap ' draw it!
End Sub

Private Sub mnuFileQuit_Click()
Call CleanExit
End Sub
Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 2 Then
    Call ShowInfo(X, Y)
    Exit Sub
End If

' this procedure moves the character
' MX, MY are the mouse x,y when the map(form)was clicked

' step 1, calculate map offset from the mouse x,y
' since we know all the squares are 50x50 pixels, calculate the actual
' X,Y on the form
ClickedMapX% = Int(X / 50) + DisplayXOffset%
ClickedMapY% = Int(Y / 50) + DisplayYOffset%
' step 2 - since the hero only moves 1 square at a time, calculate
' the adjacient square to the hero
DX% = 0: DY% = 0
If ClickedMapY% > Char.Y Then DY% = 1
If ClickedMapY% < Char.Y Then DY% = -1
If ClickedMapX% > Char.X Then DX% = 1
If ClickedMapX% < Char.X Then DX% = -1

Call MoveCharacter(DX%, DY%)

End Sub

Private Sub mnuCharacter_Click()
frmCharacter.Show 1
End Sub

Private Sub mnuInventory_Click()
ShowInventory
End Sub

Private Sub PickUpButton_Click()
Call PickUpItem
End Sub

Private Sub ShowInventory()
PackOffset% = 0
OtherOffset% = 0
Call UpdateInventoryForm(0)
frmInventory.Show 1
End Sub

Private Sub ShowHeroButton_Click()
ShowInventory
End Sub

Private Sub SplashTimer_Timer()
SplashFlag = True
End Sub

Sub MoveByKeyboard(Key As Integer)
Select Case Key
    Case vbKey1, vbKeyNumpad1: X% = -1: Y% = 1
    Case vbKey2, vbKeyNumpad2: Y% = 1
    Case vbKey3, vbKeyNumpad3: X% = 1: Y% = 1
    Case vbKey4, vbKeyNumpad4: X% = -1
    Case vbKey6, vbKeyNumpad6: X% = 1
    Case vbKey7, vbKeyNumpad7: X% = -1: Y% = -1
    Case vbKey8, vbKeyNumpad8: Y% = -1
    Case vbKey9, vbKeyNumpad9: X% = 1: Y% = -1
    Case Else: Exit Sub
End Select
Call MoveCharacter(X%, Y%)
End Sub

Private Sub Timer1_Timer()
    GameTime = GameTime + Timer1.Interval / 1000
End Sub
