VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "PBot 4.0"
   ClientHeight    =   3705
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   5985
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9.75
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   247
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   399
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   5160
      Top             =   0
   End
   Begin VB.CheckBox chNoMove 
      BackColor       =   &H00000000&
      Caption         =   "Don't Move"
      Enabled         =   0   'False
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   4560
      Style           =   1  'Graphical
      TabIndex        =   20
      Top             =   3240
      Width           =   1215
   End
   Begin VB.Timer tmrSpear 
      Left            =   5520
      Top             =   0
   End
   Begin VB.CheckBox chAppear 
      BackColor       =   &H00000000&
      Caption         =   "Appearance Reaction"
      Enabled         =   0   'False
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   18
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "SE"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   8
      Left            =   5400
      Style           =   1  'Graphical
      TabIndex        =   17
      Top             =   2520
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "S"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   7
      Left            =   4920
      Style           =   1  'Graphical
      TabIndex        =   16
      Top             =   2520
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "SW"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   6
      Left            =   4440
      Style           =   1  'Graphical
      TabIndex        =   15
      Top             =   2520
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "E"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   5
      Left            =   5400
      Style           =   1  'Graphical
      TabIndex        =   14
      Top             =   2040
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "You"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   4
      Left            =   4920
      Style           =   1  'Graphical
      TabIndex        =   13
      Top             =   2040
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "W"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   3
      Left            =   4440
      Style           =   1  'Graphical
      TabIndex        =   12
      Top             =   2040
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "NE"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   2
      Left            =   5400
      Style           =   1  'Graphical
      TabIndex        =   11
      Top             =   1560
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "N"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   1
      Left            =   4920
      Style           =   1  'Graphical
      TabIndex        =   10
      Top             =   1560
      Width           =   495
   End
   Begin VB.CheckBox chSprPos 
      BackColor       =   &H00000000&
      Caption         =   "NW"
      ForeColor       =   &H000000FF&
      Height          =   495
      Index           =   0
      Left            =   4440
      Style           =   1  'Graphical
      TabIndex        =   9
      Top             =   1560
      Width           =   495
   End
   Begin VB.CheckBox chEatLog 
      BackColor       =   &H00000000&
      Caption         =   "Log when food runs out."
      ForeColor       =   &H000000FF&
      Height          =   600
      Left            =   4440
      TabIndex        =   7
      Top             =   480
      Width           =   1455
   End
   Begin VB.Timer tmrEat 
      Left            =   5640
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
      TabIndex        =   6
      Top             =   120
      Width           =   1200
   End
   Begin VB.CheckBox chAttack 
      BackColor       =   &H00000000&
      Caption         =   "Attack Reaction"
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   600
      Width           =   1215
   End
   Begin VB.CheckBox chFish 
      BackColor       =   &H00000000&
      Caption         =   "Fisher"
      Enabled         =   0   'False
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CheckBox chHeal 
      BackColor       =   &H00000000&
      Caption         =   "Healer"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   1800
      Width           =   1215
   End
   Begin VB.CheckBox chSpell 
      BackColor       =   &H00000000&
      Caption         =   "Spell Caster"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   2760
      Width           =   1200
   End
   Begin VB.CheckBox chEat 
      BackColor       =   &H00000000&
      Caption         =   "Eater"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   4560
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.CheckBox chWalk 
      BackColor       =   &H00000000&
      Caption         =   "Auto Walker"
      Enabled         =   0   'False
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   3240
      Width           =   1200
   End
   Begin MSWinsockLib.Winsock sckL2 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckC 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckL1 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckS 
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.CheckBox chSpear 
      BackColor       =   &H00000000&
      Caption         =   "Spear Pickup"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   4440
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   1200
      Width           =   1455
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "PBot 4.0"
      BeginProperty Font 
         Name            =   "Vivaldi"
         Size            =   26.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   615
      Left            =   1440
      TabIndex        =   19
      Top             =   120
      Width           =   2895
   End
   Begin VB.Shape shpClock 
      BorderColor     =   &H000000FF&
      BorderWidth     =   3
      Height          =   2910
      Left            =   1440
      Shape           =   3  'Circle
      Top             =   720
      Width           =   2895
   End
   Begin VB.Line lnClock 
      BorderColor     =   &H000000FF&
      BorderWidth     =   3
      X1              =   192
      X2              =   192
      Y1              =   144
      Y2              =   56
   End
   Begin VB.Menu mnuBot 
      Caption         =   "&Bot"
      Begin VB.Menu mnuRune 
         Caption         =   "&Rune Maker"
      End
      Begin VB.Menu mnuAttack 
         Caption         =   "A&ttack Reaction"
      End
      Begin VB.Menu mnuAppear 
         Caption         =   "A&ppear. Reaction"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuHeal 
         Caption         =   "&Healer"
      End
      Begin VB.Menu mnuFish 
         Caption         =   "&Fisher"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuSpell 
         Caption         =   "&Spell Caster"
      End
      Begin VB.Menu mnuWalk 
         Caption         =   "&Walker"
         Enabled         =   0   'False
      End
      Begin VB.Menu Dash1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuActive 
         Caption         =   "&Active"
      End
      Begin VB.Menu Dash2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Exit"
      End
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

Private Sub chHeal_Click()
    Valid
End Sub

Private Sub chRune_Click()
    Valid
End Sub

Private Sub chSpear_Click()
    Valid
End Sub

Private Sub chSpell_Click()
    Valid
End Sub

Private Sub Command1_Click()
    frmStats.Show
End Sub

Private Sub Form_Load()
    Dim lngDeskTopHandle As Long
    Dim lngHand As Long
    Dim strName As String * 9
    Dim lngWindowCount As Long
    Dim lngTibia(20) As Long
    Dim C1 As Integer
    Dim Finished As Boolean
    If Dir("PBot.dat", vbNormal) = "" Then
        MsgBox "Where is your Tibia Client located?", vbOKOnly + vbQuestion, "PBot.dat not found"
        frmClient.Show
        Do Until frmClient.Visible = False
            DoEvents
        Loop
        Open "PBot.dat" For Output As #1
        Write #1, frmClient.dirList.List(frmClient.dirList.ListIndex), frmClient.txtFileName.Text
        Write #1, 65280, 0
        Close #1
    End If
    Do
        Open "PBot.dat" For Input As #1
        Input #1, FDir, FName
        Input #1, FColor, BColor
        Close #1
        If Dir(FDir & "/" & FName, vbNormal) = "" Then
            MsgBox "Where is your Tibia Client located?", vbOKOnly + vbQuestion, FName & " not found"
            frmClient.Show
            Do Until frmClient.Visible = False
                DoEvents
            Loop
            Open "PBot.dat" For Output As #1
            Write #1, frmClient.dirList.List(frmClient.dirList.ListIndex), frmClient.txtFileName.Text
            Write #1, 65280, 0
            Close #1
        Else
            Finished = True
        End If
    Loop Until Finished
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
    ShellExecute 0, "open", FName, 0, FDir, 3
    Pause 2000
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Finished = False
    Do While Finished = False
        If lngHand = 0 Then
            Pause 500
            lngDeskTopHandle = GetDesktopWindow()
            lngHand = GetWindow(lngDeskTopHandle, 5)
        End If
        GetWindowText lngHand, strName, Len(strName)
        If strName = "Tibia   " & vbNullChar Then
            Finished = True
            For C1 = 0 To 20
                If lngHand = lngTibia(C1) Then
                    Finished = False
                    Exit For
                End If
            Next
            If Finished = True Then Thwnd = lngHand
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    sckL1.Listen
    sckL2.Listen
    StrToMem Thwnd, adrIP, "localhost"
    StrToMem Thwnd, adrIP + &H70, "localhost"
    StrToMem Thwnd, adrIP + &HE0, "localhost"
    StrToMem Thwnd, adrIP + &H150, "localhost"
    Memory Thwnd, adrPort, sckL1.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &H70, sckL1.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &HE0, sckL1.LocalPort, 2, WMem
    Memory Thwnd, adrPort + &H150, sckL1.LocalPort, 2, WMem
End Sub

Private Sub Form_Unload(Cancel As Integer)
    EndAll
End Sub

Private Sub mnuActive_Click()
    If mnuActive.Checked = False Then
        mnuActive.Checked = True
    Else
        mnuActive.Checked = False
    End If
    Valid
End Sub

Private Sub mnuAttack_Click()
    frmAttack.Show
End Sub

Private Sub mnuHeal_Click()
    frmHeal.Show
End Sub

Private Sub mnuRune_Click()
    frmRune.Show
End Sub

Private Sub mnuSpell_Click()
    frmSpell.Show
End Sub

Private Sub sckC_Close()
    sckC.Close
    sckS.Close
End Sub

Private Sub sckC_DataArrival(ByVal bytesTotal As Long)
    Dim Buff() As Byte
    sckC.GetData Buff
    If Buff(2) = &HA Then CharLog Buff
    Do While sckS.State <> sckConnected And sckS.State <> sckClosed
        DoEvents
    Loop
    If sckS.State = sckConnected Then sckS.SendData Buff
End Sub

Private Sub sckL1_ConnectionRequest(ByVal requestID As Long)
    sckC.Close
    sckC.Accept requestID
    sckS.Close
    sckS.Connect "server.tibia.com", 7171
End Sub

Private Sub sckL2_ConnectionRequest(ByVal requestID As Long)
    sckC.Close
    sckC.Accept requestID
End Sub

Private Sub sckS_Close()
    sckS.Close
    sckC.Close
End Sub

Private Sub sckS_DataArrival(ByVal bytesTotal As Long)
    Dim Buff() As Byte
    sckS.GetData Buff
    If Buff(2) = &H14 Then Buff = LogList(Buff, sckL2.LocalPort)
    'If Buff(2) = &HA0 Then GetStats Buff
    Do While sckC.State <> sckConnected And sckC.State <> sckClosed
        DoEvents
    Loop
    If sckC.State = sckConnected Then sckC.SendData Buff
End Sub

Private Sub tmrEat_Timer()
    Dim Ate As Boolean
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
        Ate = True
    End If
    If Ate = False And chEatLog.Value = Checked Then
        sckS.Close
        sckC.Close
    End If
End Sub

Private Sub tmrSpear_Timer()
    Dim MyX As Long
    Dim MyY As Long
    Dim MyZ As Long
    Memory Thwnd, adrXPos, MyX, 2, RMem
    Memory Thwnd, adrYPos, MyY, 2, RMem
    Memory Thwnd, adrZPos, MyZ, 2, RMem
    If chSprPos(0).Value = Checked Then GrabItem &H955, MyX - 1, MyY - 1, MyZ, &H6, &H0, 10
    If chSprPos(1).Value = Checked Then GrabItem &H955, MyX, MyY - 1, MyZ, &H6, &H0, 10
    If chSprPos(2).Value = Checked Then GrabItem &H955, MyX + 1, MyY - 1, MyZ, &H6, &H0, 10
    If chSprPos(3).Value = Checked Then GrabItem &H955, MyX - 1, MyY, MyZ, &H6, &H0, 10
    If chSprPos(4).Value = Checked Then GrabItem &H955, MyX, MyY, MyZ, &H6, &H0, 10
    If chSprPos(5).Value = Checked Then GrabItem &H955, MyX + 1, MyY, MyZ, &H6, &H0, 10
    If chSprPos(6).Value = Checked Then GrabItem &H955, MyX - 1, MyY + 1, MyZ, &H6, &H0, 10
    If chSprPos(7).Value = Checked Then GrabItem &H955, MyX, MyY + 1, MyZ, &H6, &H0, 10
    If chSprPos(8).Value = Checked Then GrabItem &H955, MyX + 1, MyY + 1, MyZ, &H6, &H0, 10
        
End Sub
