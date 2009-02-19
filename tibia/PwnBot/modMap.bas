Attribute VB_Name = "modMap"
Option Explicit

Public Function GetTile_Char(id As Long) As Long
    Dim numObj As Long, i As Long, j As Long, ptrMap As Long
    ptrMap = ReadMem(ADR_MAP_POINTER, 4)
    If ptrMap <> 0 Then
        For i = 0 To LEN_TILE_ALL - 1
            numObj = ReadMem(ptrMap + i * SIZE_TILE + OS_TILE_NUM_OBJ, 4)
            If numObj > 1 Then
                For j = 1 To numObj - 1
                    If ReadMem(ptrMap + i * SIZE_TILE + j * SIZE_OBJ + OS_TILE_OBJ_ID, 4) = TILE_CHAR Then
                        If ReadMem(ptrMap + i * SIZE_TILE + j * SIZE_OBJ + OS_TILE_OBJ_DATA1, 4) = id Then
                            GetTile_Char = i
                            Exit Function
                        End If
                    End If
                Next j
            End If
        Next i
    End If
    GetTile_Char = -1
End Function
