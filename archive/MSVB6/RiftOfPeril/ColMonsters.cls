VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ColMonsters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private mMonsters() As New CMonster
Private mMonCnt As Integer

'PROPERTIES

'nummons
Property Get NumMons() As Integer
    NumMons = mMonCnt
End Property

'monster
Property Get Monster(pIndex As Integer) As CMonster
    Set Monster = mMonsters(pIndex)
End Property

'SUBS

Sub TakeTurn()
    Dim nCnt As Integer
    'check for deaths
    If mMonCnt > 0 Then
        For nCnt = 0 To mMonCnt - 1
            With mMonsters(nCnt)
                If .InGame Then .TakeTurn
            End With
        Next nCnt
    End If
    
    'do actions till all monster's short of time
End Sub

Function IndexOfMon(pMap As Variant, pX As Integer, pY As Integer) _
As Integer
    Dim nCnt As Integer
    IndexOfMon = -1
    If mMonCnt > 0 Then
        For nCnt = 0 To mMonCnt - 1
            With mMonsters(nCnt)
                If .X = pX And .Y = pY And .Map = pMap Then _
                IndexOfMon = nCnt: Exit Function
            End With
        Next nCnt
    End If

End Function

Function MonInTile(ByVal pMap As Variant, ByVal pX As Integer, _
ByVal pY As Integer) As Boolean
    Dim nCnt As Integer
    MonInTile = False
    If mMonCnt > 0 Then
        For nCnt = 0 To mMonCnt - 1
            With mMonsters(nCnt)
                If .X = pX And .Y = pY And .Map = pMap And .InGame = True Then _
                MonInTile = True: Exit Function
            End With
        Next nCnt
    End If
End Function

Sub Add(pMonster As CMonster)
    Dim Index As Integer, Cnt As Integer
    'search for empty slot
    Index = -1
    If mMonCnt > 0 Then
        For Cnt = 0 To mMonCnt - 1
            If mMonsters(Cnt).InGame = False Then
                Index = Cnt
                Exit For
            End If
        Next Cnt
    End If
    If Index = -1 Then
        ReDim Preserve mMonsters(mMonCnt)
        Set mMonsters(mMonCnt) = pMonster
        mMonCnt = mMonCnt + 1
    ElseIf Index > -1 And Index < mMonCnt - 1 Then
        Set mMonsters(Index) = pMonster
    Else
        MsgBox "error, invalid index for monster overwrite": End
    End If

End Sub

Sub AddGenericMonster(pMonType As EnumMonsters, pMap As Variant, _
pX As Integer, pY As Integer)
    Dim NewMonster As CMonster
    Set NewMonster = New CMonster
    If pMonType = Kobold Then
        DataFile.GetMonster NewMonster, "Kobold"
        With NewMonster
            .Name = "Kobold"
            .Icon = MonsterKobold
            .X = pX
            .Y = pY
            .Map = pMap
            .InGame = True
            .Incorporeal = False
        End With
    ElseIf pMonType = Goblin Then
        MsgBox "Can't create goblin yet"
    End If
    Me.Add NewMonster
End Sub

Sub GrantTime(pTime As Single)
    If mMonCnt > 0 Then
        For nCnt = 0 To mMonCnt - 1
            mMonsters(nCnt).GiveTime pTime
        Next nCnt
    End If
End Sub

