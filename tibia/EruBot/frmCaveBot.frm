VERSION 5.00
Begin VB.Form frmCaveBot 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Cave Bot"
   ClientHeight    =   5100
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4650
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5100
   ScaleWidth      =   4650
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdSmoothPath 
      Caption         =   "Smooth Way Path"
      Height          =   375
      Left            =   120
      TabIndex        =   22
      Top             =   1800
      Width           =   1695
   End
   Begin VB.CheckBox chkIgnoreFriends 
      Caption         =   "Ignore creatures named in friend list."
      Height          =   255
      Left            =   120
      TabIndex        =   21
      Top             =   4800
      Width           =   2895
   End
   Begin VB.HScrollBar hscrStopDistance 
      Height          =   255
      Left            =   120
      Max             =   8
      Min             =   1
      TabIndex        =   19
      Top             =   4560
      Value           =   1
      Width           =   2895
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "Remove"
      Height          =   375
      Left            =   3720
      TabIndex        =   18
      Top             =   3840
      Width           =   855
   End
   Begin VB.CommandButton cmdInsert 
      Caption         =   "Insert"
      Height          =   375
      Left            =   2760
      TabIndex        =   17
      Top             =   3840
      Width           =   855
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   375
      Left            =   1920
      TabIndex        =   16
      Top             =   3840
      Width           =   735
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3360
      TabIndex        =   15
      Top             =   4440
      Width           =   855
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "C"
      Height          =   495
      Index           =   8
      Left            =   720
      TabIndex        =   14
      Top             =   3240
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "NW"
      Height          =   495
      Index           =   7
      Left            =   120
      TabIndex        =   13
      Top             =   2640
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "W"
      Height          =   495
      Index           =   6
      Left            =   120
      TabIndex        =   12
      Top             =   3240
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "SW"
      Height          =   495
      Index           =   5
      Left            =   120
      TabIndex        =   11
      Top             =   3840
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "S"
      Height          =   495
      Index           =   4
      Left            =   720
      TabIndex        =   10
      Top             =   3840
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "SE"
      Height          =   495
      Index           =   3
      Left            =   1320
      TabIndex        =   9
      Top             =   3840
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "E"
      Height          =   495
      Index           =   2
      Left            =   1320
      TabIndex        =   8
      Top             =   3240
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "NE"
      Height          =   495
      Index           =   1
      Left            =   1320
      TabIndex        =   7
      Top             =   2640
      Width           =   495
   End
   Begin VB.CommandButton cmdFunctionDirection 
      Caption         =   "N"
      Height          =   495
      Index           =   0
      Left            =   720
      TabIndex        =   6
      Top             =   2640
      Width           =   495
   End
   Begin VB.ComboBox comboFunction 
      Height          =   315
      ItemData        =   "frmCaveBot.frx":0000
      Left            =   120
      List            =   "frmCaveBot.frx":000D
      TabIndex        =   5
      Top             =   2280
      Width           =   1695
   End
   Begin VB.CommandButton cmdSaveWayPath 
      Caption         =   "Save"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   720
      Width           =   1695
   End
   Begin VB.CommandButton cmdLoadWayPath 
      Caption         =   "Load"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   240
      Width           =   1695
   End
   Begin VB.ListBox listWayPath 
      Height          =   3375
      Left            =   1920
      TabIndex        =   1
      Top             =   360
      Width           =   2655
   End
   Begin VB.Timer tmrTrace 
      Enabled         =   0   'False
      Interval        =   2
      Left            =   2760
      Top             =   6480
   End
   Begin VB.Timer tmrCaveBot 
      Enabled         =   0   'False
      Interval        =   10
      Left            =   1320
      Top             =   6600
   End
   Begin VB.CheckBox chkTrace 
      Caption         =   "Append Trace"
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label lblStopDistance 
      Caption         =   "Label2"
      Height          =   255
      Left            =   120
      TabIndex        =   20
      Top             =   4320
      Width           =   2535
   End
   Begin VB.Line Line1 
      X1              =   120
      X2              =   1800
      Y1              =   1200
      Y2              =   1200
   End
   Begin VB.Label Label1 
      Caption         =   "Waypoint list"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   1920
      TabIndex        =   2
      Top             =   120
      Width           =   2175
   End
End
Attribute VB_Name = "frmCaveBot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Option Explicit
'
'Private Sub chkTrace_Click()
'    If chkTrace Then
'        tmrTrace.Enabled = True
'    Else
'        tmrTrace.Enabled = False
'    End If
'End Sub
'
'Private Sub LoadWayPath(fileLoc As String)
'    Dim FN As Integer, i As Integer, temp As String
'    FN = FreeFile
'    On Error GoTo Cancel
'    Open fileLoc For Input As #FN
'    getNext FN
'    getNext FN
'    listWayPath.Clear
'    temp = getNext(FN)
'    While temp <> "<End List>"
'        listWayPath.AddItem temp
'        temp = getNext(FN)
'    Wend
'    LogMsg "Way Path file loaded from " & vbCrLf & fileLoc
'Cancel:
'    Close FN
'End Sub
'
'Private Sub SaveWayPath(fileLoc As String)
'    Dim FN As Integer, i As Integer
'    FN = FreeFile
'    On Error GoTo Cancel
'    Open fileLoc For Output As #FN
'    Write #FN, "***ERUBOT WAY PATH FILE***"
'    Write #FN, App.Major & "." & App.Minor & "." & App.Revision
'    If listWayPath.ListCount <= 0 Then GoTo Cancel
'    For i = 0 To listWayPath.ListCount - 1
'        Write #FN, listWayPath.List(i)
'    Next i
'    Write #FN, "<End List>"
'    LogMsg "Way Path file saved to " & vbCrLf & fileLoc
'Cancel:
'    Close FN
'End Sub
'
'Private Sub cmdClear_Click()
'    If MsgBox("Are you sure you wish to clear the way path?", vbYesNo, "Confirm Clear") = vbYes Then listWayPath.Clear
'End Sub
'
'Private Sub cmdClose_Click()
'    Me.Hide
'End Sub
'
'Private Sub cmdFunctionDirection_Click(index As Integer)
'    Dim dX As Long, dY As Long
'    Dim pX As Long, pY As Long, pZ As Long
'    Select Case index
'        Case 0: dX = 0: dY = -1
'        Case 1: dX = 1: dY = -1
'        Case 2: dX = 1: dY = 0
'        Case 3: dX = 1: dY = 1
'        Case 4: dX = 0: dY = 1
'        Case 5: dX = -1: dY = 1
'        Case 6: dX = -1: dY = 0
'        Case 7: dX = -1: dY = -1
'        Case 8: dX = 0: dY = 0
'        Case Else:
'            MsgBox "there is no function direction button of that index!!111 wtf"
'            Exit Sub
'    End Select
'    getCharXYZ pX, pY, pZ, UserPos
'    listWayPath.AddItem comboFunction.List(comboFunction.ListIndex) & "," & pX + dX & "," & pY + dY & "," & pZ
'End Sub
'
'Private Sub cmdInsert_Click()
'    Dim temp As String
'    temp = InputBox("Enter custom waypoint", "Insert", "Walk,")
'    If temp <> "" Then listWayPath.AddItem temp, listWayPath.ListIndex
'End Sub
'
'Private Sub cmdLoadWayPath_Click()
'    On Error GoTo Cancel
'    With frmMain.cdlgSettings
'        .FileName = "*.ewp"
'        .Filter = "EruBot Way Path, *.ewp"
'        .DialogTitle = "Load Way Path"
'        .InitDir = App.Path
'        .DefaultExt = "ewp"
'        .ShowOpen
'    End With
'    LoadWayPath frmMain.cdlgSettings.FileName
'    Exit Sub
'Cancel:
'End Sub
'
'Private Sub cmdRemove_Click()
'    Dim index As Integer
'    index = listWayPath.ListIndex
'    listWayPath.RemoveItem index
'    If index >= listWayPath.ListCount Then index = listWayPath.ListCount - 1
'    listWayPath.ListIndex = index
'End Sub
'
'Private Sub cmdSaveWayPath_Click()
'    On Error GoTo Cancel
'    With frmMain.cdlgSettings
'        .FileName = "*.ewp"
'        .Filter = "EruBot Way Path, *.ewp"
'        .DialogTitle = "Save Way Path"
'        .InitDir = App.Path
'        .DefaultExt = "ewp"
'        .ShowSave
'    End With
'    SaveWayPath frmMain.cdlgSettings.FileName
'    Exit Sub
'Cancel:
'End Sub
'
'Private Sub cmdSmoothPath_Click()
'    Dim i As Integer, str() As String
'    Dim nX As Long, nY As Long, nZ As Long
'    Dim cX As Long, cY As Long, cZ As Long
'    If listWayPath.ListCount <= 1 Then Exit Sub
'    While i < listWayPath.ListCount - 1
'        str = Split(listWayPath.List(i), ",")
'        If str(0) <> "Walk" Then GoTo Continue
'        cX = CLng(str(1)): cY = CLng(str(2)): cZ = CLng(str(3))
'        str = Split(listWayPath.List(i + 1), ",")
'        If str(0) <> "Walk" Then GoTo Continue
'        nX = CLng(str(1)): nY = CLng(str(2)): nZ = CLng(str(3))
'        If cZ <> nZ Then
'            MsgBox "Impossible level transition found", vbCritical, "Way Path Error"
'            listWayPath.ListIndex = i
'            Exit Sub
'        End If
'        If GetStepValue(nX - cX, nY - cY) < 0 Then
'            If Abs(nX - cX) <= 2 And Abs(nY - cY) <= 2 Then
'                listWayPath.AddItem "Walk," & Fix((nX + cX) / 2) & "," & Fix((nY + cY) / 2) & "," & Fix((nZ + cZ) / 2), i + 1
'                i = i - 1
'            Else
'                MsgBox "Distance between points too great", vbCritical, "Way Path Error"
'                listWayPath.ListIndex = i
'                Exit Sub
'            End If
'        End If
'Continue:
'        i = i + 1
'    Wend
'End Sub
'
'Private Sub Form_Load()
'    comboFunction.ListIndex = 0
'    hscrStopDistance_Change
'End Sub
'
'Public Sub hscrStopDistance_Change()
'    If hscrStopDistance = 1 Then
'        lblStopDistance = "Stop if adjacent creatures."
'    ElseIf hscrStopDistance > 1 And hscrStopDistance < 8 Then
'        lblStopDistance = "Stop if creatures within " & hscrStopDistance & " squares."
'    Else
'        lblStopDistance = "Stop as soon as creature detected."
'    End If
'End Sub
'
'Private Sub tmrCaveBot_Timer()
'    Static nextMoveTime As Long, errorTime As Long, curPoint As Integer
'    Static tX As Long, tY As Long, tZ As Long
'    Dim i As Integer, stopPlx As Boolean
'    Dim pX As Long, pY As Long, pZ As Long
'    Dim cX As Long, cY As Long, cZ As Long
'    Dim bp As Integer, slot As Integer
'    Dim tempStr() As String, temp As String
'    If listWayPath.ListCount <= 0 Then Exit Sub
'    getCharXYZ pX, pY, pZ, UserPos
'    If GetTickCount < nextMoveTime Then Exit Sub
'    For i = 0 To LEN_CHAR
'        stopPlx = False
'        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 And i <> UserPos Then
'            If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = &H40 Then
'                getCharXYZ cX, cY, cZ, i
'                If cZ <> pZ Then GoTo Continue
'                'stopPlx = False
'                If hscrStopDistance = 8 Then
'                    stopPlx = True
'                Else
'                    If Abs(pX - cX) <= hscrStopDistance And Abs(pY - cY) <= hscrStopDistance Then stopPlx = True
'                End If
'                If stopPlx Then
'                    temp = ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
'                    If frmAimbot.listFriends.Contains(temp) >= 0 Then stopPlx = False
'                    'If stopPlx Then If frmIntruder.listSafe.Contains(temp) >= 0 Then stopPlx = False
'                End If
'            Else
'                If frmIntruder.listSafe.Contains(ReadMemStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)) < 0 Then stopPlx = True
'            End If
'            If stopPlx Then Exit For
'        End If
'Continue:
'    Next i
'    If stopPlx Then
'        nextMoveTime = GetTickCount + 3000
'        errorTime = GetTickCount + 8000
'        Exit Sub
'    End If
'    If GetTickCount >= nextMoveTime Then
'        If curPoint >= listWayPath.ListCount Then curPoint = 0
'        If pX = tX And pY = tY And pZ = tZ Or GetTickCount >= errorTime Then
'            If GetTickCount < errorTime Then
'                curPoint = curPoint + 1
'                If curPoint >= listWayPath.ListCount Then curPoint = 0
'            Else
'                'MsgBox "error time"
'                If GetStepValue(tX - pX, tY - pY) < 0 Then
'                    For i = 0 To listWayPath.ListCount - 1
'                        tempStr = Split(listWayPath.List(i), ",")
'                        If tempStr(0) = "Walk" Then
'                            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'                            If GetStepValue(tX - pX, tY - pY) >= 0 And tZ = pZ Then
'                                curPoint = i
'                                Exit For
'                            End If
'                        End If
'                    Next i
'                End If
'            End If
'            tempStr = Split(listWayPath.List(curPoint), ",")
'            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'            Select Case tempStr(0)
'                Case "Walk":
'                    Step GetStepValue(tX - pX, tY - pY)
'                Case "Force Walk":
'                    Step GetStepValue(tX - pX, tY - pY)
'                    i = curPoint + 1
'                    If i >= listWayPath.ListCount Then i = 0
'                    tempStr = Split(listWayPath.List(i), ",")
'                    tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'                Case "Ladder":
'                    UseGround TILE_LADDER, tX, tY, tZ
'                    i = curPoint + 1
'                    If i >= listWayPath.ListCount Then i = 0
'                    tempStr = Split(listWayPath.List(i), ",")
'                    tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'                Case "Rope":
'                    If findItem(ITEM_ROPE, bp, slot, True, False) Then
'                        UseAt ITEM_ROPE, bp, slot, tX, tY, tZ
'                        i = curPoint + 1
'                        If i >= listWayPath.ListCount Then i = 0
'                        tempStr = Split(listWayPath.List(i), ",")
'                        tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
'                    Else
'                        GoTo Error
'                    End If
'                Case Else:
'                    LogMsg "Cave Bot: Not yet implemented."
'                    GoTo Error
'            End Select
'            nextMoveTime = GetTickCount + 20
'            errorTime = GetTickCount + 10000
'        End If
'    End If
'    listWayPath.ListIndex = curPoint
'    Exit Sub
'Error:
'    frmMain.chkCaveBot.Value = Unchecked
'    frmMain.chkAlert.Value = Checked
'    LogMsg "There was an error in the cavebot. A required item might be missing."
'    Valid
'End Sub
'
'Private Sub tmrTrace_Timer()
'    Static lastX As Long, lastY As Long, lastZ As Long
'    Dim curX As Long, curY As Long, curZ As Long
'    If lastX = 0 Or lastY = 0 Or lastZ = 0 Then getCharXYZ lastX, lastY, lastZ, UserPos
'    getCharXYZ curX, curY, curZ, UserPos
'    If curX <> lastX Or curY <> lastY Or curZ <> lastZ Then
'        listWayPath.AddItem "Walk," & curX & "," & curY & "," & curZ
'        listWayPath.ListIndex = listWayPath.ListCount - 1
'        lastX = curX: lastY = curY: lastZ = curZ
'    End If
'End Sub
'
