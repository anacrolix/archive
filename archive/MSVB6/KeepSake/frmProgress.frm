VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmProgress 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Insert Current Operation"
   ClientHeight    =   1215
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3735
   ControlBox      =   0   'False
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   1215
   ScaleWidth      =   3735
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer timUpdate 
      Interval        =   100
      Left            =   600
      Top             =   1920
   End
   Begin MSComctlLib.ProgressBar pbarProgress 
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   873
      _Version        =   393216
      Appearance      =   1
      Scrolling       =   1
   End
   Begin VB.Label lblOperation 
      Caption         =   "Label1"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   3495
   End
   Begin VB.Label lblComplete 
      Caption         =   "Label1"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   3495
   End
End
Attribute VB_Name = "frmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function GetTickCount Lib "kernel32" () As Long

Private StartTime As Long 'system starting time
Private Duration As Long 'duration as referenced from registry
Private ParentForm As Form 'parent form
Private ProcessTitle As String 'title of process
Private NumDots As Integer 'num of dots on form title

Public Sub StartProcess(pParentForm As Form, pProcessTitle As String, pOperation As String)
    Me.Show 'show the form
    Set ParentForm = pParentForm 'set the parent form
    ParentForm.Enabled = False 'disable the parent form
    ProcessTitle = pProcessTitle 'set internal processtitle for use in pending animation
    
    Call SetTitle(ProcessTitle) 'update title
    Call SetOperation(pOperation) 'update with first operation
    StartTime = GetTickCount 'set start time
    If GetSetting(App.Title, "ProcessTimes", ProcessTitle, "") = "" Then
        Duration = 0
    Else
        Duration = CLng(GetSetting(App.Title, "ProcessTimes", ProcessTitle))
    End If
    DoEvents
End Sub

Public Sub SetTitle(pData As String)
    Me.Caption = pData
End Sub

Public Sub SetOperation(pData As String)
    lblOperation.Caption = pData
    UpdateProgress
End Sub

Public Sub UpdateProgress()
    Dim CurTime As Long
    Dim nProgress As Integer
    'determine progress level
    CurTime = GetTickCount
    If Not Duration = 0 Then nProgress = CInt(105 * ((CurTime - StartTime) / Duration))
    'limit progress to 100
    If nProgress > 100 Then
        nProgress = 100
    ElseIf nProgress < 0 Then
        MsgBox "Error in progress bar": End
    End If
    'update controls
    pbarProgress.Value = nProgress
    lblComplete.Caption = nProgress & "% Complete"
    'finish up
    DoEvents
End Sub

Public Sub EndProcess()
    Dim FinishTime As Long
    Call UpdateProgress
    FinishTime = GetTickCount
    Duration = FinishTime - StartTime
    Call SaveSetting(App.Title, "ProcessTimes", ProcessTitle, CStr(Duration))
    Me.Hide
    ParentForm.Enabled = True
    ParentForm.SetFocus
    DoEvents
End Sub

Private Sub timUpdate_Timer()
    'increment numdots
    NumDots = NumDots + 1
    If NumDots > 3 Then NumDots = 0
    'create suffix string
    If NumDots > 0 Then
        For Cnt% = 1 To NumDots
            Suffix$ = Suffix$ + "."
        Next Cnt%
    End If
    'update form caption and update progress bar
    Call SetTitle(ProcessTitle & " " & Suffix$)
    Call UpdateProgress
End Sub
