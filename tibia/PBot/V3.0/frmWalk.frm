VERSION 5.00
Begin VB.Form frmWalk 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Auto Walker"
   ClientHeight    =   3495
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3585
   ControlBox      =   0   'False
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   233
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   239
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer 
      Left            =   3120
      Top             =   0
   End
   Begin VB.CheckBox chAC 
      BackColor       =   &H00000000&
      Caption         =   "Attack Creatures"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   615
      Left            =   2520
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   1320
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Ok"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   3
      Top             =   2880
      Width           =   975
   End
   Begin VB.CommandButton btnAdd 
      Caption         =   "Add"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   2
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton btnRemove 
      Caption         =   "Remove"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   1
      Top             =   720
      Width           =   975
   End
   Begin VB.ListBox lstX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3210
      ItemData        =   "frmWalk.frx":0000
      Left            =   120
      List            =   "frmWalk.frx":0002
      TabIndex        =   0
      Top             =   120
      Width           =   2295
   End
End
Attribute VB_Name = "frmWalk"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private RCoord(2, 25) As Long
Private RUsed(25) As Boolean
Private RAt(2) As Long
Private RGo(2) As Long

Private Sub btnAdd_Click()
    Dim C1 As Integer
    For C1 = 0 To 25
        If RUsed(C1) = False Then
            RUsed(C1) = True
            Memory Thwnd, adrXPos, RCoord(0, C1), 2, 1
            Memory Thwnd, adrYPos, RCoord(1, C1), 2, 1
            Memory Thwnd, adrZPos, RCoord(2, C1), 2, 1
            lstX.AddItem RCoord(0, C1) & ", " & RCoord(1, C1) & ", " & RCoord(2, C1), C1
            Exit For
        End If
    Next
End Sub

Private Sub btnRemove_Click()
    If lstX.ListIndex >= 0 Then
        RUsed(lstX.ListIndex) = False
        lstX.RemoveItem (lstX.ListIndex)
    End If
End Sub

Private Sub Command1_Click()
    Me.Hide
End Sub

Private Sub Form_Load()

End Sub

Private Sub Timer_Timer()
    Dim X1 As Long
    Dim Y1 As Long
    Dim Z1 As Long
    Dim X2 As Long
    Dim Y2 As Long
    Dim Z2 As Long
    Dim KillN(3) As Byte
    Dim C1 As Long
    
    Memory Thwnd, adrXPos, RAt(0), 2, RMem
    Memory Thwnd, adrYPos, RAt(1), 2, RMem
    Memory Thwnd, adrZPos, RAt(2), 2, RMem
    Memory Thwnd, adrXGo, RGo(0), 2, RMem
    Memory Thwnd, adrYGo, RGo(1), 2, RMem
    Memory Thwnd, adrGo + (UserPos * CharDist), RGo(2), 2, RMem
    If RGo(2) = 0 Then
        TempNum = Rnd()
        Temp = Fix(26 * TempNum)
        Do
            TempNum = Rnd()
            Temp = Fix(26 * TempNum)
        Loop While RUsed(Temp) = False
        If RUsed(Temp) = True Then
            Memory Thwnd, adrXGo, RCoord(0, Temp), 2, WMem
            Memory Thwnd, adrYGo, RCoord(1, Temp), 2, WMem
            Memory Thwnd, adrGo + (UserPos * CharDist), 1, 2, WMem
            Pause 500
        End If
    End If
    If chAC.Value = Checked Then
        Y2 = 0
        X1 = 0
        Y1 = 0
        Z1 = 0
        X2 = 0
        For C1 = 0 To 150
            Memory Thwnd, adrBChar + (C1 * CharDist), Y2, 1, RMem
            Memory Thwnd, adrNChar + (C1 * CharDist), X1, 1, RMem
            Memory Thwnd, adrNChar + (C1 * CharDist) + 1, Y1, 1, RMem
            Memory Thwnd, adrNChar + (C1 * CharDist) + 2, Z1, 1, RMem
            Memory Thwnd, adrNChar + (C1 * CharDist) + 3, X2, 1, RMem
            If Y2 > 0 And X2 = &H40 And ((Y1 = 0 Or Y1 = 1) And Z1 = 0) = False Then
                Memory Thwnd, adrNChar + (C1 * CharDist), X1, 1, RMem
                Memory Thwnd, adrNChar + (C1 * CharDist) + 1, Y1, 1, RMem
                Memory Thwnd, adrNChar + (C1 * CharDist) + 2, Z1, 1, RMem
                Memory Thwnd, adrNChar + (C1 * CharDist) + 3, X2, 1, RMem
                Memory Thwnd, adrZPos, Y2, 1, RMem
                Memory Thwnd, adrZChar + (C1 * CharDist), Z2, 1, RMem
                KillN(0) = X1
                KillN(1) = Y1
                KillN(2) = Z1
                KillN(3) = X2
                If Y2 = Z2 Then
                    KillEm KillN, C1
                End If
            End If
        Next
    End If
End Sub

Private Function KillEm(bytes() As Byte, Num As Long)
    Dim buff(6) As Byte
    Dim buff2(5) As Byte
    Dim X1 As Long
    Dim Time As Long
    Memory Thwnd, adrXGo, 0, 2, WMem
    Memory Thwnd, adrGo + (UserPos * CharDist), 0, 2, WMem
    buff2(0) = &H4
    buff2(1) = &H0
    buff2(2) = &HA0
    buff2(3) = &H1
    buff2(4) = &H1
    buff2(5) = &H1
        
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff2
    Time = GetTickCount + 30000
    Do
        buff(0) = &H5
        buff(1) = &H0
        buff(2) = &HA1
        buff(3) = bytes(0)
        buff(4) = bytes(1)
        buff(5) = bytes(2)
        buff(6) = bytes(3)
        
        If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
        Pause 1000
        Memory Thwnd, adrBChar + (Num * CharDist), X1, 1, RMem
    Loop Until X1 = 0 Or Time <= GetTickCount
End Function
