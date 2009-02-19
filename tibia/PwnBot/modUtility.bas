Attribute VB_Name = "modUtility"
Public Const INT_MAX = &H7FFF
Public Const UINT_MAX = &HFFFF&
Public Const LONG_MAX = &H7FFFFFFF

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
    Dim value As Long
    value = num \ den
    If num Mod den <> 0 Then value = value + 1
    RoundUp = value
End Function

Public Sub ModPred(ByRef value, ByVal min, ByVal max)
    value = value - 1
    If value < min Then value = max
End Sub

Public Sub ModSucc(ByRef value, ByVal min, ByVal max)
    value = value + 1
    If value > max Then value = min
End Sub

Public Sub TextBox_SelectAll(tb As TextBox)
    With tb
        .SelStart = 0
        .SelLength = Len(tb.Text)
    End With
End Sub

Public Function StrIsBoundedLong(str As String, min As Long, max As Long) As Boolean
    If IsNumeric(str) Then
        If CLng(str) >= min And CLng(str) <= max Then
            StrIsBoundedLong = True
        End If
    End If
End Function

Public Sub TextBox_ForceBoundedLong(tb As TextBox, min As Long, max As Long, default As Long)
    If StrIsBoundedLong(tb.Text, min, max) = False Then tb = CStr(default)
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

Public Function GetByte(ByVal byteOffset As Long, ByVal value As Long) As Byte
    While byteOffset > 0
        value = value \ &H100
        byteOffset = byteOffset - 1
    Wend
    GetByte = CByte(value Mod &H100)
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

Public Function StrSign(value As Long) As String
    If value > 0 Then
        StrSign = "+" & value
    Else
        StrSign = value
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

Public Sub TextBox_ForceDirStr(tb As TextBox, default As String)
    If GetDir_CompassStr(tb.Text) = -1 Then tb = ""
End Sub

Public Function HexStringToByteArray(ByVal str As String) As Byte()
    Dim i As Integer, buff() As Byte
    'put to ucase
    str = UCase(str)
    'strip non-hexidecimal
    i = 1
    While i <= Len(str)
        Select Case Mid(str, i, 1)
            Case "A" To "F", "0" To "9": 'nothing
            Case Else:
                'str = Left(str, i - 1) & Right(str, Len(str) - i)
                GoTo NotHexString
        End Select
        i = i + 1
    Wend
    'convert every 2 characters to byte
    If Len(str) Mod 2 <> 0 Or str = "" Then GoTo NotHexString
    ReDim buff((Len(str) \ 2) - 1)
    For i = 0 To UBound(buff)
        buff(i) = CByte(Int("&h" & Mid(str, i * 2 + 1, 2)))
    Next i
    HexStringToByteArray = buff
    Exit Function
    'errors
NotHexString:
'    MsgBox str, vbCritical, "Invalid hex string"
    Dim emptyBuff() As Byte
    HexStringToByteArray = emptyBuff
End Function
