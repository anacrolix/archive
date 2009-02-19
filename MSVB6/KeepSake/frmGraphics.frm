VERSION 5.00
Begin VB.Form Graphics 
   Caption         =   "Form2"
   ClientHeight    =   10095
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10200
   LinkTopic       =   "Form2"
   Picture         =   "frmGraphics.frx":0000
   ScaleHeight     =   673
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   680
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox MapMaster 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   4560
      Left            =   2520
      Picture         =   "frmGraphics.frx":046A
      ScaleHeight     =   300
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   500
      TabIndex        =   4
      Top             =   1080
      Width           =   7560
   End
   Begin VB.PictureBox SplashMaster 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   810
      Left            =   5520
      Picture         =   "frmGraphics.frx":2529C
      ScaleHeight     =   50
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   150
      TabIndex        =   3
      Top             =   120
      Width           =   2310
   End
   Begin VB.PictureBox ObjectMaster 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   9060
      Left            =   120
      Picture         =   "frmGraphics.frx":2748E
      ScaleHeight     =   600
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   500
      TabIndex        =   2
      Top             =   960
      Width           =   7560
   End
   Begin VB.PictureBox CharacterMaster 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   810
      Left            =   120
      Picture         =   "frmGraphics.frx":70CAE
      ScaleHeight     =   50
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   50
      TabIndex        =   1
      Top             =   120
      Width           =   810
   End
   Begin VB.PictureBox MonsterMaster 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   810
      Left            =   960
      Picture         =   "frmGraphics.frx":71B18
      ScaleHeight     =   50
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   300
      TabIndex        =   0
      Top             =   120
      Width           =   4560
   End
End
Attribute VB_Name = "Graphics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
