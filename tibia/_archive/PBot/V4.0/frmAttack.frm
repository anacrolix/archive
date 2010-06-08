VERSION 5.00
Begin VB.Form frmAttack 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Attack Reaction"
   ClientHeight    =   4575
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4140
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4575
   ScaleWidth      =   4140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   0
      Left            =   3120
      TabIndex        =   41
      Top             =   210
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   0
      Left            =   1920
      TabIndex        =   40
      Top             =   240
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   0
      Left            =   1560
      TabIndex        =   39
      Top             =   240
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   0
      Left            =   360
      TabIndex        =   38
      Top             =   240
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Ok"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2040
      TabIndex        =   37
      Top             =   4080
      Width           =   975
   End
   Begin VB.CommandButton Command2 
      Caption         =   "&Setup"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   960
      TabIndex        =   36
      Top             =   4080
      Width           =   975
   End
   Begin VB.Timer tmrTime 
      Left            =   3720
      Top             =   0
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   0
      Left            =   720
      TabIndex        =   35
      Top             =   240
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   1
      Left            =   360
      TabIndex        =   34
      Top             =   750
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   1
      Left            =   1560
      TabIndex        =   33
      Top             =   750
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   1
      Left            =   1920
      TabIndex        =   32
      Top             =   750
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   1
      Left            =   3120
      TabIndex        =   31
      Top             =   720
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   1
      Left            =   720
      TabIndex        =   30
      Top             =   750
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   2
      Left            =   360
      TabIndex        =   29
      Top             =   1230
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   2
      Left            =   1560
      TabIndex        =   28
      Top             =   1230
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   2
      Left            =   1920
      TabIndex        =   27
      Top             =   1230
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   2
      Left            =   3120
      TabIndex        =   26
      Top             =   1200
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   2
      Left            =   720
      TabIndex        =   25
      Top             =   1230
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   3
      Left            =   360
      TabIndex        =   24
      Top             =   1710
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   3
      Left            =   1560
      TabIndex        =   23
      Top             =   1710
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   3
      Left            =   1920
      TabIndex        =   22
      Top             =   1710
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   3
      Left            =   3120
      TabIndex        =   21
      Top             =   1680
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   3
      Left            =   720
      TabIndex        =   20
      Top             =   1710
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   4
      Left            =   360
      TabIndex        =   19
      Top             =   2190
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   4
      Left            =   1560
      TabIndex        =   18
      Top             =   2190
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   4
      Left            =   1920
      TabIndex        =   17
      Top             =   2190
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   4
      Left            =   3120
      TabIndex        =   16
      Top             =   2160
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   4
      Left            =   720
      TabIndex        =   15
      Top             =   2190
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   5
      Left            =   360
      TabIndex        =   14
      Top             =   2670
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   5
      Left            =   1560
      TabIndex        =   13
      Top             =   2670
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   5
      Left            =   1920
      TabIndex        =   12
      Top             =   2670
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   5
      Left            =   3120
      TabIndex        =   11
      Top             =   2640
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   5
      Left            =   720
      TabIndex        =   10
      Top             =   2670
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   6
      Left            =   360
      TabIndex        =   9
      Top             =   3150
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   6
      Left            =   1560
      TabIndex        =   8
      Top             =   3150
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   6
      Left            =   1920
      TabIndex        =   7
      Top             =   3150
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   6
      Left            =   3120
      TabIndex        =   6
      Top             =   3120
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   6
      Left            =   720
      TabIndex        =   5
      Top             =   3150
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.TextBox MoveX 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   7
      Left            =   360
      TabIndex        =   4
      Top             =   3630
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Pausetxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   7
      Left            =   1560
      TabIndex        =   3
      Top             =   3630
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox MoveY 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   7
      Left            =   1920
      TabIndex        =   2
      Top             =   3630
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton btnHere 
      Caption         =   "Here"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   7
      Left            =   3120
      TabIndex        =   1
      Top             =   3600
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox Talktxt 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Index           =   7
      Left            =   720
      TabIndex        =   0
      Top             =   3630
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   97
      Top             =   240
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   96
      Top             =   240
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   1680
      TabIndex        =   95
      Top             =   240
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   0
      Left            =   1440
      TabIndex        =   94
      Top             =   240
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   600
      TabIndex        =   93
      Top             =   240
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   0
      Left            =   2520
      TabIndex        =   92
      Top             =   240
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   0
      Left            =   960
      TabIndex        =   91
      Top             =   240
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   1
      Left            =   960
      TabIndex        =   90
      Top             =   750
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   2520
      TabIndex        =   89
      Top             =   750
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   600
      TabIndex        =   88
      Top             =   750
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   1
      Left            =   1440
      TabIndex        =   87
      Top             =   750
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   1680
      TabIndex        =   86
      Top             =   750
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   85
      Top             =   750
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   84
      Top             =   750
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   2
      Left            =   960
      TabIndex        =   83
      Top             =   1230
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   2520
      TabIndex        =   82
      Top             =   1230
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   600
      TabIndex        =   81
      Top             =   1230
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   2
      Left            =   1440
      TabIndex        =   80
      Top             =   1230
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   1680
      TabIndex        =   79
      Top             =   1230
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   78
      Top             =   1230
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   77
      Top             =   1230
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   3
      Left            =   960
      TabIndex        =   76
      Top             =   1710
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   2520
      TabIndex        =   75
      Top             =   1710
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   600
      TabIndex        =   74
      Top             =   1710
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   3
      Left            =   1440
      TabIndex        =   73
      Top             =   1710
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   1680
      TabIndex        =   72
      Top             =   1710
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   71
      Top             =   1710
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   3
      Left            =   240
      TabIndex        =   70
      Top             =   1710
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   4
      Left            =   960
      TabIndex        =   69
      Top             =   2190
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   2520
      TabIndex        =   68
      Top             =   2190
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   600
      TabIndex        =   67
      Top             =   2190
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   4
      Left            =   1440
      TabIndex        =   66
      Top             =   2190
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   1680
      TabIndex        =   65
      Top             =   2190
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   120
      TabIndex        =   64
      Top             =   2190
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   4
      Left            =   240
      TabIndex        =   63
      Top             =   2190
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   5
      Left            =   960
      TabIndex        =   62
      Top             =   2670
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   2520
      TabIndex        =   61
      Top             =   2670
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   600
      TabIndex        =   60
      Top             =   2670
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   5
      Left            =   1440
      TabIndex        =   59
      Top             =   2670
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   1680
      TabIndex        =   58
      Top             =   2670
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   120
      TabIndex        =   57
      Top             =   2670
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   5
      Left            =   240
      TabIndex        =   56
      Top             =   2670
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   6
      Left            =   960
      TabIndex        =   55
      Top             =   3150
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   2520
      TabIndex        =   54
      Top             =   3150
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   600
      TabIndex        =   53
      Top             =   3150
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   6
      Left            =   1440
      TabIndex        =   52
      Top             =   3150
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   1680
      TabIndex        =   51
      Top             =   3150
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   120
      TabIndex        =   50
      Top             =   3150
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   6
      Left            =   240
      TabIndex        =   49
      Top             =   3150
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Label SBotlbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Stop Bot-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   7
      Left            =   960
      TabIndex        =   48
      Top             =   3630
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label PauseSec 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "seconds."
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   2520
      TabIndex        =   47
      Top             =   3630
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label PauseBeg 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Pause for"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   600
      TabIndex        =   46
      Top             =   3630
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.Label Beeplbl 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "-Beep-"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Index           =   7
      Left            =   1440
      TabIndex        =   45
      Top             =   3630
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label MoveYl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Y:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   1680
      TabIndex        =   44
      Top             =   3630
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label MoveXl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "X:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   120
      TabIndex        =   43
      Top             =   3630
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Talklbl 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Say:"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   7
      Left            =   240
      TabIndex        =   42
      Top             =   3630
      Visible         =   0   'False
      Width           =   375
   End
End
Attribute VB_Name = "frmAttack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnHere_Click(Index As Integer)
    Dim X As Long
    Dim Y As Long
    Memory Thwnd, adrXPos, X, 2, RMem
    Memory Thwnd, adrYPos, Y, 2, RMem
    MoveX(Index).Text = X
    MoveY(Index).Text = Y
End Sub

Private Sub Command1_Click()
    Me.Hide
End Sub

Private Sub Command2_Click()
    frmAttackSetup.Show
End Sub

Private Sub tmrTime_Timer()
        Dim C1 As Integer
    Dim LongX As Long
    Dim LongY As Long
    Memory Thwnd, adrHitP, HitPoints, 2, RMem
    If HitPoints > HitPoints2 Then HitPoints2 = HitPoints
    If HitPoints < HitPoints2 Then
        For C1 = 0 To 7
            If frmAttackSetup.Combo1(C1).Text = "Move To" Then
                LongX = MoveX(C1).Text
                LongY = MoveY(C1).Text
                Memory Thwnd, adrXGo, LongX, 2, WMem
                Memory Thwnd, adrYGo, LongY, 2, WMem
                Memory Thwnd, adrGo + (CharDist * UserPos), 1, 2, WMem
            ElseIf frmAttackSetup.Combo1(C1).Text = "Talk" Then
                SayStuff Talktxt(C1).Text
            ElseIf frmAttackSetup.Combo1(C1).Text = "Pause" Then
                Pause (Pausetxt(C1).Text * 1000)
            ElseIf frmAttackSetup.Combo1(C1).Text = "Stop Bot" Then
                frmMain.mnuActive.Checked = False
                Valid
            ElseIf frmAttackSetup.Combo1(C1).Text = "Beep" Then
                Beep 600, 200
            End If
        Next
        HitPoints2 = HitPoints
    End If
End Sub
