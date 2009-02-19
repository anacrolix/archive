VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Attack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarDescription As String 'local copy
Private mvarNumAttacks As Integer 'local copy
Private mvarShortDesc As String 'local copy
Private mvarDamage As New DiceRoll 'local copy
Private mvarAttVal As Integer
Public Enum EnumAttackType
    Normal = 1
    ConDrain = 2
End Enum
Public Enum EnumMonAtt
    SnakeBite = 1
    SkelClaw = 2
    ZomBash = 3
    WarSword = 4
End Enum
Private mvarAttType As EnumAttackType 'local copy
Private mvarRange As Integer 'local copy

Public Sub Attack(ByVal MonNo As Integer)
    Dim ChanceToHit, NumSucAtts, DmgDone As Integer
    ChanceToHit = mvarAttVal - Char.DefVal
    Call DisplayMessage("The " & Monster(MonNo).Name & " has " & ChanceToHit & " chance to hit you.")
    For nattack% = 1 To mvarNumAttacks
        If Rnd * 100 + 1 < ChanceToHit Then
            DmgDone = DmgDone + mvarDamage.Roll
            NumSucAtts = NumSucAtts + 1
        End If
    Next nattack%
    With Monster(MonNo)
        Call DisplayMessage("The " & .Name & " " & mvarDescription & " " & NumSucAtts & " times for " & DmgDone & " damage")
    End With
' calculate hit size
If DmgDone <= 5 Then HitIcon% = 0
If DmgDone > 5 And DmgDone <= 10 Then HitIcon% = 1
If DmgDone > 10 Then HitIcon% = 2

' show attack graphic on hero or monster
    Call DrawASquare(Char.X, Char.Y, 4, HitIcon%)
    Form1.Refresh

' wait until timer tells us its ok to erase the graphic
SplashFlag = False
Form1.SplashTimer.Enabled = True
Do
    DoEvents
Loop Until SplashFlag = True
Form1.SplashTimer.Enabled = False

Char.HitPtCur = Char.HitPtCur - DmgDone
' erase attack graphic by redrawing hero/monster

End Sub

Public Property Let AttVal(ByVal vData As Integer)
    mvarAttVal = vData
End Property

Public Property Get AttVal() As Integer
    AttVal = mvarAttVal
End Property

Public Property Let Range(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Range = 5
    mvarRange = vData
End Property

Public Property Get Range() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Range
    Range = mvarRange
End Property



Public Property Let AttType(ByVal vData As EnumAttackType)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.AttType = Form1
    mvarAttType = vData
End Property


Public Property Get AttType() As EnumAttackType
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.AttType
    AttType = mvarAttType
End Property


Public Property Set Damage(ByVal vData As DiceRoll)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Damage = Form1
    Set mvarDamage = vData
End Property


Public Property Get Damage() As DiceRoll
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Damage
    Set Damage = mvarDamage
End Property



Public Property Let ShortDesc(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ShortDesc = 5
    mvarShortDesc = vData
End Property


Public Property Get ShortDesc() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ShortDesc
    ShortDesc = mvarShortDesc
End Property



Public Property Let NumAttacks(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.NumAttacks = 5
    mvarNumAttacks = vData
End Property


Public Property Get NumAttacks() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.NumAttacks
    NumAttacks = mvarNumAttacks
End Property



Public Property Let Description(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Description = 5
    mvarDescription = vData
End Property


Public Property Get Description() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Description
    Description = mvarDescription
End Property

Private Sub SetAttProps(pNumAttacks, pRange, pAttVal As Integer, pAttType As EnumAttackType, _
                        pDesc As String)
    mvarNumAttacks = pNumAttacks
    mvarRange = pRange
    mvarAttVal = pAttVal
    mvarAttType = pAttType
    mvarDescription = pDesc
End Sub

Public Sub SetAttack(vData As EnumMonAtt)
    Select Case vData
        Case Is = SnakeBite
            SetAttProps 2, 1, 70, Normal, "bites with it's fangs"
            mvarDamage.SetRollProps 1, 0, d3
        Case Is = SkelClaw
            SetAttProps 2, 1, 60, Normal, "rakes with it's claws"
            mvarDamage.SetRollProps 1, 0, d4
        Case ZomBash
            SetAttProps 1, 1, 70, Normal, "bashes with fist"
            mvarDamage.SetRollProps 1, 0, d8
        Case WarSword
            SetAttProps 1, 1, 100, Normal, "hits with sword"
            mvarDamage.SetRollProps 1, 2, d10
    End Select
End Sub

