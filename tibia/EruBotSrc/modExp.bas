Attribute VB_Name = "modExp"
Public Const expMaxTicks = 200
Dim expFirst As Long, expLast As Long, expTicks As Long
Dim sword As Long, club As Long, axe As Long, magic As Long, shield As Long, distance As Long, fist As Long, fish As Long
Dim tSword As Long, tClub As Long, tAxe As Long, tMagic As Long, tShield As Long, tDistance As Long, tFist As Long, tFish As Long
Public titleExperience As String
Public newCharTick As Long

Public Sub Experience_Start()
    expFirst = ReadMem(ADR_EXP, 4)
    sword = ReadMem(ADR_SWORD_PERCENT, 4)
    tSword = 0
    club = ReadMem(ADR_CLUB_PERCENT, 4)
    tClub = 0
    axe = ReadMem(ADR_AXE_PERCENT, 4)
    tAxe = 0
    shield = ReadMem(ADR_SHIELD_PERCENT, 4)
    tShield = 0
    fish = ReadMem(ADR_FISH_PERCENT, 4)
    tFish = 0
    distance = ReadMem(ADR_DISTANCE_PERCENT, 4)
    tDistance = 0
    magic = ReadMem(ADR_MAGIC_PERCENT, 4)
    tMagic = 0
    fist = ReadMem(ADR_FIST_PERCENT, 4)
    tFist = 0
    expLast = expFirst
    expTicks = 0
    titleExperience = "Pending experience.."
    frmMain.tmrExp = True
    UpdateWindowText
End Sub

Public Sub Experience_Stop()
    expFirst = 0
    expLast = 0
    expTicks = 0
    frmMain.tmrExp = False
    titleExperience = "Halting experience calculator.."
    UpdateWindowText
End Sub

Private Function CheckForAdvances(skillName As String, skillLevel As Long, oldSkill As Long, curSkill As Long, lastAdvance As Long) As Boolean
    Dim msg As String
    If curSkill > oldSkill Then
        oldSkill = curSkill
        CheckForAdvances = True
        msg = "You have " & 100 - curSkill & "% to " & skillLevel + 1 & " " & skillName & " to go"
        If lastAdvance > 0 Then msg = msg & vbCrLf & vbTab & HoursToStr((100 - curSkill) * (GetTickCount - lastAdvance) / 3600000) & " at " & HoursToStr((GetTickCount - lastAdvance) / 3600000) & " per 1%"
        lastAdvance = GetTickCount
        LogMsg msg
    ElseIf curSkill < oldSkill Then
        CheckForAdvances = True
        oldSkill = curSkill
        lastAdvance = 0
        LogMsg "You advanced to " & skillLevel & " " & skillName & "."
    End If
End Function

Public Sub CalculateExperience()
    'tibia-charname; exp tnl (exp/hr), % tnl (%/hr), time tnl
    Dim str As String
    Dim expPerPercent As Long, expThisPercent As Long, percentPerHour As Double
    Dim expHour As Long, expRemain As Long
    Dim level As Long, expCur As Long, percentLeft As Double
    Dim skill As Long, doBeep As Boolean
    
    If frmMain.sckServer.State <> sckConnected Or frmMain.sckClient.State <> sckConnected Then Exit Sub
    If expFirst = 0 Then
        nextchartick = GetTickCount
        Exit Sub
    End If
    'skill advance checks
    'magic
    If CheckForAdvances("Magic Level", ReadMem(ADR_MAGIC, 4), magic, ReadMem(ADR_MAGIC_PERCENT, 4), tMagic) Then doBeep = True
    'fist
    If CheckForAdvances("Fist Fighting", ReadMem(ADR_FIST, 4), fist, ReadMem(ADR_FIST_PERCENT, 4), tFist) Then doBeep = True
    'club
    If CheckForAdvances("Club Fighting", ReadMem(ADR_CLUB, 4), club, ReadMem(ADR_CLUB_PERCENT, 4), tClub) Then doBeep = True
    'sword
    If CheckForAdvances("Sword Fighting", ReadMem(ADR_SWORD, 4), sword, ReadMem(ADR_SWORD_PERCENT, 4), tSword) Then doBeep = True
    'axe
    If CheckForAdvances("Axe Fighting", ReadMem(ADR_AXE, 4), axe, ReadMem(ADR_AXE_PERCENT, 4), tAxe) Then doBeep = True
    'distance
    If CheckForAdvances("Distance Fighting", ReadMem(ADR_DISTANCE, 4), distance, ReadMem(ADR_DISTANCE_PERCENT, 4), tDistance) Then doBeep = True
    'shield
    If CheckForAdvances("Shielding", ReadMem(ADR_SHIELD, 4), shield, ReadMem(ADR_SHIELD_PERCENT, 4), tShield) Then doBeep = True
    'fish
    If CheckForAdvances("Fishing", ReadMem(ADR_FISH, 4), fish, ReadMem(ADR_FISH_PERCENT, 4), tFish) Then doBeep = True
    
    'experience to level
    expCur = ReadMem(ADR_EXP, 4)
    
    level = ReadMem(ADR_LEVEL, 4)
    percentLeft = 100 - ReadMem(ADR_LEVEL_PERCENT, 4)
    expTicks = expTicks + 1
    
    If expTicks > expMaxTicks Then
        expFirst = expFirst + (expCur - expFirst) / expTicks
        expTicks = expTicks - 1
    End If
        
    expHour = (1000 * (expCur - expFirst)) / expTicks
    expPerPercent = (ExpForLevel(level + 1) - ExpForLevel(level)) / 100
    expThisPercent = ExpForLevel(level) + expPerPercent * (100 - percentLeft)
    If expLast < expThisPercent Then doBeep = True
    expRemain = ExpForLevel(level + 1) - expCur
    percentLeft = expRemain / expPerPercent
    percentPerHour = expHour / expPerPercent
    str = ""
    If frmMain.chkExpTnl Then
        If expRemain < 10000 Then
            str = str & "" & expRemain
        Else
            str = str & "" & Round(expRemain / 1000, 0) & "k"
        End If
    End If
    If frmMain.chkExpPerHour Then
        If expHour < 3000 Then
            str = str & " (" & expHour & "/hr)"
        Else
            str = str & " (" & Round(expHour / 1000, 1) & "k/hr)"
        End If
    End If
    If frmMain.chkExpPercentTnl Then
        If frmMain.chkExpPercent2dp Then
            str = str & ", " & Round(percentLeft, 2) & "% tnl"
        Else
            str = str & ", " & Fix(percentLeft) & "% tnl"
        End If
    End If
    If frmMain.chkExpPercentPerHour Then
        If frmMain.chkExpPercent2dp Then
            str = str & " (" & Round(percentPerHour, 2) & "%/hr)"
        Else
            str = str & " (" & Fix(percentPerHour) & "%/hr)"
        End If
    End If
    If frmMain.chkExpTimeRemain And expHour <> 0 Then
        str = str & "; " & HoursToStr(expRemain / expHour)
    End If
    If frmMain.chkExpTitle Then
        titleExperience = str
    Else
        titleExperience = ""
    End If
    If expLast < expThisPercent Then LogMsg titleExperience
    expLast = expCur
    
    If doBeep And frmMain.chkExpBeep Then
        Beep 1000, 100
        Pause 100
        Beep 1500, 150
    End If
End Sub

Public Function ExpForLevel(lvl As Long) As Long
    ExpForLevel = ((50 / 3) * lvl * lvl * lvl) - 100 * lvl * lvl + ((850 / 3) * lvl) - 200
End Function
