VERSION 5.00
Begin VB.Form Frm_Editor 
   Caption         =   "Scorch X Map Editor"
   ClientHeight    =   5940
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   6735
   LinkTopic       =   "Form1"
   ScaleHeight     =   5940
   ScaleWidth      =   6735
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   4800
      TabIndex        =   12
      Top             =   240
      Width           =   1455
   End
   Begin VB.TextBox Text4 
      Height          =   375
      Left            =   4320
      TabIndex        =   11
      Text            =   "1"
      Top             =   360
      Width           =   375
   End
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   3840
      TabIndex        =   10
      Text            =   "1"
      Top             =   360
      Width           =   375
   End
   Begin VB.TextBox txt_x2 
      Height          =   375
      Left            =   3360
      TabIndex        =   9
      Text            =   "1"
      Top             =   360
      Width           =   375
   End
   Begin VB.TextBox txt_x3 
      Height          =   375
      Left            =   2880
      TabIndex        =   8
      Text            =   "1"
      Top             =   360
      Width           =   375
   End
   Begin VB.PictureBox Picture1 
      Height          =   4800
      Left            =   120
      ScaleHeight     =   316
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   423
      TabIndex        =   6
      Top             =   960
      Width           =   6400
   End
   Begin VB.PictureBox pic_earth 
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   2520
      ScaleHeight     =   255
      ScaleWidth      =   255
      TabIndex        =   5
      Top             =   480
      Width           =   255
   End
   Begin VB.PictureBox pic_sky 
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   2520
      ScaleHeight     =   255
      ScaleWidth      =   255
      TabIndex        =   4
      Top             =   120
      Width           =   255
   End
   Begin VB.TextBox txt_earthcolor 
      Height          =   285
      Left            =   960
      TabIndex        =   3
      Text            =   "65280"
      Top             =   480
      Width           =   1455
   End
   Begin VB.TextBox txt_skycolor 
      Height          =   285
      Left            =   960
      TabIndex        =   2
      Text            =   "16711680"
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   " x^3      x^2     x^1      c"
      Height          =   255
      Left            =   2880
      TabIndex        =   7
      Top             =   120
      Width           =   2055
   End
   Begin VB.Label Label2 
      Caption         =   "Earth Color"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Sky Color"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   735
   End
   Begin VB.Menu mnu_file 
      Caption         =   "&File"
      Begin VB.Menu mnu_newmap 
         Caption         =   "&New Map"
      End
      Begin VB.Menu mnu_loadmap 
         Caption         =   "&Load Map"
      End
      Begin VB.Menu mnu_exit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "Frm_Editor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Call txt_earthcolor_Change
Call txt_skycolor_Change
End Sub

Private Sub mnu_exit_Click()
End
End Sub

Private Sub txt_earthcolor_Change()
txt_earthcolor.Text = RGBLimiter(txt_earthcolor.Text)
pic_earth.BackColor = txt_earthcolor.Text
End Sub

Private Sub txt_skycolor_Change()
txt_skycolor.Text = RGBLimiter(txt_skycolor.Text)
pic_sky.BackColor = txt_skycolor.Text
End Sub

Private Function RGBLimiter(temp) As String
If temp > 16777215 Or temp < 0 Then
    answer = MsgBox("Entered Value beyond bounds of RGB spectrum", vbCritical, "Limit Exceeded")
    RGBLimiter = 0
Else
    RGBLimiter = Int(temp)
End If
End Function
