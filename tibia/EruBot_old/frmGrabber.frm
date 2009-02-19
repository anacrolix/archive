VERSION 5.00
Begin VB.Form frmGrabber 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Ammo Grabber"
   ClientHeight    =   2520
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4065
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2520
   ScaleWidth      =   4065
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkGrabUnderTarget 
      Caption         =   "Grab from under target"
      Height          =   495
      Left            =   2160
      TabIndex        =   16
      Top             =   1440
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin VB.Timer tmrGrabber 
      Enabled         =   0   'False
      Interval        =   1300
      Left            =   2040
      Top             =   3000
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   2640
      TabIndex        =   15
      Top             =   2040
      Width           =   855
   End
   Begin VB.Frame fraAmmoType 
      Caption         =   "Ammo Type"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1335
      Left            =   2160
      TabIndex        =   10
      Top             =   120
      Width           =   1815
      Begin VB.OptionButton optThrowingKnives 
         Caption         =   "Throwing knives"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   960
         Width           =   1575
      End
      Begin VB.OptionButton optSmallStones 
         Caption         =   "Small stones"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   720
         Width           =   1335
      End
      Begin VB.OptionButton optThrowingStars 
         Caption         =   "Throwing stars"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   480
         Width           =   1455
      End
      Begin VB.OptionButton optSpears 
         Caption         =   "Spears"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Value           =   -1  'True
         Width           =   855
      End
   End
   Begin VB.Frame fraDirection 
      Caption         =   "Direction"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2055
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1935
      Begin VB.OptionButton optDir 
         Caption         =   "C"
         Enabled         =   0   'False
         Height          =   495
         Index           =   8
         Left            =   720
         Style           =   1  'Graphical
         TabIndex        =   9
         Top             =   840
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "W"
         Enabled         =   0   'False
         Height          =   495
         Index           =   7
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   8
         Top             =   840
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "SW"
         Enabled         =   0   'False
         Height          =   495
         Index           =   6
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   1440
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "S"
         Enabled         =   0   'False
         Height          =   495
         Index           =   5
         Left            =   720
         Style           =   1  'Graphical
         TabIndex        =   6
         Top             =   1440
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "SE"
         Enabled         =   0   'False
         Height          =   495
         Index           =   4
         Left            =   1320
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   1440
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "E"
         Enabled         =   0   'False
         Height          =   495
         Index           =   3
         Left            =   1320
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   840
         Value           =   -1  'True
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "NE"
         Enabled         =   0   'False
         Height          =   495
         Index           =   2
         Left            =   1320
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   240
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "N"
         Enabled         =   0   'False
         Height          =   495
         Index           =   1
         Left            =   720
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   240
         Width           =   495
      End
      Begin VB.OptionButton optDir 
         Caption         =   "NW"
         Enabled         =   0   'False
         Height          =   495
         Index           =   0
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   1
         Top             =   240
         Width           =   495
      End
   End
End
Attribute VB_Name = "frmGrabber"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub chkGrabUnderTarget_Click()
    UpdDirectionControls
End Sub

Public Sub UpdDirectionControls()
    If chkGrabUnderTarget.Value = Checked Then
        fraDirection.Enabled = False
        For i = optDir.LBound To optDir.UBound
            optDir(i).Enabled = False
        Next i
    Else
        fraDirection.Enabled = True
        For i = optDir.LBound To optDir.UBound
            optDir(i).Enabled = True
        Next i
    End If
End Sub

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub tmrGrabber_Timer()
    Dim pX As Long, pY As Long, pZ As Long
    Dim itemID As Long, targetID As Long, targetPos As Long
    
    If chkGrabUnderTarget.Value = Checked Then
        'grab from under target
        targetID = ReadMem(ADR_TARGET_ID, 4)
        If targetID = 0 Then Exit Sub
        targetPos = GetIndexByID(targetID)
        
        pX = ReadMem(ADR_CHAR_X + targetPos * SIZE_CHAR, 4)
        pY = ReadMem(ADR_CHAR_Y + targetPos * SIZE_CHAR, 4)
        pZ = ReadMem(ADR_CHAR_Z + targetPos * SIZE_CHAR, 4)
    Else
        'grab from set direction relative to player
        getCharXYZ pX, pY, pZ, UserPos
        
        For i = optDir.LBound To optDir.UBound
            If optDir(i) Then
                Select Case i
                    Case Is = 0: pX = pX - 1: pY = pY - 1
                    Case Is = 1: pY = pY - 1
                    Case Is = 2: pX = pX + 1: pY = pY - 1
                    Case Is = 3: pX = pX + 1
                    Case Is = 4: pX = pX + 1: pY = pY + 1
                    Case Is = 5: pY = pY + 1
                    Case Is = 6: pX = pX - 1: pY = pY + 1
                    Case Is = 7: pX = pX - 1
                End Select
            End If
        Next i
    End If
    If optSpears Then
        itemID = ITEM_SPEAR
    ElseIf optThrowingKnives Then
        itemID = ITEM_THROWING_KNIFE
    ElseIf optSmallStones Then
        itemID = ITEM_SMALL_STONE
    ElseIf optThrowingStars Then
        itemID = ITEM_THROWING_STAR
    End If
    GrabItem itemID, pX, pY, pZ, &H6, &H0, 3
End Sub
