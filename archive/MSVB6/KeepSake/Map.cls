VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Map"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"Items"
Attribute VB_Ext_KEY = "Member1" ,"Monsters"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvariHeight As Integer 'local copy
Private mvariWidth As Integer 'local copy
Private mvarItems As Items
Private mvarMonsters As Monsters


Public Property Get Monsters() As Monsters
    If mvarMonsters Is Nothing Then
        Set mvarMonsters = New Monsters
    End If


    Set Monsters = mvarMonsters
End Property


Public Property Set Monsters(vData As Monsters)
    Set mvarMonsters = vData
End Property



Public Property Get Items() As Items
    If mvarItems Is Nothing Then
        Set mvarItems = New Items
    End If


    Set Items = mvarItems
End Property


Public Property Set Items(vData As Items)
    Set mvarItems = vData
End Property
Private Sub Class_Terminate()
  Set mvarMonsters = Nothing
    Set mvarItems = Nothing
End Sub



Public Property Let iWidth(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.iWidth = 5
    mvariWidth = vData
End Property


Public Property Get iWidth() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.iWidth
    iWidth = mvariWidth
End Property



Public Property Let iHeight(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.iHeight = 5
    mvariHeight = vData
End Property


Public Property Get iHeight() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.iHeight
    iHeight = mvariHeight
End Property



