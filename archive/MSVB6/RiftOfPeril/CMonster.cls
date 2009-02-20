VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMonster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private Type TypeAttack
    AttBon As Integer
    NumDice As Integer
    DiceMax As Integer
    DmgBon As Integer
    Desc As String
    DmgType As EnumDamageTypes
End Type
Private mMaxHP As Integer
Private mCurHP As Integer
Private mIcon As EnumIcon
Private mX As Integer
Private mY As Integer
Private mAC As Integer
Private mNumAtts As Integer
Private mAtts() As TypeAttack
Private mGold As Long
Private mXPVal As Long
Private mBankTime As Single
Private mMap As Variant
Private mInGame As Boolean
Private mIncorporeal As Boolean
Private mMvSpd As Integer
Private mAttSpd As Integer
Private mName As String

'PROPERTIES

'name
Property Let Name(pName As String)
    mName = pName
End Property
Property Get Name() As String
    Name = mName
End Property

'incorporeal
Property Let Incorporeal(pIncorporeal As Boolean)
    mIncorporeal = pIncorporeal
End Property
Property Get Incorporeal() As Boolean
    Incorporeal = mIncorporeal
End Property

'ingame
Property Let InGame(pInGame As Boolean)
    mInGame = pInGame
End Property
Property Get InGame() As Boolean
    InGame = mInGame
End Property

'map
Property Let Map(pMap As Variant)
    mMap = pMap
End Property
Property Get Map() As Variant
    Map = mMap
End Property

'gold
Property Let Gold(pGold As Long)
    mGold = pGold
End Property
Property Get Gold() As Long
    Gold = mGold
End Property

'xp
Property Let XPVal(pXPVal As Long)
    mXPVal = pXPVal
End Property
Property Get XPVal() As Long
    XPVal = mXPVal
End Property

'ac
Property Let AC(pAC As Integer)
    mAC = pAC
End Property
Property Get AC() As Integer
    AC = mAC
End Property

'numatts
Property Get NumAtts() As Integer
    NumAtts = mNumAtts
End Property

'x
Property Let X(pX As Integer)
    mX = pX
End Property
Property Get X() As Integer
    X = mX
End Property

'y
Property Let Y(pY As Integer)
    mY = pY
End Property
Property Get Y() As Integer
    Y = mY
End Property

'icon
Property Let Icon(pIcon As EnumIcon)
    mIcon = pIcon
End Property
Property Get Icon() As EnumIcon
    Icon = mIcon
End Property

'maxhp
Property Let MaxHP(pMaxHP As Integer)
    mMaxHP = pMaxHP
End Property
Property Get MaxHP() As Integer
    MaxHP = mMaxHP
End Property

'curhp
Property Let CurHP(pCurHP As Integer)
    mCurHP = pCurHP
End Property
Property Get CurHP() As Integer
    CurHP = mCurHP
End Property

'SUBS

Sub TakeDamage(pAmount As Integer, pDmgTyp As EnumDamageTypes)
    If Not pDmgTyp = Normal Then MsgBox "that damage type stubbed atm": End
    mCurHP = mCurHP - pAmount
    If mCurHP < 1 Then
        'dish out goodies and remove from ingame
        mInGame = False
        ChAr.AddXP mXPVal
    End If
End Sub

Private Function IsValidMove(pDestX As Integer, pDestY As Integer) As Boolean
    If pDestX < 0 Or pDestY < 0 Or pDestX > Maps(ChAr.Map).Width - 1 Or pDestY > Maps(ChAr.Map).Height - 1 Then
        MsgBox "intended destination beyond map bounds"
        IsValidMove = False
        Exit Function
    End If
    'check that square not blocked
    If Maps(ChAr.Map).Blocked(pDestX, pDestY) Or _
    Mons.MonInTile(mMap, pDestX, pDestY) Then
        IsValidMove = False
        Exit Function
    End If
    IsValidMove = True
End Function


Sub RandomMove()
    Dim dX As Integer, dY As Integer, Dirctn As Integer
    Dirctn = Int(Rnd * 8) + 1
    If Dirctn < 1 Or Dirctn > 9 Then _
    MsgBox "illegal random movement by monster": End
    GetdXdY Dirctn, dX, dY
    If IsValidMove(mX + dX, mY + dY) = True _
    Or mIncorporeal = True Then
        mX = mX + dX
        mY = mY + dY
        mBankTime = mBankTime - 4 / mMvSpd
    End If
End Sub

Sub Attack()
    Dim Attack As Integer, Defense As Integer, Damage As Integer
    Dim nCnt As Integer, AttStr As String
    AttStr = mName & " attacks you with a "
    For nCnt = 0 To mNumAtts - 1
        AttStr = AttStr & mAtts(nCnt).Desc
        Attack = Roll(1, 40) + mAtts(nCnt).AttBon
        Defense = ChAr.AC
        If Attack >= Defense Then
            With mAtts(nCnt)
                Damage = Roll(.NumDice, .DiceMax) + .DmgBon
                If Damage < 1 Then Damage = 1
                ChAr.TakeDmg Damage, .DmgType
                AttStr = AttStr & " (" & Damage & ") "
            End With
        Else
            AttStr = AttStr & " (miss) "
        End If
    Next nCnt
    FeedBack (AttStr)
    mBankTime = mBankTime - 6 / mAttSpd
End Sub

Sub Chase()
    Dim Dirctn As EnumDirection, dX As Integer, dY As Integer
    Dirctn = GetDirection(ChAr.X, ChAr.Y, mX, mY)
    GetdXdY Dirctn, dX, dY
    If IsValidMove(mX + dX, mY + dY) = False And mIncorporeal = False Then
        GetdXdY Dirctn - 1, dX, dY
        If IsValidMove(mX + dX, mY + dY) = False Then
            GetdXdY Dirctn + 1, dX, dY
            If IsValidMove(mX + dX, mY + dY) = False Then
                RandomMove
                Exit Sub
            End If
        End If
    End If
    mX = mX + dX
    mY = mY + dY
    mBankTime = mBankTime - 4 / mMvSpd
End Sub

Sub TakeTurn()
    Do
        If modMaths.IsAdjacent(ChAr.X, ChAr.Y, mX, mY) = True Then
            If mBankTime >= 6 / mAttSpd Then
                Attack
            Else
                Exit Do
            End If
        ElseIf Maps(mMap).CanSee(mX, mY) = True Then
            If mBankTime >= 4 / mMvSpd Then
                Chase
            Else
                Exit Do
            End If
        ElseIf mBankTime >= 4 / mMvSpd Then
            RandomMove
        Else
            Exit Do
        End If
    Loop
End Sub

Sub GiveTime(pTime As Single)
    mBankTime = mBankTime + pTime
End Sub

Sub AddAttack(pDesc As String, pAttBon As Integer, pNumDice As Integer, _
pDiceMax As Integer, pDmgBon As Integer)
    ReDim Preserve mAtts(mNumAtts)
    With mAtts(mNumAtts)
        .Desc = pDesc
        .AttBon = pAttBon
        .NumDice = pNumDice
        .DiceMax = pDiceMax
        .DmgBon = pDmgBon
    End With
    mNumAtts = mNumAtts + 1
End Sub

Private Sub Class_Initialize()
    mMvSpd = 1
    mAttSpd = 1
End Sub
