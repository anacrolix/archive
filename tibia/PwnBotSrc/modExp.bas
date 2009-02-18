Attribute VB_Name = "modExp"
Public Enum enum_ExperienceStatus
    Stopped = 0
    Starting = 1
    Running = 2
End Enum

Const MAX_EXP_RECORDS = 450
Dim expRecords(MAX_EXP_RECORDS - 1) As Long
Dim expRate As Long
Dim nextRecordIndex As Long
Dim expLastTick As Long
Private moduleState As enum_ExperienceStatus
Private lastCharMem As typ_Char_Mem

Function GetState() As enum_ExperienceStatus
    GetState = moduleState
End Function

Sub SetState(newState As enum_ExperienceStatus)
    moduleState = newState
End Sub

Function GetExpPerHour() As Long
    GetExpPerHour = expRate
End Function

Function GetExpTnl() As Long
    GetExpTnl = ExpForLevel(charMem.level + 1) - charMem.exp
End Function

Sub ResetStats()
    Dim i As Integer
    For i = 0 To MAX_EXP_RECORDS - 1
        expRecords(i) = 0
    Next i
    nextRecordIndex = 0
    expLastTick = charMem.exp
    expRate = 0
    lastCharMem = charMem
End Sub

Private Sub CheckForAdvance( _
    ByVal skillName As String, _
    ByVal oldLevel As Long, _
    ByVal oldProgress As Long, _
    ByVal curLevel As Long, _
    ByVal curProgress As Long)
    
    If oldLevel <> curLevel Or oldProgress <> curProgress Then
        PutDefaultTab 100 - curProgress & "% to " & curLevel + 1 & " " & skillName & " remaining."
        MessageBeep MB_ICONEXCLAMATION
    End If
End Sub

Sub Update()
    On Error GoTo Problem
    'check for advances
    CheckForAdvance "Level", lastCharMem.level, lastCharMem.levelProgress, charMem.level, charMem.levelProgress
    CheckForAdvance "Sword Fighting", lastCharMem.sword, lastCharMem.swordProgress, charMem.sword, charMem.swordProgress
    CheckForAdvance "Shielding", lastCharMem.shielding, lastCharMem.shieldingProgress, charMem.shielding, charMem.shieldingProgress
    CheckForAdvance "Axe Fighting", lastCharMem.axe, lastCharMem.axeProgress, charMem.axe, charMem.axeProgress
    CheckForAdvance "Club Fighting", lastCharMem.club, lastCharMem.clubProgress, charMem.club, charMem.clubProgress
    CheckForAdvance "Fishing", lastCharMem.fishing, lastCharMem.fishingProgress, charMem.fishing, charMem.fishingProgress
    CheckForAdvance "Magic Level", lastCharMem.magic, lastCharMem.magicProgress, charMem.magic, charMem.magicProgress
    CheckForAdvance "Distance Fighting", lastCharMem.distance, lastCharMem.distanceProgress, charMem.distance, charMem.distanceProgress
    'record experience gained this tick
    Dim expGained As Long
    expGained = charMem.exp - expLastTick
    expLastTick = charMem.exp
    expRecords(nextRecordIndex) = expGained
    ModSucc nextRecordIndex, 0, MAX_EXP_RECORDS - 1
    'get sum(exp records)
    Dim i As Integer
    expRate = 0
    For i = 0 To MAX_EXP_RECORDS - 1
        expRate = expRate + expRecords(i)
    Next i
    expRate = (expRate * (3600000 \ TIME_EXP)) \ MAX_EXP_RECORDS
    lastCharMem = charMem
    Exit Sub
Problem:
    ReportBug "There was a problem updating experience records or checking for advances."
End Sub

Private Function ExpForLevel(lvl As Long) As Long
    ExpForLevel = ((50 / 3) * lvl * lvl * lvl) - 100 * lvl * lvl + ((850 / 3) * lvl) - 200
End Function

