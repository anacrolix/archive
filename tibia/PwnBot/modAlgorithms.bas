Attribute VB_Name = "modAlgorithms"
Public Function Get_TibiaDir_dXdY(dX As Long, dY As Long) As Long
    Dim ret As Long
    If dX = 0 And dY = -1 Then
        ret = DIR_NORTH
    ElseIf dX = 1 And dY = 0 Then
        ret = DIR_EAST
    ElseIf dX = 0 And dY = 1 Then
        ret = DIR_SOUTH
    ElseIf dX = -1 And dY = 0 Then
        ret = DIR_WEST
    ElseIf dX = 1 And dY = -1 Then
        ret = DIR_NORTH_EAST
    ElseIf dX = 1 And dY = 1 Then
        ret = DIR_SOUTH_EAST
    ElseIf dX = -1 And dY = 1 Then
        ret = DIR_SOUTH_WEST
    ElseIf dX = -1 And dY = -1 Then
        ret = DIR_NORTH_WEST
    Else
        ret = -1
    End If
    Get_TibiaDir_dXdY = ret
End Function

Public Function Get_TibiaDir_Vector(dX As Long, dY As Long) As Long
    Dim length As Double, ret As Long
    length = (dX ^ 2 + dY ^ 2) ^ (1 / 2)
    If length = 0 Then
        ret = Get_TibiaDir_dXdY(0, 0)
    Else
        ret = Get_TibiaDir_dXdY(Round(dX / length, 0), Round(dY / length, 0))
    End If
    Get_TibiaDir_Vector = ret
End Function

Public Function Get_CompassStr_TibiaDir(td As Long) As String
    Dim ret As String
    Select Case td
        Case DIR_NORTH: ret = "north"
        Case DIR_NORTH_EAST: ret = "north east"
        Case DIR_EAST: ret = "east"
        Case DIR_SOUTH_EAST: ret = "south east"
        Case DIR_SOUTH: ret = "south"
        Case DIR_SOUTH_WEST: ret = "south west"
        Case DIR_WEST: ret = "west"
        Case DIR_NORTH_WEST: ret = "north west"
        Case Else:
            Debug.Print "unknown direction " & td
            ret = "unknown direction"
    End Select
    Get_CompassStr_TibiaDir = ret
End Function

Public Function GetDir_CompassStr(ByVal vbstrDir As String) As Long
    Dim str As String, ret As Long
    str = LCase(vbstrDir)
    Select Case str
        Case "n", "north": ret = DIR_NORTH
        Case "ne", "north east", "northeast": ret = DIR_NORTH_EAST
        Case "e", "east": ret = DIR_EAST
        Case "se", "south east", "southeast": ret = DIR_SOUTH_EAST
        Case "s", "south": ret = DIR_SOUTH
        Case "sw", "south west", "southwest": ret = DIR_SOUTH_WEST
        Case "w", "west": ret = DIR_WEST
        Case "nw", "north west", "northwest": ret = DIR_NORTH_WEST
        Case Else: ret = -1
    End Select
    GetDir_CompassStr = ret
End Function

Public Function GetChar_ByIdEx(cm As typ_Char_Mem, id As Long) As Long
    Dim i As Long
    For i = 0 To LEN_CHAR - 1
        With cm.char(i)
            If .id = id And .onScreen = CHAR_ONSCREEN Then
                GetChar_ByIdEx = i
                Exit Function
            End If
        End With
    Next i
    GetChar_ByIdEx = -1
End Function

Public Function GetChar_ById(id As Long)
    GetChar_ById = GetChar_ByIdEx(charMem, id)
End Function

Public Function GetChar_ByName(name As String) As Long
    Dim i As Long
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> 1 Then GoTo NextChar
            If StrCmp_Tibia(name, TrimCStr(.name)) = False Then GoTo NextChar
            GetChar_ByName = i
            Exit Function
        End With
NextChar:
    Next i
    GetChar_ByName = -1
End Function

Public Function GetPlayerIndexEx(cm As typ_Char_Mem) As Long
    GetPlayerIndexEx = GetChar_ByIdEx(cm, cm.playerID)
End Function

Public Function GetPlayerIndex() As Long
    Static lastIndex As Long
    If lastIndex >= 0 Then
        If charMem.playerID = charMem.char(lastIndex).id Then
            GetPlayerIndex = lastIndex
            Exit Function
        End If
    End If
    lastIndex = GetChar_ById(charMem.playerID)
    GetPlayerIndex = lastIndex
End Function

Public Function StrCmp_Tibia(ByVal str1 As String, ByVal str2 As String) As Boolean
    Dim tildeIndex As Long
    str1 = LCase(str1)
    str2 = LCase(str2)
    tildeIndex = InStr(1, str1, "~")
    If tildeIndex > 0 Then
        If Left(str1, tildeIndex - 1) <> Left(str2, tildeIndex - 1) Then Exit Function
    Else
        If str1 <> str2 Then Exit Function
    End If
    StrCmp_Tibia = True
End Function

Public Function GetXySeperation(char1 As Long, char2 As Long) As Long
    Dim sepTotal As Long, sepX As Long, sepY As Long
    sepX = Abs(charMem.char(char1).x - charMem.char(char2).x)
    sepY = Abs(charMem.char(char1).y - charMem.char(char2).y)
    sepTotal = sepX + sepY
    If sepX > 0 And sepY > 0 Then sepTotal = sepTotal - 1
    GetXySeperation = sepTotal
End Function

Public Function IsMonster(charIndex As Long) As Boolean
    IsMonster = IsMonsterEx(charMem, charIndex)
End Function

Public Function IsMonsterEx(cm As typ_Char_Mem, i As Long) As Boolean
    If GetByte(3, cm.char(i).id) = &H40 Then IsMonsterEx = True
End Function

Public Function IsGmPresent() As Boolean
    If IsGameActive = False Then Exit Function
    If GetPlayerIndex < 0 Then Exit Function
    With charMem.char(GetPlayerIndex)
        Dim charIndex As Long
        For charIndex = 0 To LEN_CHAR - 1
            If .onScreen <> 1 Then GoTo NextChar
            If StrCmp_Tibia("gm~", TrimCStr(.name)) = False Then GoTo NextChar
            IsGmPresent = True
            Exit For
NextChar:
        Next charIndex
    End With
End Function

Public Function NameInList(fileName As String, section As String, key As String, name As String) As Boolean
    If CheckIfIniKeyExists(fileName, section, key) = False Then
        WriteToINI fileName, section, key, ""
        GoTo Cancel
    End If
    Dim str1() As String, str2 As String, i As Integer
    On Error GoTo Cancel
    str1 = Split(ReadFromINI(fileName, section, key), ";")
    If UBound(str1) < 0 Then GoTo Cancel
    For i = LBound(str1) To UBound(str1)
        str2 = Trim(str1(i))
        If str2 = "" Then GoTo NextValue
        If StrCmp_Tibia(str2, name) = False Then GoTo NextValue
        NameInList = True
        Exit Function
NextValue:
    Next i
    Exit Function
Cancel:
End Function

Public Function ReadMem(ByVal address As Long, Optional ByVal size As Long = 4) As Long
    Dim value As Long
    ReadProcessMemory hProcClient, address, value, size, 0
    ReadMem = value
End Function

Public Sub WriteMem(ByVal address As Long, ByVal value As Long, Optional ByVal size As Long = 4)
    WriteProcessMemory hProcClient, address, value, size, 0
End Sub

Public Sub WriteMemStr(address As Long, str As String)
    Dim byteStr() As Byte, i As Integer
    ReDim byteStr(Len(str))
    For i = 0 To Len(str) - 1
        byteStr(i) = CByte(Asc(Mid(str, i + 1, 1)))
    Next i
    WriteProcessMemory hProcClient, address, byteStr(0), UBound(byteStr) + 1, 0
End Sub

Public Function ReadMemStr(address As Long, length As Integer) As String
    Dim byteStr() As Byte, i As Integer
    ReDim byteStr(length - 1)
    ReadProcessMemory hProcClient, address, byteStr(0), length, 0
    For i = 0 To length - 1
        If byteStr(i) = 0 Then Exit For
        ReadMemStr = ReadMemStr & Chr(byteStr(i))
    Next i
End Function

Public Function GetLevelBySpeed(speed As Long) As Long
    GetLevelBySpeed = (speed - 218) \ 2
End Function

Public Function IsImmune(monName As String, damageType As typ_Damage) As Boolean
    If damageType = DAMAGE_FORCE Then
        If NameInList(DataIniPath, "damage immunities", "force", monName) Then GoTo Yes
    ElseIf damageType = DAMAGE_ENERGY Then
        If NameInList(DataIniPath, "damage immunities", "energy", monName) Then GoTo Yes
    ElseIf damageType = DAMAGE_FIRE Then
        If NameInList(DataIniPath, "damage immunities", "fire", monName) Then GoTo Yes
    ElseIf damageType = DAMAGE_POISON Then
        If NameInList(DataIniPath, "damage immunities", "poison", monName) Then GoTo Yes
    End If
    Exit Function
Yes:
    IsImmune = True
End Function

Public Function GetValidStrikeDir(damageType As typ_Damage, hitPlayers As Boolean) As Long
    UpdateCharMem 2
    Dim i As Long, lowestHp As Long, bestIndex As Long
    bestIndex = LEN_CHAR: lowestHp = LONG_MAX
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> CHAR_ONSCREEN Then GoTo NextI
            If .z <> charMem.char(GetPlayerIndex).z Then GoTo NextI
            If i = GetPlayerIndex Then GoTo NextI
            If hitPlayers = False Then If IsMonster(i) = False Then GoTo NextI
            If IsImmune(TrimCStr(.name), damageType) Then GoTo NextI
            If .hp = 0 Then GoTo NextI
            If .hp >= lowestHp Then GoTo NextI
            If Abs(.x - charMem.char(GetPlayerIndex).x) > 1 _
                Or Abs(.y - charMem.char(GetPlayerIndex).y) > 1 _
                Then GoTo NextI
            If .x <> charMem.char(GetPlayerIndex).x And .y <> charMem.char(GetPlayerIndex).y Then GoTo NextI
            lowestHp = .hp
            bestIndex = i
        End With
NextI:
    Next i
    Dim ret As Long
    If bestIndex < LEN_CHAR Then
        ret = Get_TibiaDir_dXdY( _
            charMem.char(bestIndex).x - charMem.char(GetPlayerIndex).x, _
            charMem.char(bestIndex).y - charMem.char(GetPlayerIndex).y)
    Else
        ret = -1
    End If
    GetValidStrikeDir = ret
End Function

Public Sub WriteNops(address As Long, length As Long)
    Debug.Assert length > 0
    Dim i As Long
    For i = 0 To length - 1
        WriteProcessMemory hProcClient, address + i, &H90, 1, 0
    Next i
End Sub
