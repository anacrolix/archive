VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Char"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarPosition As Coordinate 'local copy
Private mvarStrCur As Integer 'local copy
Private mvarStrMax As Integer 'local copy
Private mvarIntMax As Integer 'local copy
Private mvarIntCur As Integer 'local copy
Private mvarConMax As Integer 'local copy
Private mvarConCur As Integer 'local copy
Private mvarDexMax As Integer 'local copy
Private mvarDexCur As Integer 'local copy
Private mvarManaMax As Integer 'local copy
Private mvarManaCur As Integer 'local copy
Private mvarHPcur As Integer 'local copy
Private mvarHPmax As Integer 'local copy
Public Property Let HPmax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.HPmax = 5
    mvarHPmax = vData
End Property


Public Property Get HPmax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.HPmax
    HPmax = mvarHPmax
End Property



Public Property Let HPcur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.HPcur = 5
    mvarHPcur = vData
End Property


Public Property Get HPcur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.HPcur
    HPcur = mvarHPcur
End Property



Public Property Let ManaCur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ManaCur = 5
    mvarManaCur = vData
End Property


Public Property Get ManaCur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ManaCur
    ManaCur = mvarManaCur
End Property



Public Property Let ManaMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ManaMax = 5
    mvarManaMax = vData
End Property


Public Property Get ManaMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ManaMax
    ManaMax = mvarManaMax
End Property



Public Property Let DexCur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.DexCur = 5
    mvarDexCur = vData
End Property


Public Property Get DexCur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.DexCur
    DexCur = mvarDexCur
End Property



Public Property Let DexMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.DexMax = 5
    mvarDexMax = vData
End Property


Public Property Get DexMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.DexMax
    DexMax = mvarDexMax
End Property



Public Property Let ConCur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ConCur = 5
    mvarConCur = vData
End Property


Public Property Get ConCur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ConCur
    ConCur = mvarConCur
End Property



Public Property Let ConMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ConMax = 5
    mvarConMax = vData
End Property


Public Property Get ConMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ConMax
    ConMax = mvarConMax
End Property



Public Property Let IntCur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.IntCur = 5
    mvarIntCur = vData
End Property


Public Property Get IntCur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.IntCur
    IntCur = mvarIntCur
End Property



Public Property Let IntMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.IntMax = 5
    mvarIntMax = vData
End Property


Public Property Get IntMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.IntMax
    IntMax = mvarIntMax
End Property



Public Property Let StrMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.StrMax = 5
    mvarStrMax = vData
End Property


Public Property Get StrMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.StrMax
    StrMax = mvarStrMax
End Property



Public Property Let StrCur(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.StrCur = 5
    mvarStrCur = vData
End Property


Public Property Get StrCur() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.StrCur
    StrCur = mvarStrCur
End Property



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



