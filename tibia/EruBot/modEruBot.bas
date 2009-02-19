Attribute VB_Name = "modEruBot"
Private Declare Sub GetSystemTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)

Public Const NUM_CHAR_LISTS = 20

Private Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Public Type typ_Char
    Name As String * 32
    Trigger_HP As Long
End Type

Public Type typ_Char_List
    Char() As typ_Char
    lenChar As Integer
End Type

Public charLists(1 To 20) As typ_Char_List

Public Sub LoadCharLists()
    Dim i As Integer, j As Integer, strList() As String, strChar() As String
    For i = 1 To NUM_CHAR_LISTS
        strList = Split(ReadFromINI(App.Path & "\hiho.ebs", "character lists", "list " & Index), "; ")
        If UBound(strList) >= 0 Then
            ReDim charLists(i).Char(UBound(strList))
        Else
            charLists(i).lenChar = 0
            GoTo Continue
        End If
        For j = 0 To UBound(charLists(i).Char)
            strChar = Split(strList(j), ", ")
            If UBound(strChar) > 1 Then
                MsgBox "Too much char information"
                Exit Sub
            End If
            charLists(i).Char(j).Name = Left(strChar(0), 32)
            If UBound(strChar) = 1 Then charLists(i).Char(j).Trigger_HP = CLng(strChar(1))
        Next j
Continue:
    Next i
End Sub

Public Sub ConfigUpdate(fileLoc As String, wer As Boolean)
    If wer Then
        WriteToINI fileLoc, "erubot settings file", "version", App.Major & "." & App.Minor & "." & App.Revision
        WriteToINI fileLoc, "characters", "enemies", frmCharacters.listEnemies
    Else
        '
    End If
'    Dim FN As Integer, temp As String
'    FN = FreeFile
'    On Error GoTo Cancel
'    If wer Then
'        Open fileLoc For Output As #FN
'        Write #FN, "***ERUBOT SETTINGS FILE***"
'        Write #FN, App.Major & "." & App.Minor & "." & App.Revision
'    Else
'        Open fileLoc For Input As #FN
'        getNext FN
'        temp = getNext(FN)
'        'If temp <> App.Major & "." & App.Minor & "." & App.Revision Then MsgBox "Settings file and application version do not match. There may be errors in loading file:" & vbCrLf & setLoc & vbCrLf & "Check loaded settings and resave file with newer version.", vbCritical, "Potential version conflict."
'    End If
'
''    Config_Title FN, wer, "***MAIN***"
''    Config_Control FN, wer, frmMain.chkAimbot
''    Config_ControlArray FN, wer, frmAimbot.comboButton
''    Config_ControlArray FN, wer, frmAimbot.comboWeapon
''    If wer = False Then
''        frmRune.hscrManaReq_Change
''        frmRune.hscrSoulReq_Change
''    End If
''    Config_ListBox FN, wer, "MAGE CREW.MAGE LIST", frmMageCrew.listMages
'
'    Config_Title FN, wer, "***CHARACTERS***"
'    Config_ListBox FN, wer, "CHARACTERS.ENEMIES", frmCharacters.listEnemies
'    Config_ListBox FN, wer, "CHARACTERS.FRIENDS", frmCharacters.listFriends
'    Config_ListBox FN, wer, "CHARACTERS.SAFE", frmCharacters.listSafe
'    Config_Title FN, wer, "***ITEMS***"
'    Config_ListBox FN, wer, "ITEMS.LOOT-LOOTSTACK", frmLoot.listLootStack
'    Config_ListBox FN, wer, "ITEMS.LOOT-NONSTACK", frmLoot.listLootNonStack
'    Config_ListBox FN, wer, "ITEMS.STACK", frmLoot.listStack
'    Config_ListBox FN, wer, "ITEMS.NONSTACK", frmLoot.listNonStack
'    Config_Title FN, wer, "***BINDINGS***"
'    Config_ControlArray FN, wer, frmBindings.txtAction
'
'    If wer Then
'        LogMsg "Settings file saved to " & vbCrLf & fileLoc
'    Else
'        LogMsg "Settings file loaded from " & vbCrLf & fileLoc
'        'Valid
'    End If
'Cancel:
'    Close FN
End Sub

Public Sub LogDbg(msg As String)
    If frmMain.mnuDebug.Checked = True Then LogMsg msg
End Sub

Public Sub LogMsg(msg As String)
    Dim st As SYSTEMTIME
    
    GetSystemTime st
    
    st.wHour = st.wHour + timeZone
    If st.wHour > 23 Then
        st.wHour = st.wHour - 24
    ElseIf st.wHour < 0 Then
        st.wHour = st.wHour + 24
    End If

    With frmMain.txtLog
        If .Text <> "" Then .Text = .Text & vbCrLf
        .Text = .Text _
        & PadInt(st.wHour, 2) & ":" & PadInt(st.wMinute, 2)
        If frmMain.mnuDebug.Checked Then .Text = .Text & ":" & PadInt(st.wSecond, 2)
        .Text = .Text & vbTab & msg
        .SelStart = Len(.Text)
        .SelLength = 0
    End With
End Sub

