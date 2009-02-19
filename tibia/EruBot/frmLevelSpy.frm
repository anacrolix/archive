VERSION 5.00
Begin VB.Form frmLevelSpy 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Level Spy"
   ClientHeight    =   2865
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   2280
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2865
   ScaleWidth      =   2280
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   720
      TabIndex        =   8
      Top             =   2400
      Width           =   855
   End
   Begin VB.CommandButton cmdNorth 
      Caption         =   "North"
      Height          =   615
      Left            =   840
      TabIndex        =   5
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdEast 
      Caption         =   "East"
      Height          =   615
      Left            =   1560
      TabIndex        =   4
      Top             =   840
      Width           =   615
   End
   Begin VB.CommandButton cmdSouth 
      Caption         =   "South"
      Height          =   615
      Left            =   840
      TabIndex        =   3
      Top             =   1560
      Width           =   615
   End
   Begin VB.CommandButton cmdWest 
      Caption         =   "West"
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   615
   End
   Begin VB.CommandButton cmdDown 
      Caption         =   "Down"
      Height          =   615
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdUp 
      Caption         =   "Up"
      Height          =   615
      Left            =   1560
      TabIndex        =   0
      Top             =   120
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   615
      Left            =   120
      TabIndex        =   7
      Top             =   1560
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   615
      Left            =   1560
      TabIndex        =   6
      Top             =   1560
      Width           =   615
   End
   Begin VB.Line Line4 
      X1              =   840
      X2              =   1320
      Y1              =   1080
      Y2              =   1080
   End
   Begin VB.Line Line3 
      X1              =   1200
      X2              =   1080
      Y1              =   1440
      Y2              =   1200
   End
   Begin VB.Line Line2 
      X1              =   960
      X2              =   1080
      Y1              =   1440
      Y2              =   1200
   End
   Begin VB.Line Line1 
      X1              =   1080
      X2              =   1080
      Y1              =   1080
      Y2              =   1200
   End
   Begin VB.Shape Shape1 
      Height          =   255
      Left            =   960
      Shape           =   2  'Oval
      Top             =   840
      Width           =   255
   End
End
Attribute VB_Name = "frmLevelSpy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdDown_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_Z, 2)
    If position + 1 > 15 Then Exit Sub
    position = position + 1
    WriteMem ADR_CHAR_Z + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_Z, position, 2
    WriteMem ADR_GFX_VIEW_Z, position, 2
End Sub

Private Sub cmdEast_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_X, 2)
    'If position + 1 > 15 Then Exit Sub
    position = position + 1
    WriteMem ADR_CHAR_X + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_X, position, 2
    WriteMem ADR_GFX_VIEW_X, position, 2
End Sub

Private Sub cmdNorth_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_Y, 2)
    'If position + 1 > 15 Then Exit Sub
    position = position - 1
    WriteMem ADR_CHAR_Y + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_Y, position, 2
    WriteMem ADR_GFX_VIEW_Y, position, 2
End Sub

Private Sub cmdSouth_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_Y, 2)
    'If position + 1 > 15 Then Exit Sub
    position = position + 1
    WriteMem ADR_CHAR_Y + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_Y, position, 2
    WriteMem ADR_GFX_VIEW_Y, position, 2
End Sub

Private Sub cmdUp_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_Z, 2)
    If position - 1 < 0 Then Exit Sub
    position = position - 1
    WriteMem ADR_CHAR_Z + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_Z, position, 2
    WriteMem ADR_GFX_VIEW_Z, position, 2
End Sub

Private Sub cmdWest_Click()
    Dim position As Long
    position = ReadMem(ADR_PLAYER_X, 2)
    'If position + 1 > 15 Then Exit Sub
    position = position - 1
    WriteMem ADR_CHAR_X + UserPos * SIZE_CHAR, position, 2
    WriteMem ADR_PLAYER_X, position, 2
    WriteMem ADR_GFX_VIEW_X, position, 2
End Sub
