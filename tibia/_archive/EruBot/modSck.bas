Attribute VB_Name = "modSck"
Public Type st_CharList
    CName As String
    IP As String
    Port As Integer
End Type

Public CharacterList(99) As st_CharList

Public Function LoginList(buff() As Byte, Port As Long) As Byte()
    Dim i As Integer, j As Integer
    Dim numChar As Integer, curChar As Integer
    Dim strTemp As String
    On Error GoTo Fuck
    i = buff(5) + buff(6) * 256 + 9
    numChar = buff(i - 1)
    For curChar = 0 To numChar - 1
        strTemp = ""
        For j = 0 To buff(i) - 1
            strTemp = strTemp & Chr(buff(i + 2 + j))
        Next j
        CharacterList(curChar).CName = strTemp
        i = buff(i) + 2 + i
        i = buff(i) + 2 + i
        CharacterList(curChar).IP = buff(i) & "." & buff(i + 1) & "." & buff(i + 2) & "." & buff(i + 3)
        CharacterList(curChar).Port = buff(i + 4) + buff(i + 5) * &H100
        buff(i) = 127
        buff(i + 1) = 0
        buff(i + 2) = 0
        buff(i + 3) = 1
        buff(i + 4) = Port - Fix(Port / &H100) * &H100
        buff(i + 5) = Fix(Port / &H100)
        i = i + 6
    Next curChar
Fuck:
    LoginList = buff
End Function


'Public Sub loginChar(sckIndex As Integer, name As String, account As Long, password As String)
'    Dim buff() As Byte, byte1 As Byte, byte2 As Byte, byte3 As Byte, byte4 As Byte
'    If frmMain.sckMC(sckIndex).State = sckConnected Then
'        ReDim buff(15 + Len(name) + Len(password))
'        buff(0) = 14 + Len(name) + Len(password)
'        buff(1) = 0
'        buff(2) = &HA
'        buff(3) = &H2
'        buff(4) = 0
'        buff(5) = &HF8
'        buff(6) = 2
'        buff(7) = 0
'
'        byte1 = Fix(account / 16777216)
'        byte2 = Fix((account - byte1 * 16777216) / 65536)
'        byte3 = Fix((account - byte1 * 16777216 - byte2 * 65536) / 256)
'        byte4 = Fix(account - Fix(account / 16777216) * 16777216 - Fix((account - byte1 * 16777216) / 65536) * 65536 - Fix((account - byte1 * 16777216 - byte2 * 65536) / 256) * 256)
'
'        buff(8) = byte4
'        buff(9) = byte3
'        buff(10) = byte2
'        buff(11) = byte1
'        buff(12) = Len(name)
'        buff(13) = 0
'        For i = 14 To 13 + Len(name)
'            buff(i) = Asc(Mid(name, i - 13, 1))
'        Next i
'        buff(14 + Len(name)) = Len(password)
'        buff(15 + Len(name)) = 0
'        For i = 16 + Len(name) To 15 + Len(name) + Len(password)
'            buff(i) = Asc(Mid(password, i - 15 - Len(name), 1))
'        Next i
'        frmMain.sckMC(sckIndex).SendData buff
'    End If
'End Sub
