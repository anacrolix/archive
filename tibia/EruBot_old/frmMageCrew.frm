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
      Left            =   6360
      Top             =   3240
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
      Top             =   2160
      Width           =   855
   End
   Begin VB.CommandButton cmdRemoveTarget 
      Caption         =   "Remove"
      Height          =   375
      Left            =   6120
      TabIndex        =   8
      Top             =   2640
      Width           =   855
   End
   Begin VB.CommandButton cmdNewTarget 
      Caption         =   "New"
      Height          =   375
      Left            =   6120
      TabIndex        =   7
      Top             =   3120
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
      Height          =   3180
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
Dim curMage As Integer

Private Sub cmdAddMage_Click()
    If listMages.ListCount >= 20 Then
        MsgBox "No more than 20 mages can be added", vbCritical, "Too many mages"
        Exit Sub
    End If
    If txtMageAccount < 100000 Or txtMageAccount >= 10000000 Or txtMagePassword = "" Or txtMageName = "" Then
        MsgBox "Invalid value entered for account, password or character name", vbCritical
        Exit Sub
    End If
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
    listTargets.RemoveItem listTargets.ListIndex
End Sub

Public Sub LogOutMageCrew()
    tmrMageCrew.Enabled = False
    For i = 0 To listMages.ListCount - 1
        frmMain.sckMC(i).Close
    Next i
    mageCrewActive = False
End Sub

Public Sub LogInMageCrew()
    Dim temp() As String, i As Integer
    If listMages.ListCount < 1 Then Exit Sub
    For i = 0 To listMages.ListCount - 1
        If frmMain.sckMC(i).State <> sckConnected Then
            frmMain.sckMC(i).Close
            frmMain.sckMC(i).Connect txtIP, CLng(txtPort)
            DoEvents
        End If
    Next i
    For i = 0 To listMages.ListCount - 1
        Do While frmMain.sckMC(i).State <> sckConnected
            DoEvents
        Loop
        temp = Split(listMages.List(i), ",")
        LogInChar i, temp(0), CLng(temp(1)), temp(2)
    Next i
    startTime = GetTickCount
    mageCrewActive = True
    bpOpen = False
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

Private Sub tmrMageCrew_Timer()
    Dim tX As Long, tY As Long, tZ As Long, tarPos As Integer, i As Integer

    If GetTickCount > startTime + 500 And bpOpen = False Then
        MageCrew_OpenBag curMage, &HB36
        curMage = curMage + 1
        If curMage > listMages.ListCount - 1 Then
            bpOpen = True
            curMage = 0
        End If
    ElseIf bpOpen Then
        For i = 0 To listTargets.ListCount - 1
            tarPos = findPosByName(listTargets.List(i))
            If ReadMem(ADR_CHAR_ONSCREEN + tarPos * SIZE_CHAR, 1) = 1 Then
                getCharXYZ tX, tY, tZ, tarPos
                Exit For
            Else
                If i = listTargets.ListCount - 1 Then Exit Sub
            End If
        Next i
        MageCrew_FireRune curMage, ITEM_RUNE_SD, tX, tY, tZ
        curMage = curMage + 1
        If curMage > listMages.ListCount - 1 Then curMage = 0
    End If
End Sub
