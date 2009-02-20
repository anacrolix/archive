Attribute VB_Name = "Functions"
Public Function CalculateFunctionX(X, Degree As Integer, Solutions() As Single) As Single
    CalculateFunctionX = X - Solutions(1)
    For i = 2 To Degree
        CalculateFunctionX = CalculateFunctionX * (X - Solutions(i))
    Next i
End Function

Public Function TransformX(X) As Single
TransformX = (X * 16) + ScreenWidth / 2
End Function
Public Function TransformY(Y) As Single
TransformY = ScreenHeight / 2 - (Y / 3)
End Function
