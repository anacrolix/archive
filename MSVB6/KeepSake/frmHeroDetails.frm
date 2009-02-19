VERSION 5.00
Begin VB.Form HeroDetails 
   Caption         =   "Hero Details"
   ClientHeight    =   6690
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   8070
   LinkTopic       =   "Form2"
   ScaleHeight     =   446
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   538
   StartUpPosition =   3  'Windows Default
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   0
      Left            =   4440
      TabIndex        =   17
      Top             =   3720
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   0
      Left            =   3840
      TabIndex        =   16
      Top             =   240
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin VB.VScrollBar VScroll2 
      Height          =   3015
      Left            =   7800
      TabIndex        =   15
      Top             =   3240
      Width           =   255
   End
   Begin VB.VScrollBar PackScroll 
      Height          =   2775
      Left            =   7800
      TabIndex        =   14
      Top             =   240
      Width           =   255
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   0
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   1
      Left            =   960
      TabIndex        =   1
      Top             =   0
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   2
      Left            =   1920
      TabIndex        =   2
      Top             =   0
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   3
      Left            =   2880
      TabIndex        =   3
      Top             =   0
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   4
      Left            =   2880
      TabIndex        =   4
      Top             =   1560
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   5
      Left            =   2880
      TabIndex        =   5
      Top             =   3120
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   6
      Left            =   2880
      TabIndex        =   6
      Top             =   4680
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   7
      Left            =   1920
      TabIndex        =   7
      Top             =   4680
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   8
      Left            =   960
      TabIndex        =   8
      Top             =   4680
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   9
      Left            =   0
      TabIndex        =   9
      Top             =   4680
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   10
      Left            =   0
      TabIndex        =   10
      Top             =   3120
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   11
      Left            =   0
      TabIndex        =   11
      Top             =   1560
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   2778
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   1
      Left            =   5400
      TabIndex        =   18
      Top             =   3960
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   2
      Left            =   5280
      TabIndex        =   19
      Top             =   3960
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   3
      Left            =   5640
      TabIndex        =   20
      Top             =   3720
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   4
      Left            =   5760
      TabIndex        =   21
      Top             =   4200
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   5
      Left            =   5280
      TabIndex        =   22
      Top             =   3960
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   6
      Left            =   4440
      TabIndex        =   23
      Top             =   3720
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   7
      Left            =   5040
      TabIndex        =   24
      Top             =   3840
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2566
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   1
      Left            =   4800
      TabIndex        =   25
      Top             =   360
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   2
      Left            =   5640
      TabIndex        =   26
      Top             =   360
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   3
      Left            =   6600
      TabIndex        =   27
      Top             =   480
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   4
      Left            =   4200
      TabIndex        =   28
      Top             =   1440
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   5
      Left            =   5040
      TabIndex        =   29
      Top             =   1440
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   6
      Left            =   6000
      TabIndex        =   30
      Top             =   1440
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      Height          =   1215
      Index           =   7
      Left            =   6600
      TabIndex        =   31
      Top             =   1680
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   2143
   End
   Begin VB.Label lblOther 
      Alignment       =   2  'Center
      BackColor       =   &H80000002&
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Trebuchet MS"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000009&
      Height          =   255
      Left            =   3840
      TabIndex        =   13
      Top             =   3000
      Width           =   4215
   End
   Begin VB.Label lblBackPack 
      Alignment       =   2  'Center
      BackColor       =   &H80000002&
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Trebuchet MS"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000009&
      Height          =   255
      Left            =   3840
      TabIndex        =   12
      Top             =   0
      Width           =   4215
   End
   Begin VB.Menu mnuExit 
      Caption         =   "E&xit"
   End
End
Attribute VB_Name = "HeroDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdClose_Click()
Hide
End Sub

Private Sub DropSpot_DragDrop(Source As Control, X As Single, Y As Single)
InventoryPicture(Source.Index).ToolTipText = "" ' erase the old tooltip
End Sub

Private Sub InventoryPicture_DragDrop(Index As Integer, Source As Control, X As Single, Y As Single)
' an object was dragged and dropped onto this square, swap the array values
' erase the old picture and draw the new picture
' VB handles for us automatically:
' Index (which picture element number was dropped onto) - matches CharInv array
' Source (which thing it came from)
' X,Y of where it was dropped onto (ignored since we fill the picture with the bitmap)

' part 1 - check to see if its valid
If Index = Source.Index Then Exit Sub ' didn't do anything
If CharInv(Index) > 0 Then MsgBox "That inventory space is already full": Exit Sub
If CharInv(Source.Index) = 0 Then MsgBox "You have to drag an object": Exit Sub
cItem% = CharInv(Source.Index) ' calculate which object is in the source box
If Index = 0 And Item(cItem%).Type <> 1 Then MsgBox "Can only use a weapon": Exit Sub
If Index = 1 And Item(cItem%).Type <> 3 Then MsgBox "Can only wear armor": Exit Sub

' part 2 - Move the object number from the old place in the "CharInv" array to the new place
CharInv(Index) = cItem%
CharInv(Source.Index) = 0 ' erase old object

' part 3 - Draw the new picture
' bitblt the whole picture (50x50 pixels) from source to index
SourceHandle& = HeroDetails.InventoryPicture(Source.Index).hDC
success& = BitBlt(HeroDetails.InventoryPicture(Index).hDC, 0, 0, 50, 50, SourceHandle&, 0, 0, SRCCOPY)
InventoryPicture(Index).Refresh
If Index = 0 Then
WeaponText.Text = Item(cItem%).Name ' set the "in use" weapon text
Char.Sword = cItem% ' set the current sword in-use
End If
If Index = 1 Then
ArmorText.Text = Item(cItem%).Name ' set the "in use" armor text
Char.Armor = cItem% ' set the current armor in-use
End If
If Index = 0 Then WeaponText.Text = Item(cItem%).Name ' set the "in use" weapon text
If Index = 1 Then ArmorText.Text = Item(cItem%).Name ' set the "in use" armor text
' move the tooltip
InventoryPicture(Index).ToolTipText = InventoryPicture(Source.Index).ToolTipText
InventoryPicture(Source.Index).ToolTipText = ""

' part 4 - erase the old picture
InventoryPicture(Source.Index).Cls
If Source.Index = 0 Then WeaponText.Text = "None" ' clear the "in use" weapon text
If Source.Index = 1 Then ArmorText.Text = "None" ' clear the "in use" armor text
End Sub

Private Sub lblDropSpot_DragDrop(Source As Control, X As Single, Y As Single)
' an object was dragged and dropped onto this square to be "dropped" onto the ground

' part 1 - check to see if user selected a valid object
If Source.Name <> "InventoryPicture" Then Exit Sub ' only allow dragdrop from inventory
If CharInv(Source.Index) = 0 Then MsgBox "You have to drag an object": Exit Sub

' part 2 - verify the map doesn't already have something there
DropableFlag% = 0
For XX% = 1 To Universe.TotObjects ' loop through all objects
If Char.X = Item(XX%).X And Char.Y = Item(XX%).Y And Char.MapNo = Item(XX%).MapNo Then
DropableFlag% = 1 ' already something there
End If
Next XX%
If DropableFlag% = 1 Then MsgBox "Already standing on something": Exit Sub

' part 3 - drop the object (i.e. change the database to reflect where it is)
cItem% = CharInv(Source.Index) ' calculate which object is in the source box
CharInv(Source.Index) = 0 ' remove from inventory
Item(cItem%).MapNo = Char.MapNo 'on the current map
Item(cItem%).X = Char.X ' at the hero's location
Item(cItem%).Y = Char.Y ' at the hero's location
Call DisplayMessage("Dropped " + Item(cItem%).Name)

InventoryPicture(Source.Index).ToolTipText = "" ' erase the old tooltip
' part 4 - erase the old picture
InventoryPicture(Source.Index).Cls
If Source.Index = 0 Then WeaponText.Text = "None" ' clear the "in use" weapon text
If Source.Index = 1 Then ArmorText.Text = "None" ' clear the "in use" armor text

End Sub

Private Sub UseSpot_DragDrop(Source As Control, X As Single, Y As Single)
' an object was dragged and dropped onto this square to be "used"

' part 1 - check to see if user selected a valid object
If Source.Name <> "InventoryPicture" Then Exit Sub ' only allow use from inventory
If CharInv(Source.Index) = 0 Then MsgBox "You have to drag an object": Exit Sub

' part 2 - check to see if it was a "usable" object
cItem% = CharInv(Source.Index) ' calculate which object is in the source box
If Item(cItem%).Type <> 4 Then MsgBox "You can only use healing potions for now": Exit Sub

' part 3 - use the object (i.e. change a stat)
Char.HitPtCur = Char.HitPtCur + Item(cItem%).Field1
If Char.HitPtCur > Char.HitPtMax Then Char.HitPtCur = Char.HitPtMax ' can't heal to more than max

' part 4 - eliminate the object
CharInv(Source.Index) = 0 ' remove from inventory
Item(cItem%).Type = 0 ' deleted
Item(cItem%).X = 0
Item(cItem%).Y = 0
Call DisplayMessage("You are healed!")
InventoryPicture(Source.Index).ToolTipText = "" ' erase the old tooltip

' part 4 - erase the old picture and show the new health
Call UpdateHeroForm

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
List1.Top = Form1.ScaleHeight - 70
' step 3 - draw map in new form size
NoOfXSqrCanSee% = Int(Form1.ScaleWidth / 50)
NoOfYSqrCanSee% = Int((Form1.ScaleHeight - 60) / 50)
If GameReady Then Call DrawMap ' draw it!

End Sub

Private Sub mnuExit_Click()
Hide
End Sub
