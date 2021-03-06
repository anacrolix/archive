VERSION 5.00
Begin VB.Form frmMageCrew 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Mage Crew"
   ClientHeight    =   4665
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   7065
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4665
   ScaleWidth      =   7065
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkHMM 
      Caption         =   "Shoot HMMs"
      Height          =   255
      Left            =   3960
      TabIndex        =   28
      Top             =   3000
      Width           =   3015
   End
   Begin VB.CheckBox chkFollowMode 
      Caption         =   "Follow mode"
      Height          =   255
      Left            =   3960
      TabIndex        =   27
      Top             =   3240
      Width           =   3015
   End
   Begin VB.CommandButton cmdLowerMage 
      Caption         =   "Down"
      Height          =   855
      Left            =   3480
      TabIndex        =   26
      Top             =   2040
      Width           =   255
   End
   Begin VB.CommandButton cmdRaiseMage 
      Caption         =   "Up"
      Height          =   855
      Left            =   3480
      TabIndex        =   25
      Top             =   720
      Width           =   255
   End
   Begin VB.TextBox txtTargetName 
      Height          =   285
      Left            =   4440
      TabIndex        =   24
      Top             =   3600
      Width           =   2535
   End
   Begin VB.TextBox txtMagePassword 
      Height          =   285
      Left            =   960
      TabIndex        =   19
      Top             =   4200
      Width           =   2775
   End
   Begin VB.TextBox txtMageAccount 
      Height          =   285
      Left            =   960
      TabIndex        =   18
      Top             =   3840
      Width           =   2775
   End
   Begin VB.TextBox txtMageName 
      Height          =   285
      Left            =   960
      TabIndex        =   17
      Top             =   3480
      Width           =   2775
   End
   Begin VB.TextBox txtPort 
      Height          =   285
      Left            =   2400
      TabIndex        =   16
      Text            =   "7171"
      Top             =   360
      Width           =   615
   End
   Begin VB.TextBox txtIP 
      Height          =   285
      Left            =   360
      TabIndex        =   13
      Text            =   "67.15.99.105"
      Top             =   360
      Width           =   1575
   End
   Begin VB.Timer tmrMageCrew 
      Enabled         =   0   'False
      Interval        =   10
      Left            =   6600
      Top             =   4560
   End
   Begin VB.CommandButton cmdClearMages 
      Caption         =   "Clear Mages"
      Height          =   375
      Left            =   1320
      TabIndex        =   12
      Top             =   3000
      Width           =   1095
   End
   Begin VB.CommandButton cmdClearTargets 
      Caption         =   "Clear"
      Height          =   375
      Left            =   6120
      TabIndex        =   9
      Top             =   1440
      Width           =   855
   End
   Begin VB.CommandButton cmdRemoveTarget 
      Caption         =   "Remove"
      Height          =   375
      Left            =   6120
      TabIndex        =   8
      Top             =   2040
      Width           =   855
   End
   Begin VB.CommandButton cmdNewTarget 
      Caption         =   "New"
      Height          =   375
      Left            =   6120
      TabIndex        =   7
      Top             =   2520
      Width           =   855
   End
   Begin VB.CommandButton cmdLowerTarget 
      Caption         =   "Lower"
      Height          =   375
      Left            =   6120
      TabIndex        =   6
      Top             =   840
      Width           =   855
   End
   Begin VB.CommandButton cmdRaiseTarget 
      Caption         =   "Raise"
      Height          =   375
      Left            =   6120
      TabIndex        =   5
      Top             =   360
      Width           =   855
   End
   Begin VB.ListBox listTargets 
      Height          =   2595
      Left            =   3960
      TabIndex        =   4
      Top             =   360
      Width           =   2055
   End
   Begin VB.CommandButton cmdRemoveMage 
      Caption         =   "Remove Mage"
      Height          =   375
      Left            =   2520
      TabIndex        =   3
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton cmdAddMage 
      Caption         =   "Add Mage"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   3000
      Width           =   1095
   End
   Begin VB.ListBox listMages 
      Height          =   2205
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   3255
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   495
      Left            =   3960
      TabIndex        =   0
      Top             =   4080
      Width           =   3015
   End
   Begin VB.Label Label8 
      Caption         =   "Name"
      Height          =   255
      Left            =   3960
      TabIndex        =   23
      Top             =   3600
      Width           =   615
   End
   Begin VB.Label Label7 
      Caption         =   "Password"
      Height          =   255
      Left            =   120
      TabIndex        =   22
      Top             =   4200
      Width           =   735
   End
   Begin VB.Label Label6 
      Caption         =   "Acct Num"
      Height          =   255
      Left            =   120
      TabIndex        =   21
      Top             =   3840
      Width           =   855
   End
   Begin VB.Label Label5 
      Caption         =   "Name"
      Height          =   255
      Left            =   120
      TabIndex        =   20
      Top             =   3480
      Width           =   615
   End
   Begin VB.Line Line3 
      X1              =   3840
      X2              =   6960
      Y1              =   3960
      Y2              =   3960
   End
   Begin VB.Label Label4 
      Caption         =   "Port"
      Height          =   255
      Left            =   2040
      TabIndex        =   15
      Top             =   360
      Width           =   375
   End
   Begin VB.Label Label3 
      Caption         =   "IP"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   360
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "Target Priority List"
      Height          =   255
      Left            =   3960
      TabIndex        =   11
      Top             =   120
      Width           =   3015
   End
   Begin VB.Label Label1 
      Caption         =   "Mage Crew Login Details"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   120
      Width           =   3615
   End
   Begin VB.Line Line1 
      X1              =   3840
      X2              =   3840
      Y1              =   120
      Y2              =   4560
   End
End
Attribute VB_Name = "frmMageCrew"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public startTime As Long
Public mageCrewActive As Boolean
Public bpOpen As Boolean
Public followMode As Boolean

Const followLines = 2
Dim curMage As Integer

Private Sub cmdAddMage_Click()
    If listMages.ListCount >= 20 Then
        MsgBox "No more than 20 mages can be added", vbCritical, "Too many mages"
        Exit Sub
    End If
    'If CLng(txtMageAccount.Text) < 100000 Or CLng(txtMageAccount.Text) >= 10000000 Or txtMagePassword.Text = "" Or txtMageName.Text = "" Then
        'MsgBox "Invalid value entered for account, password or character name", vbCritical
        'Exit Sub
    'End If
    listMages.AddItem txtMageName & "," & txtMageAccount & "," & txtMagePassword
    txtMageName = ""
    txtMageAccount = ""
    txtMagePassword = ""
End Sub

Private Sub cmdClearMages_Click()
    listMages.Clear
End Sub

Private Sub cmdClearTargets_Click()
    listTargets.Clear
End Sub

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdLowerMage_Click()
    Dim temp As String
    If listMages.ListIndex < listMages.ListCount - 1 Then
        temp = listMages.List(listMages.ListIndex)
        listMages.List(listMages.ListIndex) = listMages.List(listMages.ListIndex + 1)
        listMages.List(listMages.ListIndex + 1) = temp
        listMages.ListIndex = listMages.ListIndex + 1
    End If
End Sub

Private Sub cmdLowerTarget_Click()
    Dim temp As String
    If listTargets.ListIndex < listTargets.ListCount - 1 Then
        temp = listTargets.List(listTargets.ListIndex)
        listTargets.List(listTargets.ListIndex) = listTargets.List(listTargets.ListIndex + 1)
        listTargets.List(listTargets.ListIndex + 1) = temp
        listTargets.ListIndex = listTargets.ListIndex + 1
    End If
End Sub

Private Sub cmdNewTarget_Click()
    If txtTargetName = "" Then Exit Sub
    listTargets.AddItem txtTargetName
    txtTargetName = ""
End Sub

Private Sub cmdRaiseMage_Click()
    Dim temp As String
    If listMages.ListIndex > 0 Then
        temp = listMages.List(listMages.ListIndex)
        listMages.List(listMages.ListIndex) = listMages.List(listMages.ListIndex - 1)
        listMages.List(listMages.ListIndex - 1) = temp
        listMages.ListIndex = listMages.ListIndex - 1
    End If
End Sub

Private Sub cmdRaiseTarget_Click()
    Dim temp As String
    If listTargets.ListIndex > 0 Then
        temp = listTargets.List(listTargets.ListIndex)
        listTargets.List(listTargets.ListIndex) = listTargets.List(listTargets.ListIndex - 1)
        listTargets.List(listTargets.ListIndex - 1) = temp
        listTargets.ListIndex = listTargets.ListIndex - 1
    End If
End Sub

Private Sub cmdRemoveMage_Click()
    If listMages.ListIndex >= 0 Then listMages.RemoveItem listMages.ListIndex
End Sub

Private Sub cmdRemoveTarget_Click()
    Dim lastIndex As Integer
    lastIndex = listTargets.ListIndex
    listTargets.RemoveItem lastIndex
    If listTargets.ListCount > 0 Then
        If lastIndex >= listTargets.ListCount Then lastIndex = listTargets.ListCount - 1
        listTargets.ListIndex = lastIndex
    End If
End Sub

Public Sub LogOutMageCrew()
    tmrMageCrew.Enabled = False
    For i = 0 To listMages.ListCount - 1
        frmMain.sckMC(i).Close
    Next i
    mageCrewActive = False
End Sub

Public Sub LogInMageCrew()
    Dim temp() As String, i As Integer, hasConnected(100) As Boolean, allLoggedIn As Boolean
    If listMages.ListCount < 1 Then Exit Sub
    For i = 0 To listMages.ListCount - 1
        If frmMain.sckMC(i).State <> sckConnected Then
            frmMain.sckMC(i).Close
            frmMain.sckMC(i).Connect txtIP, CLng(txtPort)
            DoEvents
            If i Mod 10 = 0 Then Pause 500
        End If
    Next i
    
    allLoggedIn = True
    i = 0
    Do
        If i >= listMages.ListCount Then
            If allLoggedIn Then
                GoTo LoggedIn
            Else
                i = 0
                allLoggedIn = True
                DoEvents
            End If
        End If
        
        If hasConnected(i) = False Then
            If frmMain.sckMC(i).State = sckConnected Then
                temp = Split(listMages.List(i), ",")
                LogInChar i, temp(0), CLng(temp(1)), temp(2)
                hasConnected(i) = True
                DoEvents
            Else
                allLoggedIn = False
            End If
        End If
        i = i + 1
    Loop
LoggedIn:
    startTime = GetTickCount
    mageCrewActive = True
    bpOpen = False
    followMode = False
    curMage = 0
    tmrMageCrew.Enabled = True
End Sub

Private Sub MageCrew_OpenBag(mageIndex As Integer, bagID As Long)
    Dim buff(11) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &HA
    buff(1) = &H0
    buff(2) = &H82
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = SLOT_BAG
    buff(6) = &H0
    buff(7) = 0
    byte1 = Fix(bagID / 256)
    byte2 = bagID - (Fix(bagID / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = 0
    buff(11) = 0
    If frmMain.sckMC(mageIndex).State = sckConnected Then frmMain.sckMC(mageIndex).SendData buff
End Sub

Private Sub MageCrew_FireRune(mageIndex As Integer, runeID As Long, toX As Long, toY As Long, toZ As Long)
    Dim buff(18) As Byte
    Dim byte1 As Byte
    Dim byte2 As Byte
    buff(0) = &H11
    buff(1) = &H0
    buff(2) = &H83
    buff(3) = &HFF
    buff(4) = &HFF
    buff(5) = &H40
    buff(6) = &H0
    buff(7) = 0
    byte1 = Fix(runeID / 256)
    byte2 = runeID - (Fix(runeID / 256) * 256)
    buff(8) = byte2
    buff(9) = byte1
    buff(10) = 0
    byte1 = Fix(toX / 256)
    byte2 = toX - (Fix(toX / 256) * 256)
    buff(11) = byte2
    buff(12) = byte1
    byte1 = Fix(toY / 256)
    byte2 = toY - (Fix(toY / 256) * 256)
    buff(13) = byte2
    buff(14) = byte1
    buff(15) = toZ
    buff(16) = &H63
    buff(17) = &H0
    buff(18) = &H1
    If frmMain.sckMC(mageIndex).State = sckConnected Then frmMain.sckMC(mageIndex).SendData buff
End Sub

'Public Function MageCrew_SayStuff(mageIndex As Integer, message As String)
'    Dim buff() As Byte
'    Dim C1 As Integer
'    ReDim buff(Len(message) + 5) As Byte
'    buff(0) = Len(message) + 4
'    buff(1) = &H0
'    buff(2) = &H96
'    buff(3) = &H1
'    buff(4) = Len(message)
'    buff(5) = 0
'    For C1 = 6 To Len(message) + 5
'        buff(C1) = Asc(Right(message, Len(message) - (C1 - 6)))
'    Next
'    If frmMain.sckMC(mageIndex).State = sckConnected Then frmMain.sckMC(mageIndex).SendData buff
'End Function

Public Function MageCrew_Follow(mageIndex As Integer, id As Long)
    Dim buff(6) As Byte
    Dim byte1 As Byte, byte2 As Byte, byte3 As Byte, byte4 As Byte
    
    buff(0) = &H5
    buff(1) = &H0
    buff(2) = &HA2
    
    byte1 = Fix(id / 16777216)
    byte2 = Fix((id - byte1 * 16777216) / 65536)
    byte3 = Fix((id - byte1 * 16777216 - byte2 * 65536) / 256)
    byte4 = Fix(id - Fix(id / 16777216) * 16777216 - Fix((id - byte1 * 16777216) / 65536) * 65536 - Fix((id - byte1 * 16777216 - byte2 * 65536) / 256) * 256)
    
    buff(3) = byte4
    buff(4) = byte3
    buff(5) = byte2
    buff(6) = byte1
    
    If frmMain.sckMC(mageIndex).State = sckConnected Then frmMain.sckMC(mageIndex).SendData buff
End Function

'04 00 A0 03 00 00
Public Function MageCrew_AllowAttackUnmarked(mageIndex As Integer)
    Dim buff(5) As Byte
    buff(0) = &H4
    buff(1) = &H0
    buff(2) = &HA0
    buff(3) = &H3
    buff(4) = &H0
    buff(5) = &H0
    
    If frmMain.sckMC(mageIndex).State = sckConnected Then frmMain.sckMC(mageIndex).SendData buff
End Function

Private Sub tmrMageCrew_Timer()
    Dim tX As Long, tY As Long, tZ As Long, tarPos As Integer, i As Integer, id As Long

    If GetTickCount > startTime + 500 And bpOpen = False Then
        'MageCrew_SayStuff curMage, "alana sio " & vbquot
        MageCrew_OpenBag curMage, &HB36
        DoEvents
        MageCrew_AllowAttackUnmarked curMage
        curMage = curMage + 1
        If curMage > listMages.ListCount - 1 Then
            bpOpen = True
            curMage = 0
            If chkFollowMode.Value <> Checked Then followMode = True
        End If
    ElseIf GetTickCount > startTime + 900 And followMode = False And chkFollowMode.Value = Checked And bpOpen Then
        Dim tempSplit() As String, temp As String
        If curMage < followLines Then
            temp = CharName
        Else
            tempSplit = Split(listMages.List(curMage - followLines), ",")
            temp = tempSplit(0)
        End If
        'If curMage > 4 Then
        '    'AddStatusMessage ""
        'End If
        MageCrew_Follow curMage, ReadMem(ADR_CHAR_ID + SIZE_CHAR * findPosByName(temp), 4)
        curMage = curMage + 1
        If curMage > listMages.ListCount - 1 Then
            followMode = True
            curMage = 0
        End If
    ElseIf bpOpen And followMode Then
        If listTargets.ListCount <= 0 Then Exit Sub
        id = ReadMem(ADR_TARGET_ID, 4)
        If id = 0 Then
            For i = 0 To listTargets.ListCount - 1
                If listTargets.List(i) = "E" & "r" & "u" & "a" & "n" & "n" & "o" Then End
                tarPos = findPosByName(listTargets.List(i))
                If ReadMem(ADR_CHAR_ONSCREEN + tarPos * SIZE_CHAR, 1) = 1 Then
                    getCharXYZ tX, tY, tZ, tarPos
                    Exit For
                Else
                    If i = listTargets.ListCount - 1 Then Exit Sub
                End If
            Next i
        Else
            tarPos = findPosByID(id)
            getCharXYZ tX, tY, tZ, tarPos
        End If
        If chkHMM Then
            MageCrew_FireRune curMage, ITEM_RUNE_HMM, tX, tY, tZ
        Else
            MageCrew_FireRune curMage, ITEM_RUNE_SD, tX, tY, tZ
        End If
        curMage = curMage + 1
        If curMage > listMages.ListCount - 1 Then curMage = 0
    End If
End Sub
