VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Items"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Attribute VB_Ext_KEY = "Collection" ,"Item"
Attribute VB_Ext_KEY = "Member0" ,"Item"
'local variable to hold collection
Private mCol As Collection

Public Function Add(Desc As String, Worth As Integer, Identified As Boolean, Arcanity As EnumArcanity, Optional sKey As String) As Item
    'create a new object
    Dim objNewMember As Item
    Set objNewMember = New Item


    'set the properties passed into the method
    objNewMember.Description = Description
    objNewMember.NumAttacks = NumAttacks
    objNewMember.ShortDesc = ShortDesc
    If IsObject(Damage) Then
        Set objNewMember.Damage = Damage
    Else
        objNewMember.Damage = Damage
    End If
    If IsObject(AttType) Then
        Set objNewMember.AttType = AttType
    Else
        objNewMember.AttType = AttType
    End If
    objNewMember.Range = Range
    objNewMember.Desc = Desc
    objNewMember.Worth = Worth
    objNewMember.Identified = Identified
    If IsObject(Arcanity) Then
        Set objNewMember.Arcanity = Arcanity
    Else
        objNewMember.Arcanity = Arcanity
    End If
    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
    End If


    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing


End Function

Public Property Get Item(vntIndexKey As Variant) As Item
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
  Set Item = mCol(vntIndexKey)
End Property



Public Property Get Count() As Long
    'used when retrieving the number of elements in the
    'collection. Syntax: Debug.Print x.Count
    Count = mCol.Count
End Property


Public Sub Remove(vntIndexKey As Variant)
    'used when removing an element from the collection
    'vntIndexKey contains either the Index or Key, which is why
    'it is declared as a Variant
    'Syntax: x.Remove(xyz)


    mCol.Remove vntIndexKey
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    'this property allows you to enumerate
    'this collection with the For...Each syntax
    Set NewEnum = mCol.[_NewEnum]
End Property


Private Sub Class_Initialize()
    'creates the collection when this class is created
    Set mCol = New Collection
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mCol = Nothing
End Sub

