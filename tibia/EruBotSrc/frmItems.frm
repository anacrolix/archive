VERSION 5.00
Begin VB.Form listLoot 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Items"
   ClientHeight    =   5400
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6840
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5400
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "New Item"
      Height          =   2295
      Left            =   4440
      TabIndex        =   18
      Top             =   0
      Width           =   2295
      Begin VB.CommandButton Command5 
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
      Begin VB.CommandButton cmdNewItem 
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
   Begin VB.CommandButton Command4 
      Caption         =   "<<<"
      Height          =   375
      Left            =   1920
      TabIndex        =   16
      Top             =   480
      Width           =   495
   End
   Begin VB.CommandButton Command3 
      Caption         =   ">>>"
      Height          =   375
      Left            =   1920
      TabIndex        =   15
      Top             =   2040
      Width           =   495
   End
   Begin VB.CommandButton Command2 
      Caption         =   ">>>"
      Height          =   375
      Left            =   1920
      TabIndex        =   14
      Top             =   4680
      Width           =   495
   End
   Begin VB.CommandButton Command1 
      Caption         =   "<<<"
      Height          =   375
      Left            =   1920
      TabIndex        =   13
      Top             =   3120
      Width           =   495
   End
   Begin VB.ListBox listNonStack 
      Height          =   2400
      Left            =   2400
      TabIndex        =   12
      Top             =   2880
      Width           =   1935
   End
   Begin VB.ListBox listLootStack 
      Height          =   2400
      Left            =   0
      TabIndex        =   8
      Top             =   240
      Width           =   1935
   End
   Begin VB.ListBox listLootNonStack 
      Height          =   2400
      Left            =   0
      TabIndex        =   7
      Top             =   2880
      Width           =   1935
   End
   Begin VB.ListBox listStack 
      Height          =   2400
      Left            =   2400
      TabIndex        =   6
      Top             =   240
      Width           =   1935
   End
   Begin VB.CommandButton cmdItemsToLoot 
      Caption         =   ">"
      Height          =   375
      Left            =   1920
      TabIndex        =   5
      Top             =   4200
      Width           =   495
   End
   Begin VB.CommandButton cmdItemsToStack 
      Caption         =   "<"
      Height          =   375
      Left            =   1920
      TabIndex        =   4
      Top             =   960
      Width           =   495
   End
   Begin VB.CommandButton cmdStackToItems 
      Caption         =   ">"
      Height          =   375
      Left            =   1920
      TabIndex        =   3
      Top             =   1560
      Width           =   495
   End
   Begin VB.CommandButton cmdLootToItems 
      Caption         =   "<"
      Height          =   375
      Left            =   1920
      TabIndex        =   2
      Top             =   3600
      Width           =   495
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   5040
      TabIndex        =   1
      Top             =   4920
      Width           =   1095
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear All Items"
      Height          =   375
      Left            =   5520
      TabIndex        =   0
      Top             =   2400
      Width           =   1215
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "Non-stackable Items"
      Height          =   255
      Left            =   2400
      TabIndex        =   17
      Top             =   2640
      Width           =   1935
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Stackable Loot"
      Height          =   255
      Left            =   0
      TabIndex        =   11
      Top             =   0
      Width           =   1935
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Non-stackable Loot"
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   2640
      Width           =   1935
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      Caption         =   "Stackable Items"
      Height          =   255
      Left            =   2400
      TabIndex        =   9
      Top             =   0
      Width           =   1935
   End
End
Attribute VB_Name = "listLoot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

