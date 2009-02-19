Attribute VB_Name = "modGfx"
Public Declare Function GetTickCount Lib "kernel32" () As Long

'WIN API
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Public Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
Public Declare Function SetBkColor Lib "gdi32" (ByVal hDC As Long, ByVal crColor As Long) As Long
Public Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Public Declare Function GetObject Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long

Public Const SPI_GETWORKAREA = 48
Declare Function SystemParametersInfo Lib "user32" _
    Alias "SystemParametersInfoA" (ByVal uAction As Long, _
    ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) _
    As Long
Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Const GfxFileX As Integer = 500
Private Const MaskColor As Long = vbWhite
Public Const TileSize As Integer = 48
Public Const IconInterval As Integer = 50
Private Const BufferTiles As Integer = 2

Public TilesDrawn As Long
Public AllowedToDraw As Boolean
Public ScrnOfstX As Integer, ScrnOfstY As Integer
Public NoSqCanSeeX As Integer, NoSqCanSeeY As Integer
'Public TileBmp() As Long

Sub CenterScreen()
    If AllowedToDraw = False Then Exit Sub
    ScrnOfstX = ChAr.X - Int(NoSqCanSeeX / 2)
    If ScrnOfstX < 0 Then ScrnOfstX = 0
    ScrnOfstY = ChAr.Y - Int(NoSqCanSeeY / 2)
    'protect scrnofst from displaying beyond edges of map
    If ScrnOfstX < 0 Then ScrnOfstX = 0
    If ScrnOfstX > Maps(ChAr.Map).Width - NoSqCanSeeX Then _
    ScrnOfstX = Maps(ChAr.Map).Width - NoSqCanSeeX
    If ScrnOfstY < 0 Then ScrnOfstY = 0
    If ScrnOfstY > Maps(ChAr.Map).Height - NoSqCanSeeY Then _
    ScrnOfstY = Maps(ChAr.Map).Width - NoSqCanSeeY
    With frmDisplay
        .Cls
        .vscrVert.Min = 0
        .vscrVert.Max = Maps(ChAr.Map).Height - NoSqCanSeeY
        .vscrVert.Value = ScrnOfstY
        .hscrHor.Min = 0
        .hscrHor.Max = Maps(ChAr.Map).Width - NoSqCanSeeX
        .hscrHor.Value = ScrnOfstX
    End With
    'DrawView
End Sub

Function InBuffer() As Boolean
    'check if character is in buffer zone
    If ChAr.X <= ScrnOfstX + BufferTiles Or _
    ChAr.X >= ScrnOfstX + NoSqCanSeeX - BufferTiles Or _
    ChAr.Y <= ScrnOfstY + BufferTiles Or _
    ChAr.Y >= ScrnOfstY + NoSqCanSeeY - BufferTiles Then _
    InBuffer = True
End Function

Sub DrawTile(pX As Integer, pY As Integer, pIconNo As EnumIcon, Optional pTransparent As Boolean = False)
    Dim DestX, DestY, SourceX, SourceY As Integer
    SourceY = Int(pIconNo / (GfxFileX / IconInterval))
    SourceX = pIconNo - (GfxFileX / IconInterval) * SourceY
    SourceY = SourceY * IconInterval
    SourceX = SourceX * IconInterval
    DestX = TileSize * (pX - ScrnOfstX)
    DestY = TileSize * (pY - ScrnOfstY)
    If pTransparent = True Then
        Dim maskDC As Long      'DC for the mask
        Dim tempDC As Long      'DC for temporary data
        Dim hMaskBmp As Long    'Bitmap for mask
        Dim hTempBmp As Long    'Bitmap for temporary data
        Dim TransColor As Long
        TransColor = MaskColor
        'First create some DC's. These are our gateways to assosiated bitmaps in RAM
        maskDC = CreateCompatibleDC(frmDisplay.hDC)
        tempDC = CreateCompatibleDC(frmDisplay.hDC)
        'Then we need the bitmaps. Note that we create a monochrome bitmap here!
        'this is a trick we use for creating a mask fast enough.
        hMaskBmp = CreateBitmap(TileSize, TileSize, 1, 1, ByVal 0&)
        hTempBmp = CreateCompatibleBitmap(frmDisplay.hDC, TileSize, TileSize)
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
        BitBlt frmDisplay.hDC, DestX, DestY, TileSize, TileSize, tempDC, 0, 0, vbMergePaint
        'Now we delete the transparent part of our source image. To do this
        'we must invert the mask and MergePaint it into the source image. the
        'transparent area will now appear as WHITE.
        BitBlt maskDC, 0, 0, TileSize, TileSize, maskDC, 0, 0, vbNotSrcCopy
        BitBlt tempDC, 0, 0, TileSize, TileSize, frmMain.pcbGfx.hDC, SourceX, SourceY, vbSrcCopy
        BitBlt tempDC, 0, 0, TileSize, TileSize, maskDC, 0, 0, vbMergePaint
        'Both target and source are clean, all we have to do is to AND them together!
        BitBlt frmDisplay.hDC, DestX, DestY, TileSize, TileSize, tempDC, 0, 0, vbSrcAnd
        'Now all we have to do is to clean up after us and free system resources..
        DeleteObject (hMaskBmp)
        DeleteObject (hTempBmp)
        DeleteDC (maskDC)
        DeleteDC (tempDC)
    Else
        BitBlt frmDisplay.hDC, DestX, DestY, TileSize, TileSize, frmMain.pcbGfx.hDC, SourceX, SourceY, vbSrcCopy
    End If
    TilesDrawn = TilesDrawn + 1
End Sub

Sub DrawSquare(pX As Integer, pY As Integer, Optional pDrawChar As Boolean = True)
    Dim nCnt As Integer
    'Dim Finish As Long, Start As Long
    'Start = GetTickCount
    'map tile
    DrawTile pX, pY, Maps(ChAr.Map).Icon(pX, pY)
    'entity tiles
    With Maps(ChAr.Map)
        If .NumEnts > 0 Then
            For nCnt = 0 To .NumEnts - 1
                If .Entity(nCnt).X = pX And .Entity(nCnt).Y = pY Then
                    DrawTile pX, pY, .Entity(nCnt).GetIcon, True
                End If
            Next nCnt
        End If
    End With
    'character tile
    If pDrawChar And ChAr.X = pX And ChAr.Y = pY Then _
    DrawTile pX, pY, ChAr.Icon, True
    'frmDisplay.Refresh
    'Finish = GetTickCount
    'FeedBack "Time to draw square: " & Finish - Start & " ticks"
End Sub

Sub DrawView()
    Dim Start As Long, Finish As Long, nCnt As Integer
    Static Average As Single
    Static Count As Long
    TilesDrawn = 0
    If AllowedToDraw = False Then Exit Sub
    Start = GetTickCount
    Dim nX As Integer, nY As Integer
    For nX = ScrnOfstX To ScrnOfstX + NoSqCanSeeX - 1
        For nY = ScrnOfstY To ScrnOfstY + NoSqCanSeeY - 1
            If Maps(ChAr.Map).Explored(nX, nY) = True Then _
            DrawTile nX, nY, Maps(ChAr.Map).Icon(nX, nY), False
        Next nY
    Next nX
    If Maps(ChAr.Map).NumEnts > 0 Then
        For nCnt = 0 To Maps(ChAr.Map).NumEnts - 1
            With Maps(ChAr.Map).Entity(nCnt)
                If .X >= ScrnOfstX And .X <= ScrnOfstX + NoSqCanSeeX _
                And .Y >= ScrnOfstY And .Y <= ScrnOfstY + NoSqCanSeeY _
                And Maps(ChAr.Map).Explored(.X, .Y) = True Then _
                DrawTile .X, .Y, .GetIcon, True
            End With
        Next nCnt
    End If
    If Itms.ItmCnt > 0 Then
        For nCnt = 0 To Itms.ItmCnt - 1
            With Itms
                If .InGame(nCnt) And .Map(nCnt) = ChAr.Map And _
                Maps(ChAr.Map).CanSee(.X(nCnt), .Y(nCnt)) Then _
                DrawTile .X(nCnt), .Y(nCnt), .Item(nCnt).Icon, True
            End With
        Next nCnt
    End If
    With Mons
        If .NumMons > 0 Then
            For nCnt = 0 To .NumMons - 1
                With .Monster(nCnt)
                    If Maps(ChAr.Map).CanSee(.X, .Y) And .InGame = True Then _
                    DrawTile .X, .Y, .Icon, True
                End With
            Next nCnt
        End If
    End With
    DrawTile ChAr.X, ChAr.Y, ChAr.Icon, True
    frmDisplay.Refresh
    Finish = GetTickCount
    Average = ((Average * Count) + (Finish - Start)) / (Count + 1)
    Count = Count + 1
    If Count / 10 - Int(Count / 10) = 0 Then _
    FeedBack "DEBUG-Average Screen Draw Time: " & Average & " ticks and " & TilesDrawn
End Sub

Function FitMapCode(pLevel As CLevel, pX As Integer, pY As Integer, pCode As String, pSame As EnumTileType) As Boolean
    Dim nCnt As Integer, dY As Integer, dX As Integer
    Dim MidChar As String
    FitMapCode = True
    For nCnt = 1 To 9
        MidChar = Mid(pCode, nCnt, 1)
        If MidChar <> "X" Then
            GetdXdY nCnt, dX, dY
            With pLevel
                If MidChar = "S" Then
                    If pX + dX < 0 Or pX + dX > pLevel.Width - 1 Or _
                    pY + dY < 0 Or pY + dY > pLevel.Height - 1 Then
                        
                    ElseIf .TileType(pX + dX, pY + dY) <> pSame Then FitMapCode = False: Exit Function
                    End If
                ElseIf MidChar = "D" Then
                    If pX + dX < 0 Or pX + dX > pLevel.Width - 1 Or _
                    pY + dY < 0 Or pY + dY > pLevel.Height - 1 Then
                        FitMapCode = False: Exit Function
                    ElseIf .TileType(pX + dX, pY + dY) = pSame Then FitMapCode = False: Exit Function
                    End If
                End If
            End With
        End If
    Next nCnt
End Function

Sub FixUpMapGfx(pLevel As CLevel)
    Dim BaseIcon As Integer, nX As Integer, nY As Integer
    Dim Start As Long, Finish As Long
    Dim IconNo As EnumIcon
    Start = GetTickCount
    If pMapType = Dungeon Then BaseIcon = 10
    With pLevel
        For nY = 0 To .Width - 1
            For nX = 0 To .Height - 1
                'mixes
                If FitMapCode(pLevel, nX, nY, "XSXDXSDSS", DungeonWall) Then IconNo = DungeonMixNicheTopRightWallRight: GoTo Finished
                'fill
                If FitMapCode(pLevel, nX, nY, "SSSSSSSSS", DungeonWall) Then
                    Select Case Rnd
                        Case Is < 0.15: IconNo = DungeonFillCracks1
                        Case Is < 0.3: IconNo = DungeonFillCracks2
                        Case Else: IconNo = DungeonFillBase
                    End Select
                    GoTo Finished
                End If
                'floor
                If FitMapCode(pLevel, nX, nY, "XXXXXXXXS", DungeonFloor) Then
                    Select Case Rnd
                        Case Is < 0.5: IconNo = DungeonFloorLightStone1
                        Case Else: IconNo = DungeonFloorLightStone2
                    End Select
                    GoTo Finished
                End If
                'corners
                If FitMapCode(pLevel, nX, nY, "XSXDXDXSS", DungeonWall) Then IconNo = DungeonCornerBottomRight: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSXSXDXDS", DungeonWall) Then IconNo = DungeonCornerBottomLeft: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XDXSXSXDS", DungeonWall) Then IconNo = DungeonCornerTopLeft: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XDXDXSXSS", DungeonWall) Then IconNo = DungeonCornerTopRight: GoTo Finished
                'walls
                If FitMapCode(pLevel, nX, nY, "XSXDXSXSS", DungeonWall) Then IconNo = DungeonWallRight: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSXSXSXDS", DungeonWall) Then IconNo = DungeonWallLeft: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XDXSXSXSS", DungeonWall) Then
                    If Rnd < 0.3 Then
                        IconNo = DungeonWallTopKinked: GoTo Finished
                    Else
                        IconNo = DungeonWallTopSmooth: GoTo Finished
                    End If
                End If
                If FitMapCode(pLevel, nX, nY, "XSXSXDXSS", DungeonWall) Then IconNo = DungeonWallBottom: GoTo Finished
                'niches
                If FitMapCode(pLevel, nX, nY, "XSXSDSXSS", DungeonWall) Then IconNo = DungeonNicheTopLeft: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSXSXSDSS", DungeonWall) Then IconNo = DungeonNicheTopRight: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSDSXSXSS", DungeonWall) Then IconNo = DungeonNicheBottomLeft: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "DSXSXSXSS", DungeonWall) Then IconNo = DungeonNicheBottomRight: GoTo Finished
                'peninsula
                If FitMapCode(pLevel, nX, nY, "XDXDXDXSS", DungeonWall) Then IconNo = DungeonPeninsulaRight: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSXDXDXDS", DungeonWall) Then IconNo = DungeonPeninsulaBottom:  GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XDXDXSXDS", DungeonWall) Then IconNo = DungeonPeninsulaTop: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XDXSXDXDS", DungeonWall) Then IconNo = DungeonPeninsulaLeft: GoTo Finished
                'pinches
                If FitMapCode(pLevel, nX, nY, "XDXSXDXSS", DungeonWall) Then IconNo = DungeonPinchLeftRight: GoTo Finished
                If FitMapCode(pLevel, nX, nY, "XSXDXSXDS", DungeonWall) Then IconNo = DungeonPinchTopBottom: GoTo Finished
                'other
                
                If FitMapCode(pLevel, nX, nY, "XDXDXDXDS", DungeonWall) Then IconNo = DungeonOtherStandAlone: GoTo Finished
Finished:
                .Icon(nX, nY) = IconNo
            Next nX
        Next nY
    End With

    Finish = GetTickCount
    FeedBack "DEBUG-Isometrisization time " & Finish - Start & " ticks"
End Sub

