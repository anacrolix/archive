VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DiceRoll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarNumDice As Integer 'local copy
Private mvarDiceMax As Integer 'local copy
Private mvarBonus As Integer 'local copy
Public Enum EnumPolyhedral
    d2 = 2
    d3 = 3
    d4 = 4
    d6 = 6
    d8 = 8
    d10 = 10
    d12 = 12
    d20 = 20
End Enum
Function Roll() As Integer
    Dim nRoll As Integer
    Roll = 0
    For nRoll = 1 To mvarNumDice
        Roll = Roll + Int(Rnd * mvarDiceMax) + 1
    Next nRoll
    Roll = Roll + mvarBonus
End Function

Public Sub SetRollProps(pNumDice, pBonus As Integer, pDiceMax As EnumPolyhedral)
    mvarNumDice = pNumDice
    mvarDiceMax = pDiceMax
    mvarBonus = pBonus
End Sub

Public Property Let Bonus(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Bonus = 5
    mvarBonus = vData
End Property


Public Property Get Bonus() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Bonus
    Bonus = mvarBonus
End Property



Public Property Let DiceMax(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.DiceMax = 5
    mvarDiceMax = vData
End Property


Public Property Get DiceMax() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.DiceMax
    DiceMax = mvarDiceMax
End Property



Public Property Let NumDice(ByVal vData As Integer)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.NumDice = 5
    mvarNumDice = vData
End Property


Public Property Get NumDice() As Integer
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.NumDice
    NumDice = mvarNumDice
End Property



