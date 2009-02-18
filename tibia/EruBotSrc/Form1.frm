VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "decode"
      Height          =   615
      Left            =   720
      TabIndex        =   3
      Top             =   2040
      Width           =   1695
   End
   Begin VB.CommandButton Command1 
      Caption         =   "encode"
      Height          =   495
      Left            =   840
      TabIndex        =   2
      Top             =   1200
      Width           =   1335
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   600
      Width           =   2415
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   120
      Width           =   2415
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   495
      Left            =   2400
      TabIndex        =   4
      Top             =   1200
      Width           =   2175
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub filterSpaces()
    Replace Text1, " ", ""
    Replace Text2, " ", ""
End Sub

Private Sub Command1_Click()
    Dim key(15) As Byte
    Dim v(7) As Byte
    Dim i As Integer
    'filterSpaces
    v(0) = 1
    v(1) = 0
    v(2) = &H68
    For i = 3 To 7
        v(i) = 0
    Next i
    For i = 0 To 15
        key(i) = 1
    Next i
    EncodeXTEA v(0), key(0)
    Text1 = ""
    For i = 0 To 7
        Text1 = Text1 & Hex(v(i)) & " "
    Next i
    DecodeXTEA v(0), key(0)
    Text2 = ""
    For i = 0 To 7
        Text2 = Text2 & Hex(v(i)) & " "
    Next i
End Sub
