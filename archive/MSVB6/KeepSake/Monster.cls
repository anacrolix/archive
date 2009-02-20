VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Monster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"Attacks"
Attribute VB_Ext_KEY = "Member1" ,"Treasure"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarPosition As Coordinate 'local copy
Private mvarAttacks As Attacks
Private mvarTreasure As Treasure
Private mvarCurHP As Integer 'local copy
Private mvarMaxHP As Integer 'local copy
Private mvarStatus As String 'local copy
Private mvarXPVal As Integer 'local copy
Public Property Let XPVal(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.XPVal = 5
    mvarXPVal = vData
End Property


Public Property Get XPVal() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.XPVal
    XPVal = mvarXPVal
End Property



Public Property Let Status(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Status = 5
    mvarStatus = vData
End Property


Public Property Get Status() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Status
    Status = mvarStatus
End Property



Public Property Let MaxHP(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.MaxHP = 5
    mvarMaxHP = vData
End Property


Public Property Get MaxHP() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.MaxHP
    MaxHP = mvarMaxHP
End Property



Public Property Let CurHP(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.CurHP = 5
    mvarCurHP = vData
End Property


Public Property Get CurHP() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.CurHP
    CurHP = mvarCurHP
End Property





Public Property Get Treasure() As Treasure
    If mvarTreasure Is Nothing Then
        Set mvarTreasure = New Treasure
    End If


    Set Treasure = mvarTreasure
End Property


Public Property Set Treasure(vData As Treasure)
    Set mvarTreasure = vData
End Property



Public Property Get Attacks() As Attacks
    If mvarAttacks Is Nothing Then
        Set mvarAttacks = New Attacks
    End If


    Set Attacks = mvarAttacks
End Property


Public Property Set Attacks(vData As Attacks)
    Set mvarAttacks = vData
End Property
Private Sub Class_Terminate()
  Set mvarTreasure = Nothing
    Set mvarAttacks = Nothing
End Sub



Public Property Set Position(ByVal vData As Coordinate)
'used when assigning an Object to the property, on the left side of a Set statement.
'Syntax: Set x.Position = Form1
    Set mvarPosition = vData
End Property


Public Property Get Position() As Coordinate
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Position
    Set Position = mvarPosition
End Property



