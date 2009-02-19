VERSION 5.00
Begin VB.Form frmAutoAttack 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Auto Attacker"
   ClientHeight    =   2745
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   3600
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2745
   ScaleWidth      =   3600
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkTargetClosest 
      Caption         =   "Target closest monster."
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1920
      Width           =   3375
   End
   Begin VB.CheckBox chkIgnoreFriends 
      Caption         =   "Ignore creatures named in friend list."
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   3375
   End
   Begin VB.HScrollBar hscrAttackDistance 
      Height          =   255
      Left            =   120
      Max             =   8
      Min             =   1
      TabIndex        =   4
      Top             =   1320
      Value           =   8
      Width           =   3375
   End
   Begin VB.TextBox txtTarget 
      Height          =   285
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Width           =   2055
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   2280
      Width           =   855
   End
   Begin VB.Timer tmrAutoAttack 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   3120
      Top             =   4680
   End
   Begin VB.CommandButton cmdLockMaster 
      Caption         =   "Lock Excluded Entity"
      Height          =   495
      Left            =   2280
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Line Line1 
      X1              =   120
      X2              =   3480
      Y1              =   960
      Y2              =   960
   End
   Begin VB.Label Label2 
      Caption         =   "Otherwise:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   720
      Width           =   3375
   End
   Begin VB.Label lblAttackDistance 
      Caption         =   "Attack creatures within x squares."
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1080
      Width           =   3375
   End
   Begin VB.Label Label1 
      Caption         =   "Attack this entity foremost:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   2055
   End
End
Attribute VB_Name = "frmAutoAttack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private masterID As Long

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdLockMaster_Click()
    masterID = ReadMem(ADR_TARGET_ID, 4)
End Sub

Private Sub Form_Load()
    hscrAttackDistance_Change
End Sub

Public Sub hscrAttackDistance_Change()
    If hscrAttackDistance = 1 Then
        lblAttackDistance = "Attack adjacent creatures."
    ElseIf hscrAttackDistance > 1 And hscrAttackDistance < 8 Then
        lblAttackDistance = "Attack creatures within " & hscrAttackDistance & " squares."
    Else
        lblAttackDistance = "Attack creatures as soon as detected."
    End If
End Sub

Private Function IsFriend(pos As Integer) As Boolean
    If chkIgnoreFriends Then
        If frmAimbot.listFriends.Contains(MemToStr(ADR_CHAR_NAME + pos * SIZE_CHAR, 32)) >= 0 Then
            IsFriend = True
        End If
    End If
End Function

Private Sub tmrAutoAttack_Timer()
    Dim curID As Long, id As Long
    Dim pX As Long, pY As Long, pZ As Long
    Dim cX As Long, cY As Long, cZ As Long
    Dim pos As Long, distance As Long
    Dim i As Integer
    
    'priority target
    If txtTarget <> "" Then
        For i = 0 To LEN_CHAR
            If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
                If MemToStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32) = txtTarget Then
                    PutAttack ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
                    Exit For
                End If
            End If
        Next i
        Exit Sub
    End If
    
    curID = ReadMem(ADR_TARGET_ID, 4)
    getCharXYZ pX, pY, pZ, UserPos
    pos = -1
    distance = -1
    
    If curID <> 0 And chkTargetClosest Then 'someone already targetted
        pos = findPosByID(curID)
        If pos < 0 Then Exit Sub
        getCharXYZ cX, cY, cZ, pos
        If Abs(pX - cX) > hscrAttackDistance + 1 Or Abs(pY - cY) > hscrAttackDistance + 1 Then
            PutAttack 0 'if they're too far cancel the attack on them
            Exit Sub
        End If
        distance = Abs(cX - pX) + Abs(cY - pY)
        If distance = 2 Then distance = 1
    End If
    For i = 0 To LEN_CHAR
        If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 And i <> pos And i <> UserPos Then
            id = ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
            If id <> masterID And ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = &H40 Then
                getCharXYZ cX, cY, cZ, i
                If (((Abs(pX - cX) <= hscrAttackDistance And Abs(pY - cY) <= hscrAttackDistance) Or hscrAttackDistance = 8) And pZ = cZ) Then
                    If IsFriend(i) = False Then
                        If chkTargetClosest Then
                            If pos = -1 Then
                                pos = i
                                distance = Abs(pX - cX) + Abs(pY - cY)
                                If distance = 2 Then distance = 1
                            Else
                                If Abs(pX - cX) + Abs(pY - cY) < distance Then
                                    pos = i
                                    distance = Abs(pX - cX) + Abs(pY - cY)
                                    If distance = 2 Then distance = 1
                                End If
                            End If
                        Else
                            pos = i
                            Exit For
                        End If
                    End If
                End If
            End If
        End If
    Next i
    
    If pos >= 0 Then
        id = ReadMem(ADR_CHAR_ID + pos * SIZE_CHAR, 4)
        If id <> curID Then
            PutAttack id
            'AddStatusMessage "putting attack on " & MemToStr(ADR_CHAR_NAME + pos * SIZE_CHAR, 32)
            Exit Sub
        End If
    End If
End Sub
