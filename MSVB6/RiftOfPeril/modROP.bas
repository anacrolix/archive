Attribute VB_Name = "modROP"
Public Maps As ColLevels
Public ChAr As CCharacter
Public Time As CGameTime
Public Mons As ColMonsters
Public Itms As ColItems
Public GameRunning As Boolean

Sub NewGame()
    GameRunning = False
    'prepare environment, generate character
    frmMain.Show
    frmNew.Show 1
    If GameRunning = False Then Exit Sub
    MsgBox "Move using the numpad with NUMlock on or with the mouse, move onto enemies to attack. press f to load ur freehand.", vbInformation, "No help temp substitute"
    'initialize objects
    Set Maps = New ColLevels
    Set Time = New CGameTime
    Set Mons = New ColMonsters
    Set Itms = New ColItems
    'initilize levels
    Dim NewLevel As New CLevel
    DataFile.GetMap NewLevel, "Town Map"
    FixUpMapGfx NewLevel
    Maps.Add NewLevel, "Town Map"
    modData.ScatterItems "Town Map", 30
    'prepare character
    With ChAr
        .SetPosition 13, 13
        .Map = "Town Map"
        .BaseHP = 10
        .CurHP = .MaxHP
        .SetMvSpd 1
        .Icon = CharacterStickFigure
        .DmgMax = 6
        .NxtLvlXP = ChAr.GetNxtLvlXP(2)
        .AC = 10 + .GetActAb(aDex)
    End With
    ChAr.SeeAround
    Mons.AddGenericMonster Kobold, "Town Map", 12, 13
    With frmDisplay
        .lblStatus.Caption = ""
        .txtFeedBack.Text = ""
        .Show
        .txtFeedBack.Text = "Welcome to " & modData.SplashTitle
    End With
    AllowedToDraw = True
    CenterScreen
    DrawView
    UpdateStatus
End Sub

Sub Main()
    MsgBox "This is only a early development demo version, only bare basics are included", vbExclamation, "Test Version Only"
    Randomize Timer
    modData.Initialize
    frmSplash.Show 1
    frmIntroScreen.Show 1
End Sub

Sub CleanExit(Optional pWhatever As Integer)
    lres = MsgBox("Hope you had fun, return to http://stupidape.tripod.com for latest release", vbYesNo, "Exiting Rift Of Peril")
    If lres = vbYes Then
        End
    ElseIf lres = vbNo Then
        pWhatever = 1
    Else
        MsgBox "What the fucked... stuffed quit routine"
    End If
End Sub

Sub UpdateStatus()
    With frmDisplay.lblStatus
        .Caption = _
"HP (" & ChAr.MaxHP & ") " & ChAr.CurHP & vbCr & _
"Time " & Time.GetTime & vbCr & _
"XP " & ChAr.XP & ", need " & ChAr.NxtLvlXP
    End With
End Sub


Sub FeedBack(pFeedBack As String)
    With frmDisplay.txtFeedBack
        .Text = .Text & vbCr & vbLf & pFeedBack
        .SelStart = Len(.Text)
    End With
    frmDisplay.SetFocus
End Sub
