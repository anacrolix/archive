VERSION 5.00
Begin VB.Form frmLooter 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Looter"
   ClientHeight    =   5550
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   7065
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5550
   ScaleWidth      =   7065
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   375
      Left            =   3840
      TabIndex        =   18
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "Remove"
      Height          =   375
      Left            =   2520
      TabIndex        =   17
      Top             =   5040
      Width           =   975
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   5400
      TabIndex        =   16
      Top             =   5040
      Width           =   1095
   End
   Begin VB.CommandButton cmdNewItem 
      Caption         =   "<<<"
      Height          =   375
      Left            =   4920
      TabIndex        =   15
      Top             =   1800
      Width           =   495
   End
   Begin VB.CommandButton cmdReadAmmo 
      Caption         =   "Read from Ammo Slot"
      Height          =   255
      Left            =   4920
      TabIndex        =   14
      Top             =   1440
      Width           =   2055
   End
   Begin VB.TextBox txtItemValue 
      Height          =   285
      Left            =   4920
      TabIndex        =   12
      Top             =   1080
      Width           =   2055
   End
   Begin VB.TextBox txtItemName 
      Height          =   285
      Left            =   4920
      TabIndex        =   10
      Top             =   480
      Width           =   2055
   End
   Begin VB.CommandButton cmdLootToItems 
      Caption         =   ">>>"
      Height          =   375
      Left            =   2040
      TabIndex        =   9
      Top             =   2880
      Width           =   495
   End
   Begin VB.CommandButton cmdStackToItems 
      Caption         =   ">>>"
      Height          =   375
      Left            =   2040
      TabIndex        =   8
      Top             =   600
      Width           =   495
   End
   Begin VB.CommandButton cmdItemsToStack 
      Caption         =   "<<<"
      Height          =   375
      Left            =   2040
      TabIndex        =   7
      Top             =   240
      Width           =   495
   End
   Begin VB.CommandButton cmdItemsToLoot 
      Caption         =   "<<<"
      Height          =   375
      Left            =   2040
      TabIndex        =   6
      Top             =   3240
      Width           =   495
   End
   Begin VB.ListBox listItems 
      Height          =   4740
      Left            =   2520
      TabIndex        =   2
      Top             =   240
      Width           =   2295
   End
   Begin VB.ListBox listLoot 
      Height          =   2400
      Left            =   120
      TabIndex        =   1
      Top             =   2880
      Width           =   1935
   End
   Begin VB.ListBox listStack 
      Height          =   2400
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   1935
   End
   Begin VB.Label Label5 
      Caption         =   "Item Value"
      Height          =   255
      Left            =   4920
      TabIndex        =   13
      Top             =   840
      Width           =   2055
   End
   Begin VB.Label Label4 
      Caption         =   "Item Name"
      Height          =   255
      Left            =   4920
      TabIndex        =   11
      Top             =   240
      Width           =   2055
   End
   Begin VB.Label Label3 
      Caption         =   "Lootable Items"
      Height          =   255
      Left            =   2520
      TabIndex        =   5
      Top             =   0
      Width           =   2295
   End
   Begin VB.Label Label2 
      Caption         =   "Non-stackable Loot"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   2640
      Width           =   1935
   End
   Begin VB.Label Label1 
      Caption         =   "Stackable Loot"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   0
      Width           =   1935
   End
End
Attribute VB_Name = "frmLooter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClear_Click()
    listItems.Clear
End Sub

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdItemsToLoot_Click()
    ListToList listItems, listLoot
End Sub

Private Sub cmdItemsToStack_Click()
    ListToList listItems, listStack
End Sub

Private Sub cmdLootToItems_Click()
    ListToList listLoot, listItems
End Sub

Private Sub cmdNewItem_Click()
    Dim i As Integer, newItem As String
    
    If txtItemName <> "" And IsNumeric(txtItemValue) Then
        If CInt(txtItemValue) <= 0 Then GoTo Done
        newItem = txtItemName & "," & txtItemValue
        If ItemInListBox(newItem, listItems) = False And ItemInListBox(newItem, listStack) = False _
        And ItemInListBox(newItem, listLoot) = False Then listItems.AddItem newItem
    End If
Done:
    ClearNewItem
End Sub

Private Sub cmdReadAmmo_Click()
    txtItemValue = ReadMem(ADR_AMMO, 2)
End Sub

Private Sub cmdRemove_Click()
    Dim oldIndex As Integer
    If listItems.ListIndex >= 0 Then
        oldIndex = listItems.ListIndex
        listItems.RemoveItem listItems.ListIndex
        If oldIndex < listItems.ListCount Then listItems.ListIndex = oldIndex
    End If
End Sub

Private Sub cmdStackToItems_Click()
    ListToList listStack, listItems
End Sub

Private Function ItemInListBox(str As String, theList As ListBox) As Boolean
    Dim i As Integer, str1() As String, str2() As String, itemVal1, itemVal2 As Integer
    
    ItemInListBox = False
    If theList.ListCount = 0 Then Exit Function
    str1 = Split(str, ",")
    itemVal1 = CInt(str1(1))
    If UBound(str1) < 1 Then Exit Function
    
    For i = 0 To theList.ListCount - 1
        str2 = Split(theList.List(i), ",")
        itemVal2 = CInt(str2(1))
        
        If itemVal1 = itemVal2 Then
            ItemInListBox = True
            Exit Function
        End If
    Next i
End Function

Private Sub ClearNewItem()
    txtItemName = ""
    txtItemValue = ""
End Sub

Private Sub ListToList(fromList As ListBox, toList As ListBox)
    Dim str As String
    If fromList.ListIndex < 0 Then Exit Sub
    toList.AddItem fromList.List(fromList.ListIndex)
    fromList.RemoveItem (fromList.ListIndex)
End Sub

Public Function IsLootable(itemValue As Long) As Boolean
    Dim i As Integer, str() As String
    IsLootable = False
    If listLoot.ListCount > 0 Then
        For i = 0 To listLoot.ListCount - 1
            str = Split(listLoot.List(i), ",")
            If CInt(str(1)) = itemValue Then
                IsLootable = True
                Exit Function
            End If
        Next i
    End If
    If listStack.ListCount > 0 Then
        For i = 0 To listStack.ListCount - 1
            str = Split(listStack.List(i), ",")
            If CInt(str(1)) = itemValue Then
                IsLootable = True
                Exit Function
            End If
        Next i
    End If
End Function

Public Function IsStackable(itemValue As Long) As Boolean
    Dim i As Integer, str() As String
    IsStackable = False
    If listStack.ListCount > 0 Then
        For i = 0 To listStack.ListCount - 1
            str = Split(listStack.List(i), ",")
            If CInt(str(1)) = itemValue Then
                IsStackable = True
                Exit Function
            End If
        Next i
    End If
End Function
