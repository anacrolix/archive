Attribute VB_Name = "modMain"
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
Public Const adrNum = &H49D028
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

Public Type CharList
    CName As String
    IP As String
    Port As Integer
End Type

Public Thwnd As Long
Public FName As String
Public FDir As String
Public FColor As Long
Public BColor As Long

Public stHitPoints As Long
Public stMana As Long
Public stCapacity As Long
Public stExperience As Long
Public stLevel As Long
Public stMagicLevel As Long

Public UserPos As Long
Public HitPoints As Long
Public HitPoints2 As Long
Public Mana As Long

Public CList(20) As CharList

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

Public Function EndAll()
    frmMain.sckC.Close
    frmMain.sckS.Close
    frmMain.sckL1.Close
    frmMain.sckL2.Close
    Unload frmClient
    Unload frmRune
    Unload frmMain
    Unload frmAttack
    Unload frmAttackSetup
    Unload frmSpell
    Unload frmHeal
    Unload frmStats
    End
End Function

Public Function Valid()
    If frmMain.mnuActive.Checked = True Then
        If frmMain.chRune.Value = Checked Then frmRune.tmrTime.Interval = 1000
        If frmMain.chRune.Value <> Checked Then frmRune.tmrTime.Interval = 0
        If frmMain.chSpell.Value = Checked Then frmSpell.tmrTime.Interval = 1000
        If frmMain.chSpell.Value <> Checked Then frmSpell.tmrTime.Interval = 0
        If frmMain.chHeal.Value = Checked Then frmHeal.tmrTime.Interval = 100
        If frmMain.chHeal.Value <> Checked Then frmHeal.tmrTime.Interval = 0
        If frmMain.chAttack.Value = Checked Then frmAttack.tmrTime.Interval = 100
        If frmMain.chAttack.Value <> Checked Then frmAttack.tmrTime.Interval = 0
        If frmMain.chEat.Value = Checked Then frmMain.tmrEat.Interval = 10000
        If frmMain.chEat.Value <> Checked Then frmMain.tmrEat.Interval = 0
        If frmMain.chSpear.Value = Checked Then frmMain.tmrSpear.Interval = 2000
        If frmMain.chSpear.Value <> Checked Then frmMain.tmrSpear.Interval = 0
    Else
        frmRune.tmrTime.Interval = 0
        frmSpell.tmrTime.Interval = 0
        frmHeal.tmrTime.Interval = 0
        frmAttack.tmrTime.Interval = 0
        frmMain.tmrEat.Interval = 0
        frmMain.tmrSpear.Interval = 0
    End If
End Function

Public Function MoveItem(Item As Long, fromLoc As Integer, fromSlot As Integer, toLoc As Integer, toSlot As Integer, Quant As Long)
    Dim Buff(16) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    Buff(0) = &HF
    Buff(1) = &H0
    Buff(2) = &H78
    Buff(3) = &HFF
    Buff(4) = &HFF
    Buff(5) = fromLoc
    Buff(6) = &H0
    Buff(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    Buff(8) = Byte2
    Buff(9) = Byte1
    Buff(10) = fromSlot
    Buff(11) = &HFF
    Buff(12) = &HFF
    Buff(13) = toLoc
    Buff(14) = &H0
    Buff(15) = toSlot
    Buff(16) = Quant
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

Public Function GrabItem(Item As Long, fromX As Long, fromY As Long, fromZ As Long, toLoc As Integer, toSlot As Integer, Quant As Long)
    Dim Buff(16) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    Buff(0) = &HF
    Buff(1) = &H0
    Buff(2) = &H78
    Byte1 = fromX - (Fix(fromX / 256) * 256)
    Byte2 = Fix(fromX / 256)
    Buff(3) = Byte1
    Buff(4) = Byte2
    Byte1 = fromY - (Fix(fromY / 256) * 256)
    Byte2 = Fix(fromY / 256)
    Buff(5) = Byte1
    Buff(6) = Byte2
    Buff(7) = fromZ
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    Buff(8) = Byte2
    Buff(9) = Byte1
    Buff(10) = fromSlot
    Buff(11) = &HFF
    Buff(12) = &HFF
    Buff(13) = toLoc
    Buff(14) = &H0
    Buff(15) = toSlot
    Buff(16) = Quant
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
    Pause 200
End Function

Public Function UseHere(Item As Long, fromLoc As Integer, fromSlot As Integer)
    Dim Buff(11) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    Buff(0) = &HA
    Buff(1) = &H0
    Buff(2) = &H82
    Buff(3) = &HFF
    Buff(4) = &HFF
    Buff(5) = fromLoc
    Buff(6) = &H0
    Buff(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    Buff(8) = Byte2
    Buff(9) = Byte1
    Buff(10) = fromSlot
    Buff(11) = &H0
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

Public Function SayStuff(Message As String)
    Dim Buff() As Byte
    Dim C1 As Integer
    ReDim Buff(Len(Message) + 5) As Byte
    Buff(0) = Len(Message) + 4
    Buff(1) = &H0
    Buff(2) = &H96
    Buff(3) = &H1
    Buff(4) = Len(Message)
    Buff(5) = 0
    For C1 = 6 To Len(Message) + 5
        Buff(C1) = Asc(Right(Message, Len(Message) - (C1 - 6)))
    Next
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

Public Function UseAt(Item As Long, fromLoc As Integer, fromSlot As Integer, toX As Long, toY As Long, toZ As Long)
    Dim Buff(18) As Byte
    Dim Byte1 As Byte
    Dim Byte2 As Byte
    Buff(0) = &H11
    Buff(1) = &H0
    Buff(2) = &H83
    Buff(3) = &HFF
    Buff(4) = &HFF
    Buff(5) = fromLoc
    Buff(6) = &H0
    Buff(7) = fromSlot
    Byte1 = Fix(Item / 256)
    Byte2 = Item - (Fix(Item / 256) * 256)
    Buff(8) = Byte2
    Buff(9) = Byte1
    Buff(10) = fromSlot
    Byte1 = Fix(toX / 256)
    Byte2 = toX - (Fix(toX / 256) * 256)
    Buff(11) = Byte2
    Buff(12) = Byte1
    Byte1 = Fix(toY / 256)
    Byte2 = toY - (Fix(toY / 256) * 256)
    Buff(13) = Byte2
    Buff(14) = Byte1
    Buff(15) = toZ
    If Item = &HA14 Then
        Buff(16) = &HEA
        Buff(17) = &H1
        Buff(18) = &H0
    Else
        Buff(16) = &H63
        Buff(17) = &H0
        Buff(18) = &H1
    End If
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
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

Public Function IsFood(Item As Long) As Boolean
    IsFood = False
    If Item >= &HA6A And Item <= &HA83 Then IsFood = True
    If Item = &HA87 Or Item = &HA88 Then IsFood = True
    If Item = &HAE3 Or Item = &HAE4 Or Item = &HAE5 Then IsFood = True
End Function

Public Function FindChar()
    Dim MyNum As Long
    Dim TheNum As Long
    For C1 = 0 To 147
        Memory Thwnd, adrNum, MyNum, 4, RMem
        Memory Thwnd, adrNChar + (CharDist * C1), TheNum, 4, RMem
        If MyNum = TheNum Then
            UserPos = C1
            Exit For
        End If
    Next
End Function

Public Function MessagePerson(CharTo As String, MessageTo As String)
    Dim Buff() As Byte
    Dim C1 As Byte
    ReDim Buff(7 + Len(CharTo) + Len(MessageTo)) As Byte
    Buff(0) = 6 + Len(CharTo) + Len(MessageTo)
    Buff(1) = &H0
    Buff(2) = &H96
    Buff(3) = &H4
    Buff(4) = Len(CharTo)
    For C1 = 6 To Len(CharTo) + 5
        Buff(C1) = Asc(Right(CharTo, Len(CharTo) + 6 - C1))
    Next
    Buff(C1) = Len(MessageTo)
    Buff(C1 + 1) = &H0
    For C1 = C1 + 2 To C1 + 1 + Len(MessageTo)
        Buff(C1) = Asc(Right(MessageTo, Len(MessageTo) + 8 + Len(CharTo) - C1))
    Next
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

Public Function Send1(bytSend As Byte)
    Dim Buff(2) As Byte
    Buff(0) = 1
    Buff(1) = 0
    Buff(2) = bytSend
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

Public Function FollowHim(byt1 As Long, byt2 As Long, byt3 As Long, byt4 As Long)
    Dim Buff(6) As Byte
    Buff(0) = &H5
    Buff(1) = &H0
    Buff(2) = byt1
    Buff(3) = byt2
    Buff(4) = byt3
    Buff(5) = byt4
    Buff(6) = &H0
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData Buff
End Function

