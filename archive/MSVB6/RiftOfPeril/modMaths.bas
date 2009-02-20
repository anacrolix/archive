Attribute VB_Name = "modMaths"
Public Const Pi As Double = 3.14159265358979

Function Roll(pNoDice As Integer, pDiceType As Integer, Optional DropLowest As Boolean = False)
    If pNoDice < 1 Then MsgBox "Invalid Num Dice Call": End
    Dim Rolls() As Integer, LastIndex As Integer
    ReDim Rolls(1 To pNoDice)
    Roll = 0
    For I = 1 To pNoDice
        Rolls(I) = Int((Rnd * pDiceType) + 1)
        If Rolls(I) > pDiceType Or Rolls(I) < 1 Then MsgBox "Impossible die roll": End
    Next I
    If pNoDice = 1 Then
        Roll = Rolls(1)
    Else
        LastIndex = pNoDice
        While LastIndex > 1
            For I = 1 To LastIndex - 1
                If Rolls(I) < Rolls(I + 1) Then
                    Temp% = Rolls(I + 1)
                    Rolls(I + 1) = Rolls(I)
                    Rolls(I) = Temp%
                End If
            Next I
            LastIndex = LastIndex - 1
        Wend
        If DropLowest Then
            For I = 1 To pNoDice - 1
                Roll = Roll + Rolls(I)
            Next I
        Else
            For I = 1 To pNoDice
                Roll = Roll + Rolls(I)
            Next I
        End If
    End If
End Function

Sub GetdXdY(ByVal pDirection As EnumDirection, pDX As Integer, pDY As Integer)
    Select Case pDirection
        Case Is = 1: pDX = -1: pDY = -1
        Case Is = 2: pDX = 0: pDY = -1
        Case Is = 3: pDX = 1: pDY = -1
        Case Is = 4: pDX = 1: pDY = 0
        Case Is = 5: pDX = 1: pDY = 1
        Case Is = 6: pDX = 0: pDY = 1
        Case Is = 7: pDX = -1: pDY = 1
        Case Is = 8: pDX = -1: pDY = 0
        Case Is = 9: pDX = 0: pDY = 0
    End Select
End Sub


Function IsAdjacent(pDestX As Integer, pDestY As Integer, _
pSrcX As Integer, pSrcY As Integer) As Boolean
    If Abs(pDestX - pSrcX) <= 1 And Abs(pDestY - pSrcY) <= 1 Then
        IsAdjacent = True
    Else
        IsAdjacent = False
    End If
End Function

Function GetDirection(pDestX As Integer, pDestY As Integer, _
pSrcX As Integer, pSrcY As Integer) As EnumDirection
    Dim nAngle As Double
    nAngle = Atn((pSrcY - pDestY) / (pDestX - pSrcX + 0.00000001))
    If pDestX < pSrcX Then
        If nAngle < 0 Then
            nAngle = nAngle + Pi
        Else
            nAngle = nAngle - Pi
        End If
    End If
    Select Case nAngle
        Case Is < -Pi: MsgBox "chase angle below lower bounds": End
        Case Is < -Pi / 2 - Pi / 4 - Pi / 8: GetDirection = West
        Case Is < -Pi / 2 - Pi / 8: GetDirection = SouthWest
        Case Is < -Pi / 4 - Pi / 8: GetDirection = South
        Case Is < -Pi / 8: GetDirection = SouthEast
        Case Is < Pi / 8: GetDirection = East
        Case Is < Pi / 4 + Pi / 8: GetDirection = NorthEast
        Case Is < Pi / 2 + Pi / 8: GetDirection = North
        Case Is < Pi - Pi / 8: GetDirection = NorthWest
        Case Is <= Pi: GetDirection = West
        Case Else: MsgBox "impossible chase direction, above upper bounds": End
    End Select
End Function

