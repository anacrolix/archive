VERSION 5.00
Begin VB.Form frmFisher 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Fisher"
   ClientHeight    =   2280
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2745
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2280
   ScaleWidth      =   2745
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdEnterVals 
      Caption         =   "Enter vals"
      Height          =   255
      Left            =   1560
      TabIndex        =   14
      Top             =   840
      Width           =   855
   End
   Begin VB.CheckBox chkSpeedFish 
      Caption         =   "Speed fish"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   960
      Width           =   1215
   End
   Begin VB.CheckBox chkFishNoFood 
      Caption         =   "Fish only if there is no fish."
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1440
      Width           =   2175
   End
   Begin VB.CheckBox chkFishNoWorms 
      Caption         =   "Fish even if there are no worms."
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1200
      Width           =   2655
   End
   Begin VB.Timer tmrFish 
      Enabled         =   0   'False
      Interval        =   3000
      Left            =   120
      Top             =   1800
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "Close"
      Height          =   375
      Left            =   960
      TabIndex        =   8
      Top             =   1800
      Width           =   855
   End
   Begin VB.TextBox txtBoundary 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Index           =   3
      Left            =   2160
      TabIndex        =   7
      Text            =   "5"
      Top             =   480
      Width           =   495
   End
   Begin VB.TextBox txtBoundary 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Index           =   2
      Left            =   1320
      TabIndex        =   6
      Text            =   "7"
      Top             =   480
      Width           =   495
   End
   Begin VB.TextBox txtBoundary 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Index           =   1
      Left            =   2160
      TabIndex        =   5
      Text            =   "-5"
      Top             =   120
      Width           =   495
   End
   Begin VB.TextBox txtBoundary 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Index           =   0
      Left            =   1320
      TabIndex        =   1
      Text            =   "-7"
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "X"
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
      Left            =   1080
      TabIndex        =   11
      Top             =   480
      Width           =   255
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      Caption         =   "X"
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
      Left            =   1080
      TabIndex        =   10
      Top             =   120
      Width           =   255
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      Caption         =   "Y"
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
      Left            =   1920
      TabIndex        =   4
      Top             =   120
      Width           =   255
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Y"
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
      Left            =   1920
      TabIndex        =   3
      Top             =   480
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "Bottom Right"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Top Left"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   735
   End
End
Attribute VB_Name = "frmFisher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private leftX As Integer, leftY As Integer, rightX As Integer, rightY As Integer 'coords of top left and bottom right of fishing box
Private oX As Integer, oY As Integer

Private Sub chkSpeedFish_Click()
    If chkSpeedFish.Value = Checked Then
        tmrFish.Interval = 1000
    Else
        tmrFish.Interval = 3000
    End If
End Sub

Private Sub cmdEnterVals_Click()
    updBoundVals
End Sub

Private Sub cmdOK_Click()
  Me.Hide
End Sub

Private Sub ResetBoundaries()
  'reset boundaries to maximum extends
  txtBoundary(0) = -7
  txtBoundary(1) = -5
  txtBoundary(2) = 7
  txtBoundary(3) = 5
  updBoundVals
End Sub

Private Sub Form_Load()
    ResetBoundaries
    updBoundVals
End Sub

Private Sub tmrFish_Timer()
    Dim bp As Integer
    Dim slot As Integer
    Dim pX As Long
    Dim pY As Long
    Dim pZ As Long
    Dim C1 As Integer
    Dim C2 As Integer
    Dim bpOpen As Long
    Dim ltemp As Long
    Dim items As Long
    
    If chkFishNoFood Then If findItem(ITEM_FOOD_FISH, bp, slot) Then Exit Sub
    
    If findItem(ITEM_WORM, bp, slot) Or chkFishNoWorms Then
        If findItem(ITEM_FISHING_ROD, bp, slot) Then
            getCharXYZ pX, pY, pZ, UserPos
            UseAt ITEM_FISHING_ROD, bp, slot, pX + oX, pY + oY, pZ
            oX = oX + 1
            If oX > rightX Then
                oX = leftX
                oY = oY + 1
            End If
            If oY > rightY Then oY = leftY
        End If
    End If
End Sub

Public Sub updBoundVals()
    For i = txtBoundary.LBound To txtBoundary.UBound
        If Index = 0 Or Index = 2 Then If txtBoundary(Index) < -7 Or txtBoundary(Index) > 7 Then ResetBoundaries
        If Index = 1 Or Index = 3 Then If txtBoundary(Index).Text < -5 Or txtBoundary(Index).Text > 5 Then ResetBoundaries
    Next i
    'check left boundaries do not exceed right
    If CInt(txtBoundary(0).Text) > CInt(txtBoundary(2).Text) Or _
    CInt(txtBoundary(1).Text) > CInt(txtBoundary(3).Text) Then _
        ResetBoundaries

    'parse boundaries
    leftX = txtBoundary(0)
    leftY = txtBoundary(1)
    rightX = txtBoundary(2)
    rightY = txtBoundary(3)
    oX = leftX
    oY = leftY
End Sub

Private Sub txtBoundary_LostFocus(Index As Integer)
    updBoundVals
End Sub
