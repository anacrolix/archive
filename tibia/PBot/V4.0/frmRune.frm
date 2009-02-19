VERSION 5.00
Begin VB.Form frmRune 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Rune Maker"
   ClientHeight    =   4635
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5310
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9.75
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   309
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   354
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.OptionButton optAdv 
      BackColor       =   &H00000000&
      Caption         =   "Advanced"
      ForeColor       =   &H000000C0&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   120
      Value           =   -1  'True
      Width           =   1335
   End
   Begin VB.ListBox listSpell 
      Height          =   285
      ItemData        =   "frmRune.frx":0000
      Left            =   0
      List            =   "frmRune.frx":0055
      TabIndex        =   92
      Top             =   0
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.ListBox listMana 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1033
         SubFormatType   =   1
      EndProperty
      Height          =   285
      ItemData        =   "frmRune.frx":01DC
      Left            =   0
      List            =   "frmRune.frx":0231
      TabIndex        =   91
      Top             =   0
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.TextBox txtRMana 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1033
         SubFormatType   =   1
      EndProperty
      Height          =   330
      Left            =   4590
      TabIndex        =   90
      Text            =   "0"
      Top             =   4170
      Width           =   600
   End
   Begin VB.ComboBox cmbSpell 
      Height          =   345
      Index           =   15
      ItemData        =   "frmRune.frx":02B3
      Left            =   600
      List            =   "frmRune.frx":0308
      Style           =   2  'Dropdown List
      TabIndex        =   87
      Top             =   3720
      Width           =   2535
   End
   Begin VB.VScrollBar vscrRune 
      Height          =   2025
      Left            =   5040
      Max             =   40
      TabIndex        =   84
      Top             =   750
      Width           =   255
   End
   Begin VB.Frame fraOuter 
      Caption         =   "Frame1"
      Height          =   2010
      Left            =   120
      TabIndex        =   5
      Top             =   750
      Width           =   4935
      Begin VB.Frame fraInner 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Caption         =   "Frame1"
         Height          =   6015
         Left            =   0
         TabIndex        =   6
         Top             =   0
         Width           =   4935
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   0
            ItemData        =   "frmRune.frx":0487
            Left            =   480
            List            =   "frmRune.frx":04DC
            Style           =   2  'Dropdown List
            TabIndex        =   36
            Top             =   60
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   0
            Left            =   4320
            TabIndex        =   35
            Text            =   "15"
            Top             =   60
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   1
            ItemData        =   "frmRune.frx":065B
            Left            =   480
            List            =   "frmRune.frx":06B0
            Style           =   2  'Dropdown List
            TabIndex        =   34
            Top             =   455
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   1
            Left            =   4320
            TabIndex        =   33
            Text            =   "15"
            Top             =   450
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   2
            ItemData        =   "frmRune.frx":082F
            Left            =   480
            List            =   "frmRune.frx":0884
            Style           =   2  'Dropdown List
            TabIndex        =   32
            Top             =   855
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   2
            Left            =   4320
            TabIndex        =   31
            Text            =   "15"
            Top             =   855
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   3
            ItemData        =   "frmRune.frx":0A03
            Left            =   480
            List            =   "frmRune.frx":0A58
            Style           =   2  'Dropdown List
            TabIndex        =   30
            Top             =   1245
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   3
            Left            =   4320
            TabIndex        =   29
            Text            =   "15"
            Top             =   1245
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   4
            ItemData        =   "frmRune.frx":0BD7
            Left            =   480
            List            =   "frmRune.frx":0C2C
            Style           =   2  'Dropdown List
            TabIndex        =   28
            Top             =   1635
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   4
            Left            =   4320
            TabIndex        =   27
            Text            =   "15"
            Top             =   1635
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   5
            ItemData        =   "frmRune.frx":0DAB
            Left            =   480
            List            =   "frmRune.frx":0E00
            Style           =   2  'Dropdown List
            TabIndex        =   26
            Top             =   2025
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   5
            Left            =   4320
            TabIndex        =   25
            Text            =   "15"
            Top             =   2025
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   6
            ItemData        =   "frmRune.frx":0F7F
            Left            =   480
            List            =   "frmRune.frx":0FD4
            Style           =   2  'Dropdown List
            TabIndex        =   24
            Top             =   2430
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   6
            Left            =   4320
            TabIndex        =   23
            Text            =   "15"
            Top             =   2430
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   7
            ItemData        =   "frmRune.frx":1153
            Left            =   480
            List            =   "frmRune.frx":11A8
            Style           =   2  'Dropdown List
            TabIndex        =   22
            Top             =   2820
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   7
            Left            =   4320
            TabIndex        =   21
            Text            =   "15"
            Top             =   2820
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   8
            ItemData        =   "frmRune.frx":1327
            Left            =   480
            List            =   "frmRune.frx":137C
            Style           =   2  'Dropdown List
            TabIndex        =   20
            Top             =   3210
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   8
            Left            =   4320
            TabIndex        =   19
            Text            =   "15"
            Top             =   3210
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   9
            ItemData        =   "frmRune.frx":14FB
            Left            =   480
            List            =   "frmRune.frx":1550
            Style           =   2  'Dropdown List
            TabIndex        =   18
            Top             =   3600
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   9
            Left            =   4320
            TabIndex        =   17
            Text            =   "15"
            Top             =   3600
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   10
            ItemData        =   "frmRune.frx":16CF
            Left            =   480
            List            =   "frmRune.frx":1724
            Style           =   2  'Dropdown List
            TabIndex        =   16
            Top             =   4005
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   10
            Left            =   4320
            TabIndex        =   15
            Text            =   "15"
            Top             =   4005
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   11
            ItemData        =   "frmRune.frx":18A3
            Left            =   480
            List            =   "frmRune.frx":18F8
            Style           =   2  'Dropdown List
            TabIndex        =   14
            Top             =   4395
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   11
            Left            =   4320
            TabIndex        =   13
            Text            =   "15"
            Top             =   4395
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   12
            ItemData        =   "frmRune.frx":1A77
            Left            =   480
            List            =   "frmRune.frx":1ACC
            Style           =   2  'Dropdown List
            TabIndex        =   12
            Top             =   4785
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   12
            Left            =   4320
            TabIndex        =   11
            Text            =   "15"
            Top             =   4785
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   13
            ItemData        =   "frmRune.frx":1C4B
            Left            =   480
            List            =   "frmRune.frx":1CA0
            Style           =   2  'Dropdown List
            TabIndex        =   10
            Top             =   5175
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   13
            Left            =   4320
            TabIndex        =   9
            Text            =   "15"
            Top             =   5175
            Width           =   495
         End
         Begin VB.ComboBox cmbSpell 
            Height          =   345
            Index           =   14
            ItemData        =   "frmRune.frx":1E1F
            Left            =   480
            List            =   "frmRune.frx":1E74
            Style           =   2  'Dropdown List
            TabIndex        =   8
            Top             =   5580
            Width           =   2535
         End
         Begin VB.TextBox txtPriority 
            Alignment       =   2  'Center
            Height          =   330
            Index           =   14
            Left            =   4320
            TabIndex        =   7
            Text            =   "15"
            Top             =   5580
            Width           =   495
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "1."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   81
            Top             =   120
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   0
            Left            =   3000
            TabIndex        =   80
            Top             =   120
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   0
            Left            =   3600
            TabIndex        =   79
            Top             =   120
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "2."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   78
            Top             =   510
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   1
            Left            =   3000
            TabIndex        =   77
            Top             =   510
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   1
            Left            =   3600
            TabIndex        =   76
            Top             =   510
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "3."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   75
            Top             =   915
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   2
            Left            =   3000
            TabIndex        =   74
            Top             =   915
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   2
            Left            =   3600
            TabIndex        =   73
            Top             =   915
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "4."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   72
            Top             =   1305
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   3
            Left            =   3000
            TabIndex        =   71
            Top             =   1305
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   3
            Left            =   3600
            TabIndex        =   70
            Top             =   1305
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "5."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   4
            Left            =   120
            TabIndex        =   69
            Top             =   1695
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   4
            Left            =   3000
            TabIndex        =   68
            Top             =   1695
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   4
            Left            =   3600
            TabIndex        =   67
            Top             =   1695
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "6."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   5
            Left            =   120
            TabIndex        =   66
            Top             =   2085
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   5
            Left            =   3000
            TabIndex        =   65
            Top             =   2085
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   5
            Left            =   3600
            TabIndex        =   64
            Top             =   2085
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "7."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   6
            Left            =   120
            TabIndex        =   63
            Top             =   2490
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   6
            Left            =   3000
            TabIndex        =   62
            Top             =   2490
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   6
            Left            =   3600
            TabIndex        =   61
            Top             =   2490
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "8."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   7
            Left            =   120
            TabIndex        =   60
            Top             =   2880
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   7
            Left            =   3000
            TabIndex        =   59
            Top             =   2880
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   7
            Left            =   3600
            TabIndex        =   58
            Top             =   2880
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "9."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   8
            Left            =   120
            TabIndex        =   57
            Top             =   3270
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   8
            Left            =   3000
            TabIndex        =   56
            Top             =   3270
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   8
            Left            =   3600
            TabIndex        =   55
            Top             =   3270
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "10."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   9
            Left            =   120
            TabIndex        =   54
            Top             =   3660
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   9
            Left            =   3000
            TabIndex        =   53
            Top             =   3660
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   9
            Left            =   3600
            TabIndex        =   52
            Top             =   3660
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "11."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   10
            Left            =   120
            TabIndex        =   51
            Top             =   4065
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   10
            Left            =   3000
            TabIndex        =   50
            Top             =   4065
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   10
            Left            =   3600
            TabIndex        =   49
            Top             =   4065
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "12."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   11
            Left            =   120
            TabIndex        =   48
            Top             =   4455
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   11
            Left            =   3000
            TabIndex        =   47
            Top             =   4455
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   11
            Left            =   3600
            TabIndex        =   46
            Top             =   4455
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "13."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   12
            Left            =   120
            TabIndex        =   45
            Top             =   4845
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   12
            Left            =   3000
            TabIndex        =   44
            Top             =   4845
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   12
            Left            =   3600
            TabIndex        =   43
            Top             =   4845
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "14."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   13
            Left            =   120
            TabIndex        =   42
            Top             =   5235
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   13
            Left            =   3000
            TabIndex        =   41
            Top             =   5235
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   13
            Left            =   3600
            TabIndex        =   40
            Top             =   5235
            Width           =   615
         End
         Begin VB.Label lblConNum 
            Alignment       =   1  'Right Justify
            BackColor       =   &H00000000&
            BackStyle       =   0  'Transparent
            Caption         =   "15."
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   14
            Left            =   120
            TabIndex        =   39
            Top             =   5640
            Width           =   255
         End
         Begin VB.Label lblRunes 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "--/--"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   14
            Left            =   3000
            TabIndex        =   38
            Top             =   5640
            Width           =   615
         End
         Begin VB.Label lblTime 
            Alignment       =   2  'Center
            BackStyle       =   0  'Transparent
            Caption         =   "0:00"
            ForeColor       =   &H000000FF&
            Height          =   255
            Index           =   14
            Left            =   3600
            TabIndex        =   37
            Top             =   5640
            Width           =   615
         End
      End
   End
   Begin VB.CheckBox chkLWF 
      BackColor       =   &H00000000&
      Caption         =   "Log When Finished"
      ForeColor       =   &H000000FF&
      Height          =   615
      Left            =   3720
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   3360
      Width           =   1095
   End
   Begin VB.CommandButton btnOk 
      Caption         =   "&Ok"
      Height          =   375
      Left            =   1920
      TabIndex        =   2
      Top             =   4200
      Width           =   1215
   End
   Begin VB.OptionButton optSim 
      BackColor       =   &H00000000&
      Caption         =   "Simple"
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Timer tmrTime 
      Left            =   4920
      Top             =   0
   End
   Begin VB.Timer BPCheck 
      Interval        =   1000
      Left            =   4800
      Top             =   120
   End
   Begin VB.Label lblRMana 
      BackStyle       =   0  'Transparent
      Caption         =   "Reserved Mana:"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   3240
      TabIndex        =   89
      Top             =   4200
      Width           =   1335
   End
   Begin VB.Label lblSpell2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Spell"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   600
      TabIndex        =   88
      Top             =   3360
      Width           =   2535
   End
   Begin VB.Label lblTTime 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Total Time:  0:00"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   3600
      TabIndex        =   86
      Top             =   2880
      Width           =   1575
   End
   Begin VB.Label lblSpell 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Spell"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   600
      TabIndex        =   85
      Top             =   480
      Width           =   2535
   End
   Begin VB.Label lblRune 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Runes"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   3120
      TabIndex        =   83
      Top             =   480
      Width           =   615
   End
   Begin VB.Label lblTime 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Time"
      ForeColor       =   &H000000FF&
      Height          =   255
      Index           =   15
      Left            =   3720
      TabIndex        =   82
      Top             =   480
      Width           =   615
   End
   Begin VB.Label lblPrior 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Priority"
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   4320
      TabIndex        =   3
      Top             =   480
      Width           =   855
   End
End
Attribute VB_Name = "frmRune"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private strMana(10) As Integer
Private strPrior(9) As Integer
Private RPos As Integer
Private Rune(9, 29) As Boolean

Private Sub BPCheck_Timer()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim isOpen As Long
    Dim TotalRune As Integer
    Dim items As Long
    Dim INum As Long
    TotalRune = 0
    For C1 = 0 To 14
        items = 0
        Memory Thwnd, adrBPOpen + (BPDist * C1), isOpen, 1, RMem
        If isOpen = 1 Then
            runes = 0
            Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
            For C2 = 0 To items - 1
                DoEvents
                Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), INum, 2, RMem
                If INum = &H8D4 Then
                    Rune(C1, C2) = True
                    runes = runes + 1
                    TotalRune = TotalRune + 1
                Else
                    Rune(C1, C2) = False
                End If
            Next
            For C2 = items To 19
                Rune(C1, C2) = False
            Next
            lblRunes(C1).Caption = runes & "/" & items
            If runes = 0 And lblConNum(C1).Enabled = True Then DisableBP C1
            If runes > 0 And lblConNum(C1).Enabled = False Then EnableBP C1
        Else
            If lblConNum(C1).Enabled = True Then DisableBP C1
        End If
    Next
    For C1 = 1 To 15
        For C2 = 0 To 8
            If txtPriority(C2) = C1 And cmbSpell(C2).Text <> "" Then Exit For
        Next
        If txtPriority(C2) = C1 And cmbSpell(C2).Text <> "" Then Exit For
    Next
    If TotalRune = 0 And chkLWF.Value = Checked Then
        chkLWF.Value = Unchecked
        frmMain.sckS.Close
        frmMain.sckC.Close
        frmMain.mnuActive.Checked = False
        Valid
    End If
    RPos = C2
End Sub

Private Function DisableBP(Index As Integer)
    lblConNum(Index).Enabled = False
    cmbSpell(Index).Enabled = False
    'cmbSpell(Index).Text = ""
    lblTime(Index).Enabled = False
    lblTime(Index).Caption = "0:00"
    lblRunes(Index).Enabled = False
    txtPriority(Index).Enabled = False
    txtPriority(Index).Text = "15"
End Function

Private Function EnableBP(Index As Integer)
    lblConNum(Index).Enabled = True
    cmbSpell(Index).Enabled = True
    lblTime(Index).Enabled = True
    lblRunes(Index).Enabled = True
    txtPriority(Index).Enabled = True
End Function

Private Sub btnOk_Click()
    Me.Hide
End Sub

Private Sub tmrTime_Timer()
    Dim C1 As Integer
    Dim C2 As Integer
    Dim C3 As Integer
    Dim C4 As Integer
    Dim items As Long
    Dim Items2 As Long
    Dim TempLong As Integer
    Dim TempNum As Integer
    Memory Thwnd, adrMana, Mana, 2, RMem
    If optAdv = True Then
        If cmbSpell(RPos).Text <> "" And lblConNum(RPos).Enabled = True Then
            TempNum = listMana.List(cmbSpell(RPos).ListIndex)
            TempNum = TempNum + txtRMana.Text
            If Mana >= TempNum Then
                For C1 = 0 To 20
                    If Rune(RPos, C1) = True Then Exit For
                Next
                If C1 <> 20 Then
                    Do
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                        MoveItem Items2, &H5, &H0, &HA, &H0, 1
                        Pause 200
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                    Loop Until Items2 = 0
                    TempLong = &H40 + RPos
                    MoveItem &H8D4, TempLong, C1, &H5, &H0, 1
                    MoveItem &H8D4, TempLong, C1, &H5, &H0, 1
                    C2 = 0
                    Do
                        Pause 100
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                        C2 = C2 + 1
                    Loop Until Items2 = &H8D4 Or C2 >= 15
                    If Items2 = &H8D4 Then
                        Do
                            SayStuff listSpell.List(cmbSpell(RPos).ListIndex)
                            Pause 300
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                        Loop Until Items2 <> &H8D4 Or Mana < listMana.List(cmbSpell(RPos).ListIndex)
                        Do
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                            Memory Thwnd, adrMana, Mana, 2, RMem
                            MoveItem Items2, &H5, &H0, TempLong, &H0, 1
                            Pause 200
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                        Loop Until Items2 = 0
                    End If
                    Do
                        Memory Thwnd, adrAmmo, Items2, 2, RMem
                        MoveItem Items2, &HA, &H0, &H5, &H0, 1
                        Pause 200
                        Memory Thwnd, adrAmmo, Items2, 2, RMem
                    Loop Until 0 = Items2
                    Pause 200
                End If
            End If
        End If
    Else
        If cmbSpell(15).Text <> "" Then
            If Mana >= listMana.List(cmbSpell(15).ListIndex) Then
                ltemp = 0
                For C1 = 0 To 9
                    Memory Thwnd, adrBPOpen + (BPDist * C1), items, 1, RMem
                    If items = 1 Then
                        Memory Thwnd, adrBPItems + (BPDist * C1), items, 1, RMem
                        For C2 = 0 To items - 1
                            Memory Thwnd, adrBPItem + (BPDist * C1) + (12 * C2), Items2, 2, RMem
                            If Items2 = &H8D4 Then Exit For
                        Next
                        If Items2 = &H8D4 Then Exit For
                    End If
                Next
                If ltemp = &H8D4 Then
                    Do
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                        MoveItem Items2, &H5, &H0, &HA, &H0, 1
                        Pause 200
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                    Loop Until Items2 = 0
                    TempLong = &H40 + C1
                    MoveItem &H8D4, TempLong, C2, &H5, &H0, 1
                    MoveItem &H8D4, TempLong, C2, &H5, &H0, 1
                    C3 = 0
                    Do
                        Pause 100
                        Memory Thwnd, adrRightHand, Items2, 2, RMem
                        C3 = C3 + 1
                    Loop Until Items2 = &H8D4 Or C3 >= 15
                    If Items2 = &H8D4 Then
                        Do
                            SayStuff listSpell.List(cmbSpell(15).ListIndex)
                            Pause 300
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                        Loop Until Items2 <> &H8D4 Or Mana < listMana.List(cmbSpell(15).ListIndex)
                        Do
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                            MoveItem Items2, &H5, &H0, TempLong, &H0, 1
                            Pause 200
                            Memory Thwnd, adrRightHand, Items2, 2, RMem
                        Loop Until Items2 = 0
                    End If
                    Do
                        Memory Thwnd, adrAmmo, Items2, 2, RMem
                        MoveItem Items2, &HA, &H0, &H5, &H0, 1
                        Pause 200
                        Memory Thwnd, adrAmmo, Items2, 2, RMem
                    Loop Until 0 = Items2
                    Pause 200
                End If
            End If
        End If
    End If
End Sub

Private Sub vscrRune_Change()
    fraInner.Top = vscrRune.Value * -98
End Sub
