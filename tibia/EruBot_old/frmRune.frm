VERSION 5.00
Begin VB.Form frmRune 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Rune Maker"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2400
   ControlBox      =   0   'False
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
   ScaleHeight     =   240
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   160
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkLifeRings 
      Caption         =   "Use Life Rings"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   2760
      Width           =   2175
   End
   Begin VB.HScrollBar hscrManaReq 
      Height          =   255
      LargeChange     =   50
      Left            =   120
      Max             =   1400
      Min             =   120
      SmallChange     =   10
      TabIndex        =   8
      Top             =   960
      Value           =   400
      Width           =   2175
   End
   Begin VB.TextBox txtSpellWords 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1033
         SubFormatType   =   1
      EndProperty
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000012&
      Height          =   285
      Left            =   120
      TabIndex        =   6
      Text            =   "adura vita"
      Top             =   360
      Width           =   2160
   End
   Begin VB.HScrollBar hscrSoulReq 
      Height          =   255
      Left            =   120
      Max             =   7
      Min             =   1
      TabIndex        =   5
      Top             =   1560
      Value           =   3
      Width           =   2175
   End
   Begin VB.CheckBox chkLogFinished 
      Caption         =   "Log when no blanks/soul points"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   2280
      Width           =   2175
   End
   Begin VB.TextBox txtReserveMana 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1033
         SubFormatType   =   1
      EndProperty
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000012&
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Text            =   "0"
      Top             =   1920
      Width           =   600
   End
   Begin VB.CommandButton btnOk 
      Caption         =   "Close"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   840
      TabIndex        =   0
      Top             =   3120
      Width           =   855
   End
   Begin VB.Timer tmrRune 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   2160
      Top             =   0
   End
   Begin VB.Label lblManaReq 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Mana Required: 100"
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
      TabIndex        =   9
      Top             =   720
      Width           =   2175
   End
   Begin VB.Label lblSoulReq 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Soul Points Required: 3"
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
      TabIndex        =   7
      Top             =   1320
      Width           =   2175
   End
   Begin VB.Label lblRMana 
      BackStyle       =   0  'Transparent
      Caption         =   "Reserved Mana:"
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
      TabIndex        =   2
      Top             =   1920
      Width           =   1815
   End
   Begin VB.Label lblSpell2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Spell"
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
      TabIndex        =   1
      Top             =   120
      Width           =   2175
   End
End
Attribute VB_Name = "frmRune"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnOk_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    hscrManaReq_Change
    hscrSoulReq_Change
End Sub

Public Sub hscrManaReq_Change()
    If Int(hscrManaReq / 10) - hscrManaReq / 10 <> 0 Then hscrManaReq = 10 * Int(hscrManaReq / 10)
    lblManaReq = "Mana required: " & hscrManaReq
End Sub

Public Sub hscrSoulReq_Change()
    lblSoulReq = "Soul required: " & hscrSoulReq
End Sub

Private Sub tmrRune_Timer()
    Dim blankBP As Integer
    Dim blankSlot As Integer
    Dim temp As Long
    Static weapon As Long
    
    If txtSpellWords <> "" Then
        If ReadMem(ADR_CUR_MANA, 2) >= hscrManaReq + CLng(txtReserveMana.Text) Then
            If ReadMem(ADR_CUR_SOUL, 2) >= hscrSoulReq Then
                temp = ReadMem(ADR_LEFT_HAND, 2)
                If temp = ITEM_RUNE_BLANK Then
                    SayStuff txtSpellWords
                    AddStatusMessage "Casting " & txtSpellWords & " on a blank rune."
                    Exit Sub
                ElseIf findItem(ITEM_RUNE_BLANK, blankBP, blankSlot) Then
                    If weapon = 0 Then weapon = temp
                    MoveItem ITEM_RUNE_BLANK, blankBP, blankSlot, &H6, &H0, 1
                    AddStatusMessage "Moving blank rune to left hand."
                    Exit Sub
                Else
                    StopRuneMaking "No blank runes found."
                End If
            Else
                StopRuneMaking "No Soul Points left."
            End If
        End If
    Else
        StopRuneMaking "No spell words entered."
    End If
    'switch weapon back
    If weapon <> 0 Then
        temp = ReadMem(ADR_LEFT_HAND, 2)
        If temp <> weapon Then
            If findItem(weapon, blankBP, blankSlot, False) Then
                MoveItem weapon, blankBP, blankSlot, SLOT_LEFT_HAND, 0, 1
                Exit Sub
            Else
                weapon = 0
            End If
        ElseIf temp = weapon Then
            weapon = 0
        End If
    End If
    If chkLifeRings = Checked Then
        If ReadMem(ADR_RING, 2) = 0 Then
            If findItem(ITEM_LIFE_RING, blankBP, blankSlot, True) Then
                MoveItem ITEM_LIFE_RING, blankBP, blankSlot, SLOT_RING, 0, 1
                Exit Sub
            Else
                chkLifeRings.Value = Unchecked
            End If
        End If
    End If
End Sub

Private Sub StopRuneMaking(reason As String)
    AddStatusMessage reason
    If chkLogFinished Then LogOut: frmMain.StartLogOut
    frmMain.chkRune.Value = Unchecked
    Valid
End Sub
