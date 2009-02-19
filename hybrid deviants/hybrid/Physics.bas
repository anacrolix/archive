Attribute VB_Name = "Physics"
Public Const Gravity = 9.8

Public Function Collision(X1, Y1, Rad1, X2, Y2, Rad2 As Single) As Boolean

    If ((X1 - X2) ^ 2 + (Y1 - Y2) ^ 2) ^ (1 / 2) < Rad1 + Rad2 Then
        Collision = True
    Else
        Collision = False
    End If

End Function
        
Public Function CircleRefraction(XVec, YVec, X1, Y1, CirX, CirY, CircRad As Single)

Dim Angle, Normal, Speed As Double

    Angle = Atn(YVec / XVec)
    Speed = (XVec ^ 2 + YVec ^ 2) ^ (1 / 2)
    Normal = Atn((Y1 - Y2) / (X1 - X2))
End Function

'End Function
'
'
'
'        If Ball.Collision = False Then
'            BallAngle = Atn(Ball.YVel / Ball.XVel)
'            Speed = ((Ball.XVel) ^ 2 + (Ball.YVel) ^ 2) ^ (1 / 2)
'            ColNorm = Atn((Ball.Y - Bat.Y) / (Ball.X - Bat.X))
'            If BallAngle > 0 And ColNorm > 0 Then
'                BallAngle = ColNorm * 2 - BallAngle
'                Ball.XVel = -Speed * Cos(BallAngle)
'                Ball.YVel = -Speed * Sin(BallAngle)
 '           Else
 '               BallAngle = 2 * ColNorm - BallAngle
 '               Ball.XVel = Speed * Cos(BallAngle)
 '               Ball.YVel = Speed * Sin(BallAngle)
 '           End If
 '           Ball.Collision = True
 '       End If
 '   Else
 '       Ball.Collision = False
 '   End If

