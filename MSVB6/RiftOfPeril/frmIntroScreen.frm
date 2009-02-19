VERSION 5.00
Begin VB.Form frmIntroScreen 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   8835
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   10935
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   Moveable        =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   589
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   729
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin VB.CommandButton cmdIntro 
      Appearance      =   0  'Flat
      Caption         =   "E&xit"
      BeginProperty Font 
         Name            =   "Papyrus"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   750
      Index           =   3
      Left            =   6360
      TabIndex        =   3
      Top             =   5400
      Width           =   1500
   End
   Begin VB.CommandButton cmdIntro 
      Appearance      =   0  'Flat
      Caption         =   "&Load Existing Character"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Papyrus"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1095
      Index           =   2
      Left            =   3600
      TabIndex        =   2
      Top             =   5400
      Width           =   1860
   End
   Begin VB.CommandButton cmdIntro 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      Caption         =   "Create &New Character"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "Papyrus"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   750
      Index           =   1
      Left            =   1080
      MaskColor       =   &H00FFFFFF&
      TabIndex        =   1
      Top             =   5400
      UseMaskColor    =   -1  'True
      Width           =   1500
   End
   Begin VB.Label lblVersion 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Papyrus"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080C0FF&
      Height          =   315
      Left            =   120
      TabIndex        =   4
      Top             =   8400
      Width           =   630
   End
   Begin VB.Label lblGameTitle 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "Rift Of Peril"
      BeginProperty Font 
         Name            =   "Papyrus"
         Size            =   120
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   3255
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   8655
   End
End
Attribute VB_Name = "frmIntroScreen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdIntro_Click(Index As Integer)
    Select Case Index
        Case 1:
            Me.Hide
            NewGame
        Case 3: CleanExit
    End Select
End Sub

Private Sub Form_Initialize()
    Dim ButIntX, ButY, ButWidth, ButHeight As Integer
    ButWidth = 150
    ButHeight = 75
    ButIntX = (Screen.Width / Screen.TwipsPerPixelX - cmdIntro.UBound * ButWidth) / (cmdIntro.UBound + 1)
    ButY = 4 * (Screen.Height / Screen.TwipsPerPixelY - ButHeight) / 5
    For I = cmdIntro.LBound To cmdIntro.UBound
        With cmdIntro(I)
            .Left = I * ButIntX + (I - 1) * ButWidth
            .Top = ButY
            .Width = ButWidth
            .Height = ButHeight
        End With
    Next I
    With lblGameTitle
        .Left = 0
        .Top = 100
        .Width = Screen.Width / Screen.TwipsPerPixelX
        .Height = ButY - .Top
    End With
    With lblVersion
        .Caption = "By Matthew Joiner 2004 " & modData.SplashTitle
        .Left = 0
        .Top = (Screen.Height / Screen.TwipsPerPixelY) - .Height
    End With
End Sub

