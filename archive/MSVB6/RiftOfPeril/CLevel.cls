VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CLevel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mTile() As New CTile
Private mEntity() As New CEntity
Private mEntCnt As Integer
Private mLevelName As String
Private mWidth As Integer
Private mHeight As Integer

'PROPERTIES

'cansee
Property Let CanSee(pX As Integer, pY As Integer, pCanSee As Boolean)
    mTile(pX, pY).CanSee = pCanSee
End Property
Property Get CanSee(pX As Integer, pY As Integer) As Boolean
    CanSee = mTile(pX, pY).CanSee
End Property

Property Get Tile(pX As Integer, pY As Integer) As CTile
    Tile = mTile(nX, nY)
End Property

'numents
Property Get NumEnts() As Integer
    NumEnts = mEntCnt
End Property

'tiletype
Property Let TileType(pX As Integer, pY As Integer, _
pTileType As EnumTileType)
    mTile(pX, pY).TileType = pTileType
End Property
Property Get TileType(pX As Integer, pY As Integer) As EnumTileType
    TileType = mTile(pX, pY).TileType
End Property

'entity
Public Property Get Entity(pIndex As Integer) As CEntity
    Set Entity = mEntity(pIndex)
End Property

'height
Public Property Let Height(ByVal vdata As Integer)
    mHeight = vdata
    SetDimensions
End Property
Public Property Get Height() As Integer
    Height = mHeight
End Property

'width
Public Property Let Width(ByVal vdata As Integer)
    mWidth = vdata
    SetDimensions
End Property
Public Property Get Width() As Integer
    Width = mWidth
End Property

'levelname
Public Property Let LevelName(ByVal vdata As String)
    mLevelName = vdata
End Property
Public Property Get LevelName() As String
    LevelName = mLevelName
End Property

'icon
Property Let Icon(pX As Integer, pY As Integer, pIcon As EnumIcon)
    mTile(pX, pY).Icon = pIcon
End Property
Property Get Icon(pX As Integer, pY As Integer) As EnumIcon
    Icon = mTile(pX, pY).Icon
End Property

'blocked
Property Get Blocked(pX As Integer, pY As Integer) As Boolean
    Blocked = mTile(pX, pY).Blocked
End Property
Property Let Blocked(pX As Integer, pY As Integer, pBlocked As Boolean)
    mTile(pX, pY).Blocked = pBlocked
End Property

'explored
Property Get Explored(pX As Integer, pY As Integer) As Boolean
    Explored = mTile(pX, pY).Explored
End Property
Property Let Explored(pX As Integer, pY As Integer, pExplored As Boolean)
    mTile(pX, pY).Explored = pExplored
End Property

'SUBS



Public Sub NewEntity(pX As Integer, pY As Integer, pIcon As EnumIcon, _
pType As EnumEntity, pDetail As String)
    ReDim Preserve mEntity(mEntCnt)
    mEntity(mEntCnt).SetUpEntity pX, pY, pIcon, pType, pDetail
    mEntCnt = mEntCnt + 1
End Sub

Private Sub SetDimensions()
    If mWidth < 1 Then mWidth = 1
    If mHeight < 1 Then mHeight = 1
    ReDim Preserve mTile(mWidth - 1, mHeight - 1)
End Sub

Public Sub SetTile(pX As Integer, pY As Integer, pBlocked As Boolean, _
pTileType As EnumTileType, pIcon As EnumIcon)
    With mTile(pX, pY)
        .Blocked = pBlocked
        .Icon = pIcon
        .TileType = pTileType
    End With
End Sub
