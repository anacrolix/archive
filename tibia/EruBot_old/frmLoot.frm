VERSION 5.00
Begin VB.Form frmLoot 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Loot"
   ClientHeight    =   5400
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   8010
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5400
   ScaleWidth      =   8010
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "New Item"
      Height          =   2295
      Left            =   5640
      TabIndex        =   18
      Top             =   600
      Width           =   2295
      Begin VB.CommandButton cmdNewNonStack 
         Caption         =   "Cant Stack"
         Height          =   375
         Left            =   1200
         TabIndex        =   25
         Top             =   1800
         Width           =   975
      End
      Begin VB.TextBox txtItemName 
         Height          =   285
         Left            =   120
         TabIndex        =   22
         Top             =   480
         Width           =   2055
      End
      Begin VB.TextBox txtItemValue 
         Height          =   285
         Left            =   120
         TabIndex        =   21
         Top             =   1080
         Width           =   2055
      End
      Begin VB.CommandButton cmdReadAmmo 
         Caption         =   "Read from Ammo Slot"
         Height          =   255
         Left            =   120
         TabIndex        =   20
         Top             =   1440
         Width           =   2055
      End
      Begin VB.CommandButton cmdNewStack 
         Caption         =   "Can Stack"
         Height          =   375
         Left            =   120
         TabIndex        =   19
         Top             =   1800
         Width           =   975
      End
      Begin VB.Label Label4 
         Caption         =   "Item Name"
         Height          =   255
         Left            =   120
         TabIndex        =   24
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label Label5 
         Caption         =   "Item Value"
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   840
         Width           =   2055
      End
   End
   Begin VB.CommandButton cmdStackAllToLootStack 
      Caption         =   "<<<"
      Height          =   375
      Left            =   2500
      TabIndex        =   16
      Top             =   480
      Width           =   495
   End
   Begin VB.CommandButton cmdLootStackAllToStack 
      Caption         =   ">>>"
      Height          =   375
      Left            =   2500
      TabIndex        =   15
      Top             =   2040
      Width           =   495
   End
   Begin VB.CommandButton cmdLootNonStackAllToNonStack 
      Caption         =   ">>>"
      Height          =   375
      Left            =   2500
      TabIndex        =   14
      Top             =   4680
      Width           =   495
   End
   Begin VB.CommandButton cmdNonStackAllToLootNonStack 
      Caption         =   "<<<"
      Height          =   375
      Left            =   2500
      TabIndex        =   13
      Top             =   3120
      Width           =   495
   End
   Begin VB.ListBox listNonStack 
      Height          =   2400
      Left            =   3000
      TabIndex        =   12
      Top             =   2880
      Width           =   2500
   End
   Begin VB.ListBox listStack 
      Height          =   2400
      Left            =   3000
      TabIndex        =   6
      Top             =   240
      Width           =   2500
   End
   Begin VB.CommandButton cmdLootNonStackToNonStack 
      Caption         =   ">"
      Height          =   375
      Left            =   2500
      TabIndex        =   5
      Top             =   4200
      Width           =   495
   End
   Begin VB.CommandButton cmdStackToLootStack 
      Caption         =   "<"
      Height          =   375
      Left            =   2500
      TabIndex        =   4
      Top             =   960
      Width           =   495
   End
   Begin VB.CommandButton cmdLootStackToStack 
      Caption         =   ">"
      Height          =   375
      Left            =   2500
      TabIndex        =   3
      Top             =   1560
      Width           =   495
   End
   Begin VB.CommandButton cmdNonStackToLootNonStack 
      Caption         =   "<"
      Height          =   375
      Left            =   2500
      TabIndex        =   2
      Top             =   3600
      Width           =   495
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   6240
      TabIndex        =   1
      Top             =   4920
      Width           =   1095
   End
   Begin VB.CommandButton cmdClearAll 
      Caption         =   "Clear All Items"
      Height          =   375
      Left            =   6720
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.ListBox listLootNonStack 
      Height          =   2400
      Left            =   0
      TabIndex        =   7
      Top             =   2880
      Width           =   2500
   End
   Begin VB.ListBox listLootStack 
      Height          =   2400
      Left            =   0
      TabIndex        =   8
      Top             =   240
      Width           =   2500
   End
   Begin VB.Label Label7 
      Caption         =   "Double click on an item to delete it from the list."
      Height          =   375
      Left            =   5640
      TabIndex        =   26
      Top             =   3000
      Width           =   2295
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "Non-stackable Items"
      Height          =   255
      Left            =   3000
      TabIndex        =   17
      Top             =   2640
      Width           =   2505
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Stackable Loot"
      Height          =   255
      Left            =   0
      TabIndex        =   11
      Top             =   0
      Width           =   2500
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Non-stackable Loot"
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   2640
      Width           =   2500
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Stackable Items"
      Height          =   255
      Left            =   3000
      TabIndex        =   9
      Top             =   0
      Width           =   2505
   End
End
Attribute VB_Name = "frmLoot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClearAll_Click()
    If MsgBox("This will remove all items from the form.", vbOKCancel, "Delete all items") = vbCancel Then Exit Sub
    listLootStack.Clear
    listLootNonStack.Clear
    listStack.Clear
    listNonStack.Clear
End Sub

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdLootNonStackAllToNonStack_Click()
    MoveAllItems listLootNonStack, listNonStack
End Sub

Private Sub cmdLootNonStackToNonStack_Click()
    MoveOneItem listLootNonStack, listNonStack
End Sub

Private Sub cmdLootStackAllToStack_Click()
    MoveAllItems listLootStack, listStack
End Sub

Private Sub cmdLootStackToStack_Click()
    MoveOneItem listLootStack, listStack
End Sub

Private Sub cmdNewNonStack_Click()
    If txtItemName = "" Then Exit Sub
    If IsNumeric(txtItemValue) = False Then Exit Sub
    If AlreadyListed(CLng(txtItemValue)) Then Exit Sub
    listNonStack.AddItem txtItemName & "," & txtItemValue
    ClearNewItem
End Sub

Private Sub cmdNewStack_Click()
    If txtItemName = "" Then Exit Sub
    If IsNumeric(txtItemValue) = False Then Exit Sub
    If AlreadyListed(CLng(txtItemValue)) Then Exit Sub
    listStack.AddItem txtItemName & "," & txtItemValue
    ClearNewItem
End Sub

Private Sub cmdNonStackAllToLootNonStack_Click()
    MoveAllItems listNonStack, listLootNonStack
End Sub

Private Sub cmdNonStackToLootNonStack_Click()
    MoveOneItem listNonStack, listLootNonStack
End Sub

Private Sub cmdReadAmmo_Click()
    txtItemValue = ReadMem(ADR_AMMO, 4)
End Sub

Private Sub ClearNewItem()
    txtItemName = ""
    txtItemValue = ""
End Sub

Private Function ListBoxContainsItem(lb As ListBox, id As Long) As Boolean
    Dim i As Long, tStr() As String
    If lb.ListCount <= 0 Then Exit Function
    For i = 0 To lb.ListCount - 1
        tStr = Split(lb.List(i), ",")
        If UBound(tStr) < 1 Then GoTo Continue
        If IsNumeric(tStr(1)) = False Then GoTo Continue
        If CLng(tStr(1)) <> id Then GoTo Continue
        ListBoxContainsItem = True
        Exit Function
Continue:
    Next i
End Function

Private Function AlreadyListed(id As Long) As Boolean
    If ListBoxContainsItem(listStack, id) Or ListBoxContainsItem(listNonStack, id) Or ListBoxContainsItem(listLootStack, id) Or ListBoxContainsItem(listLootNonStack, id) Then
        MsgBox "Item of value " & id & " already in list."
        ClearNewItem
        AlreadyListed = True
        Exit Function
    End If
End Function

Private Sub MoveOneItem(lbFrom As ListBox, lbTo As ListBox)
    If lbFrom.ListIndex < 0 Then Exit Sub
    lbTo.AddItem lbFrom.List(lbFrom.ListIndex)
    lbFrom.RemoveItem lbFrom.ListIndex
End Sub

Private Sub MoveAllItems(lbFrom As ListBox, lbTo As ListBox)
    Dim i As Long
    If lbFrom.ListCount < 1 Then Exit Sub
    For i = 0 To lbFrom.ListCount - 1
        lbTo.AddItem lbFrom.List(i)
    Next i
    lbFrom.Clear
End Sub

Private Sub DeleteItem(lb As ListBox)
    If lb.ListIndex >= 0 Then lb.RemoveItem lb.ListIndex
End Sub

Private Sub cmdStackAllToLootStack_Click()
    MoveAllItems listStack, listLootStack
End Sub

Private Sub cmdStackToLootStack_Click()
    MoveOneItem listStack, listLootStack
End Sub

Public Function IsLoot(id As Long) As Boolean
    If ListBoxContainsItem(listLootStack, id) Or ListBoxContainsItem(listLootNonStack, id) Then IsLoot = True
End Function

Public Function IsStackable(id As Long) As Boolean
    If ListBoxContainsItem(listStack, id) Or ListBoxContainsItem(listLootStack, id) Then IsStackable = True
End Function

Private Sub listLootNonStack_DblClick()
    DeleteItem listLootNonStack
End Sub

Private Sub listLootStack_DblClick()
    DeleteItem listLootStack
End Sub

Private Sub listNonStack_DblClick()
    DeleteItem listNonStack
End Sub

Private Sub listStack_DblClick()
    DeleteItem listStack
End Sub
