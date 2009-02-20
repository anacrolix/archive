VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Item"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarDesc As String 'local copy
Private mvarWorth As Integer 'local copy
Private mvarIdentified As Boolean 'local copy
Public Enum EnumArcanity
    Normal = 1
    Cursed = 2
    Enchanted = 3
End Enum
Private mvarArcanity As EnumArcanity 'local copy
Public Property Let Arcanity(ByVal vData As EnumArcanity)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Arcanity = Form1
    Set mvarArcanity = vData
End Property


Public Property Get Arcanity() As EnumArcanity
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Arcanity
    Set Arcanity = mvarArcanity
End Property




Public Property Let Identified(ByVal vData As Boolean)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Identified = 5
    mvarIdentified = vData
End Property


Public Property Get Identified() As Boolean
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Identified
    Identified = mvarIdentified
End Property



Public Property Let Worth(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Worth = 5
    mvarWorth = vData
End Property


Public Property Get Worth() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Worth
    Worth = mvarWorth
End Property



Public Property Let Desc(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Desc = 5
    mvarDesc = vData
End Property


Public Property Get Desc() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Desc
    Desc = mvarDesc
End Property



