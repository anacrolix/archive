VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CEntity"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mX As Integer
Private mY As Integer
Private mType As EnumEntity
Private mDetail As String
Private mIcon As EnumIcon

Sub SetUpEntity(pX As Integer, pY As Integer, pIcon As EnumIcon, _
pType As EnumEntity, pAction As String)
    SetPosition pX, pY
    SetIcon pIcon
    SetFunction pType, pAction
End Sub

Sub SetIcon(pIcon As EnumIcon)
    mIcon = pIcon
End Sub

Sub SetPosition(pX As Integer, pY As Integer)
    mX = pX
    mY = pY
End Sub

Sub SetFunction(pType As EnumEntity, Optional pDetail As String = "")
    mType = pType
    mDetail = pDetail
End Sub

Property Get X() As Integer
    X = mX
End Property

Property Get Y() As Integer
    Y = mY
End Property

Function GetIcon() As EnumIcon
    GetIcon = mIcon
End Function
