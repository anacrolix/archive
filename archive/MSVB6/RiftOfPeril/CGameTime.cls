VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CGameTime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mDays As Long
Private mHours As Integer
Private mMinutes As Integer
Private mSeconds As Single

Sub AddSecs(pSeconds As Single)
    Dim XSmins As Integer
    mSeconds = mSeconds + pSeconds
    If mSeconds >= 60 Then
        XSmins = Int(mSeconds / 60)
        mSeconds = mSeconds - 60 * XSmins
        AddMins XSmins
    End If
End Sub

Sub AddMins(pMinutes As Integer)
    Dim XShours As Integer
    mMinutes = mMinutes + pMinutes
    If mMinutes >= 60 Then
        XShours = Int(mMinutes / 60)
        mMinutes = mMinutes - 60 * XShours
        AddHours XShours
    End If
End Sub

Sub AddHours(pHours As Integer)
    Dim XSdays As Long
    mHours = mHours + pHours
    If mHours >= 24 Then
        XSdays = Int(mHours / 24)
        mHours = mHours - 24 * XSdays
        AddDays XSdays
    End If
End Sub

Sub AddDays(pDays As Long)
    mDays = mDays + pDays
End Sub

Function GetTime() As String
    GetTime = mDays & " days " & mHours & ":" & mMinutes & ":" & mSeconds
End Function

Private Sub Class_Initialize()
    mDays = 0
    mHours = 0
    mMinutes = 0
    mSeconds = 0
End Sub
