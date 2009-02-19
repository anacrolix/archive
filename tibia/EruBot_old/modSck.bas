Attribute VB_Name = "modSck"
Public Function LogList(buff() As Byte, Port As Long) As Byte()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim C3 As Integer
    Dim strTemp As String
    
    'MsgBox "loglist!! heloo!"
    On Error GoTo Error
    C1 = buff(3) + buff(4) * 256 + 7
    For C2 = 1 To buff(C1 - 1)
        strTemp = ""
        For C3 = 2 To buff(C1) + 1
            strTemp = strTemp & Chr(buff(C3 + C1))
        Next
        CList(C2).CName = strTemp
        C1 = C1 + buff(C1) + 2
        C1 = C1 + buff(C1) + 2
        CList(C2).IP = buff(C1) & "." & buff(C1 + 1) & "." & buff(C1 + 2) & "." & buff(C1 + 3)
        CList(C2).Port = buff(C1 + 4) + buff(C1 + 5) * 256
        buff(C1) = 127
        buff(C1 + 1) = 0
        buff(C1 + 2) = 0
        buff(C1 + 3) = 1
        buff(C1 + 4) = Port - Fix(Port / 256) * 256
        buff(C1 + 5) = Fix(Port / 256)
        C1 = C1 + 6
    Next
    LogList = buff
    Exit Function
Error:
    MsgBox "There was a problem logging into the server. It may be offline."
End Function

Public Function CharLog(buff() As Byte)
    Dim C1 As Integer
    For C1 = 14 To 13 + buff(12)
        name = name & Chr(buff(C1))
    Next C1
    For C1 = 1 To 60
        If name = CList(C1).CName Then
            frmMain.sckS.Close
            frmMain.sckS.Connect CList(C1).IP, CList(C1).Port
            CharName = name
            frmMain.Caption = "EruBot - " & CharName
            frmBroadcast.Caption = "Broadcast - " & CharName
            'frmStats.Caption = "Stats - " & CharName
            SetWindowText tHWND, "Tibia - " & CharName
            frmMain.chkExpHour.Value = Unchecked
            Exp_Stop
            ExpTime = 0
            AddStatusMessage "Connecting to character: " & name
            If frmMain.chkEatLog.Value = Checked Then
                AddStatusMessage "Deactived function: 'Log when food runs out.' - Containers with food not yet opened"
                frmMain.chkEatLog.Value = Unchecked
            End If
            If frmMain.chkHeal = Checked Then
                AddStatusMessage "Deactived function: 'Auto heal' - HP may differ from last character"
                frmMain.chkHeal.Value = Unchecked
            End If
            If frmRune.chkLogFinished.Value = Checked Then
                AddStatusMessage "Deactivate function: 'Log when no soul/blanks remaining.' - Containers containing blanks may not be open"
                frmRune.chkLogFinished.Value = Unchecked
            End If
            Valid
            Exit For
        End If
    Next C1
End Function

Public Function GetStats(Buff1() As Byte)
    Dim C1 As Long
    Dim buff() As Long
    ReDim buff(Buff1(0) + Buff1(1) * 256 + 1)
    For C1 = 0 To (Buff1(0) + Buff1(1) * 256 + 1)
        buff(C1) = Buff1(C1)
    Next
    C1 = 2
    Do
        If buff(C1) = &HA0 Then
            stHitPoints = buff(C1 + 1) + buff(C1 + 2) * 256
            stCapacity = buff(C1 + 5) + buff(C1 + 6) * 256
            stExperience = buff(C1 + 7) + buff(C1 + 8) * 256 + buff(C1 + 9) * 65536 + buff(C1 + 10) * 16777216
            stLevel = buff(C1 + 11)
            stMana = buff(C1 + 13) + buff(C1 + 14) * 256
            stMagicLevel = buff(C1 + 17)
            frmStats.lblHit.Caption = "Hit Points: " & stHitPoints
            frmStats.lblLevel.Caption = "Level: " & stLevel
            frmStats.lblMagic.Caption = "Magic Level: " & stMagicLevel
            frmStats.lblMana.Caption = "Mana: " & stMana
            C1 = C1 + 19
        ElseIf buff(C1) = &H8C Then
            C1 = C1 + 6
        End If
    Loop Until C1 > buff(0)
        
End Function

Public Sub LogInChar(sckIndex As Integer, name As String, account As Long, password As String)
    Dim buff() As Byte, byte1 As Byte, byte2 As Byte, byte3 As Byte, byte4 As Byte
    If frmMain.sckMC(sckIndex).State = sckConnected Then
        ReDim buff(15 + Len(name) + Len(password))
        buff(0) = 14 + Len(name) + Len(password)
        buff(1) = 0
        buff(2) = &HA
        buff(3) = &H2
        buff(4) = 0
        buff(5) = &HF8
        buff(6) = 2
        buff(7) = 0
        
        byte1 = Fix(account / 16777216)
        byte2 = Fix((account - byte1 * 16777216) / 65536)
        byte3 = Fix((account - byte1 * 16777216 - byte2 * 65536) / 256)
        byte4 = Fix(account - Fix(account / 16777216) * 16777216 - Fix((account - byte1 * 16777216) / 65536) * 65536 - Fix((account - byte1 * 16777216 - byte2 * 65536) / 256) * 256)
        
        buff(8) = byte4
        buff(9) = byte3
        buff(10) = byte2
        buff(11) = byte1
        buff(12) = Len(name)
        buff(13) = 0
        For i = 14 To 13 + Len(name)
            buff(i) = Asc(Mid(name, i - 13, 1))
        Next i
        buff(14 + Len(name)) = Len(password)
        buff(15 + Len(name)) = 0
        For i = 16 + Len(name) To 15 + Len(name) + Len(password)
            buff(i) = Asc(Mid(password, i - 15 - Len(name), 1))
        Next i
        frmMain.sckMC(sckIndex).SendData buff
    End If
End Sub
