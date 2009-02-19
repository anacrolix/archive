Attribute VB_Name = "modMap"
Public Const LEN_TILE = 2016
Public Const SIZE_TILE = 172

Public Const LEN_TILE_X = 18
Public Const LEN_TILE_Y = 14
Public Const LEN_TILE_Z = 8

Public Const SIZE_OBJ = 12
Public Const LEN_OBJ = 13

Public Const OFF_TILE_NUM_OBJ = 0
Public Const OFF_TILE_OBJ_ID = 4
Public Const OFF_TILE_OBJ_DATA1 = 8
Public Const OFF_TILE_OBJ_DATA2 = 12

Public Const TILE_CHAR = &H63
Public Const TILE_LADDER = &H79C

Public Function GetTileChar(id As Long) As Long
    Dim numObj As Long, i As Long, j As Long
    ptrMap = ReadMem(ADR_MAP_POINTER, 4)
    If ptrMap <> 0 Then
        For i = 0 To LEN_TILE - 1
            numObj = ReadMem(ptrMap + i * SIZE_TILE + OFF_TILE_NUM_OBJ, 4)
            If numObj > 1 Then
                For j = 1 To numObj - 1
                    If ReadMem(ptrMap + i * SIZE_TILE + j * SIZE_OBJ + OFF_TILE_OBJ_ID, 4) = TILE_CHAR Then
                        If ReadMem(ptrMap + i * SIZE_TILE + j * SIZE_OBJ + OFF_TILE_OBJ_DATA1, 4) = id Then
                            GetTileChar = i
                            Exit Function
                        End If
                    End If
                Next j
            End If
        Next i
    End If
    GetTileChar = -1
End Function

Public Function GetTopObjTile(tile As Long) As Long
    Dim ptrMap As Long, numObj As Long
    ptrMap = ReadMem(ADR_MAP_POINTER, 4)
    If ptrMap = 0 Then GoTo NotFound
    numObj = ReadMem(ptrMap + tile * SIZE_TILE + OFF_TILE_NUM_OBJ, 4)
    If numObj < 2 Then GoTo NotFound
    GetTopObjTile = ReadMem(ptrMap + tile * SIZE_TILE + 2 * SIZE_OBJ + OFF_TILE_OBJ_ID, 4)
    'frmMain.lblMyTilePosition = ptrMap + tile * SIZE_TILE + SIZE_OBJ + OFF_TILE_OBJ_ID
    Exit Function
NotFound:
    GetTopObjTile = -1
    LogDbg "top obj tile not found"
End Function

Public Function GetIndexTile(tile As Long, iX As Long, iY As Long, iZ As Long)
    iZ = Fix(tile / (LEN_TILE_Y * LEN_TILE_X))
    iY = Fix((tile - iZ * LEN_TILE_Y * LEN_TILE_X) / LEN_TILE_X)
    iX = Fix(tile - iZ * LEN_TILE_Y * LEN_TILE_X - iY * LEN_TILE_X)
End Function

Private Function WrapIndex(iX As Long, iY As Long, iZ As Long)
    iX = iX Mod LEN_TILE_X
    If iX < 0 Then iX = iX + LEN_TILE_X
    iY = iY Mod LEN_TILE_Y
    If iY < 0 Then iY = iY + LEN_TILE_Y
    iZ = iZ Mod LEN_TILE_Z
    If iZ < 0 Then iZ = iZ + LEN_TILE_Z
End Function

Public Function GetTileIndex(iX As Long, iY As Long, iZ As Long) As Long
    GetTileIndex = iZ * LEN_TILE_X * LEN_TILE_Y + iY * LEN_TILE_X + iX
End Function

Public Function GetTileOffset(tile As Long, dX As Long, dY As Long, dZ As Long)
    Dim iX As Long, iY As Long, iZ As Long
    GetIndexTile tile, iX, iY, iZ
    iX = iX + dX
    iY = iY + dY
    iZ = iZ + dZ
    WrapIndex iX, iY, iZ
    GetTileOffset = GetTileIndex(iX, iY, iZ)
End Function
