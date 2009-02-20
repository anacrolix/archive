VERSION 5.00
Begin VB.UserControl InventorySlot 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FFFFFF&
   ClientHeight    =   3060
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2490
   ScaleHeight     =   204
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   166
   Begin VB.PictureBox picIcon 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      DragIcon        =   "ctlInventorySlot.ctx":0000
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   600
      ScaleHeight     =   57
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   57
      TabIndex        =   1
      Top             =   480
      Width           =   855
   End
   Begin VB.Shape shpBorder 
      Height          =   3375
      Left            =   -120
      Top             =   -360
      Width           =   2055
   End
   Begin VB.Label lblCaption 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   360
      TabIndex        =   0
      Top             =   2400
      Width           =   1455
   End
End
Attribute VB_Name = "InventorySlot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Property Let ContainsItem(ByVal NewValue As Boolean)
    
End Property

Public Property Get ContainsItem() As Boolean

End Property

Private Sub UserControl_Click()
    UserControl.SetFocus
End Sub

Private Sub UserControl_EnterFocus()
    shpBorder.BorderColor = vbRed
    shpBorder.BorderStyle = 2
End Sub

Private Sub UserControl_ExitFocus()
    shpBorder.BorderColor = vbBlack
    shpBorder.BorderStyle = 1
End Sub

Private Sub UserControl_LostFocus()
    shpBorder.BorderColor = vbBlack
    shpBorder.BackStyle = vbSolid
End Sub

Private Sub UserControl_Resize()
    'fit the border to edges of control
    shpBorder.Move 1, 1, ScaleWidth - 1, ScaleHeight - 1
    picIcon.Move (ScaleWidth - 50) / 2, 2, 50, 50
    lblCaption.Move 0, picIcon.Height, ScaleWidth, ScaleHeight - picIcon.Height
End Sub

Public Property Get Caption() As String
   Caption = lblCaption.Caption
End Property

Public Property Let Caption(ByVal NewCaption As String)
   lblCaption.Caption = NewCaption
   PropertyChanged "Caption"
End Property

Public Property Let hDC(ByRef NewhDC As Long)
   picIcon = NewhDC
   PropertyChanged "hDC"
End Property

Public Property Get hDC() As Long
   hDC = picIcon.hDC
End Property

Public Sub Cls()
   picIcon.Cls
   lblCaption.Caption = ""
End Sub

Public Sub Refresh()
    picIcon.Refresh
End Sub
