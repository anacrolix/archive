VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmInventory 
   Caption         =   "Form1"
   ClientHeight    =   8190
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   11880
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   546
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   792
   Begin MSComctlLib.Slider sldPack 
      Height          =   675
      Left            =   5040
      TabIndex        =   15
      Top             =   240
      Width           =   6615
      _ExtentX        =   11668
      _ExtentY        =   1191
      _Version        =   393216
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   10
      Left            =   2400
      TabIndex        =   1
      Top             =   1800
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Pack"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   0
      Left            =   3600
      TabIndex        =   2
      Top             =   0
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Weapon Hand"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   1
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      emptytext       =   "Armor"
      caption         =   "Armor"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   2
      Left            =   1200
      TabIndex        =   3
      Top             =   0
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Shield"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   3
      Left            =   2400
      TabIndex        =   4
      Top             =   0
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Off Hand"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   4
      Left            =   0
      TabIndex        =   5
      Top             =   1800
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      emptytext       =   "Overgarment"
      caption         =   "Overgarment"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   5
      Left            =   1200
      TabIndex        =   6
      Top             =   3600
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Gloves"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   6
      Left            =   0
      TabIndex        =   7
      Top             =   3600
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Bracers"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   7
      Left            =   2400
      TabIndex        =   8
      Top             =   5400
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Boots"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   8
      Left            =   2400
      TabIndex        =   9
      Top             =   3600
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Left Ring"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   9
      Left            =   3600
      TabIndex        =   10
      Top             =   3600
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Right Ring"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   11
      Left            =   0
      TabIndex        =   11
      Top             =   5400
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Belt"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   13
      Left            =   3600
      TabIndex        =   12
      Top             =   1800
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Helmet"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   14
      Left            =   1200
      TabIndex        =   13
      Top             =   1800
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      emptytext       =   "Overgarment"
      caption         =   "Neckwear"
   End
   Begin RiftOfPeril.InvSlot InvSlots 
      DragMode        =   1  'Automatic
      Height          =   1815
      Index           =   12
      Left            =   1200
      TabIndex        =   14
      Top             =   5400
      Width           =   1215
      _extentx        =   2143
      _extenty        =   3201
      caption         =   "Greaves"
   End
   Begin VB.Menu mnu_Exit 
      Caption         =   "E&xit"
   End
End
Attribute VB_Name = "frmInventory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub GetSrcXY(pIconNo As EnumIcon, pSrcX As Integer, pSrcY As Integer)
End Sub

Private Sub Form_Activate()
    Dim SrcX As Integer, SrcY As Integer, n As Integer
    Me.Caption = "Weight: " & ChAr.GetCurWt & " (" & ChAr.MaxWt & ")"
    For n = InvSlots.LBound To InvSlots.UBound
        With InvSlots(n)
            If ChAr.EqItm(n).Name = "Empty" Then
                .Caption = modEnums.RetSlotStr(n)
                'drawicon
            Else
                .Caption = ChAr.EqItm(n).Name
                DrawIcon InvSlots(n), ChAr.EqItm(n).Icon
            End If
        End With
    Next n
End Sub

Private Sub DrawIcon(pDestObj As Object, pIconNo As EnumIcon)
    Dim SrcX As Integer, SrcY As Integer
    SrcY = Int(pIconNo / (GfxFileX / IconInterval))
    SrcX = pIconNo - (GfxFileX / IconInterval) * SrcY
    SrcY = SrcY * IconInterval
    SrcX = SrcX * IconInterval
    BitBlt pDestObj.hDC, 0, 0, TileSize, TileSize, frmMain.pcbGfx.hDC, SrcX, SrcY, vbSrcCopy
    pDestObj.Refresh
End Sub

Function GetIcon(pIconNo As Integer) As Picture
    Dim SourceX, SourceY As Integer
    SourceY = Int(pIconNo / (GfxFileX / IconInterval))
    SourceX = pIconNo - (GfxFileX / IconInterval) * SourceY
    SourceY = SourceY * IconInterval
    SourceX = SourceX * IconInterval
    Dim maskDC As Long      'DC for the mask
    Dim tempDC As Long      'DC for temporary data
    Dim hMaskBmp As Long    'Bitmap for mask
    Dim hTempBmp As Long    'Bitmap for temporary data
    Dim TransColor As Long
    TransColor = MaskColor
    'First create some DC's. These are our gateways to assosiated bitmaps in RAM
    maskDC = CreateCompatibleDC(pcbIcon.hDC)
    tempDC = CreateCompatibleDC(pcbIcon.hDC)
    'Then we need the bitmaps. Note that we create a monochrome bitmap here!
    'this is a trick we use for creating a mask fast enough.
    hMaskBmp = CreateBitmap(TileSize, TileSize, 1, 1, ByVal 0&)
    hTempBmp = CreateCompatibleBitmap(pcbIcon.hDC, TileSize, TileSize)
    '..then we can assign the bitmaps to the DCs
    hMaskBmp = SelectObject(maskDC, hMaskBmp)
    hTempBmp = SelectObject(tempDC, hTempBmp)
    'Now we can create a mask..First we set the background color to the
    'transparent color then we copy the image into the monochrome bitmap.
    'When we are done, we reset the background color of the original source.
    TransColor = SetBkColor(frmMain.pcbGfx.hDC, TransColor)
    BitBlt maskDC, 0, 0, TileSize, TileSize, frmMain.pcbGfx.hDC, SourceX, SourceY, vbSrcCopy
    TransColor = SetBkColor(frmMain.pcbGfx.hDC, TransColor)
    'The first we do with the mask is to MergePaint it into the destination.
    'this will punch a WHITE hole in the background exactly were we want the
    'graphics to be painted in.
    BitBlt tempDC, 0, 0, TileSize, TileSize, maskDC, 0, 0, vbSrcCopy
    BitBlt pcbIcon.hDC, 0, 0, TileSize, TileSize, tempDC, 0, 0, vbMergePaint
    'Now we delete the transparent part of our source image. To do this
    'we must invert the mask and MergePaint it into the source image. the
    'transparent area will now appear as WHITE.
    BitBlt maskDC, 0, 0, TileSize, TileSize, maskDC, 0, 0, vbNotSrcCopy
    BitBlt tempDC, 0, 0, TileSize, TileSize, frmMain.pcbGfx.hDC, SourceX, SourceY, vbSrcCopy
    BitBlt tempDC, 0, 0, TileSize, TileSize, maskDC, 0, 0, vbMergePaint
    'Both target and source are clean, all we have to do is to AND them together!
    BitBlt pcbIcon.hDC, 0, 0, TileSize, TileSize, tempDC, 0, 0, vbSrcAnd
    'Now all we have to do is to clean up after us and free system resources..
    DeleteObject (hMaskBmp)
    DeleteObject (hTempBmp)
    DeleteDC (maskDC)
    DeleteDC (tempDC)
    BitBlt pcbIcon.hDC, 0, 0, TileSize, TileSize, frmMain.pcbGfx.hDC, SourceX, SourceY, vbSrcCopy
    pcbIcon.Refresh
End Function

Private Sub InvSlots_DragDrop(Index As Integer, Source As Control, X As Single, Y As Single)
    If Index = Source.Index Then Exit Sub
    If ChAr.EqItm(Source.Index).Name = "Empty" Then
        MsgBox "There was no item in the source slot.", vbExclamation, "Nothing to move."
        Exit Sub
    ElseIf ChAr.EqItm(Index).Name <> "Empty" Then
        MsgBox "Slot already filled", vbExclamation, "Slot Full"
        Exit Sub
    ElseIf IsValidSlot(ChAr.EqItm(Source.Index).ItemType, Index) = False Then
        MsgBox "Wrong slot for item.", vbExclamation, "Wrong Slot"
        Exit Sub
    Else
        Set ChAr.EqItm(Index) = ChAr.EqItm(Source.Index)
        ChAr.EqItm(Source.Index).Name = "Empty"
        DrawIcon InvSlots(Index), ChAr.EqItm(Index).Icon
        DrawIcon InvSlots(Source.Index), Blank
    End If
End Sub

Private Sub InvSlots_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    MsgBox "invslots mousedown"
    InvSlots(Index).SetFocus
End Sub

Private Sub mnu_Exit_Click()
    frmDisplay.Show
    Me.Hide
    'frmDisplay.Show
End Sub
