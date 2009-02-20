VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private Type TypeBonuses
    Type As EnumBonusType
    Amnt As Integer
    Desc As String
End Type
Private mType As EnumItems
Private mWt As Single
Private mBagWt As Single
Private mBagItms() As New CItem
Private mNoBagItms As Integer
Private mIcon As EnumIcon
Private mBonuses() As TypeBonuses
Private mNoBon As Integer
Private mName As String
Private mIdentified As Boolean
Private mEnchTyp As EnumEnchantType

Property Get ItemType() As EnumItems
    ItemType = mType
End Property
Property Let ItemType(pType As EnumItems)
    mType = pType
End Property

Sub AddBonus(pType As EnumBonusType, pAmnt As Integer, pDesc As String)
    ReDim Preserve mBonuses(mNoBon)
    With mBonuses(mNoBon)
        .Type = pType
        .Amnt = pAmnt
        .Desc = pDesc
    End With
    mNoBon = mNoBon + 1
End Sub

Property Get Name() As String
    Name = mName
End Property
Property Let Name(pName As String)
    mName = pName
End Property

Property Get Weight() As Single
    Weight = mWt
End Property
Property Let Weight(pWeight As Single)
    mWt = pWeight
End Property

Property Get Icon() As EnumIcon
    Icon = mIcon
End Property
Property Let Icon(pIcon As EnumIcon)
    mIcon = pIcon
End Property

Private Sub Class_Initialize()
    mName = "Empty"
End Sub
