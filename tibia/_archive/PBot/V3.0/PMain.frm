VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmMain 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "PBot 3.2"
   ClientHeight    =   4170
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   4785
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9.75
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   FontTransparent =   0   'False
   Icon            =   "PMain.frx":0000
   MaxButton       =   0   'False
   ScaleHeight     =   278
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   319
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chWalk 
      BackColor       =   &H00000000&
      Caption         =   "Auto Walker"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   3720
      Width           =   1200
   End
   Begin VB.Timer tmrALog 
      Left            =   3840
      Top             =   480
   End
   Begin VB.Timer trmRef 
      Interval        =   5000
      Left            =   3960
      Top             =   360
   End
   Begin VB.CheckBox chEat 
      BackColor       =   &H00000000&
      Caption         =   "Eater"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   7
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Timer tmrFish 
      Left            =   4080
      Top             =   240
   End
   Begin VB.Timer tmrHKey 
      Interval        =   10
      Left            =   4200
      Top             =   120
   End
   Begin VB.Timer tmrClock 
      Interval        =   50
      Left            =   4320
      Top             =   0
   End
   Begin VB.CheckBox chSpell 
      BackColor       =   &H00000000&
      Caption         =   "Spell Caster"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   6
      Top             =   3240
      Width           =   1200
   End
   Begin VB.CheckBox chHeal 
      BackColor       =   &H00000000&
      Caption         =   "Healer"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CheckBox chFish 
      BackColor       =   &H00000000&
      Caption         =   "Fisher"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CheckBox chAttack 
      BackColor       =   &H00000000&
      Caption         =   "Attack Reaction"
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   1680
      Width           =   1215
   End
   Begin MSWinsockLib.Winsock sckS 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckC2 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckC1 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckL 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Timer tmrEat 
      Left            =   3840
      Top             =   0
   End
   Begin VB.CheckBox chRune 
      BackColor       =   &H00000000&
      Caption         =   "Rune Maker"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      MaskColor       =   &H00000000&
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   720
      Width           =   1200
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Pargermer"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   735
      Left            =   600
      TabIndex        =   0
      Top             =   0
      Width           =   2535
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Bot"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   1560
      TabIndex        =   1
      Top             =   480
      Width           =   1095
   End
   Begin VB.Line lnClock 
      BorderColor     =   &H000000FF&
      BorderWidth     =   3
      X1              =   205
      X2              =   205
      Y1              =   165
      Y2              =   64
   End
   Begin VB.Shape shpClock 
      BorderColor     =   &H000000FF&
      BorderWidth     =   3
      Height          =   3270
      Left            =   1440
      Shape           =   3  'Circle
      Top             =   840
      Width           =   3255
   End
   Begin VB.Menu mnuBot 
      Caption         =   "&Bot"
      Begin VB.Menu mnuRune 
         Caption         =   "&Rune Maker"
      End
      Begin VB.Menu mnuAttack 
         Caption         =   "A&ttack Reaction"
      End
      Begin VB.Menu mnuHeal 
         Caption         =   "&Healer"
      End
      Begin VB.Menu mnuSpell 
         Caption         =   "&Spell Caster"
      End
      Begin VB.Menu mnuWalk 
         Caption         =   "&Auto Walker"
      End
      Begin VB.Menu mnuD1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuActive 
         Caption         =   "&Active"
      End
      Begin VB.Menu mnuD2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Exit"
      End
   End
   Begin VB.Menu mnuOther 
      Caption         =   "&Other"
      Begin VB.Menu mnuSearch 
         Caption         =   "&CharSearch"
      End
      Begin VB.Menu mnuAim 
         Caption         =   "&Aim Bot"
      End
      Begin VB.Menu mnuLog 
         Caption         =   "Auto &Log"
      End
      Begin VB.Menu mnuMS 
         Caption         =   "&Master/Slave"
      End
   End
   Begin VB.Menu mnuSkin 
      Caption         =   "&Skin"
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub chAttack_Click()
    Valid
End Sub

Private Sub chEat_Click()
    Valid
End Sub

Private Sub chFish_Click()
    Valid
End Sub

Private Sub chHeal_Click()
    Valid
End Sub

Private Sub chRune_Click()
    Valid
    frmWalk.chAC.Visible = True
End Sub

Private Sub chSpell_Click()
    Valid
End Sub

Private Sub chWalk_Click()
    Valid
End Sub

Private Sub Form_Load()
    Dim lngDeskTopHandle As Long
    Dim lngHand As Long
    Dim strName As String * 9
    Dim lngWindowCount As Long
    Dim lngTibia(20) As Long
    Dim C1 As Integer
    Dim Valid As Boolean
    sckL.Close
    sckL.Listen
    sckC2.Close
    sckC2.Listen
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Do While lngHand <> 0
        GetWindowText lngHand, strName, Len(strName)
        If strName = "Tibia   " & vbNullChar Then
            lngTibia(C1) = lngHand
            C1 = C1 + 1
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    Open "PBot.dat" For Input As #1
    Input #1, TibiaDir
    Input #1, FColor, BColor
    TextChange FColor
    BackChange BColor
    Close #1
    ShellExecute 0, "open", "tibia.exe", 0, TibiaDir, 3
    Pause 2000
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Do While Valid <> True
        If lngHand = 0 Then
            Pause 500
            lngDeskTopHandle = GetDesktopWindow()
            lngHand = GetWindow(lngDeskTopHandle, 5)
        End If
        GetWindowText lngHand, strName, Len(strName)
        If strName = "Tibia   " & vbNullChar Then
            Valid = True
            For C1 = 0 To 20
                If lngHand = lngTibia(C1) Then
                    Valid = False
                    Exit For
                End If
            Next
            If Valid = True Then Thwnd = lngHand
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    StrToMem Thwnd, adrIP, sckS.LocalIP
    StrToMem Thwnd, adrIP + &H70, sckS.LocalIP
    StrToMem Thwnd, adrIP + &HE0, sckS.LocalIP
    StrToMem Thwnd, adrIP + &H150, sckS.LocalIP
    Memory Thwnd, adrPort, sckL.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &H70, sckL.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &HE0, sckL.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &H150, sckL.LocalPort, 2, WMem
    ClockPos = 30
End Sub

Private Sub Form_Unload(Cancel As Integer)
    sckS.Close
    sckL.Close
    sckC1.Close
    sckC2.Close
    EndAll
End Sub

Private Sub mnuActive_Click()
    If mnuActive.Checked = True Then
        mnuActive.Checked = False
    Else
        mnuActive.Checked = True
    End If
    Valid
End Sub

Private Sub mnuAim_Click()
    frmAim.Show
End Sub

Private Sub mnuAttack_Click()
    frmAttack.Show
    FindChar
End Sub

Private Sub mnuExit_Click()
    EndAll
End Sub

Private Sub mnuHeal_Click()
    frmHeal.Show
End Sub

Private Sub mnuLog_Click()
    If mnuLog.Checked = True Then
        mnuLog.Checked = False
        tmrALog.Interval = 0
    Else
        mnuLog.Checked = True
        tmrALog.Interval = 200
    End If
End Sub

Private Sub mnuMS_Click()
    frmSM.Show
End Sub

Private Sub mnuRune_Click()
    frmRune.Show
End Sub

Private Sub mnuSearch_Click()
    frmCharSearch.Show
End Sub

Private Sub mnuSkin_Click()
    frmSkin.Show
End Sub

Private Sub mnuSpell_Click()
    frmSpell.Show
End Sub

Private Sub mnuWalk_Click()
    frmWalk.Show
End Sub

Private Sub sckC1_Close()
    sckC1.Close
    sckS.Close
    mnuActive.Checked = False
    Valid
End Sub

Private Sub sckC1_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    Dim C1 As Integer
    Dim Temp As Integer
    Dim Name As String
    sckC1.GetData buff
    If buff(2) = &HA Then
        Temp = buff(12)
        For C1 = 14 To 14 + Temp - 1
            Name = Name & Chr(buff(C1))
        Next
        For C1 = 0 To 20
            If Name = Characters(C1) Then
                sckS.Close
                sckS.Connect Connection(C1), 7171
                GameConnection = Connection(C1)
                Me.Caption = "PBot 3.2 - " & Name
                Exit For
            End If
        Next
    End If
    Do While sckS.State <> sckConnected And sckS.State <> sckClosed
        DoEvents
    Loop
    sckS.SendData buff
End Sub

Private Sub sckC2_ConnectionRequest(ByVal requestID As Long)
    sckC1.Close
    sckC1.Accept requestID
    sckS.Close
    sckS.Connect GameConnection, 7171
End Sub

Private Sub sckL_ConnectionRequest(ByVal requestID As Long)
    sckC1.Close
    sckC1.Accept requestID
    sckS.Close
    sckS.Connect "server.tibia.com", 7171
End Sub

Private Sub sckS_Close()
    sckC1.Close
    sckS.Close
    mnuActive.Checked = False
    Valid
End Sub

Private Sub sckS_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    Dim C1 As Integer
    Dim C2 As Integer
    Dim C3 As Integer
    Dim C4 As Integer
    Dim strIP As String
    Dim strTemp As String
    Dim lng1 As Long
    Dim Temp As Integer
    Dim Name As String
    Dim Message As String
    Dim strAgain As String
    Dim byt1 As Long
    Dim byt2 As Long
    Dim byt3 As Long
    Dim byt4 As Long
    
    sckS.GetData buff
    If buff(2) = &HAA And frmSM.chSlave.Value = Checked Then
        If buff(buff(3) + 5) = 4 Then
            For C1 = 5 To buff(3) + 4
                Name = Name & Chr(buff(C1))
            Next
            For C1 = 8 + buff(3) To 7 + buff(3) + buff(buff(3) + 6)
                Message = Message & Chr(buff(C1))
            Next
            If Name = frmSM.txtMaster.Text Then
                If Message = "-mov:UpLeft" Then Send1 &H6D
                If Message = "-mov:Up" Then Send1 &H65
                If Message = "-mov:UpRight" Then Send1 &H6A
                If Message = "-mov:Right" Then Send1 &H66
                If Message = "-mov:DownRight" Then Send1 &H6B
                If Message = "-mov:Down" Then Send1 &H67
                If Message = "-mov:DownLeft" Then Send1 &H6C
                If Message = "-mov:Left" Then Send1 &H68
                If Left(Message, 7) = "-follow" Then
                    For C1 = 0 To 147
                        C2 = 0
                        strAgain = ""
                        Do
                            Memory Thwnd, adrNameStart + (C1 * CharDist) + C2, lng1, 1, RMem
                            strAgain = strAgain & Chr(lng1)
                            Memory Thwnd, adrNameStart + (C1 * CharDist) + C2 + 1, lng1, 1, RMem
                        Loop Until C2 = 0
                        If strAgain = frmSM.txtMaster.Text Then
                            Memory Thwnd, adrNChar + (C1 * CharDist), byt1, 1, RMem
                            Memory Thwnd, adrNChar + (C1 * CharDist) + 1, byt2, 1, RMem
                            Memory Thwnd, adrNChar + (C1 * CharDist) + 2, byt3, 1, RMem
                            Memory Thwnd, adrNChar + (C1 * CharDist) + 3, byt4, 1, RMem
                            FollowHim byt1, byt2, byt3, byt4
                        End If
                    Next
                End If
                If Message = "-stopfollow" Then FollowHim 0, 0, 0, 0
                If Message = "-logoff" Then
                    sckS.Close
                    sckC1.Close
                End If
                If Message = "-stopbot" Then
                    mnuActive.Checked = False
                    Valid
                End If
                If Message = "-startbot" Then
                    mnuActive.Checked = True
                    Valid
                End If
                If Left(Message, 5) = "-say:" Then
                    SayStuff Right(Message, Len(Message) - 5)
                End If
            End If
        End If
    ElseIf buff(2) = &H14 Then
        C1 = C1 + buff(3) + (buff(4) * 256) + 8
        For C4 = 1 To buff(C1 - 2)
            Temp = buff(C1 - 1)
            C1 = C1 + 1
            For C2 = C1 To C1 + Temp - 1
                Characters(C3) = Characters(C3) & Chr(buff(C2))
            Next
            C1 = C1 + Temp - 1
            Temp = buff(C1 + 1)
            C1 = C1 + Temp + 3
            Connection(C3) = buff(C1) & "." & buff(C1 + 1) & "." & buff(C1 + 2) & "." & buff(C1 + 3)
            strIP = sckS.LocalIP
            Temp = 0
            For C2 = 0 To 3
                strTemp = ""
                For Temp = Temp To Len(strIP) - 1
                    If Asc(Right(strIP, Len(strIP) - Temp)) = Asc(".") Then
                        Temp = Temp + 1
                        Exit For
                    Else
                        strTemp = strTemp + "" + Chr(Asc(Right(strIP, Len(strIP) - Temp)))
                    End If
                Next
                buff(C1 + C2) = strTemp
            Next
            C1 = C1 + 4
            buff(C1) = sckC2.LocalPort - (Fix(sckC2.LocalPort / 256) * 256)
            buff(C1 + 1) = Fix(sckC2.LocalPort / 256)
            C1 = C1 + 3
            C3 = C3 + 1
        Next
    End If
    Do While sckC1.State <> sckConnected And sckC1.State <> sckClosed
        DoEvents
    Loop
        sckC1.SendData buff
End Sub

Private Sub tmrALog_Timer()
    Dim C1 As Integer
    Dim Z1 As Long
    Dim Z2 As Long
    Dim bt As Long
    For C1 = 0 To 147
        Memory Thwnd, adrZPos, Z1, 4, RMem
        Memory Thwnd, adrZChar + (CharDist * C1), Z2, 4, RMem
        Memory Thwnd, adrBChar + (CharDist * C1), bt, 1, RMem
        If Z1 = Z2 And bt = 1 And C1 <> UserPos Then
            sckS.Close
            sckC1.Close
            mnuLog.Checked = False
            tmrALog.Interval = 0
            mnuActive.Checked = False
            Valid
            Exit For
        End If
    Next
End Sub

Private Sub tmrClock_Timer()
    Dim gtInp As Long
    Dim gtInp2 As Long
    If mnuActive.Checked = True Then
        lnClock.X2 = -(Sin((ClockPos * 6.28) / 60) * 101) + 205
        lnClock.Y2 = (Cos((ClockPos * 6.28) / 60) * 101) + 165
        ClockPos = ClockPos + 1
        If ClockPos = 60 Then ClockPos = 0
    End If
    If boolLight = True Then Memory Thwnd, adrLight + CharDist * UserPos, 20, 1, WMem
End Sub

Private Sub tmrEat_Timer()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim bpopen As Long
    Dim ltemp As Long
    Dim items As Long
    Dim Temp As Long
    Dim X As Long
    Dim Y As Long
    Dim Z As Long
    
    For C1 = 0 To 20
        Memory Thwnd, adrBPOpen + (BPDist * C1), bpopen, 1, RMem
        If bpopen = 1 Then
            Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
            For C2 = 0 To items - 1
                Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), ltemp, 2, RMem
                If IsFood(ltemp) Then Exit For
            Next
            If IsFood(ltemp) Then Exit For
        End If
    Next
    If IsFood(ltemp) Then
        UseHere ltemp, &H40 + C1, C2
    End If
End Sub

Private Sub tmrFish_Timer()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim bpopen As Long
    Dim ltemp As Long
    Dim items As Long
    Dim Temp As Long
    Dim X As Long
    Dim Y As Long
    Dim Z As Long
    
    For C1 = 0 To 20
        Memory Thwnd, adrBPOpen + (BPDist * C1), bpopen, 1, RMem
        If bpopen = 1 Then
            Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
            For C2 = 0 To items - 1
                Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), ltemp, 2, RMem
                If ltemp = &HA14 Then Exit For
            Next
            If ltemp = &HA14 Then Exit For
        End If
    Next
    If ltemp = &HA14 Then
        Memory Thwnd, adrXPos, X, 2, RMem
        X = X + Fix(Rnd() * 15) - 7
        Memory Thwnd, adrYPos, Y, 2, RMem
        Y = Y + Fix(Rnd() * 15) - 7
        Memory Thwnd, adrZPos, Z, 2, RMem
        UseAt &HA14, &H40 + C1, C2, X, Y, Z
    End If
End Sub

Private Sub tmrHKey_Timer()
    Dim items As Long
    Dim Piece As Long
    Dim lngx As Long
    Dim lngy As Long
    Dim lngz As Long
    
    If GetAsyncKeyState(vbKeyEnd) And GetForegroundWindow() = Thwnd Then
        Do
            DoEvents
        Loop Until (GetAsyncKeyState(vbKeyEnd) = 0)
        If boolLight = True Then
            boolLight = False
            Memory Thwnd, adrLight + (CharDist * UserPos), 0, 1, WMem
        Else
            boolLight = True
        End If
    End If
    HKShoot &H8DC, vbKeyInsert, frmAim.Check1.Value
    HKShoot &H907, vbKeyHome, frmAim.Check2.Value
    If GetAsyncKeyState(vbKeyPageUp) And GetForegroundWindow() = Thwnd And frmAim.Check3.Value = Checked Then
        Do
            DoEvents
        Loop Until (GetAsyncKeyState(vbKeyPageUp) = 0)
        Memory Thwnd, adrXPos, lngx, 2, RMem
        Memory Thwnd, adrYPos, lngy, 2, RMem
        Memory Thwnd, adrZPos, lngz, 2, RMem
        ShootRune &H8E1, lngx, lngy, lngz
    End If
    If GetAsyncKeyState(vbKeyPageDown) And GetForegroundWindow() = Thwnd Then
        Memory Thwnd, adrExp, items, 4, RMem
        Piece = 0
        Memory Thwnd, adrLvl, Piece, 2, RMem
        TalkWhite ExpToLvl(Piece + 1, items)
    End If
End Sub
Private Function HKShoot(RuneMem As Long, HotKey As Integer, Val As Integer)
    Dim Pcode As Long
    Dim Pcod2 As Long
    Dim PX As Long
    Dim PY As Long
    Dim PZ As Long
    Dim C1 As Integer
    If GetAsyncKeyState(HotKey) And GetForegroundWindow() = Thwnd And Val = 1 Then
        Do
            DoEvents
        Loop Until (GetAsyncKeyState(HotKey) = 0)
        Memory Thwnd, adrAtk, Pcode, 4, RMem
        If Pcode <> 0 Then
            For C1 = 0 To 147
                Memory Thwnd, adrNChar + (CharDist * C1), Pcod2, 4, RMem
                If Pcode = Pcod2 Then
                    Memory Thwnd, adrXChar + (CharDist * C1), PX, 2, RMem
                    Memory Thwnd, adrYChar + (CharDist * C1), PY, 2, RMem
                    Memory Thwnd, adrZChar + (CharDist * C1), PZ, 2, RMem
                    ShootRune RuneMem, PX, PY, PZ
                    Exit For
                End If
            Next
        End If
    End If
End Function

Private Sub trmRef_Timer()
    FindChar
End Sub
