Attribute VB_Name = "modSck"
Public Function LogList(Buff() As Byte, Port As Long) As Byte()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim C3 As Integer
    Dim strTemp As String
    C1 = Buff(3) + Buff(4) * 256 + 7
    For C2 = 1 To Buff(C1 - 1)
        strTemp = ""
        For C3 = 2 To Buff(C1) + 1
            strTemp = strTemp & Chr(Buff(C3 + C1))
        Next
        CList(C2).CName = strTemp
        C1 = C1 + Buff(C1) + 2
        C1 = C1 + Buff(C1) + 2
        CList(C2).IP = Buff(C1) & "." & Buff(C1 + 1) & "." & Buff(C1 + 2) & "." & Buff(C1 + 3)
        CList(C2).Port = Buff(C1 + 4) + Buff(C1 + 5) * 256
        Buff(C1) = 127
        Buff(C1 + 1) = 0
        Buff(C1 + 2) = 0
        Buff(C1 + 3) = 1
        Buff(C1 + 4) = Port - Fix(Port / 256) * 256
        Buff(C1 + 5) = Fix(Port / 256)
        C1 = C1 + 6
    Next
    LogList = Buff
End Function

Public Function CharLog(Buff() As Byte)
    Dim C1 As Integer
    Dim Name As String
    For C1 = 14 To 13 + Buff(12)
        Name = Name & Chr(Buff(C1))
    Next
    For C1 = 1 To 20
        If Name = CList(C1).CName Then
            frmMain.sckS.Close
            frmMain.sckS.Connect CList(C1).IP, CList(C1).Port
            frmMain.Caption = "PBot 4.0 - " & Name
            frmStats.Caption = "Stats - " & Name
            Exit For
        End If
    Next
End Function

Public Function GetStats(Buff1() As Byte)
    Dim C1 As Long
    Dim Buff() As Long
    ReDim Buff(Buff1(0) + Buff1(1) * 256 + 1)
    For C1 = 0 To (Buff1(0) + Buff1(1) * 256 + 1)
        Buff(C1) = Buff1(C1)
    Next
    C1 = 2
    Do
        If Buff(C1) = &HA0 Then
            stHitPoints = Buff(C1 + 1) + Buff(C1 + 2) * 256
            stCapacity = Buff(C1 + 5) + Buff(C1 + 6) * 256
            stExperience = Buff(C1 + 7) + Buff(C1 + 8) * 256 + Buff(C1 + 9) * 65536 + Buff(C1 + 10) * 16777216
            stLevel = Buff(C1 + 11)
            stMana = Buff(C1 + 13) + Buff(C1 + 14) * 256
            stMagicLevel = Buff(C1 + 17)
            frmStats.lblHit.Caption = "Hit Points: " & stHitPoints
            frmStats.lblLevel.Caption = "Level: " & stLevel
            frmStats.lblMagic.Caption = "Magic Level: " & stMagicLevel
            frmStats.lblMana.Caption = "Mana: " & stMana
            C1 = C1 + 19
        ElseIf Buff(C1) = &H8C Then
            C1 = C1 + 6
        End If
    Loop Until C1 > Buff(0)
        
End Function
