VERSION 5.00
Begin VB.Form frmInventory 
   Caption         =   "KeepSake - Inventory"
   ClientHeight    =   6390
   ClientLeft      =   165
   ClientTop       =   555
   ClientWidth     =   9480
   LinkTopic       =   "Form2"
   ScaleHeight     =   426
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   632
   StartUpPosition =   2  'CenterScreen
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   0
      Left            =   4440
      TabIndex        =   17
      Top             =   3720
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   0
      Left            =   3840
      TabIndex        =   16
      Top             =   240
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin VB.VScrollBar OtherScroll 
      Height          =   3015
      Left            =   7800
      TabIndex        =   15
      Top             =   3240
      Width           =   255
   End
   Begin VB.VScrollBar PackScroll 
      Height          =   2775
      Left            =   7800
      Max             =   0
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
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   1
      Left            =   960
      TabIndex        =   1
      Top             =   0
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   2
      Left            =   1920
      TabIndex        =   2
      Top             =   0
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   3
      Left            =   2880
      TabIndex        =   3
      Top             =   0
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   4
      Left            =   2880
      TabIndex        =   4
      Top             =   1560
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   5
      Left            =   2880
      TabIndex        =   5
      Top             =   3120
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   6
      Left            =   2880
      TabIndex        =   6
      Top             =   4680
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   7
      Left            =   1920
      TabIndex        =   7
      Top             =   4680
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   8
      Left            =   960
      TabIndex        =   8
      Top             =   4680
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   9
      Left            =   0
      TabIndex        =   9
      Top             =   4680
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   10
      Left            =   0
      TabIndex        =   10
      Top             =   3120
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1575
      Index           =   11
      Left            =   0
      TabIndex        =   11
      Top             =   1560
      Width           =   975
      _extentx        =   1720
      _extenty        =   2778
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   1
      Left            =   5400
      TabIndex        =   18
      Top             =   3960
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   2
      Left            =   5280
      TabIndex        =   19
      Top             =   3960
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   3
      Left            =   5640
      TabIndex        =   20
      Top             =   3720
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   4
      Left            =   5760
      TabIndex        =   21
      Top             =   4200
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   5
      Left            =   5280
      TabIndex        =   22
      Top             =   3960
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   6
      Left            =   4440
      TabIndex        =   23
      Top             =   3720
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot OtherSlot 
      Height          =   1455
      Index           =   7
      Left            =   5040
      TabIndex        =   24
      Top             =   3840
      Width           =   1575
      _extentx        =   2778
      _extenty        =   2566
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   1
      Left            =   4800
      TabIndex        =   25
      Top             =   360
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   2
      Left            =   5640
      TabIndex        =   26
      Top             =   360
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   3
      Left            =   6600
      TabIndex        =   27
      Top             =   480
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   4
      Left            =   4200
      TabIndex        =   28
      Top             =   1440
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   5
      Left            =   5040
      TabIndex        =   29
      Top             =   1440
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   6
      Left            =   6000
      TabIndex        =   30
      Top             =   1440
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
   End
   Begin KeepSake.InventorySlot PackSlot 
      DragMode        =   1  'Automatic
      Height          =   1215
      Index           =   7
      Left            =   6600
      TabIndex        =   31
      Top             =   1680
      Width           =   1215
      _extentx        =   2143
      _extenty        =   2143
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
      Caption         =   "Back Pack"
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
Attribute VB_Name = "frmInventory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClose_Click()
Hide
End Sub

Private Sub Form_Resize()
Dim lRet As Long ' needed for the call
Dim apiRECT As RECT ' needed for the call

If frmInventory.WindowState = 2 Then ' user "maximized" the form
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
frmInventory.WindowState = 0 ' turn off "maximized" so we can mess with the form
frmInventory.Left = apiRECT.Left * Screen.TwipsPerPixelX
frmInventory.Top = apiRECT.Top * Screen.TwipsPerPixelY
frmInventory.Height = ScreenMaxHeight%
frmInventory.Width = ScreenMaxWidth%
End If

' this code is run no matter what size the form is now, find out how much we can see now
inventoryslotwidth& = ScaleWidth / 8
inventoryslotheight& = ScaleHeight / 4
MiscSlotsHeight& = (ScaleHeight - lblBackPack.Height - lblOther.Height) / 4
MiscSlotswidth& = (ScaleWidth / 2 - PackScroll.Width) / 4
'resize right hand side slots
For Index% = 0 To 7
    Y% = Int(Index% / 4)
    X% = (Index% - 4 * Y)
    With PackSlot(Index%)
        .Top = lblBackPack.Height + Y% * MiscSlotsHeight&
        .Left = ScaleWidth / 2 + X% * MiscSlotswidth&
        .Height = MiscSlotsHeight&
        .Width = MiscSlotswidth&
    End With
    With OtherSlot(Index%)
        .Top = 2 * lblBackPack.Height + MiscSlotsHeight& * (2 + Y%)
        .Left = ScaleWidth / 2 + X% * MiscSlotswidth&
        .Height = MiscSlotsHeight&
        .Width = MiscSlotswidth&
    End With
Next Index%
For Index% = 0 To 11
    Select Case Index%
        Case 0: Y% = 0 * inventoryslotheight&: X% = 0 * inventoryslotwidth&
        Case 1: Y% = 0 * inventoryslotheight&: X% = 1 * inventoryslotwidth&
        Case 2: Y% = 0 * inventoryslotheight&: X% = 2 * inventoryslotwidth&
        Case 3: Y% = 0 * inventoryslotheight&: X% = 3 * inventoryslotwidth&
        Case 4: Y% = 1 * inventoryslotheight&: X% = 3 * inventoryslotwidth&
        Case 5: Y% = 2 * inventoryslotheight&: X% = 3 * inventoryslotwidth&
        Case 6: Y% = 3 * inventoryslotheight&: X% = 3 * inventoryslotwidth&
        Case 7: Y% = 3 * inventoryslotheight&: X% = 2 * inventoryslotwidth&
        Case 8: Y% = 3 * inventoryslotheight&: X% = 1 * inventoryslotwidth&
        Case 9: Y% = 3 * inventoryslotheight&: X% = 0 * inventoryslotwidth&
        Case 10: Y% = 2 * inventoryslotheight&: X% = 0 * inventoryslotwidth&
        Case 11: Y% = 1 * inventoryslotheight&: X% = 0 * inventoryslotwidth&
    End Select
    With InventorySlot(Index%)
        .Width = inventoryslotwidth&
        .Height = inventoryslotheight&
        .Top = Y%
        .Left = X%
    End With
Next Index%
With lblBackPack
    .Top = 0
    .Left = ScaleWidth / 2
    .Height = 17
    .Width = ScaleWidth / 2
End With
With lblOther
    .Top = lblBackPack.Height + 2 * MiscSlotsHeight&
    .Left = ScaleWidth / 2
    .Height = 17
    .Width = ScaleWidth / 2
End With
With PackScroll
    .Left = ScaleWidth - 17
    .Top = lblBackPack.Height
    .Width = 17
    .Height = 2 * MiscSlotsHeight&
End With
With OtherScroll
    .Left = ScaleWidth - 17
    .Top = lblBackPack.Height * 2 + 2 * MiscSlotsHeight&
    .Width = 17
    .Height = 2 * MiscSlotsHeight&
End With
End Sub

Private Sub InventorySlot_DragDrop(Index As Integer, Source As Control, X As Single, Y As Single)
    Call MoveItem(Source, InventorySlot(Source.Index), Index)
End Sub
Private Sub PackSlot_DragDrop(Index As Integer, Source As Control, X As Single, Y As Single)
    Call MoveItem(Source, PackSlot(Index), Index)
End Sub
Private Sub OtherSlot_DragDrop(Index As Integer, Source As Control, X As Single, Y As Single)
    Call MoveItem(Source, OtherSlot(Index), Index)
End Sub

Private Sub mnuExit_Click()
Hide
End Sub


Private Sub PackScroll_Change()
    PackOffset% = 4 * PackScroll.Value
    Call UpdateInventoryForm(0)
End Sub


