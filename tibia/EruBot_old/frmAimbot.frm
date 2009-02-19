VERSION 5.00
Begin VB.Form frmAimbot 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Aimbot"
   ClientHeight    =   5760
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6375
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5760
   ScaleWidth      =   6375
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkFluidMoveUpBP 
      Caption         =   "Move up backpack when empty."
      Height          =   255
      Left            =   3360
      TabIndex        =   40
      Top             =   2640
      Width           =   2895
   End
   Begin VB.Timer tmrExura 
      Enabled         =   0   'False
      Interval        =   1200
      Left            =   3480
      Top             =   3840
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   13
      ItemData        =   "frmAimbot.frx":0000
      Left            =   4680
      List            =   "frmAimbot.frx":0019
      Style           =   2  'Dropdown List
      TabIndex        =   39
      Top             =   3480
      Width           =   1600
   End
   Begin VB.CheckBox chkGetShield 
      Caption         =   "Move Shield from Ammo Slot"
      Height          =   375
      Index           =   1
      Left            =   4800
      TabIndex        =   37
      Top             =   1680
      Width           =   1455
   End
   Begin VB.ComboBox comboWeapon 
      Height          =   315
      Index           =   1
      ItemData        =   "frmAimbot.frx":0050
      Left            =   3240
      List            =   "frmAimbot.frx":006C
      Style           =   2  'Dropdown List
      TabIndex        =   35
      Top             =   1680
      Width           =   1455
   End
   Begin VB.CheckBox chkGetShield 
      Caption         =   "Move Shield from Ammo Slot"
      Height          =   375
      Index           =   0
      Left            =   4800
      TabIndex        =   34
      Top             =   600
      Width           =   1455
   End
   Begin VB.ComboBox comboWeapon 
      Height          =   315
      Index           =   0
      ItemData        =   "frmAimbot.frx":00CC
      Left            =   3240
      List            =   "frmAimbot.frx":00E8
      Style           =   2  'Dropdown List
      TabIndex        =   32
      Top             =   600
      Width           =   1455
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   12
      ItemData        =   "frmAimbot.frx":0148
      Left            =   4680
      List            =   "frmAimbot.frx":0161
      Style           =   2  'Dropdown List
      TabIndex        =   29
      Top             =   3000
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   11
      ItemData        =   "frmAimbot.frx":0198
      Left            =   4680
      List            =   "frmAimbot.frx":01B1
      Style           =   2  'Dropdown List
      TabIndex        =   28
      Top             =   2280
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   10
      ItemData        =   "frmAimbot.frx":01E8
      Left            =   4680
      List            =   "frmAimbot.frx":0201
      Style           =   2  'Dropdown List
      TabIndex        =   25
      Top             =   1200
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   9
      ItemData        =   "frmAimbot.frx":0238
      Left            =   4680
      List            =   "frmAimbot.frx":0251
      Style           =   2  'Dropdown List
      TabIndex        =   24
      Top             =   120
      Width           =   1635
   End
   Begin VB.Frame frameAdvanced 
      Caption         =   "Advanced Aimbot Options"
      Height          =   975
      Left            =   120
      TabIndex        =   20
      Top             =   4680
      Width           =   2895
      Begin VB.OptionButton optAll 
         Caption         =   "Shoot all surrounding squares"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   960
         Width           =   3615
      End
      Begin VB.OptionButton optLead 
         Caption         =   "Lead in direction faced"
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   600
         Width           =   1935
      End
      Begin VB.OptionButton optNormal 
         Caption         =   "Shoot normally"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   240
         Value           =   -1  'True
         Width           =   1335
      End
   End
   Begin VB.TextBox txtFriendName 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   120
      TabIndex        =   19
      Text            =   "Friend's Name"
      Top             =   4320
      Width           =   2895
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   8
      ItemData        =   "frmAimbot.frx":0288
      Left            =   1440
      List            =   "frmAimbot.frx":02A1
      Style           =   2  'Dropdown List
      TabIndex        =   17
      Top             =   3960
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   7
      ItemData        =   "frmAimbot.frx":02D8
      Left            =   1440
      List            =   "frmAimbot.frx":02F1
      Style           =   2  'Dropdown List
      TabIndex        =   15
      Top             =   3480
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   6
      ItemData        =   "frmAimbot.frx":0328
      Left            =   1440
      List            =   "frmAimbot.frx":0341
      Style           =   2  'Dropdown List
      TabIndex        =   13
      Top             =   3000
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Enabled         =   0   'False
      Height          =   315
      Index           =   5
      ItemData        =   "frmAimbot.frx":0378
      Left            =   1440
      List            =   "frmAimbot.frx":0391
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Top             =   2520
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   4
      ItemData        =   "frmAimbot.frx":03C8
      Left            =   1440
      List            =   "frmAimbot.frx":03E1
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   2040
      Width           =   1600
   End
   Begin VB.Timer tmrTime 
      Enabled         =   0   'False
      Interval        =   4
      Left            =   4080
      Top             =   3960
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   3
      ItemData        =   "frmAimbot.frx":0418
      Left            =   1440
      List            =   "frmAimbot.frx":0431
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   1560
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   2
      ItemData        =   "frmAimbot.frx":0468
      Left            =   1440
      List            =   "frmAimbot.frx":0481
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   1080
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   1
      ItemData        =   "frmAimbot.frx":04B8
      Left            =   1440
      List            =   "frmAimbot.frx":04D1
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   600
      Width           =   1600
   End
   Begin VB.ComboBox comboButton 
      Height          =   315
      Index           =   0
      ItemData        =   "frmAimbot.frx":0508
      Left            =   1440
      List            =   "frmAimbot.frx":0521
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   120
      Width           =   1600
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Height          =   375
      Left            =   4320
      TabIndex        =   0
      Top             =   5280
      Width           =   975
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Exura to Full"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008080&
      Height          =   255
      Index           =   13
      Left            =   3240
      TabIndex        =   38
      Top             =   3480
      Width           =   1335
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Weapon"
      Height          =   255
      Index           =   1
      Left            =   3240
      TabIndex        =   36
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Line Line3 
      X1              =   3120
      X2              =   6240
      Y1              =   2160
      Y2              =   2160
   End
   Begin VB.Line Line2 
      X1              =   3120
      X2              =   6240
      Y1              =   1080
      Y2              =   1080
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Weapon"
      Height          =   255
      Index           =   0
      Left            =   3240
      TabIndex        =   33
      Top             =   360
      Width           =   1335
   End
   Begin VB.Line Line1 
      X1              =   3120
      X2              =   3120
      Y1              =   120
      Y2              =   5640
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Mage Crew"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Index           =   12
      Left            =   3240
      TabIndex        =   31
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
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
      ForeColor       =   &H00FF00FF&
      Height          =   255
      Index           =   11
      Left            =   3240
      TabIndex        =   30
      Top             =   2280
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Weapon Config"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Index           =   10
      Left            =   3240
      TabIndex        =   27
      Top             =   1200
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Weapon Config"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Index           =   9
      Left            =   3240
      TabIndex        =   26
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "UH Friend"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   8
      Left            =   0
      TabIndex        =   18
      Top             =   3960
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "UH Target"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   7
      Left            =   0
      TabIndex        =   16
      Top             =   3480
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "GFB"
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
      Height          =   255
      Index           =   6
      Left            =   0
      TabIndex        =   14
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Energy Bomb"
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
      ForeColor       =   &H00C0C000&
      Height          =   255
      Index           =   5
      Left            =   0
      TabIndex        =   10
      Top             =   2520
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Fire Bomb"
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
      Height          =   255
      Index           =   4
      Left            =   0
      TabIndex        =   9
      Top             =   2040
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "Explosion"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800080&
      Height          =   255
      Index           =   3
      Left            =   0
      TabIndex        =   8
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "HMM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF00FF&
      Height          =   255
      Index           =   2
      Left            =   0
      TabIndex        =   7
      Top             =   1080
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "SD"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Index           =   1
      Left            =   0
      TabIndex        =   6
      Top             =   600
      Width           =   1335
   End
   Begin VB.Label lblAction 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      Caption         =   "UH Self"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   0
      Left            =   0
      TabIndex        =   5
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "frmAimbot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim keysDown(255) As Boolean

Private Sub combobutton_Click(Index As Integer)
  Dim c As Integer
  If comboButton(Index).ListIndex = -1 Then Exit Sub
  If comboButton(Index).ListIndex = comboButton(Index).ListCount - 1 Then
    comboButton(Index).ListIndex = -1
    Exit Sub
  End If
  For c = comboButton.LBound To comboButton.UBound
    If comboButton(c).ListIndex = comboButton(Index).ListIndex And c <> Index Then
      comboButton(c).ListIndex = -1
      Exit Sub
    End If
  Next c
End Sub

Private Sub Command1_Click()
  Me.Hide
End Sub

Private Sub tmrExura_Timer()
    If ReadMem(ADR_CUR_HP, 2) < ReadMem(ADR_MAX_HP, 2) - 100 And ReadMem(ADR_CUR_MANA, 2) >= 25 Then
        SayStuff "exura"
    Else
        tmrExura.Enabled = False
    End If
End Sub

Private Sub tmrTime_Timer()
  On Error Resume Next 'Error Handling
  'To check if delete key is pressed
  If GetForegroundWindow <> tHWND Then Exit Sub
  
  If GetPressedKey(vbKeyDelete) Then ButtonDown "Delete": Exit Sub
  If GetPressedKey(vbKeyPageDown) Then ButtonDown "PageDown": Exit Sub
  If GetPressedKey(vbKeyHome) Then ButtonDown "Home": Exit Sub
  If GetPressedKey(vbKeyPageUp) Then ButtonDown "PageUp": Exit Sub
  If GetPressedKey(vbKeyInsert) Then ButtonDown "Insert": Exit Sub
  If GetPressedKey(vbKeyEnd) Then ButtonDown "End": Exit Sub
End Sub

Private Function GetPressedKey(key As Long) As Boolean
    GetPressedKey = False
    If keysDown(key) = False And GetAsyncKeyState(key) Then
        keysDown(key) = True
        GetPressedKey = True
    Else
        If GetAsyncKeyState(key) = 0 Then keysDown(key) = False
    End If
End Function

Private Sub ButtonDown(Button As String)
    Dim c As Integer
    For c = comboButton.LBound To comboButton.UBound
        If comboButton(c).Text = Button Then
            Select Case c
                Case 0 To 8: AimbotRune lblAction(c).Caption
                Case 9 To 10: SwapWeaponConfig (c - 9)
                Case 11: DrinkFluid
                Case 12:
                    If frmMageCrew.mageCrewActive = False Then
                        frmMageCrew.LogInMageCrew
                    Else
                        frmMageCrew.LogOutMageCrew
                    End If
                Case 13:
                    If tmrExura.Enabled = False Then
                        tmrExura.Enabled = True
                    Else
                        tmrExura.Enabled = False
                    End If
            End Select
            Exit Sub
        End If
    Next c
End Sub

Private Sub DrinkFluid()
    Dim pX As Long, pY As Long, pZ As Long
    Static bpIndex As Integer, slotIndex As Integer
    Dim curMana As Long, maxMana As Long
    Dim foundFluid As Boolean, moveUpBp As Boolean
    Dim i As Integer
    
    curMana = ReadMem(ADR_CUR_MANA, 2)
    maxMana = ReadMem(ADR_MAX_MANA, 2)
    
    If curMana < maxMana * 0.8 And curMana < maxMana - 60 Then
        foundFluid = False
        'have fluided b4 from bp, and current fluid is not last in bp and bp still open
        If bpIndex >= &H40 And slotIndex + 1 < ReadMem(ADR_BP_MAX_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) _
        And ReadMem(ADR_BP_OPEN + (bpIndex - &H40) * SIZE_BP, 1) = 1 Then
            If confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (slotIndex + 1) * SIZE_ITEM, ITEM_VIAL) Then
                foundFluid = True
                slotIndex = slotIndex + 1
            End If
        End If
        
        If Not foundFluid Then
            If findItem(ITEM_VIAL, bpIndex, slotIndex, True, True) Then foundFluid = True
        End If
        
        If foundFluid Then
            'send use fluid packet
            getCharXYZ pX, pY, pZ, UserPos
            UseAt ITEM_VIAL, bpIndex, slotIndex, pX, pY, pZ
            
            'check that move up bp is checked and that the next item is a fluid
            moveUpBp = True
            If chkFluidMoveUpBP.Value = Checked Then
                If bpIndex >= &H40 And slotIndex + 1 < ReadMem(ADR_BP_MAX_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) Then _
                If confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (slotIndex + 1) * SIZE_ITEM, ITEM_VIAL) Then _
                moveUpBp = False
            Else
                moveUpBp = False
            End If
            
            'if next item not fluid then search entire bp
            If moveUpBp Then
                For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1)
                    If i <> slotIndex And confirmItem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, ITEM_VIAL) Then
                        moveUpBp = False
                        Exit For
                    End If
                Next i
            End If
            
            Pause 50
            
            'if still no fluid then move up bp
            If moveUpBp Then
                UpBpLevel bpIndex - &H40
                itemIndex = 0
                Beep 800, 50
            End If
            DoEvents
        Else
            AddStatusMessage "No fluid found."
            Beep 400, 100
        End If
    Else
        AddStatusMessage "Mana not low enough to require fluid"
    End If
End Sub

Private Sub SwapWeaponConfig(configIndex As Integer)
    'Bright sword
    'Fire axe
    'Skull staff
    'Dragon hammer
    'Giantsword
    'Dragonlance
    'Bow
    'Crossbow

    Dim desWeap As Long, curItem As Long, bpIndex As Integer, slotIndex As Integer, rightHand As Long
    
    Select Case comboWeapon(configIndex).ListIndex
        Case 0: desWeap = ITEM_BRIGHT_SWORD
        Case 1: desWeap = ITEM_FIRE_AXE
        Case 2: desWeap = ITEM_SKULL_STAFF
        Case 3: desWeap = ITEM_DRAGON_HAMMER
        Case 4: desWeap = ITEM_GIANT_SWORD
        Case 5: desWeap = ITEM_DRAGON_LANCE
        Case 6: desWeap = ITEM_BOW
        Case 7: desWeap = ITEM_CROSS_BOW
    End Select
    If findItem(desWeap, bpIndex, slotIndex, False) Then
        rightHand = ReadMem(ADR_RIGHT_HAND, 2)
        If rightHand <> 0 Then
            MoveItem rightHand, SLOT_RIGHT_HAND, 0, SLOT_AMMO, 0, 100
            DoEvents
            Pause 150
        End If
        MoveItem desWeap, bpIndex, slotIndex, SLOT_LEFT_HAND, 0, 100
        If chkGetShield(configIndex).Value = Checked Then
            Pause 150
            curItem = ReadMem(ADR_AMMO, 2)
            MoveItem curItem, SLOT_AMMO, 0, SLOT_RIGHT_HAND, 0, 100
            DoEvents
        End If
    End If
End Sub

Private Sub AimbotRune(runeToFire As String)
    Dim pX As Long, pY As Long, pZ As Long
    Dim bpIndex As Integer, itemIndex As Integer
    Dim targetID As Long, targetPos As Long
    Dim runeID As Long
    Dim i As Integer, temp As Long, runeTick As Long, item As Long
    Dim runesLeft As Boolean
    
    pX = -1
    pY = -1
    pZ = -1
    runeID = -1
    targetPos = -1
    lead = False
    runeTick = GetTickCount
    
    If runeToFire = "UH Self" Then
        runeID = ITEM_RUNE_UH 'rune
        targetPos = UserPos
    ElseIf runeToFire = "UH Friend" Then
        runeID = ITEM_RUNE_UH
        If txtFriendName.Text = "" Then Exit Sub
        targetPos = findPosByName(txtFriendName.Text)
    Else
        targetID = ReadMem(ADR_TARGET_ID, 4)
        If targetID = 0 Then Exit Sub
        targetPos = findPosByID(targetID)
        
        Select Case runeToFire
            Case Is = "SD": runeID = ITEM_RUNE_SD
            Case Is = "HMM": runeID = ITEM_RUNE_HMM
            Case Is = "Explosion": runeID = ITEM_RUNE_EXPLO
            Case Is = "GFB": runeID = ITEM_RUNE_GFB
            Case Is = "Fire Bomb": runeID = ITEM_RUNE_FBB
            Case Is = "UH Target": runeID = ITEM_RUNE_UH
        End Select
    End If
    
    If runeID < 0 Or targetPos < 0 Then AddStatusMessage "Invalid rune or target.": Exit Sub
    If findItem(runeID, bpIndex, itemIndex) = False Then AddStatusMessage "Unable to locate runes to fire.": Exit Sub
    getCharXYZ pX, pY, pZ, targetPos
    
    If pX < 0 Or pY < 0 Or pZ < 0 Then AddStatusMessage "Unable to determine target coordinates.": Exit Sub
    
    'If runeToFire = "UH Self" Or optLead Then
    If optLead Then
        If ReadMem(ADR_CHAR_GFX_DX + targetPos * SIZE_CHAR, 1) <> 0 Then
            temp = ReadMem(ADR_CHAR_GFX_DX + targetPos * SIZE_CHAR + 2, 1)
            Select Case temp
                Case Is = 0: pX = pX - 1
                Case Is = &HFF: pX = pX + 1
                Case Else: AddStatusMessage "Error attempting to lead target. Unexpected value."
            End Select
        End If
        If ReadMem(ADR_CHAR_GFX_DY + targetPos * SIZE_CHAR, 1) <> 0 Then
        temp = ReadMem(ADR_CHAR_GFX_DY + targetPos * SIZE_CHAR + 2, 1)
            Select Case temp
                Case Is = 0: pY = pY - 1
                Case Is = &HFF: pY = pY + 1
                Case Else: AddStatusMessage "Error attempting to lead target. Unexpected value."
            End Select
        End If
    End If
    
    runesLeft = False
    
    If itemIndex + 1 < ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) _
    Then If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + (itemIndex + 1) * SIZE_ITEM, 2) = runeID _
    Then runesLeft = True
    
    If runesLeft = False Then
        For i = 0 To ReadMem(ADR_BP_NUM_ITEMS + (bpIndex - &H40) * SIZE_BP, 1) - 1
            If ReadMem(ADR_BP_ITEM + (bpIndex - &H40) * SIZE_BP + i * SIZE_ITEM, 2) = runeID _
            And itemIndex <> i Then
                runesLeft = True
                Exit For
            End If
        Next i
    End If
    
    UseAt runeID, bpIndex, itemIndex, pX, pY, pZ
    
    Pause 50
    
    If runesLeft = False Then UpBpLevel bpIndex - &H40
    
    DoEvents
    
    'AddStatusMessage "Time taken to perform action: " & runeToFire & " = " & GetTickCount - runeTick & " ms."
End Sub

Private Sub txtFriendName_Click()
    With txtFriendName
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub txtFriendName_GotFocus()
    With txtFriendName
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub
