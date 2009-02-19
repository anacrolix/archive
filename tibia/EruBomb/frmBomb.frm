VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmBomb 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EruBomb"
   ClientHeight    =   7155
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6945
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7155
   ScaleWidth      =   6945
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtRuneID 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   4320
      TabIndex        =   16
      Text            =   "3155"
      Top             =   6480
      Width           =   615
   End
   Begin VB.CheckBox chkStayAlive 
      Caption         =   "Send stay alive packets"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   6600
      Width           =   3255
   End
   Begin VB.CheckBox chkFollowEachOther 
      Caption         =   "Form brigade"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   6360
      Width           =   3375
   End
   Begin VB.CheckBox chkFollowTarget 
      Caption         =   "Follow first target"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   6120
      Width           =   3255
   End
   Begin VB.Timer tmrChooseTarget 
      Interval        =   100
      Left            =   4560
      Top             =   1320
   End
   Begin VB.Timer tmrAction 
      Interval        =   1
      Left            =   4080
      Top             =   1320
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   0
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog cdlgBomb 
      Left            =   3480
      Top             =   1320
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdChangeClient 
      Caption         =   "Change Client"
      Enabled         =   0   'False
      Height          =   255
      Left            =   2760
      TabIndex        =   10
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton cmdDisconnect 
      Caption         =   "DISCONNECT"
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
      Left            =   4800
      TabIndex        =   9
      Top             =   120
      Width           =   1935
   End
   Begin VB.CommandButton cmdLogin 
      Caption         =   "LOGIN"
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
      Left            =   2760
      TabIndex        =   8
      Top             =   120
      Width           =   1935
   End
   Begin VB.TextBox txtServerPort 
      Height          =   285
      Left            =   840
      TabIndex        =   7
      Text            =   "7171"
      Top             =   480
      Width           =   1695
   End
   Begin VB.TextBox txtServerIP 
      Height          =   285
      Left            =   840
      TabIndex        =   5
      Text            =   "67.15.99.105"
      Top             =   120
      Width           =   1695
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Save Target List"
      Height          =   375
      Left            =   5280
      TabIndex        =   3
      Top             =   960
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Save Character List"
      Height          =   375
      Left            =   1800
      TabIndex        =   2
      Top             =   960
      Width           =   1575
   End
   Begin VB.CommandButton cmdLoadTargets 
      Caption         =   "Load Target List"
      Height          =   375
      Left            =   3600
      TabIndex        =   1
      Top             =   960
      Width           =   1575
   End
   Begin VB.CommandButton cmdLoadChars 
      Caption         =   "Load Character List"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   960
      Width           =   1575
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   1
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   2
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   3
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   4
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   5
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   6
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   7
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   8
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   9
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   10
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   11
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   12
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   13
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   14
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   15
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   16
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   17
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   18
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   19
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   20
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   21
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   22
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   23
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   24
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   25
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   26
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   27
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   28
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   29
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   30
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   31
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   32
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   33
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   34
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   35
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   36
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   37
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   38
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckChar 
      Index           =   39
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Rune ID"
      Height          =   255
      Left            =   3600
      TabIndex        =   17
      Top             =   6480
      Width           =   615
   End
   Begin VB.Label lblBestTarget 
      Caption         =   "Optimum Target: NONE"
      Height          =   255
      Left            =   3600
      TabIndex        =   12
      Top             =   6120
      Width           =   3255
   End
   Begin VB.Label lblCurClient 
      Caption         =   "Current client: NONE"
      Height          =   255
      Left            =   4080
      TabIndex        =   11
      Top             =   600
      Width           =   2655
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Port"
      Height          =   255
      Left            =   0
      TabIndex        =   6
      Top             =   480
      Width           =   735
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Server IP"
      Height          =   255
      Left            =   0
      TabIndex        =   4
      Top             =   120
      Width           =   735
   End
End
Attribute VB_Name = "frmBomb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub SelectAll_TextBox(tb As TextBox)
    With tb
        .SelLength = Len(.Text)
        .SelStart = 1
    End With
End Sub

Private Sub cmdChangeClient_Click()
    'changeclient
End Sub

Private Sub cmdDisconnect_Click()
    modEruBomb.BombChars_Disconnect
End Sub

Private Sub cmdLoadChars_Click()
    modEruBomb.BombChars_LoadList
End Sub

Private Sub cmdLoadTargets_Click()
    modEruBomb.LoadTargets
End Sub

Private Sub cmdLogin_Click()
    modEruBomb.BombChars_Connect
End Sub

Private Sub Form_Load()
    Dim lngDeskTopHandle As Long, lngHand As Long, strName As String * 9
    Dim lngWindowCount As Long, lngTibia(20) As Long, i As Integer
    
    listTargets.Clear
    listChars.Clear
    
    i = -1
    lngDeskTopHandle = GetDesktopWindow()
    lngHand = GetWindow(lngDeskTopHandle, 5)
    Do While lngHand <> 0
        GetWindowText lngHand, strName, Len(strName)
        If Left(strName, 7) = Left("Tibia <" & vbNullChar, 7) Or strName = "Tibia   " & vbNullChar Then
            i = i + 1
            lngTibia(i) = lngHand
        End If
        lngHand = GetWindow(lngHand, 2)
    Loop
    If i < 0 Then GoTo NoClient
    hwndTibia = lngTibia(i)
    
    GetWindowThreadProcessId hwndTibia, lngProcID
    hProcTibia = OpenProcess(PROCESS_ALL_ACCESS, False, lngProcID)
    CharName = ReadMemStr(ADR_CHAR_NAME + SIZE_CHAR * GetPlayerIndex, 32)
    If CharName = "" Then GoTo NoClient
    lblCurClient = "Current client: " & CharName
    Exit Sub
NoClient:
    MsgBox "No client found, exiting...", vbCritical, "Error"
    End
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CloseHandle hProcTibia
End Sub

Private Sub sckChar_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    Dim buff() As Byte
    sckChar(Index).GetData buff
    BombSocket_ReceivePacket Index, buff
End Sub

Private Sub tmrAction_Timer()
    modEruBomb.BombChars_TakeAction
End Sub

Private Sub tmrChooseTarget_Timer()
    modEruBomb.BombChars_ChooseTarget
End Sub

Private Sub txtRuneID_Change()
    ForceBounds_TextBox txtRuneID, 0, INT_MAX, 0
End Sub

Private Sub txtRuneID_GotFocus()
    SelectAll_TextBox txtRuneID
End Sub

Private Sub txtServerIP_GotFocus()
    SelectAll_TextBox txtServerIP
End Sub

Private Sub txtServerPort_GotFocus()
    SelectAll_TextBox txtServerPort
End Sub

