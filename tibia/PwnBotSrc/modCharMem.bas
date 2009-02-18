Attribute VB_Name = "modCharMem"
Public charMem As typ_Char_Mem
Private lastCharMemUpdate As Long

Public Sub UpdateCharMem(Optional agePermitted As Long = TIME_CHARMEM_DEFAULT)
    If GetTickCount >= lastCharMemUpdate + agePermitted Then
        ReadProcessMemory hProcClient, ADR_BATTLE_SIGN, charMem, Len(charMem), 0
        lastCharMemUpdate = GetTickCount
    End If
End Sub

Public Function IsCharMemRecent(agePermitted As Long) As Boolean
    If GetTickCount < lastCharMemUpdate + agePermitted Then IsCharMemRecent = True
End Function
