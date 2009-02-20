Attribute VB_Name = "DMusic"
Option Explicit

Dim mobjPerf As DirectMusicPerformance
Dim mobjSeg As DirectMusicSegment
Dim mobjLoader As DirectMusicLoader

Public Sub Initialize()

Dim X As Integer
Dim udtPortCaps As DMUS_PORTCAPS

    'Initialize
    Set gdx = New DirectX7
    Set mobjLoader = gdx.DirectMusicLoaderCreate()
    Set mobjPerf = gdx.DirectMusicPerformanceCreate()
    mobjPerf.Init Nothing, 0

    'Get the port
    For X = 1 To mobjPerf.GetPortCount
        Call mobjPerf.GetPortCaps(X, udtPortCaps)
        If udtPortCaps.lFlags And DMUS_PC_SHAREABLE Then
            mobjPerf.SetPort X, 1
            Exit For
        End If
    Next X
    
End Sub

Public Sub Play(strSong As String)

    'Load and play the file
    Set mobjSeg = mobjLoader.LoadSegment(App.Path & "\" & strSong)
    mobjSeg.SetLoopPoints 0, mobjSeg.GetLength - 3000
    mobjSeg.SetRepeats 99
    mobjPerf.PlaySegment mobjSeg, 0, 0

End Sub

Public Sub Terminate()

    Set mobjSeg = Nothing
    mobjPerf.CloseDown
    Set mobjPerf = Nothing
    Set mobjLoader = Nothing
    Set gdx = Nothing

End Sub
