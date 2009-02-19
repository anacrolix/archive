VERSION 5.00
Begin VB.Form frmHeal 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Auto Healing"
   ClientHeight    =   3345
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2400
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3345
   ScaleWidth      =   2400
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkHealFriends 
      Caption         =   "AutoHeal Friends"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   2520
      Width           =   2175
   End
   Begin VB.CheckBox chkAlertLowHP 
      Caption         =   "Alert if HP below threshold"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2280
      Width           =   2175
   End
   Begin VB.TextBox txtRuneDelay 
      Height          =   285
      Left            =   1320
      TabIndex        =   12
      Text            =   "1100"
      Top             =   1920
      Width           =   975
   End
   Begin VB.Timer tmrHeal 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   1800
      Top             =   2880
   End
   Begin VB.CommandButton cmdDone 
      Caption         =   "Close"
      Height          =   375
      Left            =   720
      TabIndex        =   11
      Top             =   2880
      Width           =   975
   End
   Begin VB.CheckBox chkUseSpell 
      Caption         =   "Use Spells"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   720
      Value           =   1  'Checked
      Width           =   1095
   End
   Begin VB.CheckBox chkUseRune 
      Caption         =   "Use Runes"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox txtMana 
      Height          =   285
      Left            =   720
      TabIndex        =   8
      Text            =   "25"
      Top             =   1440
      Width           =   1575
   End
   Begin VB.TextBox txtHP 
      Height          =   285
      Left            =   480
      TabIndex        =   6
      Text            =   "1250"
      Top             =   120
      Width           =   615
   End
   Begin VB.Frame fraPref 
      Caption         =   "Try First"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   1320
      TabIndex        =   2
      Top             =   120
      Width           =   975
      Begin VB.OptionButton optRuneFirst 
         Caption         =   "Rune"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   240
         Width           =   735
      End
      Begin VB.OptionButton optSpellFirst 
         Caption         =   "Spell"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   480
         Value           =   -1  'True
         Width           =   735
      End
   End
   Begin VB.TextBox txtSpell 
      Height          =   285
      Left            =   720
      TabIndex        =   0
      Text            =   "exura"
      Top             =   1080
      Width           =   1575
   End
   Begin VB.Label Label4 
      Caption         =   "Rune Delay"
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
      Left            =   120
      TabIndex        =   13
      Top             =   1920
      Width           =   1095
   End
   Begin VB.Line Line1 
      X1              =   120
      X2              =   2280
      Y1              =   1800
      Y2              =   1800
   End
   Begin VB.Label Label3 
      Caption         =   "Mana"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1440
      Width           =   495
   End
   Begin VB.Label Label2 
      Caption         =   "HP:"
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
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label1 
      Caption         =   "Spell"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1080
      Width           =   495
   End
End
Attribute VB_Name = "frmHeal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private lastHeal As Long
Private triedRune As Boolean
Private triedSpell As Boolean

Private Sub cmdDone_Click()
    Me.Hide
End Sub

Private Sub tmrHeal_Timer()
    If GetTickCount > lastHeal + CLng(txtRuneDelay) Then
        triedRune = False
        triedSpell = False
        
        If ReadMem(ADR_CUR_HP, 2) <= CLng(txtHP) And txtHP <> "" And CLng(txtHP) > 1 Then
            If chkAlertLowHP.Value = Checked Then StartAlert
            If optRuneFirst.Value = True Then
                UseRune
            Else
                UseSpell
            End If
        ElseIf chkHealFriends.Value = Checked Then
            Dim targetPos As Long
            targetPos = -1
            targetPos = FindPosByHP(frmAimbot.listFriends, frmAimbot.hscrHealAt.Value, frmAimbot.chkHealLowest.Value)
            If targetPos >= 0 Then ShootRune ITEM_RUNE_UH, targetPos
        End If
    End If
End Sub

Private Sub UseSpell()
    If triedSpell Then Exit Sub
    If chkUseSpell.Value = Checked Then
        If ReadMem(ADR_CUR_MANA, 2) >= CLng(txtMana) Then
            SayStuff txtSpell
            lastHeal = GetTickCount
        Else
            triedSpell = True
            UseRune
        End If
    Else
        triedSpell = True
        UseRune
    End If
End Sub

Private Sub UseRune()
    Dim pX As Long, pY As Long, pZ As Long 'coords of player
    Dim bpIndex As Integer, itemIndex As Integer 'location of uh
    Dim runesLeft As Boolean 'uh left in current bp
    
    If triedRune Then Exit Sub
    If chkUseRune.Value = Checked Then
        If findItem(ITEM_RUNE_UH, bpIndex, itemIndex) Then 'if find a uh
            getCharXYZ pX, pY, pZ, UserPos 'get char coords
            runesLeft = False
            If itemIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) _
            Then If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (itemIndex + 1) * SIZE_ITEM, 2) = ITEM_RUNE_UH _
            Then runesLeft = True 'if not last item in bp and the next item is a uh then there are uhs left

            If runesLeft = False Then 'but if no uhs found, then search rest of bp
                For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1
                    If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2) = ITEM_RUNE_UH _
                    And itemIndex <> i Then 'if an item in bp isn't the current uh
                        runesLeft = True
                        Exit For
                    End If
                Next i
            End If

            UseAt ITEM_RUNE_UH, bpIndex, itemIndex, pX, pY, pZ 'throw the uh
            Pause 50 'slight pause for server to process uh
            If runesLeft = False Then UpBpLevel bpIndex - &H40 'if no uhs left, then move up bp
            lastHeal = GetTickCount 'set last heal time to now
        Else
            triedRune = True
            UseSpell
        End If
    Else
        triedRune = True
        UseSpell
    End If
End Sub

Private Sub txtHP_Change()
    If Not IsNumeric(txtHP) Then txtHP = ""
End Sub

Private Sub txtRuneDelay_LostFocus()
    If IsNumeric(txtRuneDelay) And CLng(txtRuneDelay) >= 50 And CLng(txtRuneDelay) <= 5000 Then
        Exit Sub
    Else
        txtRuneDelay = 1000
    End If
End Sub
