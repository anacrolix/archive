Attribute VB_Name = "modUtility"
Public Function StrRev(str As String) As String
    Dim str2 As String, i As Long
    str2 = ""
    For i = Len(str) To 1 Step -1
        str2 = str2 & Mid(str, i, 1)
    Next i
    StrRev = str2
End Function

Public Function PadLong(num As Long, toPlaces As Integer) As String
    Dim strOut As String
    strOut = ""
    If toPlaces < 2 Then
        strOut = num
    Else
        Dim i As Integer
        For i = toPlaces To 1 Step -1
            If num >= 10 ^ (i - 1) Then
                strOut = strOut & num
                Exit For
            Else
                strOut = strOut & "0"
            End If
        Next i
    End If
    PadLong = strOut
End Function

Public Function PadInt(num As Integer, toPlaces As Integer) As String
    PadInt = PadLong(CLng(num), toPlaces)
End Function

Public Function HexStringToByteArray(ByRef str As String) As Byte()
    Dim i As Integer, buff() As Byte
    'strip whitespace
    i = 1
    While i <= Len(str)
        Select Case Mid(str, i, 1)
            Case "a" To "z", "A" To "Z", "0" To "9": 'nothing
            Case Else:
                str = Left(str, i - 1) & Right(str, Len(str) - i)
        End Select
        i = i + 1
    Wend
    'convert every 2 characters to byte
    If Len(str) Mod 2 <> 0 Or str = "" Then GoTo NotHexString
    ReDim buff((Len(str) / 2) - 1)
    For i = 0 To (Len(str) / 2) - 1
        buff(i) = CByte(val("&H" & Mid(str, i * 2 + 1, 2)))
    Next i
    HexStringToByteArray = buff
    Exit Function
    'errors
NotHexString:
    MsgBox "The entered hex string was invalid.", vbCritical, "Invalid input"
    End
    Exit Function
End Function

