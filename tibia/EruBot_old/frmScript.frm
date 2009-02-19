VERSION 5.00
Begin VB.Form frmScript 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Script"
   ClientHeight    =   4845
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3390
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4845
   ScaleWidth      =   3390
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdTest 
      Caption         =   "Test Script"
      Height          =   495
      Left            =   1200
      TabIndex        =   3
      Top             =   4320
      Width           =   975
   End
   Begin VB.CommandButton cmdDone 
      Caption         =   "Close"
      Height          =   495
      Left            =   2280
      TabIndex        =   2
      Top             =   4320
      Width           =   975
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Prepare Script"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   4320
      Width           =   975
   End
   Begin VB.Timer tmrScript 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   2040
      Top             =   3120
   End
   Begin VB.TextBox txtScript 
      Height          =   4215
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   0
      Width           =   3375
   End
End
Attribute VB_Name = "frmScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim curLine As Integer
Dim statements() As String
Dim waitTime As Long
Dim scriptLoaded As Boolean

Private Sub cmdDone_Click()
    Me.Hide
End Sub

Public Sub cmdSave_Click()
    On Error GoTo fucked
    statements = Split(txtScript.Text, ";")
    scriptLoaded = True
    AddStatusMessage "Script loaded."
    Exit Sub
fucked:
    MsgBox "Invalid script! Seperate commands by semicolon.", vbCritical
End Sub

Private Sub cmdTest_Click()
    StartScript
End Sub

Private Sub tmrScript_Timer()
    Dim line() As String
    If curLine > UBound(statements) Then
        AddStatusMessage "Completed Script."
        tmrScript.Enabled = False
        Exit Sub
    End If
    If waitTime <> 0 Then
        If GetTickCount() < waitTime Then Exit Sub
        waitTime = 0
    End If
    On Error GoTo noScript
    line = Split(statements(curLine), ",")
    Select Case line(0)
        Case "say": SayStuff line(1): AddStatusMessage "Scripted message."
        Case "wait": waitTime = GetTickCount() + CLng(line(1)): AddStatusMessage "Scripted wait, " & line(1) & "ms."
        Case "pm": SendPM line(1), line(2): AddStatusMessage "Scripted PM sent."
        Case "log": frmMain.StartLogOut: AddStatusMessage "Scripted Log ASAP."
        Case "walk": Step Int(line(1)): AddStatusMessage "Scripted walk in direction " & line(1) & "."
    End Select
    curLine = curLine + 1
    Exit Sub
noScript:
    MsgBox "Script line empty or invalid."
    curLine = curLine + 1
End Sub

Public Sub StartScript()
    If scriptLoaded Then
        curLine = 0
        tmrScript.Enabled = True
        waitTime = 0
    Else
        MsgBox "No script loaded.", vbCritical
    End If
End Sub
