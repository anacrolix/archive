VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CCharacter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mActAb(5) As Integer 'actual ability score member
Private mEffAb(5) As Integer 'effective ability score member
Private mInv(14) As New CItem 'inventory slots
Private mX As Integer, mY As Integer
Private mMvSpd As Single
Private mAttSpd As Single
Private mMap As Variant
Private mRace As EnumRaces
Private mBaseHP As Integer
Private mMaxHP As Integer
Private mCurHP As Integer
Private mClass As EnumClass
Private mIcon As EnumIcon
Private mAttBon As Integer
Private mDmgMax As Integer
Private mDmgBon As Integer
Private mXP As Long
Private mNxtLvlXP As Long
Private mCurLvl As Integer
Private mAC As Integer
Private mWt As Single, mMaxWt As Single

'PROPERTIES

Property Get EqItm(pIdx As Integer) As CItem
    Set EqItm = mInv(pIdx)
End Property
Property Set EqItm(pIdx As Integer, pItem As CItem)
    Set mInv(pIdx) = pItem
End Property

'ac
Property Get AC() As Integer
    AC = mAC
End Property
Property Let AC(pAC As Integer)
    mAC = pAC
End Property

'nxtlvlxp
Property Get NxtLvlXP() As Long
    NxtLvlXP = mNxtLvlXP
End Property
Property Let NxtLvlXP(pNxtLvlXP As Long)
    mNxtLvlXP = pNxtLvlXP
End Property
'curxp
Property Get XP() As Long
    XP = mXP
End Property

'basehp
Property Let BaseHP(pBaseHP As Integer)
    mBaseHP = pBaseHP
    mMaxHP = mBaseHP + Me.AbMod(aCon) * mCurLvl
End Property
Property Get BaseHP() As Integer
    BaseHP = mBaseHP
End Property

'damage
Property Let DmgMax(pDmgMax As Integer)
    mDmgMax = pDmgMax
End Property
Property Get DmgMax() As Integer
    DmgMax = mDmgMax
End Property

'icon
Property Let Icon(pIcon As EnumIcon)
    mIcon = pIcon
End Property
Property Get Icon() As EnumIcon
    Icon = mIcon
End Property

'class
Property Let Class(pClass As EnumClass)
    mClass = pClass
End Property
Property Get Class() As EnumClass
    Class = mClass
End Property

'curhp
Property Let CurHP(pCurHP As Integer)
    mCurHP = pCurHP
End Property
Property Get CurHP() As Integer
    CurHP = mCurHP
End Property

'maxhp
Property Let MaxHP(pMaxHP As Integer)
    mMaxHP = pMaxHP
End Property
Property Get MaxHP() As Integer
    MaxHP = mMaxHP
End Property

'x
Public Property Let X(pX As Integer)
    mX = pX
End Property
Public Property Get X() As Integer
    X = mX
End Property

'y
Public Property Let Y(pY As Integer)
    mY = pY
End Property
Public Property Get Y() As Integer
    Y = mY
End Property

'map
Property Let Map(pMap As Variant)
    mMap = pMap
End Property
Property Get Map() As Variant
    Map = mMap
End Property

'race
Property Let Race(pRace As EnumRaces)
    mRace = pRace
End Property
Property Get Race() As EnumRaces
    Race = mRace
End Property


'SUBS

Function GetCurWt() As Single
    GetCurWt = mWt
End Function

Sub PickUpItm(pDest As EnumSlots)
    Dim n As Integer
    If Itms.NoItmsInSq(mMap, mX, mY) > 0 Then
        If pDest = eSlotPack And mInv(pDest).Name = "Empty" Then _
        MsgBox "No Pack equipped": Exit Sub
        If pDest = eSlotPack And mInv(eSlotPack).Name <> "Empty" Then
            For n = 1 To Itms.NoItmsInSq(mMap, mX, mY)
                
            Next n
        ElseIf pDest = eSlotOffhand And mInv(pDest).Name = "Empty" Then
            If mWt + Itms.GetItmBySq(mMap, mX, mY).Weight <= Me.MaxWt Then
                Set mInv(eSlotOffhand) = Itms.GetItmBySq(mMap, mX, mY)
                mWt = mWt + mInv(eSlotOffhand).Weight
                Itms.InGame(Itms.GetIdxBySq(mMap, mX, mY)) = False
            Else
                FeedBack "Encumbrance will be too great. Drop some items and try again."
            End If
        End If
    ElseIf Itms.NoItmsInSq(mMap, mX, mY) = 0 Then
        FeedBack "There are no items to pick up here."
    Else
        MsgBox "Error in items returned-impossible item count": End
    End If
End Sub

Sub TakeDmg(pAmount As Integer, pDmgTyp As EnumDamageTypes)
    If Not pDmgTyp = Normal Then MsgBox "invalid dmgtype atm"
    Me.CurHP = Me.CurHP - pAmount
    If Me.CurHP <= 0 Then _
    MsgBox "you dead buddy, death is stubbed!": End
End Sub

Function GetNxtLvlXP(pNxtLvl As Integer) As Long
    GetNxtLvlXP = 500 * (pNxtLvl ^ 2 - pNxtLvl)
End Function

Sub LevelUp()
    mCurLvl = mCurLvl + 1
    If mClass = Fighter Then
        Me.BaseHP = Me.BaseHP + Roll(2, 10, True)
        mNxtLvlXP = GetNxtLvlXP(mCurLvl + 1)
        'select new spell
    End If
End Sub

Sub AddXP(pXP As Long)
    mXP = mXP + pXP
    If mXP > mNxtLvlXP Then
        Me.LevelUp
    End If
End Sub

Private Sub ChkAbDeath()
    For I = 0 To 5
        If mActAb(I) = 0 Or mEffAb(I) = 0 Then
            MsgBox "character attribute death!"
        End If
    Next I
End Sub

Sub SetPosition(pX As Integer, pY As Integer)
    mX = pX
    mY = pY
End Sub

Sub SeeAround()
    Dim nAngle As Single, nX As Integer, nY As Integer, nDist As Single
    Dim CanSee As Boolean
    Maps(ChAr.Map).Explored(mX, mY) = True
    For nX = 0 To Maps(ChAr.Map).Width - 1
        For nY = 0 To Maps(ChAr.Map).Height - 1
            Maps(ChAr.Map).CanSee(nX, nY) = False
        Next nY
    Next nX
    For nAngle = 0 To 2 * Pi Step Pi / 24
        nDist = 1
        CanSee = True
        Do
            nX = mX + Round(nDist * Cos(nAngle), 0)
            nY = mY + Round(nDist * Sin(nAngle), 0)
            Maps(ChAr.Map).CanSee(nX, nY) = True
            If Maps(ChAr.Map).Blocked(nX, nY) = True Then CanSee = False
            nDist = nDist + 1
        Loop Until CanSee = False
    Next nAngle
        
End Sub

Sub SeeAdjacent()
    Dim nCnt As Long, dX As Integer, dY As Integer
    For nCnt = 1 To 9
        GetdXdY nCnt, dX, dY
        Maps(ChAr.Map).Explored(ChAr.X + dX, ChAr.Y + dY) = True
    Next nCnt
End Sub

Sub Move(pDirection As EnumDirection)
    Dim dX As Integer, dY As Integer
    Dim Finish As Long, Start As Long
    Static Average As Single, Count As Long
    Start = GetTickCount
    GetdXdY pDirection, dX, dY
    If Maps(mMap).Blocked(mX + dX, mY + dY) = True Then FeedBack "Invalid Move request": Exit Sub
    If Mons.MonInTile(mMap, mX + dX, mY + dY) Then
        'attack
        Dim Attack As Integer, Damage As Integer, Defense As Integer
        Dim nVic As Integer, AttStr As String
        nVic = Mons.IndexOfMon(mMap, mX + dX, mY + dY)
        Attack = Roll(1, 40) + mAttack + mEffAb(0) - 10
        Defense = Mons.Monster(nVic).AC
        AttStr = "You attack the " & Mons.Monster(nVic).Name & " and "
        If Attack >= Defense Then
            Damage = Roll(1, mDmgMax) + ChAr.AbMod(aStr)
            Mons.Monster(nVic).TakeDamage Damage, Normal
            AttStr = AttStr & "hit (" & Attack & " to " & Defense & ") for " & Damage & " damage"
        Else
            AttStr = AttStr & "miss (" & Attack & " to " & Defense & ")"
        End If
        Time.AddSecs 6 / mAttSpd
        Mons.GrantTime 6 / mAttSpd
        FeedBack (AttStr)
    Else
        'move
        mX = mX + dX
        mY = mY + dY
        Time.AddSecs 4 / mMvSpd
        Mons.GrantTime 4 / mMvSpd
        If InBuffer Then CenterScreen
    End If
    Mons.TakeTurn
    SeeAround
    DrawView
    UpdateStatus
    Finish = GetTickCount
    Average = (Average * Count + (Finish - Start)) / (Count + 1)
    Count = Count + 1
    If Count / 10 - Int(Count / 10) = 0 Then _
    FeedBack "DEBUG-Average Move Alg Time: " & (Average)
End Sub

Sub SetMvSpd(pMvSpd As Single)
    mMvSpd = pMvSpd
End Sub

Sub SetAttSpd(pAttSpd As Single)
    mAttSpd = pAttSpd
End Sub

Sub SetActAb(pAbility As EnumAbilities, pScore As Integer)
    EffAbOfst% = mEffAb(pAbility) - mActAb(pAbility)
    If pScore < 0 Then MsgBox "Can't set abilities negative"
    mActAb(pAbility) = pScore
    mEffAb(pAbility) = pScore + EffAbOfst%
    ChkAbDeath
End Sub

Function GetActAb(pAbility As EnumAbilities) As Integer
    GetActAb = mActAb(pAbility)
End Function

Sub ChgActAb(pAbility As EnumAbilities, pScoreChg As Integer)
    EffAbOfst% = mEffAb(pAbility) - mActAb(pAbility)
    mActAb(pAbility) = mActAb(pAbility) + pScoreChg
    mEffAb(pAbility) = mActAb(pAbility) + EffAbOfst%
    ChkAbDeath
End Sub

Sub ChgEffAb(pAbility As EnumAbilities, pScoreChg As Integer)
    mEffAb(pAbility) = mEffAb(pAbility) + pScoreChg
    ChkAbDeath
End Sub

Sub ResetEffAb(pAbility As EnumAbilities)
    mEffAb(pAbility) = mActAb(pAbility)
End Sub

Function MaxWt() As Single
    MaxWt = mEffAb(aStr) ^ 2
End Function

Function AbMod(pAbility As EnumAbilities) As Integer
    AbMod = Int(mEffAb(pAbility) / 2 - 5)
End Function

Function AbActScore(pAbility As EnumAbilities) As Integer
    AbActScore = mActAb(pAbility)
End Function

Private Sub Class_Initialize()
    For I = 0 To 5
        mActAb(I) = 1
        mEffAb(I) = 1
    Next I
    Me.BaseHP = 10
    mMvSpd = 1
    mAttSpd = 1
    mCurLvl = 1
End Sub
