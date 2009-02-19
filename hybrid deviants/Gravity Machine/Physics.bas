Attribute VB_Name = "Physics"
Public Gravity As Single

Public Function RadToDeg(Angle) As Single
    RadToDeg = Angle * pi * 2
End Function

Sub Initialize()
Gravity = 0.00000757575758
End Sub
