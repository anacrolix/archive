Attribute VB_Name = "modCharSpy"
Private lastCharMem As typ_Char_Mem

Public Sub DoCharSpy()
    UpdateCharMem
    Dim i As Long, j As Long, str As String 'i = new mem, j = old mem
    'check for new characters
    For i = 0 To LEN_CHAR - 1
        With charMem.char(i)
            If .onScreen <> CHAR_ONSCREEN Then GoTo NextI
            If IsMonster(i) Then GoTo NextI
            If i = GetPlayerIndex Then GoTo NextI
            j = GetChar_ByIdEx(lastCharMem, .id)
            str = TrimCStr(.name)
            If j >= 0 Then
                If lastCharMem.char(j).z = .z Then GoTo NextI
                str = str & " is now "
            Else
                str = str & " entered from the "
            End If
            str = str & Get_CompassStr_TibiaDir(Get_TibiaDir_Vector(.x - charMem.char(GetPlayerIndex).x, .y - charMem.char(GetPlayerIndex).y))
            str = str & " / "
            If .z <> charMem.char(GetPlayerIndex).z Then
                str = str & "Z " & StrSign(charMem.char(GetPlayerIndex).z - .z)
                str = str & " / "
            End If
            str = str & "SPD " & GetLevelBySpeed(.speed)
            Call Log(FEEDBACK, str)
        End With
NextI:
    Next i
    'check for missing characters
    For j = 0 To LEN_CHAR - 1
        With lastCharMem.char(j)
            If .onScreen <> CHAR_ONSCREEN Then GoTo NextJ
            If IsMonster(j) Then GoTo NextJ
            If j = GetPlayerIndexEx(lastCharMem) Then GoTo NextJ
            i = GetChar_ById(.id)
            If i >= 0 Then GoTo NextJ
            str = TrimCStr(.name)
            str = str & " left to the "
            str = str & Get_CompassStr_TibiaDir(Get_TibiaDir_Vector(.x - charMem.char(GetPlayerIndex).x, .y - charMem.char(GetPlayerIndex).y))
            str = str & " / "
            If .z <> charMem.char(GetPlayerIndex).z Then str = str & "Z " & StrSign(charMem.char(GetPlayerIndex).z - .z) & " / "
            str = str & "SPD " & GetLevelBySpeed(.speed)
            Call Log(FEEDBACK, str)
        End With
NextJ:
    Next j
    lastCharMem = charMem
End Sub

Public Sub CharSpy_ClearMem()
    Dim i As Long
    For i = 0 To LEN_CHAR - 1
        With lastCharMem.char(i)
            .onScreen = 0
        End With
    Next i
End Sub
