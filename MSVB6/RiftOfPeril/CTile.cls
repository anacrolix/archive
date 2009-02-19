VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarIcon As Integer 'local copy
Private mvarBlocked As Boolean 'local copy
Private mvarExplored As Boolean 'local copy
Private mTileType As EnumTileType
Private mCanSee As Boolean

Property Let CanSee(pCanSee As Boolean)
    mCanSee = pCanSee
    If pCanSee = True Then mvarExplored = True
End Property
Property Get CanSee() As Boolean
    CanSee = mCanSee
End Property

Public Property Let Explored(ByVal vdata As Boolean)
    mvarExplored = vdata
End Property

Public Property Get Explored() As Boolean
    Explored = mvarExplored
End Property

Public Property Let Blocked(ByVal vdata As Boolean)
    mvarBlocked = vdata
End Property

Public Property Get Blocked() As Boolean
    Blocked = mvarBlocked
End Property

Public Property Let Icon(ByVal vdata As EnumIcon)
    mvarIcon = vdata
End Property

Public Property Get Icon() As EnumIcon
    Icon = mvarIcon
End Property

'tiletype
Public Property Get TileType() As EnumTileType
    TileType = mTileType
End Property
Public Property Let TileType(pTileType As EnumTileType)
    mTileType = pTileType
End Property


