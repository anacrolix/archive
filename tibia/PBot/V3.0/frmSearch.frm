VERSION 5.00
Begin VB.Form frmCharSearch 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Find Char"
   ClientHeight    =   5175
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4815
   ControlBox      =   0   'False
   ForeColor       =   &H00C0C0C0&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   345
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   321
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnClose 
      Caption         =   "Close"
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
      Left            =   2520
      TabIndex        =   23
      Top             =   4680
      Width           =   1215
   End
   Begin VB.TextBox txtComment 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
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
      Height          =   1695
      Left            =   1320
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   21
      Top             =   2880
      Width           =   3375
   End
   Begin VB.CommandButton btnSubmit 
      BackColor       =   &H00000000&
      Caption         =   "&Submit"
      Default         =   -1  'True
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
      Left            =   1080
      TabIndex        =   16
      Top             =   4680
      Width           =   1215
   End
   Begin VB.TextBox txtCharName 
      BackColor       =   &H00FFFFFF&
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
      Left            =   1440
      TabIndex        =   1
      Top             =   120
      Width           =   1935
   End
   Begin VB.Line Line3 
      BorderColor     =   &H000000FF&
      X1              =   87
      X2              =   313
      Y1              =   305
      Y2              =   305
   End
   Begin VB.Line Line2 
      BorderColor     =   &H000000FF&
      X1              =   87
      X2              =   313
      Y1              =   191
      Y2              =   191
   End
   Begin VB.Line Line1 
      BorderColor     =   &H000000FF&
      X1              =   87
      X2              =   87
      Y1              =   191
      Y2              =   305
   End
   Begin VB.Label Label12 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Comment:"
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
      Left            =   120
      TabIndex        =   22
      Top             =   2880
      Width           =   1095
   End
   Begin VB.Label Label11 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Guld Mem:"
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
      Left            =   120
      TabIndex        =   20
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label lblGuild 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   19
      Top             =   2280
      Width           =   3495
   End
   Begin VB.Label Label9 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "House:"
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
      Left            =   120
      TabIndex        =   18
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label lblHouse 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   17
      Top             =   2040
      Width           =   3375
   End
   Begin VB.Label lblLog 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   15
      Top             =   2520
      Width           =   2055
   End
   Begin VB.Label lblRes 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   14
      Top             =   1800
      Width           =   2055
   End
   Begin VB.Label lblWorld 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   13
      Top             =   1560
      Width           =   2055
   End
   Begin VB.Label lblLevel 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   12
      Top             =   1320
      Width           =   2055
   End
   Begin VB.Label lblProf 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   11
      Top             =   1080
      Width           =   2055
   End
   Begin VB.Label lblSex 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   10
      Top             =   840
      Width           =   2055
   End
   Begin VB.Label lblName 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      Left            =   1320
      TabIndex        =   9
      Top             =   600
      Width           =   3495
   End
   Begin VB.Label Label7 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Last Login:"
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
      Left            =   120
      TabIndex        =   8
      Top             =   2520
      Width           =   1095
   End
   Begin VB.Label Label6 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "World:"
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
      Left            =   120
      TabIndex        =   7
      Top             =   1560
      Width           =   1095
   End
   Begin VB.Label Label5 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Residence:"
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
      Left            =   120
      TabIndex        =   6
      Top             =   1800
      Width           =   1095
   End
   Begin VB.Label Label4 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Level:"
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
      Left            =   120
      TabIndex        =   5
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label3 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Profession:"
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
      Left            =   120
      TabIndex        =   4
      Top             =   1080
      Width           =   1095
   End
   Begin VB.Label Label2 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Sex:"
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
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Name:"
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
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   1095
   End
   Begin VB.Label lblCharName 
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Character Name:"
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
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "frmCharSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnClose_Click()
    Me.Hide
End Sub

Private Sub btnSubmit_Click()
    Dim strString As String
    Dim C1 As Integer
    strString = GetUrlSource("http://www.tibia.com/community/?subtopic=character&name=" & txtCharName.Text)
    If Len(strString) > 25000 Then
        lblName.Caption = FindSrcString(strString, "Name:</TD><TD>", "<")
        lblSex.Caption = FindSrcString(strString, "<TD>Sex:</TD><TD>", "<")
        lblProf.Caption = FindSrcString(strString, "Profession:</TD><TD>", "<")
        lblLevel.Caption = FindSrcString(strString, "Level:</TD><TD>", "<")
        lblWorld.Caption = FindSrcString(strString, "World:</TD><TD>", "<")
        lblRes.Caption = FindSrcString(strString, "Residence:</TD><TD>", "<")
        If InStr(1, strString, "House:</TD><TD>") = 0 Then
            lblHouse.Caption = ""
        Else
            lblHouse.Caption = FindSrcString(strString, "House:</TD><TD>", " is paid")
        End If
        If InStr(1, strString, "Guild&#160;membership:</TD><TD>") = 0 Then
            lblGuild.Caption = ""
        Else
            lblGuild.Caption = FindSrcString(strString, "Guild&#160;membership:</TD><TD>", "<A") & OneForAnother(FindSrcString(strString, "page=view&GuildName=", """"), "+", " ")
        End If
        lblLog.Caption = GetDate(Right(strString, Len(strString) - InStr(1, strString, "login:</TD><TD>") - 14))
        txtComment.Text = ""
        If InStr(1, strString, "Comment:</TD><TD") <> 0 Then
            strString = Right(strString, Len(strString) - InStr(1, strString, "Comment:</TD><TD") - 15)
            Do
                txtComment.Text = txtComment.Text & FindSrcString(strString, ">", "<")
                strString = Right(strString, Len(strString) - InStr(1, strString, "<"))
                If Left(strString, 9) = "/TD></TR>" Then Exit Do
            Loop While True
        End If
    Else
    
    End If
End Sub
Private Function FindSrcString(FullString As String, StartAt As String, StopAt As String) As String
    FindSrcString = Left(Right(FullString, Len(FullString) - InStr(1, FullString, StartAt) - Len(StartAt) + 1), InStr(1, Right(FullString, Len(FullString) - InStr(1, FullString, StartAt) - Len(StartAt) + 1), StopAt) - 1)
End Function
Private Function OneForAnother(strOrig As String, Before As String, After As String) As String
    Dim C1 As Integer
    Dim Temp As String
    Temp = strOrig
    For C1 = 1 To Len(strOrig)
        If Asc(Right(strOrig, C1)) = Asc(Before) Then Temp = Left(Temp, Len(strOrig) - C1) & After & Right(Temp, C1 - 1)
    Next
    OneForAnother = Temp
End Function
Private Function GetDate(FullString As String) As String
    GetDate = Left(FullString, 3) & " "
    FullString = Right(FullString, Len(FullString) - 9)
    GetDate = GetDate & Left(FullString, 2) & " "
    FullString = Right(FullString, Len(FullString) - 8)
    GetDate = GetDate & Left(FullString, 5) & " "
    FullString = Right(FullString, Len(FullString) - 11)
    GetDate = GetDate & Left(FullString, 8) & " " & "CET"
End Function

