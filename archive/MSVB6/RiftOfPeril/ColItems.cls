VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ColItems"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Type TypeMapItem
    Item As CItem
    Map As Variant
    X As Integer
    Y As Integer
    InGame As Boolean
End Type

Private mItems() As TypeMapItem
Private mItmCnt As Integer

Property Get Item(pIndex As Integer) As CItem
    Set Item = mItems(pIndex).Item
End Property

Property Get X(pIndex As Integer) As Integer
    X = mItems(pIndex).X
End Property

Property Get Y(pIndex As Integer) As Integer
    Y = mItems(pIndex).Y
End Property

Property Get ItmCnt() As Integer
    ItmCnt = mItmCnt
End Property

Property Get Map(pIndex As Integer) As Variant
    Map = mItems(pIndex).Map
End Property

Property Get InGame(pIndex As Integer) As Boolean
    InGame = mItems(pIndex).InGame
End Property
Property Let InGame(pIndex As Integer, pInGame As Boolean)
    mItems(pIndex).InGame = pInGame
End Property


Function GetIdxBySq(pMap As Variant, pX As Integer, pY As Integer) As Integer
    Dim n As Integer
    GetIdxBySq = -1
    If mItmCnt > 0 Then
        For n = 0 To mItmCnt - 1
            With mItems(n)
                If .X = pX And .Y = pY And .Map = pMap And .InGame Then _
                GetIdxBySq = n: Exit Function
            End With
        Next n
    End If
End Function

Function GetItmBySq(pMap As Variant, pX As Integer, pY As Integer) As CItem
    Dim n As Integer
    Set GetItmBySq = Nothing
    If mItmCnt > 0 Then
        For n = 0 To mItmCnt - 1
            With mItems(n)
                If .X = pX And .Y = pY And .Map = pMap And .InGame Then _
                Set GetItmBySq = .Item: Exit Function
            End With
        Next n
    End If
End Function

Function NoItmsInSq(pMap As Variant, pX As Integer, pY As Integer) As Integer
    Dim n As Integer
    NoItmsInSq = 0
    If mItmCnt > 0 Then
        For n = 0 To mItmCnt - 1
            With mItems(n)
                If .X = pX And .Y = pY And .Map = pMap And .InGame Then _
                NoItmsInSq = NoItmsInSq + 1
            End With
        Next n
    End If
End Function

Sub Add(pItem As CItem, pMap As Variant, pX As Integer, pY As Integer)
    Dim nCnt As Integer, Index As Integer
    Index = -1
    If mItmCnt > 0 Then
        For nCnt = 0 To mItmCnt - 1
            If mItems(nCnt).InGame = False Then Index = nCnt: Exit For
        Next nCnt
    End If
    If Index = -1 Then
        ReDim Preserve mItems(mItmCnt)
        Index = mItmCnt
        mItmCnt = mItmCnt + 1
    End If
    With mItems(Index)
        Set .Item = pItem
        .Map = pMap
        .X = pX
        .Y = pY
        .InGame = True
    End With
End Sub
