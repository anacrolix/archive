Attribute VB_Name = "Physics"
Const G = 4

Public Enum Direction
    Up = 1
    Right = 2
    Down = 3
    Left = 4
    None = 0
End Enum

Public Type typFoot
    Dir As Direction
    XPos As Single
    YPos As Single
    Radius As Double
    Speed As Double
End Type

Public Type typBall
    XVel As Single
    YVel As Single
    XPos As Single
    YPos As Single
    Radius As Double
    Collided As Boolean
End Type

Public Foot As typFoot
Public Ball As typBall

Public Sub Calculate()
    MoveFoot
    MoveBall
End Sub

Private Sub MoveFoot()
Dim Acceleration As Double

If Foot.Dir <> None Then
    Select Case Foot.Dir
        Case Up
        Case Right
            Acceleration = 0.5
            Foot.Speed = Foot.Speed + Acceleration
        Case Down
        Case Left
            Acceleration = -0.5
            Foot.Speed = Foot.Speed + Acceleration
    End Select
End If

If Foot.Speed > 0 Then Foot.Speed = Foot.Speed - (Foot.Speed ^ 2) / 125
If Foot.Speed < 0 Then Foot.Speed = Foot.Speed + (Foot.Speed ^ 2) / 125

If Foot.XPos + Foot.Speed > ScreenWidth Or Foot.XPos + Foot.Speed < 0 Then
    If Foot.XPos + Foot.Speed > ScreenWidth Then
        Foot.XPos = Foot.XPos + (Foot.Speed - 2 * (ScreenWidth - Foot.XPos)) * -1
        Foot.Speed = Foot.Speed * -1
    Else
        Foot.XPos = Foot.XPos + (Foot.Speed + 2 * -Foot.XPos) * -1
        Foot.Speed = Foot.Speed * -1
    End If
Else
    Foot.XPos = Foot.XPos + Foot.Speed
End If



Foot.Dir = None
End Sub
Private Sub MoveBall()
Dim Speed, Normal, pX, pY As Single

    If ((Ball.XPos - Foot.XPos) ^ 2 + (Ball.YPos - Foot.YPos) ^ 2) ^ 0.5 < Ball.Radius + Foot.Radius Then
        Speed = (Ball.XVel ^ 2 + Ball.YVel ^ 2) ^ 0.5
        pX = Ball.XPos - Foot.XPos
        pY = Ball.YPos - Foot.YPos
End Sub
