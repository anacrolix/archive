Attribute VB_Name = "Module1"
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByRef lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function GetForegroundWindow Lib "user32" () As Long
Public Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Public Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal sURL As String, ByVal sHeaders As String, ByVal lHeadersLength As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
Public Declare Function InternetReadFile Lib "wininet.dll" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Public Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
Public Declare Function GetDesktopWindow Lib "user32" () As Long
Public Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Public Const RMem = 1
Public Const WMem = 2

Public Const adrExp = &H49D01C
Public Const adrLvl = &H49D018
Public Const adrMana = &H49D008
Public Const adrHitP = &H49D024
Public Const adrLight = &H49D0FC
Public Const adrXPos = &H127080
Public Const adrYPos = &H127084
Public Const adrZPos = &H127088
Public Const adrXGo = &H49D06C
Public Const adrYGo = &H49D068
Public Const adrGo = &H49D0D4
Public Const adrBPOpen = &H4A5398
Public Const adrBPItem = &H4A53D4
Public Const adrBPItems = &H4A53D0
Public Const adrXChar = &H49D0AC
Public Const adrYChar = &H49D0B0
Public Const adrZChar = &H49D0B4
Public Const adrBChar = &H49D114
Public Const adrNChar = &H49D088
Public Const adrAtk = &H49CFFC
Public Const adrWText = &H5F2DA8
Public Const adrWhiteTT = &H5F2DA4
Public Const adrNameStart = &H49D08C
Public Const adrIP = &H5EB918
Public Const adrPort = &H5EB90C
Public Const BPDist = 492
Public Const CharDist = 156
Public Const adrRightHand = &H4A5350
Public Const adrAmmo = &H4A538C


Public Characters(20) As String
Public Connection(20) As String
Public GameConnection As String
Public TryCon As Boolean
Public boolLight As Boolean
Public ClockPos As Integer
Public Mana As Long
Public HitPoints As Long
Public HitPoints2 As Long
Public UserPos As Long

Public TibiaDir As String
Public FColor As Long
Public BColor As Long

Public Thwnd As Long

Public Function Memory(hwnd As Long, Address As Long, Value As Long, Size As Long, Process As Integer)
    Dim pid As Long
    Dim phandle As Long
    GetWindowThreadProcessId hwnd, pid
    phandle = OpenProcess(&H1F0FFF, False, pid)
    If Process = 1 Then ReadProcessMemory phandle, Address, Value, Size, 0
    If Process = 2 Then WriteProcessMemory phandle, Address, Value, Size, 0
    CloseHandle hProcess
End Function

Public Function Pause(Milliseconds As Long)
    Dim EndPause As Long
    EndPause = GetTickCount + Milliseconds
    Do
        DoEvents
    Loop Until GetTickCount >= EndPause
End Function

Public Function StrToMem(hwnd As Long, Address As Long, Text As String)
    Dim C1 As Integer
    For C1 = 0 To Len(Text) - 1
        Memory hwnd, Address + C1, Asc(Right(Text, Len(Text) - C1)), 1, WMem
    Next
    Memory hwnd, Address + Len(Text), 0, 1, WMem
End Function

Public Function MoveItem(Item As Long, fromLoc As Integer, fromSlot As Integer, toLoc As Integer, toSlot As Integer)
    Dim buff(16) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    buff(0) = &HF
    buff(1) = &H0
    buff(2) = &H78
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = Byte2
    buff(9) = Byte1
    buff(10) = fromSlot
    buff(11) = &HFF
    buff(12) = &HFF
    buff(13) = toLoc
    buff(14) = &H0
    buff(15) = toSlot
    buff(16) = &H1
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UseHere(Item As Long, fromLoc As Integer, fromSlot As Integer)
    Dim buff(11) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    buff(0) = &HA
    buff(1) = &H0
    buff(2) = &H82
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = Byte2
    buff(9) = Byte1
    buff(10) = fromSlot
    buff(11) = &H0
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function SayStuff(Message As String)
    Dim Mess() As Byte
    Dim C1 As Integer
    ReDim Mess(Len(Message) + 5) As Byte
    Mess(0) = Len(Message) + 4
    Mess(1) = &H0
    Mess(2) = &H96
    Mess(3) = &H1
    Mess(4) = Len(Message)
    Mess(5) = 0
    For C1 = 6 To Len(Message) + 5
        Mess(C1) = Asc(Right(Message, Len(Message) - (C1 - 6)))
    Next
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Mess
End Function

Public Function UseAt(Item As Long, fromLoc As Integer, fromSlot As Integer, toX As Long, toY As Long, toZ As Long)
    Dim ItemUsed(18) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    ItemUsed(0) = &H11
    ItemUsed(1) = &H0
    ItemUsed(2) = &H83
    ItemUsed(3) = &HFF
    ItemUsed(4) = &HFF
    ItemUsed(5) = fromLoc
    ItemUsed(6) = &H0
    ItemUsed(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    ItemUsed(8) = Byte2
    ItemUsed(9) = Byte1
    ItemUsed(10) = fromSlot
    Byte1 = Fix(toX / 256)
    Byte2 = toX - (Fix(toX / 256) * 256)
    ItemUsed(11) = Byte2
    ItemUsed(12) = Byte1
    Byte1 = Fix(toY / 256)
    Byte2 = toY - (Fix(toY / 256) * 256)
    ItemUsed(13) = Byte2
    ItemUsed(14) = Byte1
    ItemUsed(15) = toZ
    If Item = &HA14 Then
        ItemUsed(16) = &HEA
        ItemUsed(17) = &H1
        ItemUsed(18) = &H0
    Else
        ItemUsed(16) = &H63
        ItemUsed(17) = &H0
        ItemUsed(18) = &H1
    End If
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData ItemUsed
End Function

Public Function IntOnly(Changed As TextBox, Intgr As Integer)
    If Changed.Text = "" Then
        Intgr = -1
    ElseIf IsNumeric(Changed) = True Then
        Changed.Text = Abs(Fix(Changed))
        Intgr = Changed.Text
    Else
        Changed.Text = Intgr
    End If
End Function

Public Function GetUrlSource(sURL As String) As String
    Dim sBuffer As String * 256, iResult As Integer, sData As String
    Dim hInternet As Long, hSession As Long, lReturn As Long
    
    hSession = InternetOpen("vb wininet", 1, vbNullString, vbNullString, 0)
    If hSession Then hInternet = InternetOpenUrl(hSession, sURL, vbNullString, 0, &H4000000, 0)
    If hInternet Then
        iResult = InternetReadFile(hInternet, sBuffer, 256, lReturn)
        sData = sBuffer
        Do While lReturn <> 0
            iResult = InternetReadFile(hInternet, sBuffer, 256, lReturn)
            sData = sData + Mid(sBuffer, 1, lReturn)
        Loop
    End If
    iResult = InternetCloseHandle(hInternet)
    GetUrlSource = sData
End Function

Public Function TalkWhite(StrWord As String)
    Dim C1 As Integer
    Dim Demmo As String
    For C1 = 0 To Len(StrWord) - 1
        Memory Thwnd, adrWText + C1, Asc(Right(StrWord, Len(StrWord) - C1)), 1, WMem
    Next
    Memory Thwnd, adrWText + Len(StrWord), 0, 1, WMem
    Memory Thwnd, adrWText - 4, 50, 1, WMem
End Function

Public Function ExpToLvl(Level As Long, Expr As Long) As String
    Dim strString As String

    ExpToLvl = (-Expr + ((50 / 3) * Level * Level * Level) - 100 * Level * Level + ((850 / 3) * Level) - 200) & " experience until level " & (Level) & "."
End Function

Public Function ShootRune(RuneMem As Long, X As Long, Y As Long, Z As Long)
    Dim C1 As Integer
    Dim C2 As Integer
    Dim items As Long
    Dim bpopen As Long
    Dim ltemp As Long
    Dim Temp As Long
    
    For C1 = 0 To 9
        Memory Thwnd, adrBPOpen + (BPDist * C1), bpopen, 1, RMem
        If bpopen = 1 Then
            Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
            For C2 = 0 To items - 1
                Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), ltemp, 2, RMem
                If ltemp = RuneMem Then Exit For
            Next
            If ltemp = RuneMem Then Exit For
        End If
    Next
    If ltemp = RuneMem Then
        UseAt RuneMem, &H40 + C1, C2, X, Y, Z
        Pause 500
    End If
End Function

Public Function EndAll()
    Unload frmAim
    Unload frmHeal
    Unload frmRune
    Unload frmSpell
    Unload frmAttack
    Unload frmAttackSetup
    Unload frmCharSearch
    Unload frmWalk
    Unload frmSkin
    Unload frmSM
    Unload frmMain
    End
End Function

Public Function IsFood(Item As Long) As Boolean
    IsFood = False
    If Item >= &HA6A And Item <= &HA83 Then IsFood = True
    If Item = &HA87 Or Item = &HA88 Then IsFood = True
    If Item = &HAE3 Or Item = &HAE4 Or Item = &HAE5 Then IsFood = True
End Function

Public Function Valid()
    If frmMain.mnuActive.Checked = True Then
        If frmMain.chRune.Value = Checked Then frmRune.Timer.Interval = 1000
        If frmMain.chRune.Value <> Checked Then frmRune.Timer.Interval = 0
        If frmMain.chSpell.Value = Checked Then frmSpell.Timer.Interval = 2000
        If frmMain.chSpell.Value <> Checked Then frmSpell.Timer.Interval = 0
        If frmMain.chAttack.Value = Checked Then frmAttack.Timer.Interval = 500
        If frmMain.chAttack.Value <> Checked Then frmAttack.Timer.Interval = 0
        If frmMain.chHeal.Value = Checked Then frmHeal.Timer.Interval = 200
        If frmMain.chHeal.Value <> Checked Then frmHeal.Timer.Interval = 0
        If frmMain.chFish.Value = Checked Then frmMain.tmrFish.Interval = 1500
        If frmMain.chFish.Value <> Checked Then frmMain.tmrFish.Interval = 0
        If frmMain.chEat.Value = Checked Then frmMain.tmrEat.Interval = 20000
        If frmMain.chEat.Value <> Checked Then frmMain.tmrEat.Interval = 0
        If frmMain.chWalk.Value = Checked Then frmWalk.Timer.Interval = 500
        If frmMain.chWalk.Value <> Checked Then frmWalk.Timer.Interval = 0
    Else
        frmRune.Timer.Interval = 0
        frmSpell.Timer.Interval = 0
        frmAttack.Timer.Interval = 0
        frmHeal.Timer.Interval = 0
        frmMain.tmrFish.Interval = 0
        frmMain.tmrEat.Interval = 0
        frmWalk.Timer.Interval = 0
    End If
End Function

Public Function FindChar()
    Dim X1 As Long
    Dim X2 As Long
    Dim Y1 As Long
    Dim Y2 As Long
    Dim Z1 As Long
    Dim Z2 As Long
    Dim bt As Long
    
    For C1 = 0 To 147
        Memory Thwnd, adrXPos, X1, 4, RMem
        Memory Thwnd, adrYPos, Y1, 4, RMem
        Memory Thwnd, adrZPos, Z1, 4, RMem
        Memory Thwnd, adrXChar + (CharDist * C1), X2, 4, RMem
        Memory Thwnd, adrYChar + (CharDist * C1), Y2, 4, RMem
        Memory Thwnd, adrZChar + (CharDist * C1), Z2, 4, RMem
        Memory Thwnd, adrBChar + (CharDist * C1), bt, 1, RMem
        If X1 = X2 And Y1 = Y2 And Z1 = Z2 And bt = 1 Then
            UserPos = C1
            Exit For
        End If
    Next
End Function

Public Function TextChange(lngColor As Long)
    Dim C1 As Integer
    FColor = lngColor
    With frmMain
        .chRune.ForeColor = lngColor
        .chEat.ForeColor = lngColor
        .chAttack.ForeColor = lngColor
        .chFish.ForeColor = lngColor
        .chHeal.ForeColor = lngColor
        .chSpell.ForeColor = lngColor
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
        .shpClock.BorderColor = lngColor
        .lnClock.BorderColor = lngColor
        .chWalk.ForeColor = lngColor
    End With
    With frmRune
        For C1 = 0 To 9
            .lblBP(C1).ForeColor = lngColor
            .lblRunes(C1).ForeColor = lngColor
        Next
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
        .Label4.ForeColor = lngColor
        .Label5.ForeColor = lngColor
        .Label6.ForeColor = lngColor
        .optAdv.ForeColor = lngColor
        .optSim.ForeColor = lngColor
    End With
    With frmSpell
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
    End With
    With frmAim
        .Check1.ForeColor = lngColor
        .Check2.ForeColor = lngColor
        .Check3.ForeColor = lngColor
    End With
    With frmAttack
        For C1 = 0 To 7
            .Beeplbl(C1).ForeColor = lngColor
            .PauseBeg(C1).ForeColor = lngColor
            .PauseSec(C1).ForeColor = lngColor
            .Talklbl(C1).ForeColor = lngColor
            .MoveXl(C1).ForeColor = lngColor
            .MoveYl(C1).ForeColor = lngColor
            .SBotlbl(C1).ForeColor = lngColor
        Next
    End With
    With frmHeal
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
        .Label3.ForeColor = lngColor
        .Label4.ForeColor = lngColor
        .chIh.ForeColor = lngColor
        .chUh.ForeColor = lngColor
        .chRuneH.ForeColor = lngColor
        .chSpellH.ForeColor = lngColor
        .optRune.ForeColor = lngColor
        .optSpell.ForeColor = lngColor
    End With
    With frmCharSearch
        .lblCharName.ForeColor = lngColor
        .lblGuild.ForeColor = lngColor
        .lblHouse.ForeColor = lngColor
        .lblLevel.ForeColor = lngColor
        .lblLog.ForeColor = lngColor
        .lblName.ForeColor = lngColor
        .lblProf.ForeColor = lngColor
        .lblRes.ForeColor = lngColor
        .lblSex.ForeColor = lngColor
        .lblWorld.ForeColor = lngColor
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
        .Label3.ForeColor = lngColor
        .Label4.ForeColor = lngColor
        .Label5.ForeColor = lngColor
        .Label6.ForeColor = lngColor
        .Label7.ForeColor = lngColor
        .Label9.ForeColor = lngColor
        .Label11.ForeColor = lngColor
        .Label12.ForeColor = lngColor
        .txtComment.ForeColor = lngColor
        .Line1.BorderColor = lngColor
        .Line2.BorderColor = lngColor
        .Line3.BorderColor = lngColor
    End With
    With frmSkin
        .Label1.ForeColor = lngColor
        .Label2.ForeColor = lngColor
        .Label3.ForeColor = lngColor
        .Label4.ForeColor = lngColor
        .Label5.ForeColor = lngColor
        .Label6.ForeColor = lngColor
        .Label7.ForeColor = lngColor
        .Label8.ForeColor = lngColor
    End With
    With frmSM
        .lblMaster.ForeColor = lngColor
        .lblMove.ForeColor = lngColor
        .lblSay.ForeColor = lngColor
        .lblSlaves.ForeColor = lngColor
        .chSlave.ForeColor = lngColor
    End With
    With frmWalk
        .chAC.ForeColor = lngColor
    End With
    
End Function

Public Function BackChange(lngColor As Long)
    BColor = lngColor
    With frmMain
        .BackColor = lngColor
        .chAttack.BackColor = lngColor
        .chEat.BackColor = lngColor
        .chFish.BackColor = lngColor
        .chHeal.BackColor = lngColor
        .chRune.BackColor = lngColor
        .chSpell.BackColor = lngColor
        .chWalk.BackColor = lngColor
    End With
    With frmRune
        .BackColor = lngColor
        .optAdv.BackColor = lngColor
        .optSim.BackColor = lngColor
    End With
    With frmAim
        .BackColor = lngColor
        .Check1.BackColor = lngColor
        .Check2.BackColor = lngColor
        .Check3.BackColor = lngColor
    End With
    With frmAttack
        .BackColor = lngColor
    End With
    With frmAttackSetup
        .BackColor = lngColor
    End With
    With frmHeal
        .BackColor = lngColor
        .chIh.BackColor = lngColor
        .chUh.BackColor = lngColor
        .chRuneH.BackColor = lngColor
        .chSpellH.BackColor = lngColor
        .optRune.BackColor = lngColor
        .optSpell.BackColor = lngColor
    End With
    With frmSpell
        .BackColor = lngColor
    End With
    With frmCharSearch
        .BackColor = lngColor
        .txtComment.BackColor = lngColor
    End With
    With frmSkin
        .BackColor = lngColor
    End With
    With frmSM
        .BackColor = lngColor
        .chSlave.BackColor = lngColor
    End With
    With frmWalk
        .BackColor = lngColor
        .chAC.BackColor = lngColor
    End With
End Function

Public Function MessagePerson(CharTo As String, MessageTo As String)
    Dim buff() As Byte
    Dim C1 As Byte
    ReDim buff(7 + Len(CharTo) + Len(MessageTo)) As Byte
    buff(0) = 6 + Len(CharTo) + Len(MessageTo)
    buff(1) = &H0
    buff(2) = &H96
    buff(3) = &H4
    buff(4) = Len(CharTo)
    For C1 = 6 To Len(CharTo) + 5
        buff(C1) = Asc(Right(CharTo, Len(CharTo) + 6 - C1))
    Next
    buff(C1) = Len(MessageTo)
    buff(C1 + 1) = &H0
    For C1 = C1 + 2 To C1 + 1 + Len(MessageTo)
        buff(C1) = Asc(Right(MessageTo, Len(MessageTo) + 8 + Len(CharTo) - C1))
    Next
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function Send1(bytSend As Byte)
    Dim buff(2) As Byte
    buff(0) = 1
    buff(1) = 0
    buff(2) = bytSend
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function FollowHim(byt1 As Long, byt2 As Long, byt3 As Long, byt4 As Long)
    Dim buff(6) As Byte
    buff(0) = &H5
    buff(1) = &H0
    buff(2) = byt1
    buff(3) = byt2
    buff(4) = byt3
    buff(5) = byt4
    buff(6) = &H0
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function
