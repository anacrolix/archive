VERSION 5.00
Begin VB.Form frmAuto 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Auto Actions"
   ClientHeight    =   3090
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4680
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkUHSelf 
      Caption         =   "Heal Self"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1335
   End
   Begin VB.CommandButton cmdHide 
      Caption         =   "Hide"
      Height          =   375
      Left            =   1800
      TabIndex        =   0
      Top             =   2400
      Width           =   975
   End
End
Attribute VB_Name = "frmAuto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub cmdHide_Click()
    Me.Hide
End Sub
