Attribute VB_Name = "modCavebot"
Public Function FindClosestWayPoint(Index As Long) As Long
    Dim tempStr() As String, i As Long
    For i = Index To listCavebotWaypath.ListCount - 1
        tempStr = Split(listCavebotWaypath.List(i), ",")
        If tempStr(0) = "Walk" Then
            tX = CLng(tempStr(1)): tY = CLng(tempStr(2)): tZ = CLng(tempStr(3))
            If GetStepValue(tX - pX, tY - pY) >= 0 And tZ = pZ Then
                FindClosestWayPoint = i
                Exit For
            End If
        End If
    Next i
End Function

