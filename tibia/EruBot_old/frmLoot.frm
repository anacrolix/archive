VERSION 5.00
Begin VB.Form frmLooter 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Looter"
   ClientHeight    =   4095
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   7470
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4095
   ScaleWidth      =   7470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
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
   Begin VB.CommandButton cmdStackToLoot 
      Caption         =   ">>>"
      Height          =   375
      Left            =   2040
      TabIndex        =   8
      Top             =   600
      Width           =   495
   End
   Begin VB.CommandButton cmdToStack 
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
      Height          =   3375
      Left            =   2520
      TabIndex        =   2
      Top             =   240
      Width           =   2295
   End
   Begin VB.ListBox listLoot 
      Height          =   2010
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Width           =   1935
   End
   Begin VB.ListBox listStack 
      Height          =   1035
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
      Top             =   1320
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

Private Sub cmdNewItem_Click()
    Dim i As Integer, str() As String
    
    If txtItemName <> "" And IsNumeric(txtItemValue) Then
        For i = 0 To listItems.ListCount - 1
            str = Split(listItems.List(i), ",")
            If str(0) = txtItemName Or CInt(str(1)) = CInt(txtItemValue) Then
                ClearNewItem
                Exit Sub
            End If
        Next i
        listItems.AddItem txtItemName & "," & txtItemValue
        ClearNewItem
    End If
End Sub

Private Sub ClearNewItem()
    txtItemName = ""
    txtItemValue = ""
End Sub

Private Sub cmdReadAmmo_Click()
    txtItemValue = ReadMem(adr_slot_ammo, 2)
End Sub
