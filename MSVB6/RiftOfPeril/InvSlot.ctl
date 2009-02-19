VERSION 5.00
Begin VB.UserControl InvSlot 
   BackColor       =   &H00FFFFFF&
   ClientHeight    =   4290
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2625
   ScaleHeight     =   286
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   175
   Begin VB.PictureBox pcbIcon 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   720
      Left            =   720
      ScaleHeight     =   46
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   46
      TabIndex        =   0
      Top             =   1200
      Width           =   720
   End
   Begin VB.Shape shpBorder 
      BorderColor     =   &H000000FF&
      BorderStyle     =   2  'Dash
      Height          =   2175
      Left            =   360
      Top             =   600
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.Label lblName 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   360
      TabIndex        =   1
      Top             =   3000
      Width           =   1695
   End
End
Attribute VB_Name = "InvSlot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private m_SlotType As EnumSlots
Private m_EmptyText As String
Const m_def_EmptyText = "Empty Slot"
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Sub Refresh()
    pcbIcon.Refresh
End Sub

Private Sub UserControl_Click()
    UserControl.SetFocus
End Sub

Private Sub UserControl_EnterFocus()
    shpBorder.Visible = True
End Sub

Private Sub UserControl_ExitFocus()
    shpBorder.Visible = False
End Sub

Private Sub UserControl_GotFocus()
    UserControl_EnterFocus
End Sub

Private Sub UserControl_Initialize()
    lblName.Caption = Me.EmptyText
End Sub

Private Sub UserControl_LostFocus()
    UserControl_ExitFocus
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    UserControl.SetFocus
End Sub

Private Sub UserControl_Resize()
    With pcbIcon
        .Width = TileSize
        .Height = TileSize
        .Top = 2
        .Left = (UserControl.ScaleWidth - .Width) / 2
    End With
    With lblName
        .Width = UserControl.ScaleWidth
        .Height = UserControl.ScaleHeight / 2
        .Left = 0
        .Top = 52
    End With
    With shpBorder
        .Width = UserControl.ScaleWidth
        .Height = UserControl.ScaleHeight
        .Top = 0
        .Left = 0
    End With
    
End Sub
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=pcbIcon,pcbIcon,-1,hDC
Public Property Get hDC() As Long
Attribute hDC.VB_Description = "Returns a handle (from Microsoft Windows) to the object's device context."
    hDC = pcbIcon.hDC
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=13,0,0,Empty Slot
Public Property Get EmptyText() As String
    EmptyText = m_EmptyText
End Property

Public Property Let EmptyText(ByVal New_EmptyText As String)
    m_EmptyText = New_EmptyText
    PropertyChanged "EmptyText"
End Property

'Initialize Properties for User Control
Private Sub UserControl_InitProperties()
    m_EmptyText = m_def_EmptyText
End Sub

'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    m_EmptyText = PropBag.ReadProperty("EmptyText", m_def_EmptyText)
    lblName.Caption = PropBag.ReadProperty("Caption", "EmptyText")
    
End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("EmptyText", m_EmptyText, m_def_EmptyText)
    Call PropBag.WriteProperty("Caption", lblName.Caption, "Label1")
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=lblName,lblName,-1,Caption
Public Property Get Caption() As String
Attribute Caption.VB_Description = "Returns/sets the text displayed in an object's title bar or below an object's icon."
    Caption = lblName.Caption
End Property

Public Property Let Caption(ByVal New_Caption As String)
    lblName.Caption() = New_Caption
    PropertyChanged "Caption"
End Property

