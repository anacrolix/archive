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
Public Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
'Public Declare Function SetActiveWindow Lib "user32" (ByVal hwnd As Long) As Long

Public Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Public Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long

Public Declare Function ReadMemory Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long) As Long
Public Declare Function WriteMemory Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long, ByVal val As Long) As Integer
Public Declare Function ReadMemoryString Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long) As String
Public Declare Function FullLight Lib "erudll.dll" (ByVal processHandle As Long) As Long

Public Declare Function playa Lib "winmm.dll" Alias "sndPlaySoundA" (ByVal lpszSoundName As String, ByVal uFlags As Long) As Long
Public Const SND_FLAG = &H2 '&H1 'Or
'Public Declare Function Memory Lib "erumem.dll" (ByVal hwnd As Long, ByVal address As Long, ByRef val As Long, ByVal size As Long, ByVal process As Integer) As Integer

Private Declare Sub GetSystemTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
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

Public timeZone As Integer

Public Type CharList
    CName As String
    IP As String
    Port As Integer
End Type

Public Type typItem
  Item As Long
  quantity As Long
End Type

Public Type typBackpack
  Item() As typItem
  numItems As Long
  maxItems As Long
End Type

Public activeIndex As Integer
Public ServerIP As String
Public ServerPort As Integer
Public tHWND As Long
Public processID As Long
Public processHandle As Long
Public tibDir As String
Public tibFileName As String
Public wavLoc As String

Public stHitPoints As Long
Public stMana As Long
Public stCapacity As Long
Public stExperience As Long
Public stLevel As Long
Public stMagicLevel As Long

Public HitPoints As Long
Public HitPoints2 As Long
Public mana As Long
Public Soul As Long
Public ExpCur As Long
Public ExpStart As Long
Public ExpTime As Long
Public PercentTnl As Long
Public PercentTnlNextExp As Long
Public ExpRecord(9) As Long
Public ExpRecordPos As Integer

Public CharName As String

Public CList(100) As CharList

Public Const PROCESS_ALL_ACCESS = &H1F0FFF

Public Function ReadMem(ByVal address As Long, ByVal size As Long) As Long
    ReadMem = ReadMemory(processHandle, address, size)
'    Exit Function
'    Dim val As Long
'    Static reads As Long, lastTime As Long
'
'    If frmMain.mnuDebug.Checked Then
'      If GetTickCount >= lastTime + 3000 Then
'       lastTime = GetTickCount
'        AddStatusMessage "Reads/second: " & reads / 3
'        reads = 0
'      End If
'      reads = reads + 1
'    End If
'
'    If ReadProcessMemory(ProcessHandle, address, val, size, 0) = 0 Then EndAll
'    ReadMem = val
End Function

Public Sub WriteMem(ByVal address As Long, ByVal val As Long, ByVal size As Long)
    WriteMemory processHandle, address, size, val
'    Exit Sub
'    Static writes As Long, lastTime As Long
'
'    If frmMain.mnuDebug.Checked Then
'      If GetTickCount >= lastTime + 3000 Then
'        lastTime = GetTickCount
'        AddStatusMessage "Writes/second: " & writes / 3
'        writes = 0
'      End If
'      writes = writes + 1
'    End If
'
'    If WriteProcessMemory(ProcessHandle, address, val, size, 0) = 0 Then EndAll
End Sub

Public Function Pause(milliseconds As Long)
    Dim EndPause As Long
    EndPause = GetTickCount + milliseconds
    Do
        DoEvents
    Loop Until GetTickCount >= EndPause
End Function

Public Sub StrToMem(address As Long, str As String)
    Dim i As Integer
    
    For i = 0 To Len(str) - 1
        WriteMem address + i, Asc(Right(str, Len(str) - i)), 1
    Next
    'add null byte
    WriteMem address + Len(str), 0, 1
End Sub

Public Function MemToStr(address As Long, length As Integer) As String
    Dim tempString As String
    tempString = ReadMemoryString(processHandle, address, length)
'    Dim s As String, b As Long, i As Integer
'
'    s = ""
'    For i = 0 To length - 1
'        b = ReadMem(address + i, 1)
'        If b = 0 Then MemToStr = s: Exit Function
'        s = s & Chr$(b)
'    Next i
'
'    MemToStr = s
    'MemToStr = Left(tempString, Len(tempString) - 1)
    'If Len(tempString) > 0 Then
    '    MemToStr = Left(tempString, Len(tempString) - 1)
    'Else
    '    MemToStr = ""
    'End If
    'tempString = CStr(tempString)
    'Dim i As Integer
    'If Len(tempString) <= 0 Then Exit Function
    'For i = 1 To Len(tempString)
    '    If Asc(Mid(tempString, i, 1)) = 0 Then
    '        tempString = Left(tempString, i - 1) & Right(tempString, Len(tempString) - i)
    '    End If
    'Next i
    If tempString = "" Then Exit Function
    If Asc(Mid(tempString, Len(tempString), 1)) = 0 Then tempString = Left(tempString, Len(tempString) - 1)
    'MemToStr = tempString
    MemToStr = tempString
End Function

Public Function EndAll()
    frmMain.sckC.Close
    frmMain.sckS.Close
    frmMain.sckL1.Close
    frmMain.sckL2.Close
    End
End Function

Public Function Valid()
    If frmMain.mnuActive.Checked = True Then
        If frmMain.chkRune.Value = Checked Then frmRune.tmrRune.Enabled = True: frmMain.chkRune.ForeColor = vbGreen
        If frmMain.chkRune.Value <> Checked Then frmRune.tmrRune.Enabled = False: frmMain.chkRune.ForeColor = vbRed
        If frmMain.chkSpell.Value = Checked Then frmSpell.tmrTime.Enabled = True: frmMain.chkSpell.ForeColor = vbGreen
        If frmMain.chkSpell.Value <> Checked Then frmSpell.tmrTime.Enabled = False: frmMain.chkSpell.ForeColor = vbRed
        If frmMain.chkHeal.Value = Checked Then frmHeal.tmrHeal.Enabled = True: frmMain.chkHeal.ForeColor = vbGreen
        If frmMain.chkHeal.Value <> Checked Then frmHeal.tmrHeal.Enabled = False: frmMain.chkHeal.ForeColor = vbRed
        If frmMain.chkAttack.Value = Checked Then frmAttack.tmrAttack.Enabled = True: frmMain.chkAttack.ForeColor = vbGreen
        If frmMain.chkAttack.Value <> Checked Then frmAttack.tmrAttack.Enabled = False: frmMain.chkAttack.ForeColor = vbRed
        If frmMain.chkEat.Value = Checked Then frmMain.tmrEat.Enabled = True: frmMain.chkEat.ForeColor = vbGreen
        If frmMain.chkEat.Value <> Checked Then frmMain.tmrEat.Enabled = False: frmMain.chkEat.ForeColor = vbRed
        If frmMain.chkAimbot.Value = Checked Then frmAimbot.tmrTime.Enabled = True: frmMain.chkAimbot.ForeColor = vbGreen
        If frmMain.chkAimbot.Value <> Checked Then frmAimbot.tmrTime.Enabled = False: frmMain.chkAimbot.ForeColor = vbRed
        If frmMain.chkExpHour.Value = Checked And frmMain.tmrExp.Enabled = False Then Exp_Start
        If frmMain.chkExpHour.Value <> Checked Then Exp_Stop
        If frmMain.chkFisher.Value = Checked Then frmFisher.tmrFish.Enabled = True: frmMain.chkFisher.ForeColor = vbGreen
        If frmMain.chkFisher.Value <> Checked Then frmFisher.tmrFish.Enabled = False: frmMain.chkFisher.ForeColor = vbRed
        If frmMain.chkIntruder.Value = Checked Then frmMain.chkIntruder.ForeColor = vbGreen: frmIntruder.tmrAppear.Enabled = True: frmIntruder.tmrCheckSkulls.Enabled = True
        If frmMain.chkIntruder.Value <> Checked Then frmMain.chkIntruder.ForeColor = vbRed: frmIntruder.tmrAppear.Enabled = False: frmIntruder.tmrCheckSkulls.Enabled = False
        If frmMain.chkAlert = Checked Then frmMain.tmrAlert.Enabled = True: frmMain.chkAlert.ForeColor = vbGreen
        If frmMain.chkAlert <> Checked Then frmMain.tmrAlert.Enabled = False: frmMain.chkAlert.ForeColor = vbRed
        If frmMain.chkOutfit = Checked Then frmOutfit.tmrOutfit.Enabled = True: frmMain.chkOutfit.ForeColor = vbGreen
        If frmMain.chkOutfit <> Checked Then frmOutfit.tmrOutfit.Enabled = False: frmMain.chkOutfit.ForeColor = vbRed
        If frmMain.chkLooter = Checked Then frmMain.tmrLooter.Enabled = True: frmMain.chkLooter.ForeColor = vbGreen
        If frmMain.chkLooter <> Checked Then frmMain.tmrLooter.Enabled = False: frmMain.chkLooter.ForeColor = vbRed
        If frmMain.chkLogOut = Checked Then frmMain.tmrLogOut.Enabled = True: frmMain.chkLogOut.ForeColor = vbGreen
        If frmMain.chkLogOut <> Checked Then frmMain.tmrLogOut.Enabled = False: frmMain.chkLogOut.ForeColor = vbRed
        If frmMain.chkGrabber = Checked Then frmGrabber.tmrGrabber.Enabled = True: frmMain.chkGrabber.ForeColor = vbGreen
        If frmMain.chkGrabber <> Checked Then frmGrabber.tmrGrabber.Enabled = False: frmMain.chkGrabber.ForeColor = vbRed
        If frmMain.chkLight = Checked Then frmMain.tmrLight.Enabled = True: frmMain.chkLight.ForeColor = vbGreen
        If frmMain.chkLight <> Checked Then frmMain.tmrLight.Enabled = False: frmMain.chkLight.ForeColor = vbRed
        If frmMain.chkRevealInvis = Checked Then frmMain.tmrRevealInvis.Enabled = True: frmMain.chkRevealInvis.ForeColor = vbGreen
        If frmMain.chkRevealInvis <> Checked Then frmMain.tmrRevealInvis.Enabled = False: frmMain.chkRevealInvis.ForeColor = vbRed
        If frmMain.chkAutoAttack = Checked Then frmAutoAttack.tmrAutoAttack.Enabled = True: frmMain.chkAutoAttack.ForeColor = vbGreen
        If frmMain.chkAutoAttack <> Checked Then frmAutoAttack.tmrAutoAttack.Enabled = False: frmMain.chkAutoAttack.ForeColor = vbRed
        If frmMain.chkCaveBot = Checked Then frmCaveBot.tmrCaveBot.Enabled = True: frmMain.chkCaveBot.ForeColor = vbGreen
        If frmMain.chkCaveBot <> Checked Then frmCaveBot.tmrCaveBot.Enabled = False: frmMain.chkCaveBot.ForeColor = vbRed
    Else
        frmRune.tmrRune.Enabled = False: frmMain.chkRune.ForeColor = vbRed
        frmSpell.tmrTime.Enabled = False: frmMain.chkSpell.ForeColor = vbRed
        frmHeal.tmrHeal.Enabled = False: frmMain.chkHeal.ForeColor = vbRed
        frmAttack.tmrAttack.Enabled = False: frmMain.chkAttack.ForeColor = vbRed
        frmMain.tmrEat.Enabled = False: frmMain.chkEat.ForeColor = vbRed
        frmAimbot.tmrTime.Enabled = False: frmMain.chkAimbot.ForeColor = vbRed
        Exp_Stop
        frmFisher.tmrFish.Enabled = False: frmMain.chkFisher.ForeColor = vbRed
        frmMain.chkIntruder.ForeColor = vbRed: frmIntruder.tmrAppear.Enabled = False: frmIntruder.tmrCheckSkulls.Enabled = False
        frmMain.tmrAlert.Enabled = False: frmMain.chkAlert.ForeColor = vbRed
        frmOutfit.tmrOutfit.Enabled = False: frmMain.chkOutfit.ForeColor = vbRed
        frmMain.tmrLooter.Enabled = False: frmMain.chkLooter.ForeColor = vbRed
        frmMain.tmrLogOut.Enabled = False: frmMain.chkLogOut.ForeColor = vbRed
        frmGrabber.tmrGrabber.Enabled = False: frmMain.chkGrabber.ForeColor = vbRed
        frmMain.tmrLight.Enabled = False: frmMain.chkLight.ForeColor = vbRed
        frmMain.tmrRevealInvis.Enabled = False: frmMain.chkRevealInvis.ForeColor = vbRed
        frmAutoAttack.tmrAutoAttack.Enabled = False: frmMain.chkAutoAttack.ForeColor = vbRed
        frmCaveBot.tmrCaveBot.Enabled = False: frmMain.chkCaveBot.ForeColor = vbRed
    End If
End Function

Public Function MoveItem(Item As Long, fromLoc As Integer, fromSlot As Integer, toLoc As Integer, toSlot As Integer, quant As Long)
    Dim buff(16) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &HF
    buff(1) = &H0
    buff(2) = &H78
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    byte1 = Fix(Item / 256)
    byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = fromSlot
    buff(11) = &HFF
    buff(12) = &HFF
    buff(13) = toLoc
    buff(14) = &H0
    buff(15) = toSlot
    buff(16) = quant
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function GrabItem(Item As Long, fromX As Long, fromY As Long, fromZ As Long, toLoc As Integer, toSlot As Integer, quant As Long)
    Dim buff(16) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &HF
    buff(1) = &H0
    buff(2) = &H78
    byte1 = fromX - (Fix(fromX / 256) * 256)
    byte2 = Fix(fromX / 256)
    buff(3) = byte1
    buff(4) = byte2
    byte1 = fromY - (Fix(fromY / 256) * 256)
    byte2 = Fix(fromY / 256)
    buff(5) = byte1
    buff(6) = byte2
    buff(7) = fromZ
    byte1 = Fix(Item / 256)
    byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = fromSlot
    buff(11) = &HFF
    buff(12) = &HFF
    buff(13) = toLoc
    buff(14) = &H0
    buff(15) = toSlot
    buff(16) = quant
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UseGround(id As Long, x As Long, y As Long, z As Long, Optional newLoc As Integer = 0)
'0A 00 82 C0 80 2D 7D 06 98 01 00 01 floor
'0A 00 82 C0 80 2E 7D 06 36 0B 01 01 bp y+1
'0A 00 82 BF 80 2D 7D 06 9C 07 01 02 ladder x-1
    Dim buff(11) As Byte, bytes() As Byte
    buff(0) = &HA 'len-2
    buff(1) = 0 '?
    buff(2) = &H82 'command usehere
    ConvertLongToBytes x, bytes, 2
    buff(3) = bytes(0)
    buff(4) = bytes(1)
    ConvertLongToBytes y, bytes, 2
    buff(5) = bytes(0)
    buff(6) = bytes(1)
    buff(7) = z
    ConvertLongToBytes id, bytes, 2
    buff(8) = bytes(0)
    buff(9) = bytes(1)
    buff(10) = 0 'quantity?
    buff(11) = newLoc
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UseHere(Item As Long, fromLoc As Integer, fromSlot As Integer, Optional newLoc As Integer = 0)
    Dim buff(11) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &HA
    buff(1) = &H0
    buff(2) = &H82
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    byte1 = Fix(Item / 256)
    byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = fromSlot
    buff(11) = newLoc
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UpBpLevel(bpIndex As Integer)
    Static lastUp(LEN_BP) As Long
    If GetTickCount < lastUp(bpIndex) + 1000 Then Exit Function
    Dim buff(3) As Byte
    buff(0) = &H2
    buff(1) = &H0
    buff(2) = &H88
    buff(3) = bpIndex
    
    If frmMain.sckS.State = sckConnected Then
        frmMain.sckS.SendData buff
        AddStatusMessage "UpBpLevel, bp: " & bpIndex - &H40
    End If
    lastUp(bpIndex) = GetTickCount
End Function

Public Function SayStuff(message As String)
    Dim buff() As Byte
    Dim C1 As Integer
    ReDim buff(Len(message) + 5) As Byte
    buff(0) = Len(message) + 4
    buff(1) = &H0
    buff(2) = &H96
    buff(3) = &H1
    buff(4) = Len(message)
    buff(5) = 0
    For C1 = 6 To Len(message) + 5
        buff(C1) = Asc(Right(message, Len(message) - (C1 - 6)))
    Next
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UseAtMonster(Item As Long, fromLoc As Integer, fromSlot As Integer, id As Long)
    '0D 00 84 FF FF 45 00 00 7E 0C 00 A3 A9 00 40
    Dim buff(14) As Byte, bytID() As Byte, i As Integer
    buff(0) = &HD
    buff(1) = &H0
    buff(2) = &H84
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    'rune id
    buff(9) = Fix(Item / 256)
    buff(8) = Item - (Fix(Item / 256) * 256)
    buff(10) = fromSlot
    ConvertIDtoBytes id, bytID
    For i = 0 To 3
        buff(11 + i) = bytID(i)
    Next i
    
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function UseAt(Item As Long, fromLoc As Integer, fromSlot As Integer, toX As Long, toY As Long, toZ As Long)
    '11 00 83 FF FF 06 00 00 5D 0D 00 8F 7E A0 7B 0A 63 01 00
    Dim buff(18) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &H11
    buff(1) = &H0
    buff(2) = &H83
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = fromLoc
    buff(6) = &H0
    buff(7) = fromSlot
    byte1 = Fix(Item / 256)
    byte2 = Item - (Fix(Item / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = fromSlot
    byte1 = Fix(toX / 256)
    byte2 = toX - (Fix(toX / 256) * 256)
    buff(11) = byte2
    buff(12) = byte1
    byte1 = Fix(toY / 256)
    byte2 = toY - (Fix(toY / 256) * 256)
    buff(13) = byte2
    buff(14) = byte1
    buff(15) = toZ
    If Item = ITEM_FISHING_ROD Then
        buff(16) = &HF5 + Int(Rnd * 6)
        buff(17) = &H11
        buff(18) = &H0
    ElseIf Item = ITEM_ROPE Then
        buff(16) = &H82
        buff(17) = 1
        buff(18) = 0
    Else
        buff(16) = &H63
        buff(17) = &H0
        buff(18) = &H1
    End If
    
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function StringToPacket(str As String, pckt() As Byte)
    Dim str2() As String
    str2 = Split(str, " ")
    ReDim pckt(UBound(str2))
    For i = LBound(str2) To UBound(str2)
        pckt(i) = val("&H" & str2(i))
    Next i
End Function

Public Function PacketToString(pckt() As Byte) As String
  Dim str As String
  For i = LBound(pckt) To UBound(pckt)
    If Int(pckt(i)) < 16 Then
      str = str & "0" & Hex(pckt(i))
    Else
      str = str & Hex(pckt(i))
    End If
    str = str & " "
  Next i
  PacketToString = Left(str, Len(str) - 1)
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

Public Function SendPM(toName As String, message As String)
    Dim buff() As Byte
    ReDim buff(Len(toName) + Len(message) + 7) As Byte
    buff(0) = UBound(buff) - 1
    buff(1) = &H0
    buff(2) = &H96
    buff(3) = 4
    buff(4) = Len(toName)
    buff(5) = &H0
    For i = 1 To Len(toName)
        buff(5 + i) = Asc(Mid(toName, i, 1))
    Next i
    buff(Len(toName) + 6) = Len(message)
    buff(Len(toName) + 7) = 0
    For i = 1 To Len(message)
        buff(Len(toName) + 7 + i) = Asc(Mid(message, i, 1))
    Next i
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function ExpOfLevel(lvl As Long)
    ExpOfLevel = ((50 / 3) * lvl * lvl * lvl) - 100 * lvl * lvl + ((850 / 3) * lvl) - 200
End Function

Public Function GetPercentTnl(level As Long) As Long
    Dim expPerPercent As Long
    expPerPercent = (ExpOfLevel(level + 1) - ExpOfLevel(level)) / 100
    GetPercentTnl = 100 - Int((ExpCur - ExpOfLevel(level)) / expPerPercent)
End Function

Public Function ExpNextPercent(CurTnlPercent As Long, level As Long) As Long
    Dim expPerPercent As Long
    expPerPercent = (ExpOfLevel(level + 1) - ExpOfLevel(level)) / 100
    ExpNextPercent = ExpOfLevel(level) + (101 - CurTnlPercent) * expPerPercent
End Function

Public Function ExpToLevel() As Long
  ExpToLevel = -ExpCur + ExpOfLevel(1 + ReadMem(ADR_LEVEL, 4))
End Function

Public Function getCharXYZ(pX As Long, pY As Long, pZ As Long, ByVal charPos As Long)
    pX = ReadMem(ADR_CHAR_X + charPos * SIZE_CHAR, 4)
    pY = ReadMem(ADR_CHAR_Y + charPos * SIZE_CHAR, 4)
    pZ = ReadMem(ADR_CHAR_Z + charPos * SIZE_CHAR, 4)
End Function

Public Function confirmItem(address As Long, desiredItem As Long) As Boolean
    confirmItem = False
    If ReadMem(address, 2) = desiredItem Then
        If desiredItem = ITEM_VIAL Then
            If ReadMem(address + 4, 1) = 7 Then confirmItem = True
        Else
            confirmItem = True
        End If
    End If
End Function

Public Function findItem(Item As Long, bpIndex As Integer, itemIndex As Integer, Optional checkEquipped As Boolean = True, Optional confirm As Boolean = True) As Boolean
    Dim bpOpen As Long, bpNumItems As Long
    Dim temp As Long 'current item looked at
    
    findItem = False
    
    For bpIndex = 0 To LEN_BP
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bpIndex, 1) = 1 Then
            bpNumItems = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bpIndex, 1)
            For itemIndex = 0 To bpNumItems - 1
                If confirm Then
                    If confirmItem(ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, Item) Then
                        findItem = True
                        bpIndex = bpIndex + &H40
                        Exit Function
                    End If
                Else
                    If ReadMem(ADR_BP_ITEM + bpIndex * SIZE_BP + itemIndex * SIZE_ITEM, 2) = Item Then
                        findItem = True
                        bpIndex = bpIndex + &H40
                        Exit Function
                    End If
                End If
            Next itemIndex
        End If
    Next bpIndex
    
    If checkEquipped Then
        itemIndex = 0
        If confirmItem(ADR_LEFT_HAND, Item) Then
            bpIndex = SLOT_LEFT_HAND
            findItem = True
        ElseIf confirmItem(ADR_RIGHT_HAND, Item) Then
            bpIndex = SLOT_RIGHT_HAND
            findItem = True
        ElseIf confirmItem(ADR_AMMO, Item) Then
            bpIndex = SLOT_AMMO
            findItem = True
        End If
    End If
End Function


'Public Function findLoot(item As Long, bpIndex As Integer, itemIndex As Integer, quantity As Long) As Boolean'
'
'End Function

Public Function IsLoot(Item As Long) As Boolean
    IsLoot = False
    Select Case Item
        Case Is = ITEM_GOLD, ITEM_BOLT: IsLoot = True
        Case Is = ITEM_WORM And frmMain.chkLootWorms = Checked: IsLoot = True
        Case Is = &HD17, &HD61, &HCCB: IsLoot = True
        Case Else
    End Select
End Function

'assumes that the target is already determined to be within range etc.
Public Function ShootRune(runeID As Long, pos As Long, Optional lead As Boolean = False) As Boolean
    ShootRune = False
    
    If runeID < 0 Or pos < 0 Then
        If frmMain.mnuDebug.Checked = True Then AddStatusMessage "Invalid rune type or target."
        Exit Function
    End If
    
    'LOCATE RUNE AND DETERMINE IF ITS THE LAST
    Dim bpIndex As Integer, itemIndex As Integer, runesLeft As Boolean
    runesLeft = False
    
    'return if no rune of type
    If findItem(runeID, bpIndex, itemIndex, True, False) = False Then
        AddStatusMessage "No runes of type " & runeID & " found."
        Exit Function
    End If
    
    'if this isn't the last rune, and the next rune is another of the same kind, then there are runes left
    If itemIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) _
    Then If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (itemIndex + 1) * SIZE_ITEM, 2) = runeID _
    Then runesLeft = True
    
    'if no more runes have yet been found
    If runesLeft = False Then
        'check the rest of backpack
        For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1
            'if an item is the same rune type and isn't the one we're about to use
            If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2) = runeID _
            And itemIndex <> i Then
                runesLeft = True
                Exit For
            End If
        Next i
    End If
    
    'LOCATE TARGET
    If IsMonster(pos) Then
        UseAtMonster runeID, bpIndex, itemIndex, ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
    Else
        Dim pX As Long, pY As Long, pZ As Long, dG As Long
        pX = -1: pY = -1: pZ = -1
        
        getCharXYZ pX, pY, pZ, pos
        If pX < 0 Or pY < 0 Or pZ < 0 Then If frmMain.mnuDebug.Checked = True Then AddStatusMessage "Error locating target coordinates.": Exit Function
        
        If lead Then
            If ReadMem(ADR_CHAR_GFX_DX + pos * SIZE_CHAR, 1) <> 0 Then
                dG = ReadMem(ADR_CHAR_GFX_DX + pos * SIZE_CHAR + 2, 1)
                Select Case dG
                    Case Is = 0: pX = pX - 1
                    Case Is = &HFF: pX = pX + 1
                    Case Else: If frmMain.mnuDebug.Checked = True Then AddStatusMessage "Error attempting to lead target. Unexpected value."
                End Select
            End If
            If ReadMem(ADR_CHAR_GFX_DY + pos * SIZE_CHAR, 1) <> 0 Then
            dG = ReadMem(ADR_CHAR_GFX_DY + pos * SIZE_CHAR + 2, 1)
                Select Case dG
                    Case Is = 0: pY = pY - 1
                    Case Is = &HFF: pY = pY + 1
                    Case Else: If frmMain.mnuDebug.Checked = True Then AddStatusMessage "Error attempting to lead target. Unexpected value."
                End Select
            End If
        End If
        UseAt runeID, bpIndex, itemIndex, pX, pY, pZ
    End If

    If frmMain.mnuDebug.Checked Then AddStatusMessage "Shoot rune, type: " & runeID & ", bp: " & bpIndex - &H40 & " slot: " & itemIndex & "."
    Pause 50
    
    If runesLeft = False Then UpBpLevel bpIndex - &H40
    DoEvents
End Function

Public Function IsFood(Item As Long) As Boolean
    Select Case Item
        Case &HDF9 To &HE17, &HE8B To &HE94: IsFood = True
        Case Else: IsFood = False
    End Select
End Function

Public Function IsMonster(pos As Long) As Boolean
    If ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR + 3, 1) = &H40 Then IsMonster = True
End Function

Public Function findLoot() As Boolean
    Dim i As Integer, i2 As Integer
    Dim Item As Long, bpName As String, numItems As Integer, bpIndex As Integer, itemIndex As Integer, quantity As Long
    Dim tarNumItems As Long, tarBpIndex As Integer, tarQuant As Long, moved As Boolean
    Dim tarBP As typBackpack
    Dim bagFound As Boolean, bagSlot As Integer
    
    tarBpIndex = -1
    
    For bpIndex = 0 To LEN_BP
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bpIndex, 1) = 1 Then
            bpName = MemToStr(ADR_BP_NAME + SIZE_BP * bpIndex, 7)
            If Left(bpName, 3) = "Bag" Or Left(bpName, 4) = "Dead" Or Left(bpName, 5) = "Slain" Or Left(bpName, 5) = "Split" Or Left(bpName, 6) = "Remain" Then
                numItems = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bpIndex, 1)
                For itemIndex = numItems - 1 To 0 Step -1
                    Item = ReadMem(ADR_BP_ITEM + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 2)
                    If frmLooter.IsLootable(Item) Then
                        findLoot = True
                        If tarBpIndex < 0 Then
                            If findItem(ITEM_ROPE, tarBpIndex, i, False, False) = False Then Exit Function
                            tarBP.numItems = ReadMem(ADR_BP_NUM_ITEMS + (tarBpIndex - &H40) * SIZE_BP, 1)
                            tarBP.maxItems = ReadMem(ADR_BP_MAX_ITEMS + (tarBpIndex - &H40) * SIZE_BP, 1)
                            ReDim tarBP.Item(tarBP.maxItems)
                            For i = 0 To tarBP.numItems - 1
                                tarBP.Item(i).Item = ReadMem(ADR_BP_ITEM + (tarBpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2)
                                If IsLoot(tarBP.Item(i).Item) Then tarBP.Item(i).quantity = ReadMem(ADR_BP_ITEM_QUANTITY + (tarBpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 1)
                            Next i
                        End If
                        quantity = ReadMem(ADR_BP_ITEM_QUANTITY + SIZE_BP * bpIndex + SIZE_ITEM * itemIndex, 1)
                        moved = False
                        If frmLooter.IsStackable(Item) Then
                            For i = 0 To tarBP.numItems - 1
                                If tarBP.Item(i).Item = Item Then
                                    If tarBP.Item(i).quantity < 100 Then
                                        If tarBP.Item(i).quantity + quantity <= 100 Then
                                            MoveItem Item, bpIndex + &H40, itemIndex, tarBpIndex, i, quantity
                                            moved = True
                                            tarBP.Item(i).quantity = tarBP.Item(i).quantity + quantity
                                            Pause 300
                                        ElseIf tarBP.Item(i).quantity + quantity > 100 And tarBP.numItems < tarBP.maxItems Then
                                            MoveItem Item, bpIndex + &H40, itemIndex, tarBpIndex, i, quantity
                                            moved = True
                                            Pause 300
                                            'tarBP.item(i).quantity = 100
                                            For i2 = tarBP.numItems To 1 Step -1
                                              tarBP.Item(i2) = tarBP.Item(i2 - 1)
                                            Next i2
                                            tarBP.Item(0).Item = Item
                                            tarBP.Item(0).quantity = tarBP.Item(i + 1).quantity + quantity - 100
                                            tarBP.Item(i + 1).quantity = 100
                                            tarBP.numItems = tarBP.numItems + 1
                                        Else
                                            Exit Function
                                        End If
                                    End If
                                End If
                            Next i
                        End If
                        If tarBP.numItems < tarBP.maxItems And moved = False Then
                            MoveItem Item, bpIndex + &H40, itemIndex, tarBpIndex, CInt(tarBP.maxItems), quantity
                            Pause 300
                            For i2 = tarBP.numItems To 1 Step -1
                            tarBP.Item(i2) = tarBP.Item(i2 - 1)
                            Next i2
                            tarBP.Item(0).Item = Item
                            tarBP.Item(0).quantity = quantity
                            tarBP.numItems = tarBP.numItems + 1
                        ElseIf moved = False Then
                            Exit Function
                        End If
                        If bagFound Then bagSlot = bagSlot - 1
                    ElseIf Item = ITEM_BAG Then
                        bagFound = True
                        bagSlot = itemIndex
                    End If
                Next itemIndex
                If bagFound Then
                    UseHere ITEM_BAG, bpIndex + &H40, bagSlot, bpIndex
                    bagFound = False
                    Pause 500
                End If
            End If
        End If
    Next bpIndex
    If findLoot = True Then Pause 500
End Function

Public Function UserPos() As Long
    Static lastPos As Long
    Dim playerID As Long, i As Long
    playerID = ReadMem(ADR_PLAYER_ID, 4)
    If ReadMem(ADR_CHAR_ID + lastPos * SIZE_CHAR, 4) = playerID Then
        UserPos = lastPos
    Else
        For i = 0 To LEN_CHAR
            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = playerID Then
                lastPos = i
                UserPos = i
                Exit Function
            End If
        Next i
        MsgBox "Player entity not found in array. :\", vbCritical, "Omg."
    End If
End Function

Public Function findPosByPriority(listNames As ListBox, Optional reqOnScr As Boolean = False) As Long
    Dim name As String 'current character name
    Dim iChar As Integer 'current character array index
    Dim iList As Integer 'current list index being checked
    Dim iLast As Integer 'index of last found listed character
    
    If listNames.ListCount > 0 Then 'if there are names in the priority list
        iLast = listNames.ListCount 'set the last found character to the length of the list
        For iChar = 0 To LEN_CHAR 'loop from the first to last character in memory
            name = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * iChar, 32) 'read the characters name
            If name = "" Then Exit For 'if the name is blank then we're at the end of the list
            For iList = 0 To iLast - 1 'loop through the priority list, but not checking past the last found name
                If listNames.List(iList) = name Then 'if the names match
                    If reqOnScr Or ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * iChar, 1) = 1 Then 'if they dont need to be onscreen or they're onscreen
                        iLast = iList 'set the last found character to this one
                        findPosByPriority = iChar 'set pos of target to
                        Exit For 'stop searching the priority list
                    End If
                End If
            Next iList
            If iLast = 0 Then Exit For 'if the char found is of the highest priority, then dont search anymore
        Next iChar
        If iLast < listNames.ListCount Then Exit Function 'if a target was found then we're done
    End If
    'if a priority target wasn't found, default to the reticle target
    Dim id As Long
    
    id = ReadMem(ADR_TARGET_ID, 4)
    If id <> 0 Then
        findPosByPriority = findPosByID(id)
        Exit Function
    End If
    
    findPosByPriority = -1
End Function

Public Function FindPosByHP(listNames As listFancy, hp As Integer, Optional lowestHP As Boolean = False) As Long
    FindPosByHP = -1
    If listNames.ListCount <= 0 Then Exit Function
    
    Dim i As Integer, worstHP As Integer, str As String, thisHP As Integer, plyrZ As Integer
    worstHP = hp
    plyrZ = ReadMem(ADR_PLAYER_Z, 2)
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then 'on screen
            thisHP = ReadMem(ADR_CHAR_HP + SIZE_CHAR * i, 2)
            If thisHP < worstHP Then 'low hp
                If ReadMem(ADR_CHAR_Z + SIZE_CHAR * i, 2) = plyrZ Then 'same altitude
                    str = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
                    If listNames.Contains(str) >= 0 Then 'listed name
                        FindPosByHP = i
                        If lowestHP Then
                            worstHP = thisHP
                        Else
                            Exit Function
                        End If
                    End If
                End If
            End If
        End If
    Next i
End Function

Public Function findPosByName(name As String) As Long
    Dim str As String
    Dim onScreen As Long
    Dim i As Integer
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
            str = MemToStr(ADR_CHAR_NAME + (SIZE_CHAR * i), 32)
            If str = name Then findPosByName = i: Exit Function
        End If
    Next i
    findPosByName = -1
End Function

Public Function findPosByID(id As Long) As Long
    Dim i As Integer
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ID + SIZE_CHAR * i, 4) = id Then
            findPosByID = i
            Exit Function
        End If
    Next i
    findPos = -1
End Function

Public Function findPosByXYZ(pX As Long, pY As Long, pZ As Long) As Long
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = 0 Then Exit For
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
            If ReadMem(ADR_CHAR_X + SIZE_CHAR * i, 4) = pX Then
                If ReadMem(ADR_CHAR_Y + SIZE_CHAR * i, 4) = pY And ReadMem(ADR_CHAR_Z + SIZE_CHAR * i, 4) = pZ Then
                    findPosByXYZ = i
                    Exit Function
                End If
            End If
        End If
    Next i
    findPosByXYZ = -1
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

Public Function Step(dir As Integer, Optional numSteps As Integer = 1)
    Dim buff() As Byte
    
    If numSteps = 1 Then
        ReDim buff(2)
        buff(0) = 1
        buff(1) = 0
        buff(2) = dir + &H65
    ElseIf numSteps > 1 Then
        ReDim buff(1 + numSteps)
        For i = 2 To 1 + numSteps
            buff(i) = dir + &H65
        Next i
    End If
  
  'walk left 2
  'Dim buff(5) As Byte
 '
 ' buff(0) = 4
 ' buff(1) = 0
 ' buff(2) = &H64
 ' buff(3) = 2
 ' buff(4) = 5
 ' buff(5) = 5
  
  If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function FollowHim(id As Long)
    Dim buff(6) As Byte, idBytes() As Byte, i As Integer
    buff(0) = &H5
    buff(1) = &H0
    buff(2) = &HA2
    ConvertIDtoBytes id, idBytes
    For i = 0 To 3
        buff(3 + i) = idBytes(i)
    Next i
    WriteMem ADR_FOLLOW_ID, id, 4
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Function ConvertIDtoBytes(id As Long, bytes() As Byte)
    ReDim bytes(3)
    bytes(3) = Fix(id / 16777216)
    bytes(2) = Fix((id - bytes(3) * 16777216) / 65536)
    bytes(1) = Fix((id - bytes(3) * 16777216 - bytes(2) * 65536) / 256)
    bytes(0) = Fix(id - Fix(id / 16777216) * 16777216 - Fix((id - bytes(3) * 16777216) / 65536) * 65536 - Fix((id - bytes(3) * 16777216 - bytes(2) * 65536) / 256) * 256)
End Function

Public Function ConvertLongToBytes(ByVal id As Long, bytes() As Byte, ByVal numBytes As Integer)
    ReDim bytes(numBytes - 1)
    Dim i As Integer, j As Integer, temp As Long
    If numBytes = 1 And id < &H100 Then
        bytes(0) = id
    Else
        bytes(numBytes - 1) = Fix(id / &H100 ^ (numBytes - 1))
        For i = numBytes - 2 To 0 Step -1
            temp = id
            For j = i + 1 To numBytes - 1
                temp = temp - Fix(bytes(j) * &H100 ^ j)
            Next j
            temp = Fix(temp / &H100 ^ i)
            bytes(i) = temp
        Next i
    End If
End Function

Public Function PutAttack(id As Long)
    Dim buff(6) As Byte, idByte() As Byte, i As Integer
    
    buff(0) = &H5
    buff(1) = &H0
    buff(2) = &HA1
    ConvertIDtoBytes id, idByte
    For i = 0 To 3
        buff(3 + i) = idByte(i)
    Next i
    
    WriteMem ADR_TARGET_ID, id, 4
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Function

Public Sub AddStatusMessage(str As String)
    Dim st As SYSTEMTIME
    
    GetSystemTime st
    
    st.wHour = st.wHour + timeZone
    If st.wHour > 23 Then
        st.wHour = st.wHour - 24
    ElseIf st.wHour < 0 Then
        st.wHour = st.wHour + 24
    End If

    If frmMain.txtStatusMessages <> "" Then frmMain.txtStatusMessages = frmMain.txtStatusMessages & vbCrLf
    frmMain.txtStatusMessages = frmMain.txtStatusMessages & st.wHour & ":" & st.wMinute & " - " & str
    frmMain.txtStatusMessages.SelStart = Len(frmMain.txtStatusMessages.Text)
End Sub

Public Sub StartAlert()
    If frmMain.chkAlert.Value = Unchecked Then
        frmMain.chkAlert = Checked
        AddStatusMessage "Starting Alert."
    End If
    'SetForegroundWindow Thwnd
End Sub

Public Sub StopAlert()
    If frmMain.chkAlert.Value = Checked Then
        frmMain.chkAlert.Value = Unchecked
        AddStatusMessage "Stopping Alert."
        'Valid
    End If
End Sub

Public Sub Loot(pckt() As Byte)
    Dim i, j, slot, numGoldPiles As Integer
    Dim slots() As Integer
    Dim quantity() As Long
    '64 65 61 64 dead container
    If pckt(8) <> &H64 And pckt(9) <> &H65 And pckt(10) <> &H61 And pckt(11) <> &H64 Then Exit Sub
    AddStatusMessage "Corpse container detected."
    For i = 8 To UBound(pckt)
        If pckt(i) = 0 Then Exit For
    Next i
    slot = 0
    numGoldPiles = -1
    j = i + 2
    If j >= UBound(pckt) - 1 Then Exit Sub
    Do
        If pckt(j) = ITEM_GOLD - (Fix(ITEM_GOLD / 256) * 256) And pckt(j + 1) = Fix(ITEM_GOLD / 256) Then
            numGoldPiles = numGoldPiles + 1
            ReDim Preserve slots(numGoldPiles)
            ReDim Preserve quantity(numGoldPiles)
            slots(numGoldPiles) = slot
            quantity(numGoldPiles) = CLng(pckt(j + 2))
        End If
        If pckt(j + 2) < 100 And j < UBound(pckt) - 3 Then
            If pckt(j + 4) < 16 Then
                j = j + 3
            Else
                j = j + 2
            End If
        Else
            j = j + 2
        End If
        slot = slot + 1
    Loop Until j >= UBound(pckt) - 1
    
    If numGoldPiles >= 0 Then
        For i = numGoldPiles To 0 Step -1
            MoveItem ITEM_GOLD, &H40 + pckt(3), slots(i), &H40, 0, quantity(i)
            Pause 250
        Next i
    End If
End Sub

Public Sub LogOut()
  Dim logBuff(2) As Byte
  
  'construct logout packet
  logBuff(0) = 1
  logBuff(1) = 0
  logBuff(2) = &H14
  
  'send packet
  If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData logBuff
  
  AddStatusMessage "Sent Logout packet."
End Sub

Public Sub ConfigUpdate(fileLoc As String, wer As Boolean)
    Dim FN As Integer
    FN = FreeFile
    On Error GoTo Cancel
    If wer Then
        Open fileLoc For Output As #FN
        Write #FN, "***ERUBOT SETTINGS FILE***"
        Write #FN, App.Major & "." & App.Minor & "." & App.Revision
    Else
        Open fileLoc For Input As #FN
        getNext FN
        temp = getNext(FN)
        'If temp <> App.Major & "." & App.Minor & "." & App.Revision Then MsgBox "Settings file and application version do not match. There may be errors in loading file:" & vbCrLf & setLoc & vbCrLf & "Check loaded settings and resave file with newer version.", vbCritical, "Potential version conflict."
    End If

    Config_Title FN, wer, "***MAIN***"
    Config_Control FN, wer, frmMain.chkAimbot
    Config_Control FN, wer, frmMain.chkLight
    Config_Control FN, wer, frmMain.chkExpHour
    Config_Control FN, wer, frmMain.chkExpBeep
    Config_Control FN, wer, frmMain.chkLooter
    Config_Control FN, wer, frmMain.chkRevealInvis
    Config_Control FN, wer, frmMain.chkRune
    Config_Control FN, wer, frmMain.chkSpell
    Config_Control FN, wer, frmMain.chkHeal
    Config_Control FN, wer, frmMain.chkIntruder
    Config_Control FN, wer, frmMain.chkAttack
    Config_Control FN, wer, frmMain.chkEat
    Config_Control FN, wer, frmMain.chkEatLog
    Config_Control FN, wer, frmMain.chkFisher
    Config_Control FN, wer, frmMain.chkGrabber
    Config_Control FN, wer, frmMain.chkOutfit
    Config_Control FN, wer, frmMain.chkAlertLogged
    Config_Control FN, wer, frmMain.chkAutoAttack
    Config_Control FN, wer, frmMain.chkCaveBot
    Config_Control FN, wer, frmMain.chkGM
    
    Config_Title FN, wer, "***AIMBOT***"
    Config_ControlArray FN, wer, frmAimbot.comboButton
    Config_ControlArray FN, wer, frmAimbot.comboWeapon
    Config_Control FN, wer, frmAimbot.chkHealSelf
    Config_Control FN, wer, frmAimbot.chkHealLowest
    Config_Control FN, wer, frmAimbot.hscrHealAt
    Config_Control FN, wer, frmAimbot.chkFluidMoveUpBP
    Config_ListBox FN, wer, "AIMBOT.FRIENDS", frmAimbot.listFriends
    Config_ListBox FN, wer, "AIMBOT.ENEMIES", frmAimbot.listEnemies
    
    Config_Title FN, wer, "***LOOTER***"
    Config_ListBox FN, wer, "LOOTER.DONTLOOT", frmLooter.listItems
    Config_ListBox FN, wer, "LOOTER.NONSTACK", frmLooter.listLoot
    Config_ListBox FN, wer, "LOOTER.STACKABLE", frmLooter.listStack
    
    Config_Title FN, wer, "***RUNE MAKER***"
    Config_Control FN, wer, frmRune.txtSpellWords
    Config_Control FN, wer, frmRune.hscrManaReq
    Config_Control FN, wer, frmRune.hscrSoulReq
    Config_Control FN, wer, frmRune.txtReserveMana
    Config_Control FN, wer, frmRune.chkLogFinished
    If wer = False Then
        frmRune.hscrManaReq_Change
        frmRune.hscrSoulReq_Change
    End If
    
    Config_Title FN, wer, "***SPELL CASTER***"
    Config_Control FN, wer, frmSpell.txtSpell
    Config_Control FN, wer, frmSpell.txtMana
    
    Config_Title FN, wer, "***HEALER***"
    Config_Control FN, wer, frmHeal.txtHP
    Config_Control FN, wer, frmHeal.chkUseRune
    Config_Control FN, wer, frmHeal.chkUseSpell
    Config_Control FN, wer, frmHeal.optRuneFirst
    Config_Control FN, wer, frmHeal.optSpellFirst
    Config_Control FN, wer, frmHeal.txtSpell
    Config_Control FN, wer, frmHeal.txtMana
    Config_Control FN, wer, frmHeal.txtRuneDelay
    Config_Control FN, wer, frmHeal.chkAlertLowHP
    Config_Control FN, wer, frmHeal.chkHealFriends
    
    Config_Title FN, wer, "***INTRUDER RXT***"
    Config_Control FN, wer, frmIntruder.chkAlert
    Config_Control FN, wer, frmIntruder.chkAutoLog
    Config_Control FN, wer, frmIntruder.chkScript
    Config_Control FN, wer, frmIntruder.chkBattleSign
    Config_Control FN, wer, frmIntruder.chkDetectOffscreen
    Config_Control FN, wer, frmIntruder.chkWalk
    Config_Control FN, wer, frmIntruder.lblAfkSpot
    Config_Control FN, wer, frmIntruder.lblSafeSpot
    'Config_Variable FN, wer, frmIntruder.afkX
    'Config_Variable FN, wer, frmIntruder.afkY
    'Config_Variable FN, wer, frmIntruder.afkZ
    'Config_Variable FN, wer, frmIntruder.safeX
    'Config_Variable FN, wer, frmIntruder.safeY
    'Config_Variable FN, wer, frmIntruder.safeZ
    Config_Control FN, wer, frmIntruder.chkBelow
    Config_Control FN, wer, frmIntruder.hscrNumBelow
    Config_Control FN, wer, frmIntruder.chkAbove
    Config_Control FN, wer, frmIntruder.hscrNumAbove
    Config_Control FN, wer, frmIntruder.chkAlertSkulls
    Config_Control FN, wer, frmIntruder.hscrNumSkulls
    Config_Control FN, wer, frmIntruder.chkIgnoreMonsters
    Config_Control FN, wer, frmIntruder.chkIgnoreAll
    Config_ListBox FN, wer, "INTRUDER RXT.SAFE LIST", frmIntruder.listSafe
    If wer = False Then
        frmIntruder.UpdAfkLbl
        frmIntruder.UpdSafeLbl
        frmIntruder.hscrNumAbove_Change
        frmIntruder.hscrNumBelow_Change
    End If
    
    Config_Title FN, wer, "***ATTACK RXT***"
    Config_Control FN, wer, frmAttack.chkSay
    Config_Control FN, wer, frmAttack.txtSay
    Config_ControlArray FN, wer, frmAttack.optWalk
    Config_Control FN, wer, frmAttack.chkWalk
    Config_Control FN, wer, frmAttack.chkBeep
    Config_Control FN, wer, frmAttack.chkAlert
    Config_Control FN, wer, frmAttack.chkAlertLowHP
    Config_Control FN, wer, frmAttack.txtLowHP
    
    Config_Title FN, wer, "***FISHER***"
    Config_ControlArray FN, wer, frmFisher.txtBoundary
    Config_Control FN, wer, frmFisher.chkSpeedFish
    Config_Control FN, wer, frmFisher.chkFishNoFood
    Config_Control FN, wer, frmFisher.chkFishNoWorms
    If wer = False Then frmFisher.updBoundVals
    
    Config_Title FN, wer, "***AMMO GRABBER***"
    Config_ControlArray FN, wer, frmGrabber.optDir
    Config_Control FN, wer, frmGrabber.optSpears
    Config_Control FN, wer, frmGrabber.optThrowingStars
    Config_Control FN, wer, frmGrabber.optSmallStones
    Config_Control FN, wer, frmGrabber.optThrowingKnives
    Config_Control FN, wer, frmGrabber.chkGrabUnderTarget
    If wer = False Then frmGrabber.UpdDirectionControls
    
    Config_Title FN, wer, "***OUTFIT CHANGER***"
    Config_ControlArray FN, wer, frmOutfit.chkColor
    Config_Control FN, wer, frmOutfit.chkRainbow
    Config_Control FN, wer, frmOutfit.hscrOutfit
    If wer = False Then frmOutfit.hscrOutfit_Change
    
    Config_Title FN, wer, "***MAGE CREW***"
    Config_ListBox FN, wer, "MAGE CREW.MAGE LIST", frmMageCrew.listMages
    Config_ListBox FN, wer, "MAGE CREW.TARGETS", frmMageCrew.listTargets
    
    Config_Title FN, wer, "***AUTO ATTACKER***"
    Config_Control FN, wer, frmAutoAttack.hscrAttackDistance
    Config_Control FN, wer, frmAutoAttack.chkIgnoreFriends
    Config_Control FN, wer, frmAutoAttack.chkTargetClosest
    If wer = False Then frmAutoAttack.hscrAttackDistance_Change
    
    Config_Title FN, wer, "***CAVE BOT***"
    Config_Control FN, wer, frmCaveBot.hscrStopDistance
    Config_Control FN, wer, frmCaveBot.chkIgnoreFriends
    If wer = False Then frmCaveBot.hscrStopDistance_Change
    
    
    
    Config_Control FN, wer, frmScript.txtScript
    If wer = False Then frmScript.cmdSave_Click

    If wer Then
        AddStatusMessage "Settings file saved to " & vbCrLf & fileLoc
    Else
        AddStatusMessage "Settings file loaded from " & vbCrLf & fileLoc
        Valid
    End If
Cancel:
    Close FN
End Sub

Public Sub Exp_Stop()
    frmMain.chkExpHour.Value = Unchecked
    frmMain.chkExpHour.ForeColor = vbRed
    frmMain.tmrExp.Enabled = False
    
    For i = LBound(ExpRecord) To UBound(ExpRecord)
        ExpRecord(i) = 0
    Next i
    CurRecordPos = 0
    ExpTime = 0
    SetWindowText tHWND, "Tibia - " & CharName
End Sub

Public Sub Exp_Start()
    frmMain.chkExpHour.Value = Checked
    frmMain.chkExpHour.ForeColor = vbGreen
    frmMain.tmrExp.Enabled = True
    
    Dim level As Long
    
    ExpCur = ReadMem(ADR_EXP, 4)
    level = ReadMem(ADR_LEVEL, 4)
    PercentTnl = GetPercentTnl(level)
    PercentTnlNextExp = ExpNextPercent(PercentTnl, level)
    
    ExpTime = 0
    ExpStart = ExpCur
    ExpRecord(LBound(ExpRecord)) = ExpCur
    ExpRecordPos = 0
End Sub

Public Function HoursToStr(hours As Single) As String
    Dim mins As Long, hoursOnly As Long
    hoursOnly = Fix(hours)
    mins = Int(60 * (hours - hoursOnly))
    If mins >= 60 Then
        mins = mins - 60
        hoursOnly = hoursOnly + 1
    End If
    
    If hoursOnly = 1 Then
        HoursToStr = HoursToStr & hoursOnly & " hour,"
    ElseIf hoursOnly > 1 Then
        HoursToStr = HoursToStr & hoursOnly & " hours,"
    End If
    If mins = 1 Then
        HoursToStr = HoursToStr & " " & mins & " min."
    ElseIf mins > 1 Then
        HoursToStr = HoursToStr & " " & mins & " mins."
    End If
End Function

Public Sub CalculateExperience()
    Dim level As Long
    'percent tnl
    level = ReadMem(ADR_LEVEL, 4)
    ExpCur = ReadMem(ADR_EXP, 4)
    If ExpCur > PercentTnlNextExp Then
        PercentTnl = GetPercentTnl(level)
        AddStatusMessage PercentTnl & "% to level " & level + 1 & " remaining."
        If frmMain.chkExpBeep Then
            Beep 1000, 100
            Pause 50
            Beep 1500, 150
        End If
        PercentTnlNextExp = ExpNextPercent(PercentTnl, level)
    End If
    'exp/hour
    Dim expHour As Long
    Dim timeTnl As String
    If ExpCur <= ExpStart Then
        ExpTime = 0
        ExpStart = ExpCur
    Else
        ExpTime = ExpTime + 1
        expHour = 1000 * (ExpCur - ExpStart) / ExpTime
    End If
    If ExpTime Mod 50 = 0 And ExpTime > 0 Then
        For i = UBound(ExpRecord) To LBound(ExpRecord) + 1 Step -1
            ExpRecord(i) = ExpRecord(i - 1)
        Next i
        ExpRecord(LBound(ExpRecord)) = ExpCur
        If ExpRecordPos < 9 Then ExpRecordPos = ExpRecordPos + 1
        ExpStart = ExpRecord(ExpRecordPos)
        ExpTime = ExpRecordPos * 50
    End If
    If expHour <> 0 Then timeTnl = " : " & HoursToStr(ExpToLevel / expHour)
    SetWindowText tHWND, "Tibia - " & CharName & " : " & Round(ExpToLevel / 1000, 1) & "k (" & PercentTnl & "%)" & " tnl : " & Round(expHour / 1000, 1) & "k xp/hr" & timeTnl
    If ExpCur = ExpStart And ExpTime > 0 Then Exp_Stop: Exp_Start: Valid
End Sub

Public Function GetStepValue(dX As Long, dY As Long) As Integer
    If dX = 0 And dY = -1 Then
        GetStepValue = 0
    ElseIf dX = 1 And dY = -1 Then
        GetStepValue = 5
    ElseIf dX = 1 And dY = 0 Then
        GetStepValue = 1
    ElseIf dX = 1 And dY = 1 Then
        GetStepValue = 6
    ElseIf dX = 0 And dY = 1 Then
        GetStepValue = 2
    ElseIf dX = -1 And dY = 1 Then
        GetStepValue = 7
    ElseIf dX = -1 And dY = 0 Then
        GetStepValue = 3
    ElseIf dX = -1 And dY = -1 Then
        GetStepValue = 8
    Else
        GetStepValue = -1
    End If
End Function

Public Sub ProcessHotkey(command As String)
    Dim temp() As String, i As Integer, pos As Long, more As Integer
    Dim hpPercent As Long, hp As Long, lowest As Boolean, mana As Long
    Dim slot As Integer, Item As Long, bp As Long
    Dim getSlot As Integer, getBP As Integer, idBytes(3) As Byte
    Dim spell As String
    
    AddStatusMessage "Processing: '" & command & "'"
    temp = Split(command, " ")
    If UBound(temp) = 0 Then
        AddStatusMessage "Unspecified command"
    'Else
    '    For i = LBound(temp) To UBound(temp)
    '        AddStatusMessage "Token(" & i & "): '" & temp(i) & "'"
    '    Next i
    End If
    If temp(1) = "repeat" Then
        If UBound(temp) >= 6 Then
            hp = 0
            If temp(2) = "-hp" Then
                If IsNumeric(temp(3)) And CLng(temp(3)) >= 1 Then
                    hp = CLng(temp(3))
                Else
                    GoTo ErrorRepeatHealSpell
                End If
            ElseIf temp(2) = "-%hp" Or temp(2) = "-hp%" Then
                If IsNumeric(temp(3)) And CLng(temp(3)) <= 100 And CLng(temp(3)) >= 1 Then
                    hp = CLng(Int(CLng(temp(3)) * ReadMem(ADR_MAX_HP, 4) / 100))
                Else
                    GoTo ErrorRepeatHealSpell
                End If
            Else
                GoTo ErrorRepeatHealSpell
            End If
            If temp(4) = "-mana" Then
                If IsNumeric(temp(5)) And CLng(temp(5)) >= 1 Then
                    mana = CLng(temp(5))
                Else
                    GoTo ErrorRepeatHealSpell
                End If
            ElseIf temp(4) = "-%mana" Then
                If IsNumeric(temp(5)) And CLng(temp(5)) <= 100 And CLng(temp(5)) >= 1 Then
                    mana = CLng(Int(CLng(temp(5)) * ReadMem(ADR_MAX_MANA, 4) / 100))
                Else
                    GoTo ErrorRepeatHealSpell
                End If
            Else
                GoTo ErrorRepeatHealSpell
            End If
            spell = temp(6)
            If UBound(temp) > 6 Then
                For i = 7 To UBound(temp)
                    spell = spell & " " & temp(i)
                Next i
            End If
            SayStuff spell
            frmAimbot.ToggleHealToFull hp, mana, spell
            Exit Sub
        Else
ErrorRepeatHealSpell:
            AddStatusMessage "!eb repeat (-hp|-%hp) x (-mana|-%mana) x s {s}"
            Exit Sub
        End If
    ElseIf temp(1) = "follow" Then
        If UBound(temp) >= 2 Then
            pos = -1
            Select Case temp(2)
                Case "-friend": pos = FindPosByHP(frmAimbot.listFriends, 101)
                Case "-enemy": pos = FindPosByHP(frmAimbot.listEnemies, 101)
                Case "-anyone":
                    For i = 0 To LEN_CHAR
                        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 And i <> UserPos Then
                            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = 0 _
                            And ReadMem(ADR_PLAYER_Z, 2) = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 2) Then
                                pos = i
                                Exit For
                            End If
                        End If
                    Next i
                Case Else:
                    spell = temp(2)
                    If UBound(temp) > 2 Then
                        For i = 3 To UBound(temp)
                            spell = spell & " " & temp(i)
                        Next i
                    End If
                    pos = findPosByName(spell)
            End Select
            If pos >= 0 Then
                FollowHim ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
                Exit Sub
            Else
                AddStatusMessage "No follow-targets found."
                Exit Sub
            End If
        Else
ErrorFollow:
            AddStatusMessage "!eb follow (-friend|-enemy|-anyone|s)"
            Exit Sub
        End If
    ElseIf temp(1) = "equip" Then
        If UBound(temp) >= 5 Then
            If temp(2) = "-slot" Then
                If IsNumeric(temp(3)) Then
                    slot = CLng(temp(3))
                Else
                    'convert word to slot
                    Select Case temp(3)
                        Case "neck", "amulet", "ammy": slot = SLOT_NECK
                        Case "ring": slot = SLOT_RING
                        Case "ammo", "belt": slot = SLOT_AMMO
                        Case "helmet", "head": slot = SLOT_HELMET
                        Case "armor", "body", "torso": slot = SLOT_ARMOR
                        Case "legs", "leggings": slot = SLOT_LEGS
                        Case "boots", "boot", "feet": slot = SLOT_BOOTS
                        Case "left": slot = SLOT_LEFT_HAND
                        Case "right": slot = SLOT_RIGHT_HAND
                        Case "backpack": slot = SLOT_BACKPACK
                    End Select
                End If
            Else
                GoTo ErrorEquipItemToSlot
            End If
            Item = 0
            For i = 4 To UBound(temp) - 1
                If temp(i) = "-item" Then
                    If IsNumeric(temp(i + 1)) Then
                        Item = CLng(temp(i + 1))
                    Else
                        'convert word to item
                        GoTo ErrorEquipItemToSlot
                    End If
                    Exit For
                End If
            Next i
            If Item = 0 Then GoTo ErrorEquipItemToSlot
            If findItem(Item, getBP, getSlot, False, False) Then
                MoveItem Item, getBP, getSlot, slot, 0, 100
            Else
                AddStatusMessage "item of type " & Item & " not found."
            End If
            Exit Sub
        Else
ErrorEquipItemToSlot:
            AddStatusMessage "!eb equip -slot (x|s) -item (x|s)"
            Exit Sub
        End If
    ElseIf temp(1) = "uh" Then
        If UBound(temp) >= 2 Then
            If temp(2) = "self" Then
                If UBound(temp) >= 3 Then
                    If temp(3) = "-hp" And UBound(temp) >= 4 Then
                        If IsNumeric(temp(4)) And CLng(temp(4)) >= 1 Then
                            If ReadMem(ADR_CUR_HP, 4) < CLng(temp(4)) Then
                                '!eb uh self -hp x
                                ShootRune ITEM_RUNE_UH, UserPos
                            Else
                                AddStatusMessage "Healing not required."
                            End If
                            Exit Sub
                        Else
                            GoTo ErrorUhSelf
                        End If
                    ElseIf temp(3) = "-%hp" And UBound(temp) >= 4 Then
                        If IsNumeric(temp(4)) And CLng(temp(4)) <= 100 And CLng(temp(4)) >= 1 Then
                            If ReadMem(ADR_CUR_HP, 4) <= Int(CLng(temp(4)) * ReadMem(ADR_CUR_HP, 4) / ReadMem(ADR_MAX_HP, 4)) Then
                                '!eb uh self -%hp x
                                ShootRune ITEM_RUNE_UH, UserPos
                            Else
                                AddStatusMessage "Healing not required."
                            End If
                            Exit Sub
                        Else
                            GoTo ErrorUhSelf
                        End If
                    ElseIf temp(3) = "-nowaste" Then
                        If ReadMem(ADR_CUR_HP, 4) <= ReadMem(ADR_MAX_HP, 4) - 2.8 * (ReadMem(ADR_MAG_LEVEL, 4) * 3 + ReadMem(ADR_LEVEL, 4) * 2) Then
                            '!eb uh self -nowaste
                            ShootRune ITEM_RUNE_UH, UserPos
                        End If
                        Exit Sub
                    End If
                Else
                    ShootRune ITEM_RUNE_UH, UserPos
                    Exit Sub
                End If
ErrorUhSelf:
                AddStatusMessage "!eb uh self [-hp x|-%hp x|-nowaste]"
                Exit Sub
            ElseIf temp(2) = "friend" Then
                If UBound(temp) >= 3 Then
                    hpPercent = 100
                    hp = 0
                    i = 3
                    Do
                        If temp(i) = "-%hp" And UBound(temp) >= i + 1 Then
                            If IsNumeric(temp(i + 1)) And CLng(temp(i + 1)) <= 100 And CLng(temp(i + 1)) >= 1 Then
                                hpPercent = CLng(temp(i + 1))
                            Else
                                GoTo ErrorUhFriend
                            End If
                            i = i + 2
                        ElseIf temp(i) = "-lowest" Then
                            lowest = True
                            i = i + 1
                        ElseIf temp(i) = "-self" And UBound(temp) >= i + 1 Then
                            If IsNumeric(temp(i + 1)) And CLng(temp(i + 1)) >= 1 Then
                                hp = CLng(temp(i + 1))
                            Else
                                GoTo ErrorUhFriend
                            End If
                            i = i + 2
                        Else
                            GoTo ErrorUhFriend
                        End If
                    Loop Until i > UBound(temp)
                End If
                If hp > 0 Then
                    If ReadMem(ADR_CUR_HP, 4) <= hp Then
                        ShootRune ITEM_RUNE_UH, UserPos
                        Exit Sub
                    End If
                End If
                pos = FindPosByHP(frmAimbot.listFriends, CInt(hpPercent), lowest)
                If pos >= 0 Then
                    ShootRune ITEM_RUNE_UH, pos
                    Exit Sub
                Else
                    AddStatusMessage command & " -> nobody required healing."
                    Exit Sub
                End If
ErrorUhFriend:
                AddStatusMessage "!eb uh friend {-%hp x|-lowest|-self x}"
                Exit Sub
            Else
                pos = findPosByName(temp(2))
                If pos >= 0 Then
                    ShootRune ITEM_RUNE_UH, pos
                    Exit Sub
                Else
                    AddStatusMessage command & " -> target not available."
                    Exit Sub
                End If
            End If
        Else
            AddStatusMessage "!eb uh (self|friend|name) ..."
            Exit Sub
        End If
    End If
End Sub

Public Sub DetectGM()
    Dim i As Integer, intName As String
    Dim intZ As Long, plyrZ As Long
    Static GMfound As Long, response As Integer
    
    plyrZ = ReadMem(ADR_PLAYER_Z, 4)
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ONSCREEN + SIZE_CHAR * i, 1) = 1 Then
            intName = MemToStr(ADR_CHAR_NAME + SIZE_CHAR * i, 32)
            If Left(intName, 3) = "GM " Or Left(intName, 5) = "Erig " Then
                If GMfound = 0 Then
                    frmMain.chkRune = Unchecked
                    frmMain.chkSpell = Unchecked
                    frmMain.chkAttack = Unchecked
                    frmMain.chkFisher = Unchecked
                    frmMain.chkGrabber = Unchecked
                    frmMain.chkOutfit = Unchecked
                    frmMain.chkAutoAttack = Unchecked
                    StartAlert
                    Valid
                    GMfound = GetTickCount
                    response = 0
                End If
                intZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4)
                GoTo ReactToGM
            End If
        End If
    Next i
    GMfound = 0
    Exit Sub
ReactToGM:
    If intZ <> plyrZ And ReadMem(ADR_BATTLE_SIGN, 4) = 0 Then
        LogOut
        frmMain.chkLogOut = Checked
        Valid
    Else
        If GMfound > 2000 And response = 0 Then
            i = Rnd() * 5
            Select Case i
                Case 0: SayStuff "hi"
                Case 1: SayStuff ":O"
                Case 2: SayStuff "omg"
                Case 3: SayStuff "wow"
            End Select
        ElseIf GMfound > 7000 And response = 1 Then
            i = Rnd() * 7
            Select Case i
                Case 0: SayStuff "can you summon monsters?"
                Case 1: SayStuff "first GM i've seen!"
                Case 2: SayStuff "you are very cool"
                Case 3: SayStuff "what can I do for you?"
                Case 4: SayStuff "screenshot!!! ololol!"
            End Select
        ElseIf GMfound > 10000 And response = 2 Then
            i = Rnd() * 5
            Select Case i
                Case 0: SayStuff "oh"
                Case 1: SayStuff "wait lol"
                Case 2: SayStuff "plz"
                Case 3: SayStuff "um"
                Case 4: SayStuff "what?"
            End Select
        End If
        response = response + 1
    End If
End Sub

Public Function NoFood() As Boolean

End Function
