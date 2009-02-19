VERSION 5.00
Begin VB.UserControl listFancy 
   ClientHeight    =   3870
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5070
   ScaleHeight     =   3870
   ScaleWidth      =   5070
   Begin VB.CommandButton cmdAdd 
      Caption         =   "Add"
      Height          =   375
      Left            =   3000
      TabIndex        =   5
      Top             =   1080
      Width           =   855
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "Remove"
      Height          =   375
      Left            =   3000
      TabIndex        =   4
      Top             =   1560
      Width           =   855
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   375
      Left            =   3000
      TabIndex        =   3
      Top             =   2040
      Width           =   855
   End
   Begin VB.CommandButton cmdLower 
      Caption         =   "Lower"
      Height          =   375
      Left            =   3000
      TabIndex        =   2
      Top             =   480
      Width           =   855
   End
   Begin VB.CommandButton cmdRaise 
      Caption         =   "Raise"
      Height          =   375
      Left            =   3000
      TabIndex        =   1
      Top             =   0
      Width           =   855
   End
   Begin VB.ListBox theList 
      Height          =   2400
      ItemData        =   "list.ctx":0000
      Left            =   0
      List            =   "list.ctx":0002
      TabIndex        =   0
      Top             =   240
      Width           =   2895
   End
   Begin VB.Shape shpBorder 
      Height          =   135
      Left            =   1560
      Top             =   3360
      Width           =   975
   End
   Begin VB.Label lblTitle 
      Caption         =   "Label1"
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
      Left            =   0
      TabIndex        =   6
      Top             =   0
      Width           =   2895
   End
End
Attribute VB_Name = "listFancy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Const BUTTON_WIDTH = 855
Const BUTTON_HEIGHT = 375
Const BUTTON_SPACE = 100
Const LIST_HEIGHT = 255
Const TWIXT_SPACE = 50
Const HOR_PADDING = 30
Const VERT_PADDING = 30
'Default Property Values:
Const m_def_Prioritized = 1
'Const m_def_Prioritized = True
'Const m_def_Prioritized = 1
'Property Variables:
Dim m_Prioritized As Boolean
'Dim m_Prioritized As Boolean
'Dim m_Prioritized As Boolean



Private Sub cmdAdd_Click()
    Dim temp As String
    temp = InputBox("Enter string", "Enter value")
    If temp <> "" Then If Contains(temp) < 0 Then theList.AddItem temp
End Sub
'
'Property Get Title() As String
'    Title = lblTitle.Caption
'End Property
'
'Property Let Title(param As String)
'    lblTitle.Caption = param
'End Property

Private Sub cmdClear_Click()
    If MsgBox("This will clear the list irreversibly.", vbOKCancel, "Are you sure?") = vbOK Then theList.Clear
End Sub

Private Sub cmdLower_Click()
    Dim temp As String
    If theList.ListIndex >= theList.ListCount - 1 Then Exit Sub
    temp = theList.List(theList.ListIndex)
    theList.List(theList.ListIndex) = theList.List(theList.ListIndex + 1)
    theList.List(theList.ListIndex + 1) = temp
    theList.ListIndex = theList.ListIndex + 1
End Sub

Private Sub cmdRaise_Click()
    Dim temp As String
    If theList.ListIndex >= theList.ListCount Or theList.ListIndex <= 0 Then Exit Sub
    temp = theList.List(theList.ListIndex)
    theList.List(theList.ListIndex) = theList.List(theList.ListIndex - 1)
    theList.List(theList.ListIndex - 1) = temp
    theList.ListIndex = theList.ListIndex - 1
End Sub

Private Sub cmdRemove_Click()
    Dim lastIndex As Integer
    If theList.ListCount <= 0 Then Exit Sub
    lastIndex = theList.ListIndex
    theList.RemoveItem lastIndex
    If theList.ListCount > 0 Then
        If lastIndex >= theList.ListCount Then lastIndex = theList.ListCount - 1
        theList.ListIndex = lastIndex
    End If
End Sub

Private Sub UserControl_Initialize()
    theList.Clear
    UserControl_Resize
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
Dim Index As Integer
    On Error Resume Next
    lblTitle.Caption = PropBag.ReadProperty("Title")
    lblTitle.Caption = PropBag.ReadProperty("Caption", "Label1")
'TO DO: The member you have mapped to contains an array of data.
'   You must supply the code to persist the array.  A prototype
'   line is shown next:
    theList.List(Index) = PropBag.ReadProperty("List" & Index, "")
    theList.ListIndex = PropBag.ReadProperty("ListIndex", 0)
'    m_Prioritized = PropBag.ReadProperty("Prioritized", m_def_Prioritized)
'    m_Prioritized = PropBag.ReadProperty("Prioritized", m_def_Prioritized)
    m_Prioritized = PropBag.ReadProperty("Prioritized", m_def_Prioritized)
End Sub

Private Sub UserControl_Resize()
If Me.Prioritized = True Then
    With cmdRaise
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
        .Visible = True
        .Enabled = True
    End With
    With cmdLower
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING + BUTTON_HEIGHT + BUTTON_SPACE
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
        .Visible = True
        .Enabled = True
    End With
    With cmdAdd
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = UserControl.Height - VERT_PADDING - BUTTON_HEIGHT - 2 * (BUTTON_HEIGHT + BUTTON_SPACE)
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
    With cmdRemove
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = UserControl.Height - VERT_PADDING - BUTTON_HEIGHT - (BUTTON_HEIGHT + BUTTON_SPACE)
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
    With cmdClear
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = UserControl.Height - VERT_PADDING - BUTTON_HEIGHT
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
Else
    With cmdRaise
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
        .Visible = False
        .Enabled = False
    End With
    With cmdLower
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING + BUTTON_HEIGHT + BUTTON_SPACE
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
        .Visible = False
        .Enabled = False
    End With
    With cmdAdd
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
    With cmdRemove
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING + BUTTON_HEIGHT + BUTTON_SPACE
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
    With cmdClear
        .Height = BUTTON_HEIGHT
        .Width = BUTTON_WIDTH
        .Top = VERT_PADDING + 2 * (BUTTON_HEIGHT + BUTTON_SPACE)
        .Left = UserControl.Width - BUTTON_WIDTH - HOR_PADDING
    End With
End If
    With lblTitle
        .Height = LIST_HEIGHT
        .Width = UserControl.Width - BUTTON_WIDTH
        .Top = VERT_PADDING
        .Left = HOR_PADDING
    End With
    With theList
        .Height = UserControl.Height - LIST_HEIGHT - 2 * VERT_PADDING
        .Width = UserControl.Width - BUTTON_WIDTH - TWIXT_SPACE
        .Top = LIST_HEIGHT + VERT_PADDING
        .Left = HOR_PADDING
    End With
    With shpBorder
        .Height = UserControl.Height
        .Width = UserControl.Width
        .Top = 0
        .Left = 0
    End With
End Sub

Private Sub UserControl_Show()
    UserControl_Resize
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
Dim Index As Integer
     PropBag.WriteProperty "Title", lblTitle.Caption
    Call PropBag.WriteProperty("Caption", lblTitle.Caption, "Label1")
'TO DO: The member you have mapped to contains an array of data.
'   You must supply the code to persist the array.  A prototype
'   line is shown next:
    Call PropBag.WriteProperty("List" & Index, theList.List(Index), "")
    Call PropBag.WriteProperty("ListIndex", theList.ListIndex, 0)
'    Call PropBag.WriteProperty("Prioritized", m_Prioritized, m_def_Prioritized)
'    Call PropBag.WriteProperty("Prioritized", m_Prioritized, m_def_Prioritized)
    Call PropBag.WriteProperty("Prioritized", m_Prioritized, m_def_Prioritized)
End Sub
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=lblTitle,lblTitle,-1,Caption
Public Property Get Caption() As String
Attribute Caption.VB_Description = "Returns/sets the text displayed in an object's title bar or below an object's icon."
    Caption = lblTitle.Caption
End Property

Public Property Let Caption(ByVal New_Caption As String)
    lblTitle.Caption() = New_Caption
    PropertyChanged "Caption"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,RemoveItem
Public Sub RemoveItem(ByVal Index As Integer)
Attribute RemoveItem.VB_Description = "Removes an item from a ListBox or ComboBox control or a row from a Grid control."
    theList.RemoveItem Index
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,AddItem
Public Sub AddItem(ByVal item As String, Optional ByVal Index As Variant)
Attribute AddItem.VB_Description = "Adds an item to a Listbox or ComboBox control or a row to a Grid control."
    theList.AddItem item, Index
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,Clear
Public Sub Clear()
Attribute Clear.VB_Description = "Clears the contents of a control or the system Clipboard."
    theList.Clear
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,List
Public Property Get List(ByVal Index As Integer) As String
Attribute List.VB_Description = "Returns/sets the items contained in a control's list portion."
    List = theList.List(Index)
End Property

Public Property Let List(ByVal Index As Integer, ByVal New_List As String)
    theList.List(Index) = New_List
    PropertyChanged "List"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,ListCount
Public Property Get ListCount() As Integer
Attribute ListCount.VB_Description = "Returns the number of items in the list portion of a control."
    ListCount = theList.ListCount
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,ListIndex
Public Property Get ListIndex() As Integer
Attribute ListIndex.VB_Description = "Returns/sets the index of the currently selected item in the control."
    ListIndex = theList.ListIndex
End Property

Public Property Let ListIndex(ByVal New_ListIndex As Integer)
    theList.ListIndex() = New_ListIndex
    PropertyChanged "ListIndex"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0
Public Function Contains(strTest As String) As Integer
    Contains = -1
    If theList.ListCount <= 0 Or strTest = "" Then Exit Function
    Dim i As Integer
    For i = 0 To theList.ListCount - 1
        If theList.List(i) = Left(strTest, Len(theList.List(i))) _
        Or strTest = Left(theList.List(i), Len(strTest)) Then
            Contains = i
            Exit Function
        End If
    Next i
End Function
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MemberInfo=0,3,0,1
'Public Property Get Prioritized() As Boolean
'    If Ambient.UserMode Then Err.Raise 393
'    Prioritized = m_Prioritized
'End Property
'
'Public Property Let Prioritized(ByVal New_Prioritized As Boolean)
'    If Ambient.UserMode Then Err.Raise 382
'    m_Prioritized = New_Prioritized
'    PropertyChanged "Prioritized"
'End Property

'Initialize Properties for User Control
Private Sub UserControl_InitProperties()
'    m_Prioritized = m_def_Prioritized
'    m_Prioritized = m_def_Prioritized
    m_Prioritized = m_def_Prioritized
    UserControl_Resize
End Sub
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MemberInfo=0,1,0,true
'Public Property Get Prioritized() As Boolean
'    Prioritized = m_Prioritized
'End Property
'
'Public Property Let Prioritized(ByVal New_Prioritized As Boolean)
'    If Ambient.UserMode Then Err.Raise 382
'    m_Prioritized = New_Prioritized
'    PropertyChanged "Prioritized"
'End Property
'
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,1,0,1
Public Property Get Prioritized() As Boolean
    Prioritized = m_Prioritized
End Property

Public Property Let Prioritized(ByVal New_Prioritized As Boolean)
    If Ambient.UserMode Then Err.Raise 382
    m_Prioritized = New_Prioritized
    PropertyChanged "Prioritized"
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=theList,theList,-1,MultiSelect
Public Property Get MultiSelect() As Integer
Attribute MultiSelect.VB_Description = "Returns/sets a value that determines whether a user can make multiple selections in a control."
    MultiSelect = theList.MultiSelect
End Property

