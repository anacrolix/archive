VERSION 5.00
Begin VB.Form frmDisplay 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H00000080&
   Caption         =   "Character Name"
   ClientHeight    =   7200
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   8940
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   480
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   596
   WindowState     =   2  'Maximized
   Begin VB.VScrollBar vscrVert 
      Height          =   3855
      LargeChange     =   5
      Left            =   8280
      TabIndex        =   5
      Top             =   240
      Width           =   255
   End
   Begin VB.HScrollBar hscrHor 
      Height          =   255
      LargeChange     =   5
      Left            =   1200
      TabIndex        =   4
      Top             =   3960
      Width           =   5655
   End
   Begin VB.TextBox txtFeedBack 
      Appearance      =   0  'Flat
      Height          =   1095
      Left            =   1680
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      TabStop         =   0   'False
      Text            =   "frmDisplay.frx":0000
      ToolTipText     =   "Displays results of actions and provides information on game events."
      Top             =   5760
      Width           =   2415
   End
   Begin VB.CommandButton cmdKeyBoard 
      Caption         =   "?"
      Height          =   255
      Left            =   8280
      TabIndex        =   0
      Top             =   4080
      Width           =   255
   End
   Begin VB.Label lblInfo 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H00C0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "InfoBox"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Left            =   4200
      TabIndex        =   3
      Top             =   1680
      UseMnemonic     =   0   'False
      Visible         =   0   'False
      Width           =   690
   End
   Begin VB.Label lblStatus 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Character Status Window"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   1935
      Left            =   5640
      TabIndex        =   1
      Top             =   4920
      Width           =   3255
      WordWrap        =   -1  'True
   End
   Begin VB.Menu mnu_Game 
      Caption         =   "&Game"
      Begin VB.Menu mnu_File_New 
         Caption         =   "&New"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_Load 
         Caption         =   "&Load"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_Save 
         Caption         =   "&Save"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_SaveAs 
         Caption         =   "Save &As"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Game_Exit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnu_Character 
      Caption         =   "&Character"
      Begin VB.Menu mnu_Character_Details 
         Caption         =   "&Details"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu_Character_Inventory 
         Caption         =   "&Inventory"
      End
   End
   Begin VB.Menu mnu_Help 
      Caption         =   "&Help"
      Enabled         =   0   'False
      NegotiatePosition=   3  'Right
      Begin VB.Menu mnu_Help_Contents 
         Caption         =   "&Contents"
      End
      Begin VB.Menu mnu_Help_About 
         Caption         =   "&About Rift Of Peril..."
      End
   End
End
Attribute VB_Name = "frmDisplay"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private StatusY As Integer
Private StatusX As Single

Private Sub cmdKeyBoard_Click()
    MsgBox "Hello! To move click the mouse or use the numpad."
End Sub

Private Sub cmdKeyBoard_KeyDown(KeyCode As Integer, Shift As Integer)
    Form_KeyDown KeyCode, Shift
End Sub

Private Sub Form_GotFocus()
    CenterScreen
    DrawView
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    Select Case KeyCode
        Case vbKeyNumpad1: ChAr.Move SouthWest
        Case vbKeyNumpad2: ChAr.Move South
        Case vbKeyNumpad3: ChAr.Move SouthEast
        Case vbKeyNumpad4: ChAr.Move West
        Case vbKeyNumpad6: ChAr.Move East
        Case vbKeyNumpad7: ChAr.Move NorthWest
        Case vbKeyNumpad8: ChAr.Move North
        Case vbKeyNumpad9: ChAr.Move NorthEast
        Case vbKeyG: ChAr.PickUpItm eSlotPack
        Case vbKeyF: ChAr.PickUpItm eSlotOffhand
    End Select
End Sub

Private Sub Form_Load()
    StatusY = 106
    StatusX = 0.66
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        Dim Dirctn As EnumDirection
        Dirctn = GetDirection(CInt(X), CInt(Y), _
        TileSize * (ChAr.X + 0.5 - ScrnOfstX), _
        TileSize * (ChAr.Y + 0.5 - ScrnOfstY))
        ChAr.Move Dirctn
    ElseIf Button = 2 Then
        Dim nX As Integer, nY As Integer
        Dim InfoStr As String, NextBit As String, Cnt As Integer
        nX = ScrnOfstX + Int(X / TileSize)
        nY = ScrnOfstY + Int(Y / TileSize)
        InfoStr = "You see:" & vbLf
        With Maps(ChAr.Map)
            If .Explored(nX, nY) = True Then
                If .TileType(nX, nY) = DungeonFloor Then NextBit = "the Floor"
                If .TileType(nX, nY) = DungeonWall Then NextBit = "Solid Rock"
            Else
                NextBit = "not explored"
            End If
        End With
        InfoStr = InfoStr + NextBit
        If Mons.NumMons > 0 Then
            For Cnt = 0 To Mons.NumMons - 1
                With Mons.Monster(Cnt)
                    If .X = nX And .Y = nY And .Map = ChAr.Map And _
                    .InGame And Maps(ChAr.Map).CanSee(.X, .Y) Then _
                    InfoStr = InfoStr & vbLf & "a " & .Name
                End With
            Next Cnt
        End If
        
        With lblInfo
            .Top = Y + 20
            .Left = X + 12
            .Caption = InfoStr
            .Visible = True
        End With
    End If
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblInfo.Visible = False
End Sub

Private Sub Form_Resize()
    With txtFeedBack
        .Top = Me.ScaleHeight - StatusY
        .Left = 0
        .Width = StatusX * Me.ScaleWidth
        .Height = StatusY
    End With
    With cmdKeyBoard
        .Top = txtFeedBack.Top
        .Left = 0
    End With
    With lblStatus
        .Top = Me.ScaleHeight - StatusY
        .Left = StatusX * Me.ScaleWidth
        .Width = (1 - StatusX) * Me.ScaleWidth
        .Height = StatusY
    End With
    With vscrVert
        .Left = Me.ScaleWidth - 17
        .Top = 0
        .Height = Me.ScaleHeight - StatusY - 17
        .Width = 17
    End With
    With hscrHor
        .Left = 0
        .Top = Me.ScaleHeight - StatusY - 17
        .Height = 17
        .Width = Me.ScaleWidth - 17
    End With
    With cmdKeyBoard
        .Left = Me.ScaleWidth - 17
        .Top = Me.ScaleHeight - StatusY - 17
        .Height = 17
        .Width = 17
    End With
    AvailY% = Me.ScaleHeight - StatusY
    AvailX% = Me.ScaleWidth
    NoSqCanSeeX = Int(AvailX% / TileSize) + 1
    NoSqCanSeeY = Int(AvailY% / TileSize) + 1
    CenterScreen
    DrawView
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CleanExit Cancel
End Sub

Private Sub lstFeedBack_GotFocus()
    frmDisplay.SetFocus
End Sub

Private Sub lstFeedBack_KeyDown(KeyCode As Integer, Shift As Integer)
    Call Form_KeyDown(KeyCode, Shift)
End Sub

Private Sub lstFeedBack_KeyUp(KeyCode As Integer, Shift As Integer)
    frmDisplay.SetFocus
End Sub


Private Sub hscrHor_Change()
    ScrnOfstX = hscrHor.Value
    frmDisplay.Cls
    DrawView
End Sub

Private Sub hscrHor_GotFocus()
    cmdKeyBoard.SetFocus
End Sub

Private Sub mnu_Character_Inventory_Click()
    frmInventory.Show
    Me.Hide
End Sub

Private Sub mnu_Game_Exit_Click()
    CleanExit
End Sub

Private Sub vscrVert_Change()
    ScrnOfstY = vscrVert.Value
    frmDisplay.Cls
    DrawView
End Sub

Private Sub vscrVert_GotFocus()
    cmdKeyBoard.SetFocus
End Sub
