VERSION 5.00
Begin VB.UserControl LevelBar 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FFFFFF&
   ClientHeight    =   4845
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3645
   ScaleHeight     =   323
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   243
   Begin VB.Line lineMiddle 
      X1              =   40
      X2              =   40
      Y1              =   136
      Y2              =   240
   End
   Begin VB.Shape shpBorder 
      Height          =   1095
      Left            =   1560
      Top             =   480
      Width           =   1575
   End
   Begin VB.Line lineDiv 
      Index           =   2
      X1              =   16
      X2              =   120
      Y1              =   88
      Y2              =   88
   End
   Begin VB.Line lineDiv 
      Index           =   1
      X1              =   40
      X2              =   144
      Y1              =   112
      Y2              =   112
   End
   Begin VB.Line lineDiv 
      Index           =   3
      X1              =   24
      X2              =   128
      Y1              =   288
      Y2              =   288
   End
   Begin VB.Label lblLevel2 
      Appearance      =   0  'Flat
      BackColor       =   &H0000FF00&
      ForeColor       =   &H80000008&
      Height          =   1455
      Left            =   2520
      TabIndex        =   1
      Top             =   2520
      Width           =   855
   End
   Begin VB.Label lblLevel1 
      Appearance      =   0  'Flat
      BackColor       =   &H00FF0000&
      ForeColor       =   &H80000008&
      Height          =   1815
      Left            =   1080
      TabIndex        =   0
      Top             =   2280
      Width           =   1095
   End
End
Attribute VB_Name = "LevelBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mvarNoDividers As Integer
'Default Property Values:
Const m_def_Min1 = 0
Const m_def_Min2 = 0
Const m_def_Max1 = 100
Const m_def_Max2 = 100
Const m_def_Value1 = 50
Const m_def_Value2 = 50
'Property Variables:
Dim m_Min1 As Integer
Dim m_Min2 As Integer
Dim m_Max1 As Integer
Dim m_Max2 As Integer
Dim m_Value1 As Integer
Dim m_Value2 As Integer

Private Sub UserControl_Initialize()
    m_Value1 = 2
    m_Value2 = 2
    m_Min1 = 1
    m_Min2 = 1
    m_Max1 = 3
    m_Max2 = 3
End Sub

Private Sub UserControl_Resize()
    With lblLevel1
        .Top = UserControl.ScaleHeight * (1 - (m_Value1 - m_Min1) / (m_Max1 - m_Min1))
        .Left = 0
        .Width = UserControl.ScaleWidth / 2
        .Height = UserControl.ScaleHeight
    End With
    With lblLevel2
        .Top = UserControl.ScaleHeight * (1 - (m_Value2 - m_Min2) / (m_Max2 - m_Min2))
        .Left = UserControl.ScaleWidth / 2
        .Width = UserControl.ScaleWidth / 2
        .Height = UserControl.ScaleHeight
    End With
    With shpBorder
        .Top = 0
        .Left = 0
        .Width = UserControl.ScaleWidth
        .Height = UserControl.ScaleHeight
    End With
    With lineMiddle
        .X1 = UserControl.ScaleWidth / 2
        .X2 = .X1
        .Y1 = 0
        .Y2 = UserControl.ScaleHeight
    End With
    For i = lineDiv.LBound To lineDiv.UBound
        With lineDiv(i)
            .X1 = 0
            .X2 = UserControl.ScaleWidth
            .Y1 = i * UserControl.ScaleHeight / 4
            .Y2 = .Y1
        End With
    Next i
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get Min1() As Integer
    Min1 = m_Min1
End Property

Public Property Let Min1(ByVal New_Min1 As Integer)
    m_Min1 = New_Min1
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get Min2() As Integer
    Min2 = m_Min2
End Property

Public Property Let Min2(ByVal New_Min2 As Integer)
    m_Min2 = New_Min2
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,100
Public Property Get Max1() As Integer
End Property

Public Property Let Max1(ByVal New_Max1 As Integer)
    m_Max1 = New_Max1
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,100
Public Property Get Max2() As Integer
    Max2 = m_Max2
End Property

Public Property Let Max2(ByVal New_Max2 As Integer)
    m_Max2 = New_Max2
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,50
Public Property Get Value1() As Integer
    Value1 = m_Value1
End Property

Public Property Let Value1(ByVal New_Value1 As Integer)
    m_Value1 = New_Value1
    UserControl_Resize
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,50
Public Property Get Value2() As Integer
End Property

Public Property Let Value2(ByVal New_Value2 As Integer)
    m_Value2 = New_Value2
    UserControl_Resize
End Property
