VERSION 5.00
Begin VB.Form frmOutfit 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Outfit Changer"
   ClientHeight    =   3090
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2490
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3090
   ScaleWidth      =   2490
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkRainbow 
      Caption         =   "Rainbow thingy"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1800
      Width           =   2295
   End
   Begin VB.CheckBox chkColor 
      Caption         =   "Outfit"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   360
      Width           =   855
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "Close"
      Height          =   375
      Left            =   840
      TabIndex        =   6
      Top             =   2640
      Width           =   855
   End
   Begin VB.Timer tmrOutfit 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   2040
      Top             =   2640
   End
   Begin VB.HScrollBar hscrOutfit 
      Height          =   255
      LargeChange     =   1000
      Left            =   120
      Max             =   10000
      Min             =   100
      SmallChange     =   250
      TabIndex        =   4
      Top             =   2280
      Value           =   500
      Width           =   2295
   End
   Begin VB.CheckBox chkColor 
      Caption         =   "Feet"
      Height          =   255
      Index           =   4
      Left            =   120
      TabIndex        =   3
      Top             =   1320
      Width           =   855
   End
   Begin VB.CheckBox chkColor 
      Caption         =   "Legs"
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   2
      Top             =   1080
      Width           =   855
   End
   Begin VB.CheckBox chkColor 
      Caption         =   "Body"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   855
   End
   Begin VB.CheckBox chkColor 
      Caption         =   "Hair"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   855
   End
   Begin VB.Image Image1 
      Height          =   1320
      Left            =   960
      Picture         =   "frmOutfit.frx":0000
      Top             =   360
      Width           =   1470
   End
   Begin VB.Label Label2 
      Caption         =   "Change:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   855
   End
   Begin VB.Label lblInterval 
      Caption         =   "Interval"
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
      Top             =   2040
      Width           =   2295
   End
End
Attribute VB_Name = "frmOutfit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private baseOutfit As Long

Private Sub chkRainbow_Click()
    Dim i As Integer
    
    For i = chkColor.LBound To chkColor.UBound
        If chkRainbow Then
            chkColor(i).Enabled = False
        Else
            chkColor(i).Enabled = True
        End If
    Next i
    
    baseOutfit = 0
End Sub

Private Sub cmdOK_Click()
  Me.Hide
End Sub

Private Sub Form_Load()
  hscrOutfit_Change
End Sub

Private Sub hscrOutfit_Change()
    tmrOutfit.Interval = hscrOutfit
    lblInterval = "Interval: " & hscrOutfit & " ms"
End Sub

Private Sub tmrOutfit_Timer()
    Static newOutfit(4) As Long
    Dim i As Integer
    Dim buff(7) As Byte
    
    
    If chkRainbow Then
        'outfit
        newOutfit(0) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR, 4)
        'colors
        Do
            baseOutfit = baseOutfit + 1
        Loop Until baseOutfit Mod 19 <> 0 And baseOutfit <> 0
        If baseOutfit > 133 Then baseOutfit = 0
        For i = 1 To 3
            newOutfit(i) = newOutfit(i + 1)
        Next i
        newOutfit(4) = baseOutfit
    Else
        Randomize Timer
        'outfit
        If chkColor(0) Then
            If newOutfit(0) >= &H80 And newOutfit(0) <= &H86 Then
                newOutfit(0) = &H80 + Int(Rnd * 7)
            Else
                newOutfit(0) = &H88 + Int(Rnd * 7)
            End If
        Else
            newOutfit(0) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR, 4)
        End If
        'colors
        For i = 1 To 4
            If chkColor(i) Then
                newOutfit(i) = Int(Rnd * 133)
            Else
                newOutfit(i) = ReadMem(ADR_CHAR_OUTFIT + UserPos * SIZE_CHAR + 4 * i, 4)
            End If
        Next i
    End If
    
    buff(0) = 6
    buff(1) = 0
    buff(2) = &HD3
    For i = 0 To 4
        buff(3 + i) = newOutfit(i)
    Next
    
    If frmMain.sckS.State = sckConnected Then frmMain.sckS.SendData buff
End Sub
