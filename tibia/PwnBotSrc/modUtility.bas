Attribute VB_Name = "modUtility"
Public Const INT_MAX = &H7FFF
Public Const UINT_MAX = &HFFFF&

Public Sub Delay(length As Long)
    Dim tick As Long
    tick = GetTickCount + length
    Do
        DoEvents
    Loop Until GetTickCount >= tick
End Sub

Public Function ByteArrayToString(buff() As Byte) As String
    Dim str As String, i As Integer
    For i = LBound(buff) To UBound(buff)
        If Int(buff(i)) < &H10 Then
            str = str & "0" & Hex(buff(i))
        Else
            str = str & Hex(buff(i))
        End If
    Next i
    ByteArrayToString = str
End Function

Public Function PacketToString(pckt() As Byte, weird As Boolean) As String
    Dim str As String, i As Long, nextBreak As Long, lastBreak As Long
    'On Error GoTo Fuck
    lastBreak = 0
    nextBreak = 2
    If weird Then
        nextBreak = &H7FFFFF
        lastBreak = -2
    End If
    For i = LBound(pckt) To UBound(pckt)
        If i = lastBreak + 2 And i >= 2 Then
            str = str & " (" & CLng(pckt(i - 1)) * &H100 + pckt(i - 2) & ")"
            If i <> nextBreak Then str = str & vbCrLf
        End If
        If i = nextBreak And i < UBound(pckt) - 1 Then
            str = str & vbCrLf & ">" '& vbCrLf
            lastBreak = nextBreak
            nextBreak = CLng(pckt(i + 1)) * &H100 + pckt(i) + nextBreak + 2
        End If
'        If (i - (lastBreak + 2)) = 0 Then
'            str = str & ">"
        If (i - (lastBreak + 2)) Mod &H10 = 0 Or i = 0 Then
            str = str & " "
        End If
        If Int(pckt(i)) < &H10 Then
            str = str & "0" & Hex(pckt(i))
        Else
            str = str & Hex(pckt(i))
        End If
        If i <> UBound(pckt) Then
            If (i - (lastBreak + 2)) Mod &H10 = &HF Then
                str = str & vbCrLf
            ElseIf (i - (lastBreak + 2)) Mod &H8 = &H7 Then
                str = str & " "
            End If
        End If
    Next i
Fuck:
    PacketToString = str
End Function

Public Function RoundUp(num As Long, den As Long) As Long
    Dim val As Long
    val = num \ den
    If num Mod den <> 0 Then val = val + 1
    RoundUp = val
End Function

Public Sub ModPred(ByRef val, ByVal min, ByVal max)
    val = val - 1
    If val < min Then val = max
End Sub

Public Sub ModSucc(ByRef val, ByVal min, ByVal max)
    val = val + 1
    If val > max Then val = min
End Sub

Public Sub TextBox_SelectAll(tb As TextBox)
    With tb
        .SelStart = 0
        .SelLength = Len(tb.Text)
    End With
End Sub

Public Function StrInBounds(str As String, low As Long, high As Long) As Boolean
    If IsNumeric(str) Then
        If CLng(str) >= low And CLng(str) <= high Then
            StrInBounds = True
        End If
    End If
End Function

Public Sub TextBox_BoundStr(tb As TextBox, low As Long, high As Long, Default As Long)
    If StrInBounds(tb.Text, low, high) = False Then tb = CStr(Default)
End Sub

'Public Sub RemovePadding(ByRef str As String, ByVal padding As String)
'    While InStr(1, Mid(str, 1, 1), padding) > 0
'        str = Right(str, Len(str) - 1)
'    Wend
'    While InStr(1, Mid(str, Len(str), 1), padding) > 0
'        str = Left(str, Len(str) - 1)
'    Wend
'End Sub

Public Function IsNumericBounded(str As String, low As Variant, high As Variant) As Boolean
    If IsNumeric(str) = False Then Exit Function
    If str <= low Then Exit Function
    If str >= high Then Exit Function
    IsNumericBounded = True
End Function

Public Function GetByte(ByVal byteOffset As Long, ByVal val As Long) As Byte
    While byteOffset > 0
        val = val \ &H100
        byteOffset = byteOffset - 1
    Wend
    GetByte = CByte(val Mod &H100)
End Function

Public Function IsEmptyArray(test() As Variant) As Boolean
    On Error GoTo ArrayEmpty
    If UBound(test) >= 0 Then Exit Function
ArrayEmpty:
    IsEmptyArray = True
End Function

Public Sub CopyMemory(ByVal adrFrom As Long, ByVal adrTo As Long, ByVal size As Long)
    Dim tempMem() As Byte
    ReDim tempMem(size - 1)
    ReadProcessMemory hProcClient, adrFrom, tempMem(0), size, 0
    WriteProcessMemory hProcClient, adrTo, tempMem(0), size, 0
End Sub

Public Function StrSign(val As Long) As String
    If val > 0 Then
        StrSign = "+" & val
    Else
        StrSign = val
    End If
End Function

Public Function TrimCStr(str As String) As String
    TrimCStr = Left(str, InStr(1, str, Chr$(0&)) - 1)
End Function

'concatenates an array of strings from the start index using delim
Public Function StrCatArray(str() As String, ByVal start As Long, ByVal delim As String) As String
    Dim i As Integer, ret As String
    If start > UBound(str) Or start < LBound(str) Then Exit Function
    ret = str(start)
    If UBound(str) = start Then GoTo Done
    For i = start + 1 To UBound(str)
        ret = ret & delim & str(i)
    Next i
Done:
    StrCatArray = ret
End Function

Public Sub TextBox_ForceDir(tb As TextBox)
    If GetDir_CompassStr(tb.Text) = -1 Then tb = ""
End Sub

