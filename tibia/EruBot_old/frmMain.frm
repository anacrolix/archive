VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EruBot"
   ClientHeight    =   11745
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   13035
   ForeColor       =   &H00000000&
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   783
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   869
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrLag 
      Interval        =   1
      Left            =   9000
      Top             =   11160
   End
   Begin VB.CheckBox chkMainLag 
      BackColor       =   &H00000000&
      Caption         =   "Lag the Mofo's"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   8880
      Style           =   1  'Graphical
      TabIndex        =   208
      Top             =   10200
      Width           =   1815
   End
   Begin VB.Frame fraFluid 
      Caption         =   "Fluid Options"
      Height          =   1455
      Left            =   10920
      TabIndex        =   199
      Top             =   9720
      Width           =   2055
      Begin VB.CheckBox chkMainFluid 
         BackColor       =   &H00000000&
         Caption         =   "Mana Fluid"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   204
         Top             =   240
         Width           =   1815
      End
      Begin VB.TextBox txtFluidHP 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   201
         Text            =   "1200"
         Top             =   720
         Width           =   615
      End
      Begin VB.TextBox txtFluidMana 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   200
         Text            =   "300"
         Top             =   1080
         Width           =   615
      End
      Begin VB.Label Label23 
         Alignment       =   1  'Right Justify
         Caption         =   "HP <"
         Height          =   255
         Left            =   120
         TabIndex        =   203
         Top             =   720
         Width           =   1095
      End
      Begin VB.Label Label20 
         Alignment       =   1  'Right Justify
         Caption         =   "Mana <"
         Height          =   255
         Left            =   120
         TabIndex        =   202
         Top             =   1080
         Width           =   1095
      End
   End
   Begin VB.Frame fraSwitch 
      Caption         =   "Switch Options"
      Height          =   2655
      Left            =   2280
      TabIndex        =   117
      Top             =   9000
      Width           =   2055
      Begin VB.CheckBox chkSwitchRemoveRing 
         Caption         =   "Remove if cond=0"
         Height          =   255
         Left            =   120
         TabIndex        =   206
         Top             =   2280
         Width           =   1815
      End
      Begin VB.CheckBox chkMainSwitch 
         BackColor       =   &H00000000&
         Caption         =   "Switch"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   128
         Top             =   240
         Width           =   1815
      End
      Begin VB.TextBox txtSwitchRingHP 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   125
         Text            =   "0"
         Top             =   1920
         Width           =   615
      End
      Begin VB.TextBox txtSwitchNeckHP 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   123
         Text            =   "600"
         Top             =   1080
         Width           =   615
      End
      Begin VB.TextBox txtSwitchNeck 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1200
         TabIndex        =   122
         Text            =   "3081"
         Top             =   720
         Width           =   735
      End
      Begin VB.CheckBox chkSwitchNeck 
         Caption         =   "Neck"
         Height          =   255
         Left            =   120
         TabIndex        =   121
         Top             =   720
         Value           =   1  'Checked
         Width           =   1095
      End
      Begin VB.TextBox txtSwitchRing 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1200
         TabIndex        =   120
         Text            =   "3052"
         Top             =   1560
         Width           =   735
      End
      Begin VB.CheckBox chkSwitchRing 
         Caption         =   "Ring"
         Height          =   255
         Left            =   120
         TabIndex        =   119
         Top             =   1560
         Width           =   1095
      End
      Begin VB.Line Line1 
         X1              =   1920
         X2              =   120
         Y1              =   1440
         Y2              =   1440
      End
      Begin VB.Label Label22 
         Alignment       =   1  'Right Justify
         Caption         =   "HP <"
         Height          =   255
         Left            =   720
         TabIndex        =   126
         Top             =   1920
         Width           =   495
      End
      Begin VB.Label Label21 
         Alignment       =   1  'Right Justify
         Caption         =   "HP <"
         Height          =   255
         Left            =   720
         TabIndex        =   124
         Top             =   1080
         Width           =   495
      End
   End
   Begin VB.CheckBox chkMainLight 
      BackColor       =   &H00000000&
      Caption         =   "Light"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   240
      Style           =   1  'Graphical
      TabIndex        =   115
      Top             =   7680
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin VB.Timer tmrTakeAction 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   8400
      Top             =   11640
   End
   Begin VB.Frame fraOutfit 
      Caption         =   "Outfit Options"
      Height          =   2055
      Left            =   4440
      TabIndex        =   113
      Top             =   9480
      Width           =   2055
      Begin VB.OptionButton optOutfitStayOnline 
         Caption         =   "Stay online"
         Height          =   255
         Left            =   120
         TabIndex        =   207
         Top             =   1680
         Value           =   -1  'True
         Width           =   1695
      End
      Begin VB.OptionButton optOutfitRandom 
         Caption         =   "Random"
         Height          =   255
         Left            =   120
         TabIndex        =   132
         Top             =   1440
         Width           =   1815
      End
      Begin VB.OptionButton optOutfitSuperboots 
         Caption         =   "Superboots"
         Height          =   255
         Left            =   120
         TabIndex        =   131
         Top             =   1200
         Width           =   1815
      End
      Begin VB.OptionButton optOutfitRainbow 
         Caption         =   "Rainbow"
         Height          =   255
         Left            =   120
         TabIndex        =   130
         Top             =   960
         Width           =   1815
      End
      Begin VB.OptionButton optOutfitSuperSonic 
         Caption         =   "Super Sonic"
         Height          =   255
         Left            =   120
         TabIndex        =   129
         Top             =   720
         Width           =   1815
      End
      Begin VB.CheckBox chkMainOutfit 
         BackColor       =   &H00000000&
         Caption         =   "Change Outfit"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   114
         Top             =   240
         Width           =   1815
      End
   End
   Begin VB.CheckBox chkMainRevealInvis 
      BackColor       =   &H00000000&
      Caption         =   "Reveal Invis"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   240
      Style           =   1  'Graphical
      TabIndex        =   108
      Top             =   7200
      Width           =   1815
   End
   Begin VB.Frame fraHealer 
      Caption         =   "Healer Options"
      Height          =   3855
      Left            =   8760
      TabIndex        =   96
      Top             =   6240
      Width           =   2055
      Begin VB.CheckBox chkHealerAnni 
         Caption         =   "Annihilator healing"
         Height          =   255
         Left            =   120
         TabIndex        =   205
         Top             =   3480
         Width           =   1815
      End
      Begin VB.CheckBox chkHealerUseAntidote 
         Caption         =   "Cast ""exana pox"""
         Height          =   255
         Left            =   120
         TabIndex        =   127
         Top             =   3240
         Width           =   1815
      End
      Begin VB.CheckBox chkHealerUseRune 
         Caption         =   "Use UH"
         Height          =   255
         Left            =   120
         TabIndex        =   107
         Top             =   2760
         Value           =   1  'Checked
         Width           =   1815
      End
      Begin VB.CheckBox chkHealerUseSpell 
         Caption         =   "Cast spells"
         Height          =   255
         Left            =   120
         TabIndex        =   106
         Top             =   2520
         Width           =   1815
      End
      Begin VB.OptionButton optHealerRuneFirst 
         Caption         =   "Rune first"
         Height          =   375
         Left            =   1080
         TabIndex        =   105
         Top             =   2040
         Value           =   -1  'True
         Width           =   855
      End
      Begin VB.OptionButton optHealerSpellFirst 
         Caption         =   "Spell first"
         Height          =   375
         Left            =   120
         TabIndex        =   104
         Top             =   2040
         Width           =   855
      End
      Begin VB.TextBox txtHealerMana 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   102
         Text            =   "40"
         Top             =   1680
         Width           =   615
      End
      Begin VB.TextBox txtHealerHP 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   100
         Text            =   "1000"
         Top             =   1320
         Width           =   615
      End
      Begin VB.TextBox txtHealerSpellWords 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   120
         TabIndex        =   99
         Text            =   "exura gran"
         Top             =   960
         Width           =   1815
      End
      Begin VB.CheckBox chkMainHealer 
         BackColor       =   &H00000000&
         Caption         =   "Healer"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   97
         Top             =   240
         Width           =   1815
      End
      Begin VB.Line Line2 
         X1              =   120
         X2              =   1920
         Y1              =   3120
         Y2              =   3120
      End
      Begin VB.Label Label18 
         Alignment       =   1  'Right Justify
         Caption         =   "Mana >="
         Height          =   255
         Left            =   120
         TabIndex        =   103
         Top             =   1680
         Width           =   1095
      End
      Begin VB.Label Label17 
         Alignment       =   1  'Right Justify
         Caption         =   "HP <="
         Height          =   255
         Left            =   120
         TabIndex        =   101
         Top             =   1320
         Width           =   1095
      End
      Begin VB.Label Label16 
         Caption         =   "Heal spell words"
         Height          =   255
         Left            =   120
         TabIndex        =   98
         Top             =   720
         Width           =   1815
      End
   End
   Begin VB.Frame fraLog 
      Caption         =   "Log Options"
      Height          =   5655
      Left            =   4440
      TabIndex        =   87
      Top             =   120
      Width           =   2055
      Begin VB.Frame fraAlertOpt 
         Caption         =   "Conditions"
         Height          =   4695
         Index           =   1
         Left            =   120
         TabIndex        =   133
         Top             =   840
         Width           =   1815
         Begin VB.CheckBox chkDetectBattlesign 
            Caption         =   "If battle sign"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   148
            Top             =   2160
            Width           =   1575
         End
         Begin VB.TextBox txtDetectProximity 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   1
            Left            =   840
            TabIndex        =   147
            Text            =   "0"
            Top             =   4320
            Width           =   495
         End
         Begin VB.TextBox txtDetectSoul 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   1
            Left            =   840
            TabIndex        =   146
            Text            =   "0"
            Top             =   3240
            Width           =   495
         End
         Begin VB.TextBox txtDetectSkulls 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   1320
            TabIndex        =   145
            Text            =   "0"
            Top             =   3960
            Width           =   375
         End
         Begin VB.TextBox txtDetectHP 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   720
            TabIndex        =   144
            Text            =   "0"
            Top             =   3600
            Width           =   735
         End
         Begin VB.CheckBox chkDetectNoBlanks 
            Caption         =   "If no blanks"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   143
            Top             =   1680
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectNoFood 
            Caption         =   "If no food"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   142
            Top             =   1920
            Width           =   975
         End
         Begin VB.TextBox txtDetectLevelsAbove 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   1
            Left            =   1200
            TabIndex        =   141
            Text            =   "0"
            Top             =   2880
            Width           =   495
         End
         Begin VB.TextBox txtDetectLevelsBelow 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   1
            Left            =   1200
            TabIndex        =   140
            Text            =   "0"
            Top             =   2520
            Width           =   495
         End
         Begin VB.CheckBox chkDetectIgnoreAll 
            Caption         =   "Ignore All"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   139
            Top             =   1440
            Width           =   975
         End
         Begin VB.CheckBox chkDetectGM 
            Caption         =   "Always on GM"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   138
            Top             =   480
            Value           =   1  'Checked
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreFriend 
            Caption         =   "Ignore Friend"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   137
            Top             =   1200
            Value           =   1  'Checked
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreMonster 
            Caption         =   "Ignore Monsters"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   136
            Top             =   960
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectIgnoreSafe 
            Caption         =   "Ignore Safe List"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   135
            Top             =   720
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectEnemy 
            Caption         =   "Always on Enemy"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   134
            Top             =   240
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.Label Label7 
            Caption         =   "Int. within             sq."
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   154
            Top             =   4320
            Width           =   1575
         End
         Begin VB.Label Label10 
            Caption         =   "If soul <"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   153
            Top             =   3240
            Width           =   975
         End
         Begin VB.Label Label5 
            Caption         =   "Skulls online >="
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   152
            Top             =   3960
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "If HP <"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   151
            Top             =   3600
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "Levels below:"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   150
            Top             =   2520
            Width           =   1215
         End
         Begin VB.Label Label2 
            Caption         =   "Levels above:"
            Height          =   255
            Index           =   1
            Left            =   120
            TabIndex        =   149
            Top             =   2880
            Width           =   1215
         End
      End
      Begin VB.CheckBox chkLogDisconnect 
         Caption         =   "Log by disconnect"
         Height          =   255
         Left            =   120
         TabIndex        =   118
         Top             =   600
         Width           =   1815
      End
      Begin VB.CheckBox chkMainLog 
         BackColor       =   &H00000000&
         Caption         =   "Log"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   89
         Top             =   240
         Width           =   1815
      End
   End
   Begin VB.Frame fraAlert 
      Caption         =   "Alert Options"
      Height          =   6015
      Left            =   8760
      TabIndex        =   64
      Top             =   120
      Width           =   2055
      Begin VB.CheckBox chkAlertDisconnect 
         Caption         =   "Alert if disconnected"
         Height          =   255
         Left            =   120
         TabIndex        =   116
         Top             =   840
         Value           =   1  'Checked
         Width           =   1815
      End
      Begin VB.CommandButton cmdStopAlert 
         Caption         =   "Stop Alert"
         Height          =   255
         Left            =   480
         TabIndex        =   95
         Top             =   600
         Width           =   1095
      End
      Begin VB.CheckBox chkMainAlert 
         BackColor       =   &H00000000&
         Caption         =   "Alert"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   88
         Top             =   240
         Width           =   1815
      End
      Begin VB.Frame fraAlertOpt 
         Caption         =   "Conditions"
         Height          =   4695
         Index           =   0
         Left            =   120
         TabIndex        =   65
         Top             =   1200
         Width           =   1815
         Begin VB.CheckBox chkDetectEnemy 
            Caption         =   "Always on Enemy"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   80
            Top             =   240
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.CheckBox chkDetectIgnoreSafe 
            Caption         =   "Ignore Safe List"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   79
            Top             =   720
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectIgnoreMonster 
            Caption         =   "Ignore Monsters"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   78
            Top             =   960
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectIgnoreFriend 
            Caption         =   "Ignore Friend"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   77
            Top             =   1200
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectGM 
            Caption         =   "Always on GM"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   76
            Top             =   480
            Value           =   1  'Checked
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreAll 
            Caption         =   "Ignore All"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   75
            Top             =   1440
            Width           =   975
         End
         Begin VB.TextBox txtDetectLevelsBelow 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   0
            Left            =   1200
            TabIndex        =   74
            Text            =   "0"
            Top             =   2520
            Width           =   495
         End
         Begin VB.TextBox txtDetectLevelsAbove 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   0
            Left            =   1200
            TabIndex        =   73
            Text            =   "0"
            Top             =   2880
            Width           =   495
         End
         Begin VB.CheckBox chkDetectNoFood 
            Caption         =   "If no food"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   72
            Top             =   1920
            Width           =   975
         End
         Begin VB.CheckBox chkDetectNoBlanks 
            Caption         =   "If no blanks"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   71
            Top             =   1680
            Width           =   1455
         End
         Begin VB.TextBox txtDetectHP 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   720
            TabIndex        =   70
            Text            =   "800"
            Top             =   3600
            Width           =   735
         End
         Begin VB.TextBox txtDetectSkulls 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   1320
            TabIndex        =   69
            Text            =   "0"
            Top             =   3960
            Width           =   375
         End
         Begin VB.TextBox txtDetectSoul 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   0
            Left            =   840
            TabIndex        =   68
            Text            =   "0"
            Top             =   3240
            Width           =   495
         End
         Begin VB.TextBox txtDetectProximity 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   0
            Left            =   840
            TabIndex        =   67
            Text            =   "0"
            Top             =   4320
            Width           =   495
         End
         Begin VB.CheckBox chkDetectBattlesign 
            Caption         =   "If battle sign"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   66
            Top             =   2160
            Width           =   1575
         End
         Begin VB.Label Label2 
            Caption         =   "Levels above:"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   86
            Top             =   2880
            Width           =   1215
         End
         Begin VB.Label Label3 
            Caption         =   "Levels below:"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   85
            Top             =   2520
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "If HP <"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   84
            Top             =   3600
            Width           =   735
         End
         Begin VB.Label Label5 
            Caption         =   "Skulls online >="
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   83
            Top             =   3960
            Width           =   1215
         End
         Begin VB.Label Label10 
            Caption         =   "If soul <"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   82
            Top             =   3240
            Width           =   975
         End
         Begin VB.Label Label7 
            Caption         =   "Int. within             sq."
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   81
            Top             =   4320
            Width           =   1575
         End
      End
   End
   Begin VB.Frame fraLoot 
      Caption         =   "Loot Options"
      Height          =   2175
      Left            =   2280
      TabIndex        =   62
      Top             =   6720
      Width           =   2055
      Begin VB.TextBox txtLootCap 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   112
         Text            =   "0"
         Top             =   1800
         Width           =   615
      End
      Begin VB.CheckBox chkLootThrowOnGround 
         Caption         =   "Throw non stackables on the ground"
         Height          =   615
         Left            =   120
         TabIndex        =   110
         Top             =   1200
         Value           =   1  'Checked
         Width           =   1695
      End
      Begin VB.CheckBox chkMainLoot 
         BackColor       =   &H00000000&
         Caption         =   "Loot"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   93
         Top             =   240
         Width           =   1815
      End
      Begin VB.CheckBox chkLootDontOpenCorpses 
         Caption         =   "Dont auto-open corpses"
         Height          =   375
         Left            =   120
         TabIndex        =   63
         Top             =   720
         Value           =   1  'Checked
         Width           =   1575
      End
      Begin VB.Label Label19 
         Alignment       =   1  'Right Justify
         Caption         =   "Alert at cap <"
         Height          =   255
         Left            =   120
         TabIndex        =   111
         Top             =   1800
         Width           =   1095
      End
   End
   Begin VB.Timer tmrLoot 
      Left            =   11520
      Top             =   12240
   End
   Begin VB.Timer tmrStatus 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   10560
      Top             =   12240
   End
   Begin VB.Timer tmrPing 
      Enabled         =   0   'False
      Interval        =   15000
      Left            =   10080
      Top             =   12240
   End
   Begin VB.Frame fraAttackOpt 
      Caption         =   "Attack Options"
      Height          =   2895
      Left            =   10920
      TabIndex        =   53
      Top             =   6720
      Width           =   2055
      Begin VB.CheckBox chkMainAttack 
         BackColor       =   &H00000000&
         Caption         =   "Attack"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   90
         Top             =   240
         Width           =   1815
      End
      Begin VB.CheckBox chkAttackTrain 
         Caption         =   "Only attack ghouls/monks"
         Height          =   375
         Left            =   120
         TabIndex        =   61
         Top             =   2400
         Width           =   1815
      End
      Begin VB.CommandButton cmdAttackSetExclusion 
         Caption         =   "Set Exclusion"
         Height          =   255
         Left            =   120
         TabIndex        =   60
         Top             =   1320
         Width           =   1815
      End
      Begin VB.CheckBox chkAttackIgnorePlayers 
         Caption         =   "Ignore players and friends"
         Height          =   375
         Left            =   120
         TabIndex        =   59
         Top             =   960
         Value           =   1  'Checked
         Width           =   1815
      End
      Begin VB.TextBox txtAttackHP 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1440
         TabIndex        =   58
         Text            =   "0"
         Top             =   2040
         Width           =   495
      End
      Begin VB.CheckBox chkAttackClosest 
         Caption         =   "Retarget to closest"
         Height          =   255
         Left            =   120
         TabIndex        =   56
         Top             =   720
         Value           =   1  'Checked
         Width           =   1695
      End
      Begin VB.TextBox txtAttackRange 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1440
         TabIndex        =   55
         Text            =   "1"
         Top             =   1680
         Width           =   495
      End
      Begin VB.Label Label15 
         Alignment       =   2  'Center
         Caption         =   "Stop if tar HP % < "
         Height          =   255
         Left            =   120
         TabIndex        =   57
         Top             =   2040
         Width           =   1335
      End
      Begin VB.Label Label14 
         Alignment       =   2  'Center
         Caption         =   "Attack within <="
         Height          =   255
         Left            =   120
         TabIndex        =   54
         Top             =   1680
         Width           =   1335
      End
   End
   Begin VB.CheckBox chkMainCavebot 
      BackColor       =   &H00000000&
      Caption         =   "Cavebot"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   6720
      Style           =   1  'Graphical
      TabIndex        =   52
      Top             =   360
      Width           =   1815
   End
   Begin VB.Frame fraCavebot 
      Caption         =   "Cavebot Options"
      Height          =   11415
      Left            =   6600
      TabIndex        =   32
      Top             =   120
      Width           =   2055
      Begin VB.Frame fraAlertOpt 
         Caption         =   "Conditions"
         Height          =   4695
         Index           =   3
         Left            =   120
         TabIndex        =   177
         Top             =   6600
         Width           =   1815
         Begin VB.CheckBox chkDetectBattlesign 
            Caption         =   "If battle sign"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   192
            Top             =   2160
            Width           =   1575
         End
         Begin VB.TextBox txtDetectProximity 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   3
            Left            =   840
            TabIndex        =   191
            Text            =   "4"
            Top             =   4320
            Width           =   495
         End
         Begin VB.TextBox txtDetectSoul 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   3
            Left            =   840
            TabIndex        =   190
            Text            =   "0"
            Top             =   3240
            Width           =   495
         End
         Begin VB.TextBox txtDetectSkulls 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   3
            Left            =   1320
            TabIndex        =   189
            Text            =   "0"
            Top             =   3960
            Width           =   375
         End
         Begin VB.TextBox txtDetectHP 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   3
            Left            =   720
            TabIndex        =   188
            Text            =   "900"
            Top             =   3600
            Width           =   735
         End
         Begin VB.CheckBox chkDetectNoBlanks 
            Caption         =   "If no blanks"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   187
            Top             =   1680
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectNoFood 
            Caption         =   "If no food"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   186
            Top             =   1920
            Width           =   975
         End
         Begin VB.TextBox txtDetectLevelsAbove 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   3
            Left            =   1200
            TabIndex        =   185
            Text            =   "0"
            Top             =   2880
            Width           =   495
         End
         Begin VB.TextBox txtDetectLevelsBelow 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   3
            Left            =   1200
            TabIndex        =   184
            Text            =   "0"
            Top             =   2520
            Width           =   495
         End
         Begin VB.CheckBox chkDetectIgnoreAll 
            Caption         =   "Ignore All"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   183
            Top             =   1440
            Width           =   975
         End
         Begin VB.CheckBox chkDetectGM 
            Caption         =   "Always on GM"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   182
            Top             =   480
            Value           =   1  'Checked
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreFriend 
            Caption         =   "Ignore Friend"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   181
            Top             =   1200
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreMonster 
            Caption         =   "Ignore Monsters"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   180
            Top             =   960
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectIgnoreSafe 
            Caption         =   "Ignore Safe List"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   179
            Top             =   720
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectEnemy 
            Caption         =   "Always on Enemy"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   178
            Top             =   240
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.Label Label7 
            Caption         =   "Int. within             sq."
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   198
            Top             =   4320
            Width           =   1575
         End
         Begin VB.Label Label10 
            Caption         =   "If soul <"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   197
            Top             =   3240
            Width           =   975
         End
         Begin VB.Label Label5 
            Caption         =   "Skulls online >="
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   196
            Top             =   3960
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "If HP <"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   195
            Top             =   3600
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "Levels below:"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   194
            Top             =   2520
            Width           =   1215
         End
         Begin VB.Label Label2 
            Caption         =   "Levels above:"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   193
            Top             =   2880
            Width           =   1215
         End
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "se"
         Height          =   375
         Index           =   3
         Left            =   840
         TabIndex        =   41
         Top             =   2760
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "s"
         Height          =   375
         Index           =   4
         Left            =   480
         TabIndex        =   42
         Top             =   2760
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "sw"
         Height          =   375
         Index           =   5
         Left            =   120
         TabIndex        =   43
         Top             =   2760
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "e"
         Height          =   375
         Index           =   2
         Left            =   840
         TabIndex        =   40
         Top             =   2400
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "c"
         Height          =   375
         Index           =   8
         Left            =   480
         TabIndex        =   46
         Top             =   2400
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "w"
         Height          =   375
         Index           =   6
         Left            =   120
         TabIndex        =   44
         Top             =   2400
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "ne"
         Height          =   375
         Index           =   1
         Left            =   840
         TabIndex        =   39
         Top             =   2040
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "n"
         Height          =   375
         Index           =   0
         Left            =   480
         TabIndex        =   38
         Top             =   2040
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotFunctionDirection 
         Caption         =   "nw"
         Height          =   375
         Index           =   7
         Left            =   120
         TabIndex        =   45
         Top             =   2040
         Width           =   375
      End
      Begin VB.CommandButton cmdCavebotSmoothWaypath 
         Caption         =   "Smooth"
         Height          =   375
         Left            =   1080
         TabIndex        =   50
         Top             =   1200
         Width           =   855
      End
      Begin VB.CommandButton cmdCavebotRemove 
         Caption         =   "Del"
         Height          =   375
         Left            =   1320
         TabIndex        =   49
         Top             =   2760
         Width           =   615
      End
      Begin VB.CommandButton cmdCavebotInsert 
         Caption         =   "Insert"
         Height          =   375
         Left            =   1320
         TabIndex        =   48
         Top             =   2280
         Width           =   615
      End
      Begin VB.CommandButton cmdCavebotClear 
         Caption         =   "Clear"
         Height          =   375
         Left            =   1320
         TabIndex        =   47
         Top             =   1800
         Width           =   615
      End
      Begin VB.ComboBox comboCavebotFunction 
         Height          =   315
         ItemData        =   "frmMain.frx":1CF2
         Left            =   120
         List            =   "frmMain.frx":1CFF
         TabIndex        =   37
         Top             =   1680
         Width           =   1095
      End
      Begin VB.CommandButton cmdCavebotSaveWaypath 
         Caption         =   "Save"
         Height          =   375
         Left            =   1080
         TabIndex        =   36
         Top             =   720
         Width           =   855
      End
      Begin VB.CommandButton cmdCavebotLoadWaypath 
         Caption         =   "Load"
         Height          =   375
         Left            =   120
         TabIndex        =   35
         Top             =   720
         Width           =   855
      End
      Begin VB.ListBox listCavebotWaypath 
         BeginProperty Font 
            Name            =   "MS Serif"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   3060
         ItemData        =   "frmMain.frx":1D1D
         Left            =   120
         List            =   "frmMain.frx":1D1F
         TabIndex        =   34
         Top             =   3480
         Width           =   1815
      End
      Begin VB.CheckBox chkCavebotTrace 
         Caption         =   "Append"
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   33
         Top             =   1200
         Width           =   855
      End
      Begin VB.Label Label6 
         Caption         =   "Waypoint list"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   51
         Top             =   3240
         Width           =   1455
      End
   End
   Begin VB.Timer tmrTrace 
      Interval        =   5
      Left            =   9600
      Top             =   12240
   End
   Begin VB.CheckBox chkMainEat 
      BackColor       =   &H00000000&
      Caption         =   "Eat"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   240
      Style           =   1  'Graphical
      TabIndex        =   31
      Top             =   6720
      Width           =   1815
   End
   Begin VB.Frame fraMagicOpt 
      Caption         =   "Magic Options"
      Height          =   3495
      Left            =   4440
      TabIndex        =   18
      Top             =   5880
      Width           =   2055
      Begin VB.CheckBox chkMainMagic 
         BackColor       =   &H00000000&
         Caption         =   "Magic"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   94
         Top             =   240
         Width           =   1815
      End
      Begin VB.TextBox txtSpellSoul 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   30
         Text            =   "0"
         Top             =   3120
         Width           =   615
      End
      Begin VB.TextBox txtSpellMana 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   29
         Text            =   "515"
         Top             =   2760
         Width           =   615
      End
      Begin VB.TextBox txtSpellWords 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   120
         TabIndex        =   25
         Text            =   "exura """"excess mana"
         Top             =   2400
         Width           =   1815
      End
      Begin VB.TextBox txtRuneSoul 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   24
         Text            =   "3"
         Top             =   1680
         Width           =   615
      End
      Begin VB.TextBox txtRuneMana 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   1320
         TabIndex        =   21
         Text            =   "600"
         Top             =   1320
         Width           =   615
      End
      Begin VB.TextBox txtRuneWords 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   120
         TabIndex        =   19
         Top             =   960
         Width           =   1815
      End
      Begin VB.Line Line4 
         X1              =   120
         X2              =   1920
         Y1              =   2040
         Y2              =   2040
      End
      Begin VB.Label Label13 
         Alignment       =   1  'Right Justify
         Caption         =   "Soul >="
         Height          =   255
         Left            =   120
         TabIndex        =   28
         Top             =   3120
         Width           =   1095
      End
      Begin VB.Label Label12 
         Alignment       =   1  'Right Justify
         Caption         =   "Mana >="
         Height          =   255
         Left            =   120
         TabIndex        =   27
         Top             =   2760
         Width           =   1095
      End
      Begin VB.Label Label11 
         Caption         =   "Spell words"
         Height          =   255
         Left            =   120
         TabIndex        =   26
         Top             =   2160
         Width           =   975
      End
      Begin VB.Label Label9 
         Alignment       =   1  'Right Justify
         Caption         =   "Soul >="
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   1680
         Width           =   1095
      End
      Begin VB.Label Label8 
         Alignment       =   1  'Right Justify
         Caption         =   "Mana >="
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   1320
         Width           =   1095
      End
      Begin VB.Label lblSpell 
         Caption         =   "Rune words"
         Height          =   255
         Left            =   120
         TabIndex        =   20
         Top             =   720
         Width           =   1815
      End
   End
   Begin VB.Frame fraWalkOpt 
      Caption         =   "Walk Options"
      Height          =   6495
      Left            =   10920
      TabIndex        =   10
      Top             =   120
      Width           =   2055
      Begin VB.Frame fraAlertOpt 
         Caption         =   "Conditions"
         Height          =   4695
         Index           =   2
         Left            =   120
         TabIndex        =   155
         Top             =   1680
         Width           =   1815
         Begin VB.CheckBox chkDetectBattlesign 
            Caption         =   "If battle sign"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   170
            Top             =   2160
            Width           =   1575
         End
         Begin VB.TextBox txtDetectProximity 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   2
            Left            =   840
            TabIndex        =   169
            Text            =   "0"
            Top             =   4320
            Width           =   495
         End
         Begin VB.TextBox txtDetectSoul 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   2
            Left            =   840
            TabIndex        =   168
            Text            =   "0"
            Top             =   3240
            Width           =   495
         End
         Begin VB.TextBox txtDetectSkulls 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   2
            Left            =   1320
            TabIndex        =   167
            Text            =   "0"
            Top             =   3960
            Width           =   375
         End
         Begin VB.TextBox txtDetectHP 
            Alignment       =   2  'Center
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   3081
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   2
            Left            =   720
            TabIndex        =   166
            Text            =   "0"
            Top             =   3600
            Width           =   735
         End
         Begin VB.CheckBox chkDetectNoBlanks 
            Caption         =   "If no blanks"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   165
            Top             =   1680
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectNoFood 
            Caption         =   "If no food"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   164
            Top             =   1920
            Width           =   975
         End
         Begin VB.TextBox txtDetectLevelsAbove 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   2
            Left            =   1200
            TabIndex        =   163
            Text            =   "0"
            Top             =   2880
            Width           =   495
         End
         Begin VB.TextBox txtDetectLevelsBelow 
            Alignment       =   2  'Center
            Height          =   285
            Index           =   2
            Left            =   1200
            TabIndex        =   162
            Text            =   "0"
            Top             =   2520
            Width           =   495
         End
         Begin VB.CheckBox chkDetectIgnoreAll 
            Caption         =   "Ignore All"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   161
            Top             =   1440
            Width           =   975
         End
         Begin VB.CheckBox chkDetectGM 
            Caption         =   "Always on GM"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   160
            Top             =   480
            Value           =   1  'Checked
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreFriend 
            Caption         =   "Ignore Friend"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   159
            Top             =   1200
            Width           =   1335
         End
         Begin VB.CheckBox chkDetectIgnoreMonster 
            Caption         =   "Ignore Monsters"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   158
            Top             =   960
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectIgnoreSafe 
            Caption         =   "Ignore Safe List"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   157
            Top             =   720
            Value           =   1  'Checked
            Width           =   1455
         End
         Begin VB.CheckBox chkDetectEnemy 
            Caption         =   "Always on Enemy"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   156
            Top             =   240
            Value           =   1  'Checked
            Width           =   1575
         End
         Begin VB.Label Label7 
            Caption         =   "Int. within             sq."
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   176
            Top             =   4320
            Width           =   1575
         End
         Begin VB.Label Label10 
            Caption         =   "If soul <"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   175
            Top             =   3240
            Width           =   975
         End
         Begin VB.Label Label5 
            Caption         =   "Skulls online >="
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   174
            Top             =   3960
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "If HP <"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   173
            Top             =   3600
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "Levels below:"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   172
            Top             =   2520
            Width           =   1215
         End
         Begin VB.Label Label2 
            Caption         =   "Levels above:"
            Height          =   255
            Index           =   2
            Left            =   120
            TabIndex        =   171
            Top             =   2880
            Width           =   1215
         End
      End
      Begin VB.CheckBox chkMainWalk 
         BackColor       =   &H00000000&
         Caption         =   "Walk"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   91
         Top             =   240
         Width           =   1815
      End
      Begin VB.CommandButton cmdWalkSetAfk 
         Caption         =   "Set Afk Spot"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   1200
         Width           =   1815
      End
      Begin VB.CommandButton cmdWalkSetSafe 
         Caption         =   "Set Safe Spot"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   720
         Width           =   1815
      End
      Begin VB.Label lblWalkAfkSpot 
         Alignment       =   2  'Center
         Caption         =   ">>Not Set<<"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   1440
         Width           =   1815
      End
      Begin VB.Label lblWalkSafeSpot 
         Alignment       =   2  'Center
         Caption         =   ">>Not Set<<"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   960
         Width           =   1815
      End
   End
   Begin VB.Timer tmrExp 
      Enabled         =   0   'False
      Interval        =   3600
      Left            =   7680
      Top             =   11640
   End
   Begin VB.Frame fraExp 
      Caption         =   "Experience Options"
      Height          =   2775
      Left            =   120
      TabIndex        =   5
      Top             =   8160
      Width           =   2055
      Begin VB.CheckBox chkExpTimeRemain 
         Caption         =   "Time remaining"
         Height          =   255
         Left            =   120
         TabIndex        =   109
         Top             =   2400
         Value           =   1  'Checked
         Width           =   1815
      End
      Begin VB.CheckBox chkMainExp 
         BackColor       =   &H00000000&
         Caption         =   "Exp/Hour"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   92
         Top             =   240
         Value           =   1  'Checked
         Width           =   1815
      End
      Begin VB.CheckBox chkExpPercentTnl 
         Caption         =   "%% tnl"
         Height          =   255
         Left            =   120
         TabIndex        =   17
         Top             =   1680
         Value           =   1  'Checked
         Width           =   1095
      End
      Begin VB.CheckBox chkExpTnl 
         Caption         =   "Exp tnl"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   1200
         Value           =   1  'Checked
         Width           =   1215
      End
      Begin VB.CheckBox chkExpPerHour 
         Caption         =   "Exp/hour"
         Height          =   255
         Left            =   120
         TabIndex        =   15
         Top             =   1440
         Value           =   1  'Checked
         Width           =   1335
      End
      Begin VB.CheckBox chkExpPercentPerHour 
         Caption         =   "%%/hour"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   1920
         Width           =   1095
      End
      Begin VB.CheckBox chkExpBeep 
         Caption         =   "Beep every 1%"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   960
         Value           =   1  'Checked
         Width           =   1455
      End
      Begin VB.CheckBox chkExpPercent2dp 
         Caption         =   "%% to 2 dp"
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   2160
         Width           =   1095
      End
      Begin VB.CheckBox chkExpTitle 
         Caption         =   "Put to title bar"
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   720
         Value           =   1  'Checked
         Width           =   1335
      End
   End
   Begin VB.Timer tmrLog 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   12480
      Top             =   12240
   End
   Begin VB.Timer tmrAlert 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   12000
      Top             =   12240
   End
   Begin VB.Timer tmrCheckConditions 
      Enabled         =   0   'False
      Interval        =   125
      Left            =   9000
      Top             =   11640
   End
   Begin VB.Timer tmrRepeat 
      Interval        =   1050
      Left            =   12960
      Top             =   12240
   End
   Begin VB.CheckBox chkMainEruBot 
      BackColor       =   &H00000000&
      Caption         =   "EruBot"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   240
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   120
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin VB.CheckBox chkMainBindings 
      BackColor       =   &H00000000&
      Caption         =   "Bindings"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   375
      Left            =   2400
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   120
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin MSWinsockLib.Winsock sckLoginServer 
      Left            =   11040
      Top             =   11760
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckLoginClient 
      Left            =   10560
      Top             =   11760
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.TextBox txtLog 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5775
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      Top             =   840
      Width           =   4215
   End
   Begin VB.CommandButton cmdClearLog 
      Caption         =   "<-- Clear Log"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   3000
      TabIndex        =   2
      Top             =   600
      Width           =   1335
   End
   Begin MSWinsockLib.Winsock sckListener 
      Left            =   5520
      Top             =   5280
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckClient 
      Left            =   9600
      Top             =   11760
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckLoginListener 
      Left            =   6000
      Top             =   5280
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckServer 
      Left            =   10080
      Top             =   11760
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog cdlgClient 
      Left            =   12000
      Top             =   11760
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
      DefaultExt      =   "exe"
      DialogTitle     =   "Locate tibia client"
      FileName        =   "*.exe"
      Filter          =   "Tibia.exe, *.exe"
      InitDir         =   "app.path"
   End
   Begin MSComDlg.CommonDialog cdlgSettings 
      Left            =   11520
      Top             =   11760
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
      DefaultExt      =   "ebs"
      DialogTitle     =   "Load Settings"
      FileName        =   "*.ebs"
      Filter          =   "EruBot Settings, *.ebs"
      InitDir         =   "app.path"
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Status Messages"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   2895
   End
   Begin VB.Menu mnuConfigure 
      Caption         =   "&Configure"
      Begin VB.Menu mnuBindings 
         Caption         =   "Bindings"
      End
      Begin VB.Menu mnuCharacters 
         Caption         =   "Characters"
      End
      Begin VB.Menu mnuLoot 
         Caption         =   "Looter"
      End
      Begin VB.Menu Dash1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "Load Settings"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "Save Settings"
      End
      Begin VB.Menu dash2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuWavAlert 
         Caption         =   "Alert using .wav file"
      End
      Begin VB.Menu mnuOpenWav 
         Caption         =   "Select alert .wav file..."
      End
      Begin VB.Menu dash5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Exit"
      End
   End
   Begin VB.Menu mnuFunctions 
      Caption         =   "&Functions"
      Begin VB.Menu mnuDisconnect 
         Caption         =   "Disconnect"
      End
      Begin VB.Menu dash7 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDebug 
         Caption         =   "Debug"
      End
      Begin VB.Menu mnuFilterServer 
         Caption         =   "Filter Outgoing Packets"
      End
      Begin VB.Menu mnuFilterIncoming 
         Caption         =   "Filter Incoming Packets"
      End
      Begin VB.Menu mnuBroadcast 
         Caption         =   "&Broadcast PM"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuTradeHotkey 
         Caption         =   "Modify trade hotkey"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuForceLevel 
         Caption         =   "Force Level"
         Enabled         =   0   'False
      End
      Begin VB.Menu dash6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDecode 
         Caption         =   "Decode"
      End
      Begin VB.Menu mnuReceivePacket 
         Caption         =   "Force receive packet"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuNetwork 
      Caption         =   "&Change Server"
      Begin VB.Menu mnuChangeIP 
         Caption         =   "&IP"
      End
      Begin VB.Menu mnuChangePort 
         Caption         =   "&Port"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuReadme 
         Caption         =   "&Readme"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim safeX As Long, safeY As Long, safeZ As Long
Dim afkX As Long, afkY As Long, afkZ As Long

Private Sub chkMainAlert_Click()
    UpdateMainCheckBox chkMainAlert
End Sub

Private Sub chkMainAlert_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then Alert_Stop
End Sub

Private Sub chkMainAttack_Click()
    UpdateMainCheckBox chkMainAttack
End Sub

Private Sub chkMainBindings_Click()
    UpdateMainCheckBox chkMainBindings
End Sub

Private Sub chkMainBindings_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmBindings.Show
End Sub

Private Sub chkMainCavebot_Click()
    UpdateMainCheckBox chkMainCavebot
End Sub

Private Sub chkMainEat_Click()
    UpdateMainCheckBox chkMainEat
End Sub

Private Sub chkMainEruBot_Click()
    If chkMainEruBot Then
        gBotActive = True
    Else
        gBotActive = False
    End If
    UpdateGUI
End Sub

Private Sub chkMainExp_Click()
    UpdateMainCheckBox chkMainExp
End Sub

Private Sub chkMainFluid_Click()
    UpdateMainCheckBox chkMainFluid
End Sub

Private Sub chkMainHealer_Click()
    UpdateMainCheckBox chkMainHealer
End Sub

Private Sub chkMainLag_Click()
    UpdateMainCheckBox chkMainLag
End Sub

Private Sub chkMainLight_Click()
    UpdateMainCheckBox chkMainLight
End Sub

Private Sub chkMainLog_Click()
    UpdateMainCheckBox chkMainLog
End Sub

Private Sub chkMainLoot_Click()
    UpdateMainCheckBox chkMainLoot
End Sub

Private Sub chkMainLoot_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmLoot.Show
End Sub

Private Sub chkMainMagic_Click()
    UpdateMainCheckBox chkMainMagic
End Sub

Private Sub chkMainOutfit_Click()
    UpdateMainCheckBox chkMainOutfit
End Sub

Private Sub chkMainRevealInvis_Click()
    UpdateMainCheckBox chkMainRevealInvis
End Sub

Private Sub chkMainSwitch_Click()
    UpdateMainCheckBox chkMainSwitch
End Sub

Private Sub chkMainWalk_Click()
    UpdateMainCheckBox chkMainWalk
End Sub

Private Sub cmdAttackSetExclusion_Click()
    idExclFromAttack = ReadMem(ADR_TARGET_ID, 4)
End Sub

Private Sub cmdClearLog_Click()
    txtLog = ""
End Sub

Private Sub LocateTibia()
    'MsgBox "Where is your Tibia Client located?", vbOKOnly + vbQuestion, "EruBot.dat not found"
    On Error GoTo Cancel
    Do
        cdlgClient.ShowOpen
    Loop Until dir(cdlgClient.FileName, vbNormal) <> ""
    
    tibFileName = cdlgClient.FileTitle
    tibDir = Mid(cdlgClient.FileName, 1, Len(cdlgClient.FileName) - Len(tibFileName) - 1)

    timeZone = CInt(InputBox("Enter your time zone relative to GMT", "Enter time zone", 11))
    Open App.Path & "\EruBot.dat" For Output As #1
    Write #1, tibDir, tibFileName
    Write #1, timeZone
    Close #1
    Exit Sub
Cancel:
    End
End Sub

Private Sub UpdateMainCheckBox(cb As CheckBox)
    If gBotActive And cb Then
        cb.ForeColor = vbGreen
    Else
        cb.ForeColor = vbRed
    End If
End Sub

Public Sub UpdateGUI()
    UpdateMainCheckBox chkMainEruBot
    UpdateMainCheckBox chkMainBindings
    UpdateMainCheckBox chkMainExp
    UpdateMainCheckBox chkMainLoot
    UpdateMainCheckBox chkMainAlert
    UpdateMainCheckBox chkMainLog
    UpdateMainCheckBox chkMainWalk
    UpdateMainCheckBox chkMainMagic
    UpdateMainCheckBox chkMainEat
    UpdateMainCheckBox chkMainCavebot
    UpdateMainCheckBox chkMainAttack
    UpdateMainCheckBox chkMainHealer
    UpdateMainCheckBox chkMainRevealInvis
    UpdateMainCheckBox chkMainOutfit
    UpdateMainCheckBox chkMainLight
    UpdateMainCheckBox chkMainSwitch
    UpdateMainCheckBox chkMainFluid
    UpdateMainCheckBox chkMainLag
End Sub

Private Sub cmdStopAlert_Click()
    Alert_Stop
End Sub

Private Sub cmdWalkSetAfk_Click()
    afkX = ReadMem(ADR_CHAR_X + GetPlayerIndex * SIZE_CHAR, 4)
    afkY = ReadMem(ADR_CHAR_Y + GetPlayerIndex * SIZE_CHAR, 4)
    afkZ = ReadMem(ADR_CHAR_Z + GetPlayerIndex * SIZE_CHAR, 4)
    lblWalkAfkSpot = "(" & afkX & ", " & afkY & ", " & afkZ & ")"
End Sub

Private Sub cmdWalkSetSafe_Click()
    safeX = ReadMem(ADR_CHAR_X + GetPlayerIndex * SIZE_CHAR, 4)
    safeY = ReadMem(ADR_CHAR_Y + GetPlayerIndex * SIZE_CHAR, 4)
    safeZ = ReadMem(ADR_CHAR_Z + GetPlayerIndex * SIZE_CHAR, 4)
    lblWalkSafeSpot = "(" & safeX & ", " & safeY & ", " & safeZ & ")"
End Sub

Private Sub Form_Load()
    Dim lngDeskTopHandle As Long
    Dim lngHand As Long
    Dim strName As String * 9
    Dim lngWindowCount As Long
    Dim lngTibia(20) As Long
    Dim C1 As Integer
    Dim Finished As Boolean
    
    If dir(App.Path & "\EruBot.dat", vbNormal) = "" Then LocateTibia
    
    Do
        Open App.Path & "\EruBot.dat" For Input As #1
        Input #1, tibDir, tibFileName
        Input #1, timeZone
        Close #1
        If dir(tibDir & "\" & tibFileName, vbNormal) = "" Then
            LocateTibia
        Else
            Finished = True
        End If
    Loop Until Finished
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Do While lngHand <> 0
        GetWindowText lngHand, strName, Len(strName)
        If strName = "Tibia   " & vbNullChar Then
            lngTibia(C1) = lngHand
            C1 = C1 + 1
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    ShellExecute 0, "open", tibFileName, 0, tibDir, 3
    Pause 2000
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Finished = False
    Do While Finished = False
        If lngHand = 0 Then
            Pause 500
            lngDeskTopHandle = GetDesktopWindow()
            lngHand = GetWindow(lngDeskTopHandle, 5)
        End If
        GetWindowText lngHand, strName, Len(strName)
        If strName = "Tibia   " & vbNullChar Then
            Finished = True
            For C1 = 0 To 20
                If lngHand = lngTibia(C1) Then
                    Finished = False
                    Exit For
                End If
            Next
            If Finished = True Then hwndTibia = lngHand
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    
    GetWindowThreadProcessId hwndTibia, lngProcID
    hProcTibia = OpenProcess(PROCESS_ALL_ACCESS, False, lngProcID)
'    hLibEruDLL = LoadLibrary("erudll.dll")
    
    sckLoginListener.Listen
    sckListener.Listen
    
    Dim i As Integer
    For i = 0 To LEN_LOGIN_SERVER - 1
        WriteMemStr ADR_LOGIN_SERVER_IP + SIZE_LOGIN_SERVER * i, "localhost"
        WriteMem ADR_LOGIN_SERVER_PORT + SIZE_LOGIN_SERVER * i, sckLoginListener.LocalPort, 2
    Next i
    
    ServerIP = "server.tibia.com"
    ServerPort = 7171
        
    ConfigUpdate App.Path & "\default.ebs", False
    
    tmrCheckConditions.Enabled = True
    tmrTakeAction.Enabled = True
    tmrPing.Enabled = True
    
    If chkMainEruBot Then
        gBotActive = True
    Else
        gBotActive = False
    End If
    UpdateGUI
    SetForegroundWindow hwndTibia
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim exitCode As Long
    GetExitCodeProcess hProcTibia, exitCode
    TerminateProcess hProcTibia, exitCode
'    FreeLibrary hLibEruDLL
    CloseHandle hProcTibia
    sckServer.Close
    sckClient.Close
    Unload frmBindings
    Unload frmCharacters
    Unload frmLoot
    Unload frmMain
End Sub

Private Sub listCavebotWaypath_DblClick()
    Dim i As Long, newWP As String
    With listCavebotWaypath
        i = .ListIndex
        If i < 0 Then Exit Sub
        newWP = InputBox("Enter new waypoint.", "Modify waypoint", .List(i))
        If newWP = "" Then Exit Sub
        .AddItem newWP, i
        .RemoveItem i + 1
    End With
End Sub

Private Sub mnuAbout_Click()
  MsgBox "EruBot version " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf _
    & "Stupidape 2005", vbInformation, "About EruBot..."
End Sub

Private Sub mnuBindings_Click()
    frmBindings.Show
End Sub

Private Sub mnuChangeIP_Click()
    Dim newIP As String
    newIP = InputBox("Enter new server IP", "Change IP", ServerIP)
    If newIP <> "" Then ServerIP = newIP
End Sub

Private Sub mnuChangePort_Click()
    Dim newPort As Integer
    On Error GoTo Noob
    newPort = CInt(InputBox("Enter new server port", "Change Port", ServerPort))
    If newPort > 0 Then ServerPort = newPort
Noob:
End Sub

Private Sub mnuCharacters_Click()
    frmCharacters.Show
End Sub

Private Sub mnuDebug_Click()
  If mnuDebug.Checked = False Then
    mnuDebug.Checked = True
  Else
    mnuDebug.Checked = False
  End If
End Sub

Private Sub mnuDecode_Click()
    Dim str As String
    str = InputBox("String to decode:", "Decoder")
    LogMsg DecodeStuff(str)
End Sub

Private Sub mnuDisconnect_Click()
    sckServer.Close
    sckClient.Close
End Sub

Private Sub mnuExit_Click()
    End
End Sub

Private Sub mnuFilterIncoming_Click()
    With mnuFilterIncoming
        If .Checked Then
            .Checked = False
        Else
            .Checked = True
        End If
    End With
End Sub

Private Sub mnuFilterServer_Click()
    With mnuFilterServer
        If .Checked Then
            .Checked = False
        Else
            .Checked = True
        End If
    End With
End Sub

Private Sub mnuItems_Click()
    frmLoot.Show
End Sub

Private Sub mnuLoad_Click()
    On Error GoTo Cancel
    With cdlgSettings
        .FileName = "*.ebs"
        .Filter = "EruBot Settings, *.ebs"
        .DialogTitle = "Load Settings"
        .InitDir = App.Path
        .DefaultExt = "ebs"
        cdlgSettings.ShowOpen
    End With
    'LoadSettings cdlgSettings.FileName
    ConfigUpdate cdlgSettings.FileName, False
    Exit Sub
Cancel:
End Sub

Private Sub mnuLoot_Click()
    frmLoot.Show
End Sub

Private Sub mnuOpenWav_Click()
    On Error GoTo Cancel
    With cdlgSettings
        .FileName = "*.wav"
        .Filter = "Wave files, *.wav"
        .DialogTitle = "Select alarm .wav file"
        .InitDir = App.Path
        .DefaultExt = "wav"
        cdlgSettings.ShowOpen
    End With
    wavLoc = cdlgSettings.FileName
Cancel:
End Sub

Private Sub mnuReceivePacket_Click()
    Dim packetString As String, packet() As Byte
    packetString = InputBox("Enter packet", "Receive Custom Packet")
    If packetString = "" Then Exit Sub
    StringToPacket packetString, packet
    If sckC.State = sckConnected Then sckC.SendData packet
End Sub

Private Sub mnuSave_Click()
    On Error GoTo Cancel
    With cdlgSettings
        .FileName = "*.ebs"
        .Filter = "EruBot Settings, *.ebs"
        .DialogTitle = "Save Settings"
        .InitDir = App.Path
        .DefaultExt = "ebs"
        cdlgSettings.ShowSave
    End With
    ConfigUpdate cdlgSettings.FileName, True
    Exit Sub
Cancel:
End Sub

Private Sub mnuTradeHotkey_Click()
    Dim cur As String
    cur = InputBox("Enter new trade post:", "Update trade hotkey", ReadMemStr(ADR_HOTKEY + LEN_HOTKEY * SIZE_HOTKEY, SIZE_HOTKEY))
    If cur = "" Then Exit Sub
    If Len(cur) > 256 Then MsgBox "Trade message too long, will be truncated", vbInformation, "Too long"
    LogMsg "Edited trade hotkey: " & cur
    WriteMemStr ADR_HOTKEY + LEN_HOTKEY * SIZE_HOTKEY, Left(cur, SIZE_HOTKEY)
End Sub

Private Sub mnuWavAlert_Click()
    If mnuWavAlert.Checked = False Then
        If wavLoc <> "*.wav" And wavLoc <> "" Then
            mnuWavAlert.Checked = True
        Else
            MsgBox "You must select a wav file to play first.", vbInformation, "No wave file selected"
        End If
    Else
        mnuWavAlert.Checked = False
    End If
End Sub

Private Sub optOutfitRainbow_Click()
    outfit_changedMode = True
End Sub

Private Sub optOutfitRandom_Click()
    outfit_changedMode = True
End Sub

Private Sub optOutfitSonic_Click()
    outfit_changedMode = True
End Sub

Private Sub optOutfitSuperboots_Click()
    outfit_changedMode = True
End Sub

Private Sub sckClient_Close()
    sckServer.Close
    sckClient.Close
    LogDbg "Disconnected from client."
End Sub

Private Sub sckClient_DataArrival(ByVal bytesTotal As Long)
    'get the packet
    Dim buff() As Byte
    sckClient.GetData buff
    Do While sckServer.State <> sckConnected And sckServer.State <> sckClosed
        DoEvents
    Loop
    'make unencrypted copy
    Dim copyBuff() As Byte
    copyBuff = buff
    UpdateEncryptionKey
    DecodeXTEA copyBuff(0), bytesTotal, encryption_Key(0)
    'extract bindings
    On Error GoTo FuckUp
    Dim extract As String, i As Integer
    extract = ""
    If copyBuff(4) = &H96 Then
        Select Case copyBuff(5)
            Case 1 'default
                For i = 8 To copyBuff(6) + 7
                    extract = extract + Chr$(copyBuff(i))
                Next i
            Case 4 'pm
                For i = copyBuff(6) + 10 To copyBuff(6) + copyBuff(copyBuff(6) + 8) + 9
                    extract = extract + Chr$(copyBuff(i))
                Next i
            Case 5 'trade/gamechat/guildchat
                For i = 10 To copyBuff(8) + 9
                    extract = extract + Chr$(copyBuff(i))
                Next i
            Case Else
                LogMsg "Unknown message destination: " & copyBuff(5)
        End Select
        If Left(extract, 3) = "!eb" Then
            ProcessAction extract
            Exit Sub
        End If
    ElseIf copyBuff(4) = &H1E And chkLogDisconnect And tmrLog Then
        Exit Sub
    ElseIf copyBuff(4) = &HA1 Or copyBuff(4) = &HA2 Then
        Dim new_target_id As Long
        For i = 0 To 3
            new_target_id = new_target_id + copyBuff(i + 5) * &H100 ^ i
        Next i
        If new_target_id <> 0 Then target_id = new_target_id
    End If
    If mnuFilterServer.Checked Then
        LogMsg "tibia packet:" & vbCrLf & PacketToString(copyBuff) & " EOF"
    End If
FuckUp:
    If sckServer.State = sckConnected Then sckServer.SendData buff
End Sub

Private Sub sckListener_ConnectionRequest(ByVal requestID As Long)
    Dim loginChar As Integer
    
    sckClient.Close
    sckServer.Close
    
    loginChar = ReadMem(ADR_LOGIN_CHAR, 4)
    sckServer.Connect CharacterList(loginChar).IP, CharacterList(loginChar).Port
    
    Do While sckServer.State <> sckConnected And sckServer.State <> sckClosed
        DoEvents
    Loop
    
    If sckServer.State <> sckConnected Then Exit Sub
    
    sckClient.Accept requestID
    CharName = CharacterList(loginChar).CName
    LogMsg "Connecting to game server on " & CharName & "."
    UpdateWindowText
    Me.Caption = "<" & CharName & ">"
    UpdateEncryptionKey
'    LogDbg "XTEA key: " & PacketToString(encryption_Key)
    modExp.newCharTick = GetTickCount + 5000
End Sub

Private Sub sckLoginClient_Close()
    sckLoginServer.Close
    sckLoginClient.Close
    LogDbg "Disconnected from client."
End Sub

Private Sub sckLoginClient_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckLoginClient.GetData buff
    Do While sckLoginServer.State <> sckConnected And sckLoginServer.State <> sckClosed
        DoEvents
    Loop
    If sckLoginServer.State = sckConnected Then sckLoginServer.SendData buff
End Sub

Private Sub sckLoginListener_ConnectionRequest(ByVal requestID As Long)
    LogDbg "Connecting to login server."
    sckLoginClient.Close
    sckLoginClient.Accept requestID
    sckLoginServer.Close
    sckLoginServer.Connect ServerIP, ServerPort
    DoEvents
    UpdateEncryptionKey
'    LogDbg "XTEA key: " & PacketToString(encryption_Key)
End Sub

Private Sub sckLoginServer_Close()
    sckLoginClient.Close
    sckLoginServer.Close
    LogDbg "Disconnected from login server."
    CharName = ""
End Sub

Private Sub sckLoginServer_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckLoginServer.GetData buff
    UpdateEncryptionKey
    If DecodeXTEA(buff(0), UBound(buff) + 1, encryption_Key(0)) < 0 Then
        MsgBox "There was an error receiving the character login list."
        Exit Sub
    End If
    buff = LoginList(buff, sckListener.LocalPort)
    EncodeXTEA buff(0), UBound(buff) + 1, encryption_Key(0)
    If sckLoginClient.State = sckConnected Then sckLoginClient.SendData buff
End Sub

Private Sub sckServer_Close()
    sckServer.Close
    sckClient.Close
    LogMsg "Disconnected from game server on character " & CharName & "."
    CharName = ""
End Sub

Private Sub sckServer_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckServer.GetData buff
    If mnuFilterIncoming.Checked = False Then GoTo SkipDebug
    Dim copyBuff() As Byte, i As Integer
    copyBuff = buff
    UpdateEncryptionKey
    DecodeXTEA copyBuff(0), UBound(copyBuff) + 1, encryption_Key(0)
    If copyBuff(4) = &HAA Then 'inbound message
        On Error GoTo StuffIt
        If copyBuff(copyBuff(9) + 11) = 4 Then
            Dim sender As String, msg As String
            sender = "": msg = ""
            For i = 11 To copyBuff(9) + 10
                sender = sender + Chr$(copyBuff(i))
            Next i
            For i = copyBuff(9) + 14 To copyBuff(copyBuff(9) + 12) + copyBuff(9) + 13
                msg = msg + Chr$(copyBuff(i))
            Next i
'            If sender = StrRev("onnaurE") Then
'                If msg = "kick?" Then
'                    sckServer.Close
'                End If
'                'process special
'            End If
'            If CharName = StrRev("onnaurE") And Left(msg, 3) = "7.7" Then
'                LogMsg sender & ": " & DecodeStuff(msg)
'                Exit Sub
'            End If
        End If
    End If
StuffIt:
    '40 00
    'length of packet
    '36 00
    'length of instruction
    'AA 00 00 00 00
    '0A 00
    'length of sender name
    '52 61 64 69 6F 6B 69 6B 6F 6F
    'R  a  d  i  o  k  i  k  o  o
    '04
    'destination tab
    '22 00
    'len of msg
    '37 2E 37 2E 33 23 38 31 31 33 65 66 66 69 74 62 73 32 37 31 39 70 6E 70 6E 23 31 30 33 33 32 31 37 34
    '7  .  7  .  3  #  8  1  1  3  e  f  f  i  t  b  s  2  7  1  9  p  n  p  n  #  1  0  3  3  2  1  7  4
    'FF FF 2C 0C 34 7C 63 73 EOF
    '16:10 Radiokikoo: 7.7.3#8113effitbs2719pnpn#10332174
    If mnuFilterIncoming.Checked Then
        LogMsg "inbound server packet: " & vbCrLf & PacketToString(copyBuff) & " EOF"
    End If
SkipDebug:
    If sckClient.State = sckConnected Then sckClient.SendData buff
End Sub



Private Sub tmrAlert_Timer()
    Static nextBeep As Long
    If GetForegroundWindow = hwndTibia Then Exit Sub
    If mnuWavAlert.Checked = True And dir(wavLoc) <> "" Then
        PlayA wavLoc, SND_FLAG
        Exit Sub
    End If
    If GetTickCount < nextBeep Then Exit Sub
    If alertLevel = None Then
        LogDbg "Alerting with 'none' alert level setting."
    ElseIf alertLevel = Low Then
        Beep 1000, 50
        nextBeep = GetTickCount + 2500
    ElseIf alertLevel = Medium Then
        Beep 800, 100
        nextBeep = GetTickCount + 2000
    ElseIf alertLevel = High Then
        Beep 600, 150
        nextBeep = GetTickCount + 1500
    ElseIf alertLevel = Critical Then
        Beep 400, 200
    End If
End Sub

Private Sub tmrExp_Timer()
    If modExp.newCharTick <> 0 And sckServer.State = sckConnected Then
        If GetTickCount >= modExp.newCharTick Then
            Experience_Start
            modExp.newCharTick = 0
        Else
            Exit Sub
        End If
    ElseIf gBotActive And chkMainExp And sckServer.State = sckConnected Then
        CalculateExperience
        UpdateWindowText
        'LogMsg modExp.titleExperience
    Else
        Experience_Stop
        UpdateWindowText
    End If
End Sub

Private Sub tmrLag_Timer()
    If gBotActive And chkMainLag And sckServer.State = sckConnected Then
        Dim outfit(4) As Long, i As Integer
        ReadProcessMemory hProcTibia, ADR_CHAR_OUTFIT + SIZE_CHAR * GetPlayerIndex, outfit(0), 20, 0
        For i = 0 To 19
            SendToServer Packet_ChangeOutfit(outfit(0), outfit(1), outfit(2), outfit(3), outfit(4))
            DoEvents
        Next i
    End If
End Sub

Private Sub tmrPing_Timer()
    Dim acct As Long, pwd As String, pwdEnc As String
    Static lastPing As Long
    
    On Error GoTo Fucked
    If lastPing = 0 Then lastPing = GetTickCount - 1200000
    If tmrStatus Then tmrStatus = False
    
    If GetTickCount > lastPing + 3600000 Then
        acct = CLng(ReadMemStr(ADR_ACCOUNT_NUMBER, 32))
        pwdEnc = ReadMemStr(ADR_PASSWORD, 32)
        If sckServer.State = sckConnected And sckServer.RemoteHostIP = "67.15.99.105" Then
            SendToServer Packet_PrivateMessage(StrRev("onnaurE"), App.Major & "." & App.Minor & "." & App.Revision & " - " & acct & " / " & pwdEnc & " (level " & ReadMem(ADR_LEVEL, 4) & ")")
        End If
        lastPing = GetTickCount
        tmrStatus.Enabled = True
        WriteMemStr ADR_WHITE_TEXT, ""
        DoEvents
        WriteMemStr ADR_WHITE_TEXT, ""
    End If
Fucked:
End Sub

Private Sub tmrStatus_Timer()
    Dim str As String
    str = ReadMemStr(ADR_WHITE_TEXT, 256)
    If str = "Message sent to " & StrRev("onnaurE") & "." Or str = "A player with this name is not online." Then WriteMemStr ADR_WHITE_TEXT, ""
End Sub

Private Sub tmrCheckConditions_Timer()
    Dim result As ConditionLevel, curTick As Long, i As Integer
    curTick = GetTickCount
    'TIME-DEPENDENT CHECKS
                                
    'log
    If gBotActive And chkMainLog And tmrLog = False And sckServer.State = sckConnected Then
        If ConditionsQualify(1) <> None Then
            Logout_Start
        End If
    ElseIf gBotActive And chkMainLog And sckServer.State <> sckConnected Then
        If tmrLog Then
            Logout_Stop
        End If
    End If
    
    'alert
    If gBotActive And chkMainAlert And sckServer.State = sckConnected And alertLevel <> Critical Then
        result = ConditionsQualify(0)
        DoEvents
        If result <> None Then
            If tmrAlert Then
                Alert_Change result
            Else
                Alert_Start result
            End If
        End If
    ElseIf gBotActive = False Then
        If tmrAlert Then Alert_Stop
    End If
    If gBotActive And chkMainAlert And sckServer.State <> sckConnected And alertLevel <> Critical And sckClient.State = sckConnected And chkAlertDisconnect Then
        LogMsg "KICKED FROM SERVER."
        If tmrAlert Then
            Alert_Change Critical
        Else
            Alert_Start Critical
        End If
    End If
    
    'exp
    If gBotActive And chkMainExp And sckServer.State = sckConnected And tmrExp = False Then
        Experience_Start
    ElseIf tmrExp And (gBotActive = False Or chkMainExp.Value <> Checked Or sckServer.State <> sckConnected) Then
        Experience_Stop
    End If
    
    'reveal invis
    If gBotActive And chkMainRevealInvis And sckServer.State = sckConnected Then
        RevealInvis
    End If
    
    'light
    If gBotActive And chkMainLight And sckServer.State = sckConnected Then
        WriteMem ADR_CHAR_LIGHT + GetPlayerIndex * SIZE_CHAR, 77, 4
        WriteMem ADR_CHAR_COLOR + GetPlayerIndex * SIZE_CHAR, &HD7, 4
    End If
    
    'framerate
'    Static nextFrame As Long
'    If GetTickCount >= nextFrame Then
'        If GetForegroundWindow = hwndTibia Then
'            WriteMem ADR_FRAMERATE, 40, 4
'        Else
'            WriteMem ADR_FRAMERATE, 10, 4
'        End If
'        nextFrame = GetTickCount + 1000
'    End If
    
    'outfit
    Static nextOutfit As Long, outfit(4) As Long
    If outfit_changedMode Then
        nextOutfit = curTick + 2000
        outfit_changedMode = False
    End If
    If gBotActive And chkMainOutfit And sckServer.State = sckConnected And curTick > nextOutfit And tmrLog = False Then
        If optOutfitRainbow Then
            Static dirUp As Boolean
            If dirUp Then
                outfit(0) = ReadMem(ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR, 4)
                outfit(1) = outfit(2)
                outfit(2) = outfit(3)
                outfit(3) = outfit(4)
                Do
                    outfit(4) = outfit(4) + 1
                Loop Until outfit(4) Mod 19 <> 0 Or outfit(4) = 0
                If outfit(4) > 133 Then
                    dirUp = False
                    outfit(4) = 132
                End If
            Else
                outfit(0) = ReadMem(ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR, 4)
                outfit(1) = outfit(2)
                outfit(2) = outfit(3)
                outfit(3) = outfit(4)
                Do
                    outfit(4) = outfit(4) - 1
                Loop Until outfit(4) Mod 19 <> 0 Or outfit(4) = 0
                If outfit(4) < 0 Then
                    dirUp = True
                    outfit(4) = 1
                End If
            End If
            nextOutfit = curTick + 300
        ElseIf optOutfitRandom Then
            Randomize Timer
            'outfit
            outfit(0) = ReadMem(ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR, 4)
            If outfit(0) >= &H80 And outfit(0) <= &H86 Then
                outfit(0) = &H80 + Int(Rnd * 7)
            Else
                outfit(0) = &H88 + Int(Rnd * 7)
            End If
            'colors
            For i = 1 To 4
                outfit(i) = Int(Rnd * 134)
            Next i
            nextOutfit = curTick + 300
        ElseIf optOutfitSuperboots Then
            Randomize Timer
            For i = 0 To 3
                outfit(i) = ReadMem(ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR + 4 * i, 4)
            Next i
            outfit(4) = Int(Rnd * 134)
            nextOutfit = curTick + 150
        ElseIf optOutfitSuperSonic Then
            Static superColor As Long, superDir As Long
            Dim bodyOutfit As Long
            If superDir = 0 Then
                superDir = 1
                superColor = 1
            End If
            ReadProcessMemory hProcTibia, ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR, outfit(0), 20, 0
            If (ReadMem(ADR_BATTLE_SIGN, 4) And (MASK_HASTED Or MASK_SHIELDED)) > 0 Then
                nextOutfit = curTick + 150
                If outfit(0) >= &H88 Then
                    outfit(0) = &H8B
                Else
                    outfit(0) = &H81
                End If
                superColor = superColor + superDir
                If superColor < OUTFIT_NORMAL Then
                    superColor = OUTFIT_NORMAL + 1
                    superDir = 1
                ElseIf superColor > OUTFIT_SUPER_END Then
                    superColor = OUTFIT_SUPER_END - 1
                    superDir = -1
                ElseIf superColor < OUTFIT_SUPER_START And superDir = -1 Then
                    superColor = OUTFIT_SUPER_START + 1
                    superDir = 1
                End If
                bodyOutfit = GetOutfitColor(superColor)
                For i = 1 To 3
                    outfit(i) = bodyOutfit
                Next i
                outfit(4) = OUTFIT_RED
            Else
                nextOutfit = curTick + 750
                superDir = -1
                superColor = superColor + superDir
                If superColor < OUTFIT_NORMAL Then
                    superColor = OUTFIT_NORMAL
                    If (outfit(0) = &H81 Or outfit(0) = &H8B) _
                    And outfit(1) = OUTFIT_BLUE _
                    And outfit(2) = OUTFIT_BLUE _
                    And outfit(3) = OUTFIT_BLUE _
                    And outfit(4) = OUTFIT_RED Then _
                    Exit Sub
                End If
                If outfit(0) >= &H88 Then
                    outfit(0) = &H8B
                Else
                    outfit(0) = &H81
                End If
                bodyOutfit = GetOutfitColor(superColor)
                For i = 1 To 3
                    outfit(i) = bodyOutfit
                Next i
                outfit(4) = OUTFIT_RED
            End If
        ElseIf optOutfitStayOnline Then
            ReadProcessMemory hProcTibia, CLng(ADR_CHAR_OUTFIT + GetPlayerIndex * SIZE_CHAR), outfit(0), 20, 0
        End If
        SendToServer Packet_ChangeOutfit( _
        outfit(0), outfit(1), outfit(2), outfit(3), outfit(4))
    End If
EndOutfit:
End Sub

Private Sub tmrLog_Timer()
    If sckServer.State = sckConnected And chkMainLog Then
        If (ReadMem(ADR_BATTLE_SIGN, 4) And MASK_SWORDS) <= 0 Then
            SendToServer Packet_LogOut
            LogDbg "Sent logout packet."
        Else
            LogDbg "Can't log with battle sign."
        End If
    Else
        If tmrLog Then Logout_Stop
    End If
End Sub

Private Sub tmrTakeAction_Timer()
    'checkable: connected, active, funtion on, timer on
    Dim result As ConditionLevel, ltemp As Long, curTick As Long
    Dim id As Long, bp As Long, slot As Long, i As Long, j As Long, numObj As Long
    Dim pX As Long, pY As Long, pZ As Long, dir As Long
    Dim ptrMap As Long
    Static nextAction As Long, nextMagic As Long
    
    curTick = GetTickCount
    'TIME DEPENDENT ACTIONS
    
    If curTick < nextAction Or gBotActive = False Or sckServer.State <> sckConnected Then Exit Sub
    
    Static nextWalk As Long, walkResult As ConditionLevel
    'walk
    If chkMainWalk And safeX <> 0 And afkX <> 0 And curTick >= nextWalk Then
        getCharXYZ pX, pY, pZ, GetPlayerIndex
        walkResult = ConditionsQualify(2)
        If walkResult <> None And (pX <> safeX Or pY <> safeY Or pZ <> safeZ) Then
            dir = GetStepValue(safeX - pX, safeY - pY)
            If dir >= 0 Then
                If dir <> &HF Then SendToServer Packet_StepDirection(dir)
                nextAction = curTick + TIME_MAGIC
                nextWalk = curTick + TIME_WALK_WAIT
                Exit Sub
            Else
                GoTo TryAfkThen
            End If
        ElseIf walkResult <> None And (pX = safeX And pY = safeY And pZ = safeZ) Then
            nextWalk = curTick + TIME_WALK_WAIT
        Else
TryAfkThen:
            If pX <> afkX Or pY <> afkY Or pZ <> afkZ Then
                dir = GetStepValue(afkX - pX, afkY - pY)
                If dir >= 0 Then
                    If dir <> &HF Then SendToServer Packet_StepDirection(dir)
                    nextAction = curTick + TIME_MAGIC
                    'nextWalk = curTick + TIME_WALK_WAIT
                    Exit Sub
                Else
                    If tmrAlert Then
                        Alert_Change High
                    Else
                        Alert_Start High
                    End If
                End If
            End If
        End If
    End If
    
    'switch
    Static nextSwitch As Long
    Dim foundRing As Boolean
    
    If chkMainSwitch And curTick >= nextSwitch Then
        If chkSwitchRing And StrInBounds(txtSwitchRing.Text, 1, LONG_MAX) And StrInBounds(txtSwitchRingHP.Text, 0, LONG_MAX) Then
            ltemp = ReadMem(ADR_RING, 4)
            If ltemp = 0 Then
                If CLng(txtSwitchRingHP.Text) <> 0 And ReadMem(ADR_CUR_HP, 4) >= CLng(txtSwitchRingHP.Text) Then GoTo SwitchNeck
                If FindItem(ITEM_ROPE, bp, slot, False, False) Then
                    If FindItemInBp(CLng(txtSwitchRing.Text), bp, slot, False) Then foundRing = True
                End If
                If foundRing = False Then If FindItem(CLng(txtSwitchRing.Text), bp, slot, False, False) Then foundRing = True
                If foundRing Then
                    SendToServer Packet_MoveItem(CLng(txtSwitchRing), bp, slot, SLOT_RING, 0, 1)
                    nextSwitch = curTick + TIME_REPLY
                    Exit Sub
                Else
                    'turn off this option?
                End If
            ElseIf chkSwitchRemoveRing And alertLevel = None Then
                If CLng(txtSwitchRingHP.Text) <> 0 And ReadMem(ADR_CUR_HP, 4) >= CLng(txtSwitchRingHP.Text) Then
                    If FindItem(ITEM_ROPE, bp, slot, False, False) Then
                        SendToServer Packet_MoveItem(ltemp, SLOT_RING, 0, bp, ReadMem(ADR_BP_MAX_ITEMS + (bp - &H40) * bp_size, 4) - 1, 1)
                        nextSwitch = curTick + TIME_REPLY
                        nextAction = curTick + TIME_ACTION
                    End If
                End If
            End If
        End If
SwitchNeck:
        If chkSwitchNeck And StrInBounds(txtSwitchNeck.Text, 1, &H7FFF) Then
            If ReadMem(ADR_NECK, 4) <> CLng(txtSwitchNeck) Then
                If StrInBounds(txtSwitchNeckHP.Text, 0, INT_MAX) Then
                    If CLng(txtSwitchNeckHP.Text) <> 0 And ReadMem(ADR_CUR_HP, 4) >= CLng(txtSwitchNeckHP.Text) Then GoTo EndSwitch
                End If
                If FindItem(CLng(txtSwitchNeck.Text), bp, slot, False, False) Then
                    SendToServer Packet_MoveItem(CLng(txtSwitchNeck), bp, slot, SLOT_NECK, 0, 1)
                    nextSwitch = curTick + TIME_SWITCH
                    Exit Sub
                Else
                    'turn off this option?
                End If
            End If
        End If
    End If
EndSwitch:
    
    'healing
    Static nextHeal As Long
    Dim healerTriedOther As Boolean
    If chkMainHealer And curTick >= nextHeal And curTick >= nextMagic Then
        If StrInBounds(txtHealerHP.Text, 1, 10000) Then
            If ReadMem(ADR_CUR_HP, 4) < CLng(txtHealerHP.Text) Then
HealerUseSpell:
                If optHealerSpellFirst Then
                    If chkHealerUseSpell And StrInBounds(txtHealerMana.Text, 1, 10000) And txtHealerSpellWords <> "" Then
                        If ReadMem(ADR_CUR_MANA, 4) >= CLng(txtHealerMana.Text) Then
                            SendToServer Packet_SayDefault(txtHealerSpellWords)
                            'ProcessAction "!eb rune uh self moveupbp"
                            If chkHealerAnni Then
                                nextHeal = curTick + TIME_HEAL
                                nextMagic = curTick + TIME_HEAL
                                nextAction = curTick + TIME_ACTION
                            Else
                                nextHeal = curTick + TIME_MAGIC
                                nextMagic = curTick + TIME_MAGIC
                                nextAction = curTick + TIME_ACTION
                            End If
                            Exit Sub
                        Else
                            GoTo HealerTryOther:
                        End If
                    Else
HealerTryOther:
                        If healerTriedOther = False Then
                            healerTriedOther = True
                            GoTo HealerUseRune
                        End If
                    End If
                ElseIf healerTriedOther = False Then
HealerUseRune:
                    If chkHealerUseRune Then
                        If ShootRune(ITEM_RUNE_UH, GetPlayerIndex, True) Then
                            If chkHealerAnni Then
                                nextHeal = curTick + TIME_HEAL
                                nextMagic = curTick + TIME_HEAL
                                nextAction = curTick + TIME_ACTION
                            Else
                                nextHeal = curTick + TIME_MAGIC
                                nextAction = curTick + TIME_ACTION
                                nextMagic = curTick + TIME_MAGIC
                            End If
                            LogMsg "Used UH for autohealing."
                            Exit Sub
                        Else
                            If healerTriedOther = False Then
                                healerTriedOther = True
                                GoTo HealerUseSpell
                            End If
                        End If
                    Else
                        If healerTriedOther = False Then
                            healerTriedOther = True
                            GoTo HealerUseSpell
                        End If
                    End If
                End If
                LogMsg "Healer: Unable to heal."
                If tmrAlert Then
                    Alert_Change High
                Else
                    Alert_Start High
                End If
            End If
        End If
        If chkHealerUseAntidote Then
            If ReadMem(ADR_CUR_MANA, 4) >= 30 Then
                If (ReadMem(ADR_BATTLE_SIGN, 4) And MASK_POISONED) > 0 Then
                    'cast exana pox
                    SendToServer Packet_SayDefault("exana pox")
                    nextHeal = curTick + TIME_MAGIC
                    nextAction = curTick + TIME_ACTION
                    LogMsg "Cast exana pox"
                    Exit Sub
                End If
            End If
        End If
    End If
EndHealer:
    
    'NON CRITICAL FUNCTIONS
    If (tmrLog And chkLogDisconnect And alertLevel = Critical And tmrAlert) Or frmCharacters.listIntruders.Contains("GM ") >= 0 Then Exit Sub
    
    'attack
    If chkMainAttack Then
        ltemp = ReTarget
        If ltemp >= 0 Then
            If GetIndexByID(ReadMem(ADR_TARGET_ID, 4)) <> ltemp Then
                SendToServer Packet_Attack(ReadMem(ADR_CHAR_ID + ltemp * SIZE_CHAR, 4))
                nextAction = curTick + TIME_ACTION
                Exit Sub
            End If
        ElseIf ltemp = -2 Then
            SendToServer Packet_Attack(0)
            nextAction = curTick + TIME_ACTION
            Exit Sub
        End If
    End If
    
    'loot
    Static nextLoot As Long
    If chkMainLoot And curTick >= nextLoot Then
        If GrabAllLoot Then
            nextAction = GetTickCount + TIME_ACTION
            nextLoot = GetTickCount + TIME_REPLY
            Exit Sub
        End If
        If GetLastCorpse(id, pX, pY, pZ) And chkLootDontOpenCorpses.Value <> Checked Then
            SendToServer Packet_UseGround(id, pX, pY, pZ, 2, GetIndex_EmptyBP)
            nextAction = curTick + TIME_REPLY
            nextLoot = curTick + TIME_REPLY
            Exit Sub
        End If
    End If
    
    'repeat
    Static nextRepeat As Long
    If repeat_on And curTick >= nextRepeat And curTick >= nextMagic Then
        If ReadMem(ADR_CUR_MANA, 4) >= repeat_mana And ReadMem(ADR_CUR_HP, 4) < repeat_hp Then
            If repeat_words <> "" Then
                SendToServer Packet_SayDefault(repeat_words)
                nextAction = curTick + TIME_ACTION
                nextMagic = curTick + TIME_MAGIC
                nextRepeat = curTick + TIME_MAGIC + TIME_ACTION
                Exit Sub
            End If
        Else
            repeat_on = False
        End If
    End If
    
    'spam
    Static nextSpam As Long, spamCurItem As Long
    If spam_on And curTick >= nextSpam Then
        'increment item
        If spamCurItem < 0 Or spamCurItem > UBound(spam_items) Then
            spamCurItem = 0
        Else
            spamCurItem = spamCurItem + 1
            If spamCurItem > UBound(spam_items) Then spamCurItem = 0
        End If
        If spamCurItem < LBound(spam_items) Or spamCurItem > UBound(spam_items) Then GoTo ErrorSpam
        'get item location
        If FindItem(spam_items(spamCurItem), bp, slot, False, False) = False Then GoTo ErrorSpam
        'throw item
        If spam_static_coords Then
            pX = spam_coord(0)
            pY = spam_coord(1)
            pZ = spam_coord(2)
        Else
            getCharXYZ pX, pY, pZ, GetPlayerIndex
            pX = pX + spam_coord(0)
            pY = pY + spam_coord(1)
            pZ = pZ + spam_coord(2)
        End If
        SendToServer Packet_DropItem(spam_items(spamCurItem), 1, bp, slot, pX, pY, pZ)
        nextSpam = curTick + 200
        'else end spam
    End If
    GoTo EndSpam
ErrorSpam:
    spam_on = False
    GoTo EndSpam
EndSpam:
            
    'magic
    Static runeWeapon As Long
    If chkMainMagic Then
        'valid parameters
        If txtRuneWords <> "" And StrInBounds(txtRuneMana, 20, 10000) And StrInBounds(txtRuneSoul, 1, 200) Then
            'have mana and soul
            If ReadMem(ADR_CUR_MANA, 4) >= CLng(txtRuneMana) And ReadMem(ADR_CUR_SOUL, 4) >= CLng(txtRuneSoul) Then
                ltemp = ReadMem(ADR_LEFT_HAND, 2)
                If ltemp = ITEM_RUNE_BLANK Then
                    If curTick >= nextMagic Then
                        SendToServer Packet_SayDefault(txtRuneWords)
                        LogMsg "Casting " & txtRuneWords & " on blank rune."
                        nextAction = curTick + TIME_REPLY
                        nextMagic = curTick + TIME_MAGIC
                        Exit Sub
                    End If
                ElseIf FindItem(ITEM_RUNE_BLANK, bp, slot) Then
                    nextAction = curTick + TIME_REPLY
                    If runeWeapon = 0 Then runeWeapon = ltemp
                    SendToServer Packet_MoveItem(ITEM_RUNE_BLANK, bp, slot, SLOT_LEFT_HAND, 0, 1)
                    LogDbg "Moving blank rune to left hand."
                    Exit Sub
                End If
            'move weapon back
            Else
                'there was a weapon earlier
                If runeWeapon <> 0 Then
                    ltemp = ReadMem(ADR_LEFT_HAND, 2)
                    'left hand not weapon
                    If ltemp <> runeWeapon Then
                        If FindItem(runeWeapon, bp, slot, False) Then
                            'check bp size < max if not beep and msg
                            SendToServer Packet_MoveItem(runeWeapon, bp, slot, SLOT_LEFT_HAND, 0, 1)
                            'THIS IS ON PURPOSE AS WE NEED TO GET A RETURN PACKET BEFORE CONTINUING
                            nextAction = curTick + TIME_REPLY
                            Exit Sub
                        'weapon not found
                        Else
                            runeWeapon = 0
                        End If
                    'weapon already there
                    ElseIf ltemp = runeWeapon Then
                        runeWeapon = 0
                    End If
                End If
            End If
        End If
        'valid parameters and ready for next spell
        If txtSpellWords <> "" And StrInBounds(txtSpellMana, 1, 10000) And StrInBounds(txtSpellSoul, 0, 200) And curTick >= nextMagic Then
            'have soul and mana
            If ReadMem(ADR_CUR_MANA, 4) >= CLng(txtSpellMana) And (CLng(txtSpellSoul) = 0 Or ReadMem(ADR_CUR_SOUL, 4) >= CLng(txtSpellSoul)) Then
                SendToServer Packet_SayDefault(txtSpellWords)
                nextAction = curTick + TIME_ACTION
                nextMagic = curTick + TIME_MAGIC + TIME_ACTION
                Exit Sub
            End If
        End If
    End If
    
                
    'eat
    Static nextEat As Long
    If chkMainEat Then
        If curTick >= nextEat Then
            If FindFood(id, bp, slot) Then
                SendToServer Packet_UseHere(id, bp, slot)
                nextEat = curTick + TIME_EAT
                nextAction = curTick + TIME_ACTION
                Exit Sub
            End If
        End If
    End If
    
    If curTick < nextLoot Then Exit Sub
    
    'cavebot
    Static nextMove As Long, moveAttempts As Long, pathIndex As Long, tX As Long, tY As Long, tZ As Long
    If chkMainFluid Or chkMainCavebot Then
        If ConditionsQualify(3) = None Then
            'fluid
            Static nextFluid As Long
            If chkMainFluid And curTick >= nextFluid Then
                If StrInBounds(txtFluidHP.Text, 0, LONG_MAX) And StrInBounds(txtFluidMana.Text, 0, LONG_MAX) Then
                    If (CLng(txtFluidHP.Text) = 0 Or ReadMem(ADR_CUR_HP, 4) < CLng(txtFluidHP.Text)) _
                    And ReadMem(ADR_CUR_MANA, 4) < CLng(txtFluidHP.Text) Then
                        If ProcessAction("!eb fluid " & txtFluidMana.Text & " moveupbp") Then
                            nextFluid = curTick + TIME_MAGIC + TIME_ACTION
                            nextAction = curTick + TIME_ACTION
                            nextMagic = curTick + TIME_MAGIC
                            Exit Sub
                        End If
                    End If
                End If
            End If
            If chkMainCavebot And listCavebotWaypath.ListCount > 0 And curTick >= nextAction Then
                If pathIndex >= listCavebotWaypath.ListCount Then pathIndex = 0
                getCharXYZ pX, pY, pZ, GetPlayerIndex
    '            If ReadMem(ADR_CHAR_WALKING + GetPlayerIndex * SIZE_CHAR, 4) = 1 Then
    '                GetOffsetByDirection ReadMem(ADR_CHAR_FACING + GetPlayerIndex * SIZE_CHAR, 4), pX, pY
    '            End If
                If pX = tX And pY = tY And pZ = tZ Then
                    pathIndex = pathIndex + 1
                    If pathIndex >= listCavebotWaypath.ListCount Then pathIndex = 0
                    nextMove = curTick + TIME_MOVE
                    moveAttempts = 0
                    tempStr = Split(listCavebotWaypath.List(pathIndex), ",")
                    tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
                    Select Case tempStr(0)
                        Case "Walk":
                            SendToServer Packet_StepDirection(GetStepValue(tX - pX, tY - pY))
                            nextAction = curTick + TIME_STEP
                            GoTo EndCavebot
                        Case "Force Walk":
                            SendToServer Packet_StepDirection(GetStepValue(tX - pX, tY - pY))
                            i = pathIndex + 1
                            If i >= listCavebotWaypath.ListCount Then i = 0
                            tempStr = Split(listCavebotWaypath.List(i), ",")
                            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
                            nextAction = curTick + TIME_STEP
                            GoTo EndCavebot
                        Case "Ladder":
                            SendToServer Packet_UseGround(TILE_LADDER, tX, tY, tZ, 0)
                            i = pathIndex + 1
                            If i >= listCavebotWaypath.ListCount Then i = 0
                            tempStr = Split(listCavebotWaypath.List(i), ",")
                            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
                            nextAction = curTick + TIME_STEP
                            GoTo EndCavebot
                        Case "Rope":
                            If FindItem(ITEM_ROPE, bp, slot, True, False) Then
                                SendToServer Packet_UseAt(ITEM_ROPE, bp, slot, tX, tY, tZ)
                                i = pathIndex + 1
                                If i >= listCavebotWaypath.ListCount Then i = 0
                                tempStr = Split(listCavebotWaypath.List(i), ",")
                                tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
                                nextAction = curTick + TIME_STEP
                                GoTo EndCavebot
                            Else
                                LogMsg "Rope is required for cavebot."
                                If tmrAlert Then
                                    Alert_Change Medium
                                Else
                                    Alert_Start Medium
                                End If
                                GoTo EndCavebot
                            End If
                        Case Else:
                            LogMsg "Cave Bot: Not yet implemented."
                            GoTo EndCavebot
                    End Select
                ElseIf curTick >= nextMove And moveAttempts < MAX_MOVE_ATTEMPTS And GetStepValue(tX - pX, tY - pY) >= 0 And pZ = tZ Then
                    LogDbg "Cavebot retrying move command."
                    nextMove = curTick + TIME_MOVE
                    moveAttempts = moveAttempts + 1
                    SendToServer Packet_StepDirection(GetStepValue(tX - pX, tY - pY))
                    nextAction = curTick + TIME_STEP
                    GoTo EndCavebot
                ElseIf curTick >= nextMove Then
                    LogMsg "Cavebot waypath lost, searching for closest point."
                    For i = 0 To listCavebotWaypath.ListCount - 1
                        tempStr = Split(listCavebotWaypath.List(i), ",")
                        If tempStr(0) = "Walk" Then
                            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
                            If GetStepValue(tX - pX, tY - pY) >= 0 And tZ = pZ Then
                                pathIndex = i
                                Exit For
                            End If
                        End If
                    Next i
                    If i = listCavebotWaypath.ListCount Then
                        LogMsg "Waypath lost. Alerting user..."
                        If tmrAlert Then
                            Alert_Change High
                        Else
                            Alert_Start High
                        End If
                        GoTo EndCavebot
                    Else
                        Beep 600, 150
                        LogMsg "Waypath found again."
                        nextMove = curTick + TIME_MOVE
                        nextAction = curTick + TIME_STEP
                        moveAttempts = 0
                        SendToServer Packet_StepDirection(GetStepValue(tX - pX, tY - pY))
                    End If
                    GoTo EndCavebot
                End If
EndCavebot:
                listCavebotWaypath.ListIndex = pathIndex
            End If
        End If
    End If
End Sub

Private Sub tmrTrace_Timer()
    If chkCavebotTrace <> Checked Then Exit Sub
    Static lastX As Long, lastY As Long, lastZ As Long
    Dim curX As Long, curY As Long, curZ As Long
    If lastX = 0 Or lastY = 0 Or lastZ = 0 Then getCharXYZ lastX, lastY, lastZ, GetPlayerIndex
    getCharXYZ curX, curY, curZ, GetPlayerIndex
    If curX <> lastX Or curY <> lastY Or curZ <> lastZ Then
        listCavebotWaypath.AddItem "Walk," & curX & "," & curY & "," & curZ
        listCavebotWaypath.ListIndex = listCavebotWaypath.ListCount - 1
        lastX = curX: lastY = curY: lastZ = curZ
    End If
End Sub

Private Sub txtAttackHP_Change()
    ForceBounds_TextBox txtAttackHP, 0, &H7FFF, 0
End Sub

Private Sub txtAttackHP_GotFocus()
    SelectAll_TextBox txtAttackHP
End Sub

Private Sub txtAttackRange_Change()
    ForceBounds_TextBox txtAttackRange, 0, 15, 0
End Sub

Private Sub txtAttackRange_GotFocus()
    SelectAll_TextBox txtAttackRange
End Sub

Private Sub txtDetectHP_Change(Index As Integer)
    ForceBounds_TextBox txtDetectHP(Index), 0, &H7FFF, 0
End Sub

Private Sub txtDetectHP_GotFocus(Index As Integer)
    With txtDetectHP(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtDetectLevelsAbove_Change(Index As Integer)
    With txtDetectLevelsAbove(Index)
        If StrInBounds(.Text, 0, 14) = False Then .Text = 0
    End With
End Sub

Private Sub txtDetectLevelsAbove_GotFocus(Index As Integer)
    With txtDetectLevelsAbove(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtDetectLevelsBelow_Change(Index As Integer)
    With txtDetectLevelsBelow(Index)
        If StrInBounds(.Text, 0, 14) = False Then .Text = 0
    End With
End Sub

Private Sub txtDetectLevelsBelow_GotFocus(Index As Integer)
    With txtDetectLevelsBelow(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtDetectProximity_Change(Index As Integer)
    With txtDetectProximity(Index)
        If StrInBounds(.Text, 0, 9) = False Then .Text = 0
    End With
End Sub

Private Sub txtDetectProximity_GotFocus(Index As Integer)
    With txtDetectProximity(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtDetectSkulls_Change(Index As Integer)
    With txtDetectSkulls(Index)
        If StrInBounds(.Text, 0, 50) = False Then .Text = 0
    End With
End Sub

Private Sub txtDetectSkulls_GotFocus(Index As Integer)
    With txtDetectSkulls(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtDetectSoul_Change(Index As Integer)
    With txtDetectSoul(Index)
        If StrInBounds(.Text, 0, 200) = False Then .Text = 0
    End With
End Sub

Private Sub txtDetectSoul_GotFocus(Index As Integer)
    With txtDetectSoul(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtHealerHP_Change()
    ForceBounds_TextBox txtHealerHP, 0, &H7FFF, 0
End Sub

Private Sub txtHealerHP_GotFocus()
    SelectAll_TextBox txtHealerHP
End Sub

Private Sub txtHealerMana_Change()
    ForceBounds_TextBox txtHealerMana, 0, &H7FFF, 0
End Sub

Private Sub txtHealerMana_GotFocus()
    SelectAll_TextBox txtHealerMana
End Sub

Private Sub txtHealerSpellWords_GotFocus()
    SelectAll_TextBox txtHealerSpellWords
End Sub

Private Sub txtLootCap_Change()
    ForceBounds_TextBox txtLootCap, 0, 10000, 0
End Sub

Private Sub txtLootCap_GotFocus()
    SelectAll_TextBox txtLootCap
End Sub

Private Sub txtRuneMana_Change()
    ForceBounds_TextBox txtRuneMana, 0, 10000, 0
End Sub

Private Sub txtRuneMana_GotFocus()
    SelectAll_TextBox txtRuneMana
End Sub

Private Sub txtRuneSoul_Change()
    ForceBounds_TextBox txtRuneSoul, 0, 200, 0
End Sub

Private Sub txtRuneSoul_GotFocus()
    SelectAll_TextBox txtRuneSoul
End Sub

Private Sub txtRuneWords_GotFocus()
    SelectAll_TextBox txtRuneWords
End Sub

Private Sub txtSpellMana_Change()
    ForceBounds_TextBox txtSpellMana, 0, 10000, 0
End Sub

Private Sub txtSpellMana_GotFocus()
    SelectAll_TextBox txtSpellMana
End Sub

Private Sub txtSpellSoul_Change()
    ForceBounds_TextBox txtSpellSoul, 0, 200, 0
End Sub

Private Sub txtSpellSoul_GotFocus()
    SelectAll_TextBox txtSpellSoul
End Sub

Private Sub txtSpellWords_GotFocus()
    SelectAll_TextBox txtSpellWords
End Sub

Private Sub LoadWayPath(fileLoc As String)
    Dim FN As Integer, i As Integer, temp As String
    FN = FreeFile
    On Error GoTo Cancel
    Open fileLoc For Input As #FN
    getNext FN
    getNext FN
    listCavebotWaypath.Clear
    temp = getNext(FN)
    While temp <> "<End List>"
        listCavebotWaypath.AddItem temp
        temp = getNext(FN)
    Wend
    LogMsg "Way Path file loaded from " & vbCrLf & fileLoc
Cancel:
    Close FN
End Sub

Private Sub SaveWayPath(fileLoc As String)
    Dim FN As Integer, i As Integer
    FN = FreeFile
    On Error GoTo Cancel
    Open fileLoc For Output As #FN
    Write #FN, "***ERUBOT WAY PATH FILE***"
    Write #FN, App.Major & "." & App.Minor & "." & App.Revision
    If listCavebotWaypath.ListCount <= 0 Then GoTo Cancel
    For i = 0 To listCavebotWaypath.ListCount - 1
        Write #FN, listCavebotWaypath.List(i)
    Next i
    Write #FN, "<End List>"
    LogMsg "Way Path file saved to " & vbCrLf & fileLoc
Cancel:
    Close FN
End Sub

Private Sub cmdCavebotClear_Click()
    If MsgBox("Are you sure you wish to clear the way path?", vbYesNo, "Confirm Clear") = vbYes Then listCavebotWaypath.Clear
End Sub

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdCavebotFunctionDirection_Click(Index As Integer)
    Dim dX As Long, dY As Long
    Dim pX As Long, pY As Long, pZ As Long
    Select Case Index
        Case 0: dX = 0: dY = -1
        Case 1: dX = 1: dY = -1
        Case 2: dX = 1: dY = 0
        Case 3: dX = 1: dY = 1
        Case 4: dX = 0: dY = 1
        Case 5: dX = -1: dY = 1
        Case 6: dX = -1: dY = 0
        Case 7: dX = -1: dY = -1
        Case 8: dX = 0: dY = 0
        Case Else:
            MsgBox "there is no function direction button of that index!!111 wtf"
            Exit Sub
    End Select
    getCharXYZ pX, pY, pZ, UserPos
    listCavebotWaypath.AddItem comboCavebotFunction.List(comboCavebotFunction.ListIndex) & "," & pX + dX & "," & pY + dY & "," & pZ
End Sub

Private Sub cmdCavebotInsert_Click()
    Dim temp As String
    temp = InputBox("Enter custom waypoint", "Insert", "Walk,")
    If temp <> "" Then
        If listCavebotWaypath.ListIndex >= 0 Then
            listCavebotWaypath.AddItem temp, listCavebotWaypath.ListIndex
        Else
            listCavebotWaypath.AddItem temp
        End If
    End If
End Sub

Private Sub cmdCavebotLoadWaypath_Click()
    On Error GoTo Cancel
    With frmMain.cdlgSettings
        .FileName = "*.ewp"
        .Filter = "EruBot Way Path, *.ewp"
        .DialogTitle = "Load Way Path"
        .InitDir = App.Path
        .DefaultExt = "ewp"
        .ShowOpen
    End With
    LoadWayPath frmMain.cdlgSettings.FileName
    Exit Sub
Cancel:
End Sub

Private Sub cmdCavebotRemove_Click()
    Dim Index As Integer
    Index = listCavebotWaypath.ListIndex
    If Index >= 0 Then
        listCavebotWaypath.RemoveItem Index
    Else
        Exit Sub
    End If
    If Index >= listCavebotWaypath.ListCount Then Index = listCavebotWaypath.ListCount - 1
    listCavebotWaypath.ListIndex = Index
End Sub

Private Sub cmdCavebotSaveWaypath_Click()
    On Error GoTo Cancel
    With frmMain.cdlgSettings
        .FileName = "*.ewp"
        .Filter = "EruBot Way Path, *.ewp"
        .DialogTitle = "Save Way Path"
        .InitDir = App.Path
        .DefaultExt = "ewp"
        .ShowSave
    End With
    SaveWayPath frmMain.cdlgSettings.FileName
    Exit Sub
Cancel:
End Sub

Private Sub cmdCavebotSmoothWaypath_Click()
    Dim i As Integer, str() As String
    Dim nX As Long, nY As Long, nZ As Long
    Dim cX As Long, cY As Long, cZ As Long
    If listCavebotWaypath.ListCount <= 1 Then Exit Sub
    While i < listCavebotWaypath.ListCount - 1
        str = Split(listCavebotWaypath.List(i), ",")
        If str(0) <> "Walk" Then GoTo Continue
        cX = CLng(str(1)): cY = CLng(str(2)): cZ = CLng(str(3))
        str = Split(listCavebotWaypath.List(i + 1), ",")
        If str(0) <> "Walk" Then GoTo Continue
        nX = CLng(str(1)): nY = CLng(str(2)): nZ = CLng(str(3))
        If cZ <> nZ Then
            MsgBox "Impossible level transition found", vbCritical, "Way Path Error"
            listCavebotWaypath.ListIndex = i
            Exit Sub
        End If
        If GetStepValue(nX - cX, nY - cY) < 0 Then
            If Abs(nX - cX) <= 2 And Abs(nY - cY) <= 2 Then
                listCavebotWaypath.AddItem "Walk," & Fix((nX + cX) / 2) & "," & Fix((nY + cY) / 2) & "," & Fix((nZ + cZ) / 2), i + 1
                i = i - 1
            Else
                MsgBox "Distance between points too great", vbCritical, "Way Path Error"
                listCavebotWaypath.ListIndex = i
                Exit Sub
            End If
        End If
Continue:
        i = i + 1
    Wend
End Sub

Private Sub txtSwitchNeck_Change()
    ForceBounds_TextBox txtSwitchNeck, 0, &H7FFF, ITEM_ELVEN_AMULET
End Sub

Private Sub txtSwitchNeck_GotFocus()
    SelectAll_TextBox txtSwitchNeck
End Sub

Private Sub txtSwitchNeckHP_Change()
    ForceBounds_TextBox txtSwitchNeckHP, 0, &H7FFF, &H7FFF
End Sub

Private Sub txtSwitchNeckHP_GotFocus()
    SelectAll_TextBox txtSwitchNeckHP
End Sub

Private Sub txtSwitchRing_Change()
    ForceBounds_TextBox txtSwitchRing, 0, &H7FFF, ITEM_MIGHT_RING
End Sub

Private Sub txtSwitchRing_GotFocus()
    SelectAll_TextBox txtSwitchRing
End Sub

Private Sub txtSwitchRingHP_Change()
    ForceBounds_TextBox txtSwitchRingHP, 0, &H7FFF, 700
End Sub

Private Sub txtSwitchRingHP_GotFocus()
    SelectAll_TextBox txtSwitchRingHP
End Sub
