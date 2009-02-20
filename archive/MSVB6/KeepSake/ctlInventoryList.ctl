VERSION 5.00
Begin VB.UserControl InventoryList 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   6030
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7275
   ForeColor       =   &H80000008&
   ScaleHeight     =   402
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   485
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   0
      Left            =   240
      TabIndex        =   3
      Top             =   600
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin VB.CommandButton CloseButton 
      Caption         =   "X"
      Height          =   375
      Left            =   6840
      TabIndex        =   2
      Top             =   0
      Width           =   375
   End
   Begin VB.VScrollBar ScrollBar 
      Height          =   5655
      Left            =   6960
      TabIndex        =   1
      Top             =   360
      Width           =   255
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   1
      Left            =   1800
      TabIndex        =   4
      Top             =   480
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   2
      Left            =   3600
      TabIndex        =   5
      Top             =   600
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   3
      Left            =   5280
      TabIndex        =   6
      Top             =   720
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   4
      Left            =   360
      TabIndex        =   7
      Top             =   2640
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   5
      Left            =   1920
      TabIndex        =   8
      Top             =   2640
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   6
      Left            =   3480
      TabIndex        =   9
      Top             =   2640
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin KeepSake.InventorySlot InventorySlot 
      Height          =   1935
      Index           =   7
      Left            =   5040
      TabIndex        =   10
      Top             =   2640
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   3413
   End
   Begin VB.Label TitleLabel 
      BackColor       =   &H80000002&
      Caption         =   "Back Pack"
      BeginProperty Font 
         Name            =   "Trebuchet MS"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000009&
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7215
   End
End
Attribute VB_Name = "InventoryList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Type IconArray
    Text As String
    Icon As Integer
    Item As Integer
End Type

Private IconList() As IconArray

Public Sub Add(Item As Integer, Icon As Integer, Text As String)
ReDim Preserve IconList(UBound(IconList) + 1)
With IconList(UBound(IconList))
    .Text = Text
    .Icon = Icon
    .Item = ItemNo
End With

End Sub

Private Sub UserControl_Resize()
    '
    CloseButton.Top = 0
    CloseButton.Left = ScaleWidth - CloseButton.Width
    
    TitleLabel.Top = 0
    TitleLabel.Left = 0
    TitleLabel.Width = ScaleWidth - CloseButton.Width
    TitleLabel.Height = CloseButton.Height
    
    ScrollBar.Width = 17
    ScrollBar.Height = ScaleHeight - CloseButton.Height
    ScrollBar.Left = ScaleWidth - ScrollBar.Width
    ScrollBar.Top = CloseButton.Height
    
    SlotAreaX& = ScaleWidth - ScrollBar.Width
    SlotAreaY& = ScaleHeight - TitleLabel.Height
    For Index& = 0 To 7
        Y& = Int(Index& / 4) * (SlotAreaY& / 2)
        X& = (Index& - (4 * Y&)) * (SlotAreaX& / 4)
        With InventorySlot(Index&)
            .Left = X&
            .Top = TitleLabel.Height + Y& - 3
            .Width = SlotAreaX& / 4
            .Height = SlotAreaY& / 2
        End With
    Next Index&
End Sub

Public Property Let SlothDC(SlotNum As Integer, ByRef NewhDC As Long)
    InventorySlot(SlotNum).hDC = NewhDC
    PropertyChanged "slothDC"
End Property

Public Property Get SlothDC(SlotNum As Integer) As Long
    SlothDC = InventorySlot(SlotNum).hDC
End Property
