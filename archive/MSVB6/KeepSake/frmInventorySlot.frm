VERSION 5.00
Object = "*\AprojUserControl.vbp"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4545
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6330
   LinkTopic       =   "Form1"
   ScaleHeight     =   4545
   ScaleWidth      =   6330
   StartUpPosition =   3  'Windows Default
   Begin Project1.InventorySlot InventorySlot1 
      DragMode        =   1  'Automatic
      Height          =   1815
      Left            =   1560
      TabIndex        =   0
      Top             =   600
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   3201
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
InventorySlot1.Caption = "Normal Sword xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
End Sub
