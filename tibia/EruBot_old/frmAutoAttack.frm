VERSION 5.00
Begin VB.Form frmAutoAttack 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Auto Attacker"
   ClientHeight    =   1440
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2280
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1440
   ScaleWidth      =   2280
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtTarget 
      Height          =   285
      Left            =   120
      TabIndex        =   2
      Top             =   1080
      Width           =   2055
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   120
      Width           =   855
   End
   Begin VB.Timer tmrAutoAttack 
      Enabled         =   0   'False
      Interval        =   333
      Left            =   2040
      Top             =   960
   End
   Begin VB.CommandButton cmdLockMaster 
      Caption         =   "Lock Master"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Priority target, leave empty to hit monsters that come close."
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   600
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

Private Sub tmrAutoAttack_Timer()
    Dim id As Long
    Dim pX As Long, pY As Long, pZ As Long
    Dim cX As Long, cY As Long, cZ As Long
    Dim i As Integer
    If ReadMem(ADR_TARGET_ID, 4) = 0 Then
        'search for new target
        If txtTarget <> "" Then
            For i = 0 To LEN_CHAR
                If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
                    If MemToStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32) = txtTarget Then
                        PutAttack ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
                        Exit Sub
                    End If
                End If
            Next i
        Else
            For i = 0 To LEN_CHAR
                If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
                    id = ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4)
                    If id <> masterID Then
                        If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR + 3, 1) = &H40 Then
                            getCharXYZ pX, pY, pZ, UserPos
                            cX = ReadMem(ADR_CHAR_X + i * SIZE_CHAR, 4)
                            cY = ReadMem(ADR_CHAR_Y + i * SIZE_CHAR, 4)
                            cZ = ReadMem(ADR_CHAR_Z + i * SIZE_CHAR, 4)
                            If Abs(pX - cX) <= 1 And Abs(pY - cY) <= 1 And pZ = cZ Then
                                PutAttack id
                                Exit Sub
                            End If
                        End If
                    End If
                End If
            Next i
        End If
    End If
End Sub
