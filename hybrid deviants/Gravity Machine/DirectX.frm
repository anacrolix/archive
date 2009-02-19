VERSION 5.00
Begin VB.Form FrmDirectX 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "DirectX Demo"
   ClientHeight    =   3195
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "FrmDirectX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-------------------------------------------------------------'
'This project was made by Matt Hafermann (matt@fusion-web.net)'
'Feel free to use it however you want, this code is free ;)   '
'-------------------------------------------------------------'

'Whether the program is still running
Dim Running As Boolean

'Sprite type
Private Type Sprite
    X As Single
    Y As Single
    XVel As Double
    YVel As Double
    Mass As Single
    SurfIndex As Integer
    RotVel As Single
    Angle As Single
End Type

Const NumCelestials = 10
Dim Celestial(NumCelestials) As Sprite

'For FPS and time-based modelling calculations
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long
Dim TimeElapsed As Double

Sub InitialVars()
Dim CenterScreenX, CenterScreenY As Single

'Determine Values for center of screen
CenterScreenX = (ScreenWidth - Surfaces(1).Width) / 2
CenterScreenY = (ScreenHeight - Surfaces(1).Height) / 2

'Set initial defaults for all celestials
For i = 0 To UBound(Celestial)
    With Celestial(i)
        .X = CenterScreenX
        .YVel = 0
        .RotVel = pi / 180
        .Angle = 0
    End With
Next i

'The Sun
With Celestial(0)
    .Y = CenterScreenY
    .XVel = 0
    .Mass = 330000
    .SurfIndex = 1
End With
'Mercury
With Celestial(1)
    .Y = CenterScreenY - 4
    .XVel = 0.0474341649
    .Mass = 0.06
    .SurfIndex = 2
End With
'Venus
With Celestial(2)
    .Y = CenterScreenY - 7
    .XVel = 0.49004373
    .Mass = 0.82
    .SurfIndex = 3
End With
'Earth
With Celestial(3)
    .Y = CenterScreenY - 10
    .XVel = 0.5
    .Mass = 1
    .SurfIndex = 4
End With
'Mars
With Celestial(4)
    .Y = CenterScreenY - 15
    .XVel = 0.044907312
    .Mass = 0.11
    .SurfIndex = 5
End With
'Jupiter
With Celestial(5)
    .Y = CenterScreenY - 52
    .XVel = 70.1646416
    .Mass = 320
    .SurfIndex = 6
End With
'Saturn
With Celestial(6)
    .Y = CenterScreenY - 95
    .XVel = 15.411035
    .Mass = 95
    .SurfIndex = 7
End With
'Uranus
With Celestial(7)
    .Y = CenterScreenY - 192
    .XVel = 1.71163299
    .Mass = 15
    .SurfIndex = 8
End With
'Neptune
With Celestial(8)
    .Y = CenterScreenY - 301
    .XVel = 1.54930056
    .Mass = 17
    .SurfIndex = 9
End With
'Pluto
With Celestial(9)
    .Y = CenterScreenY - 395
    .XVel = 0.000238667185
    .Mass = 0.003
    .SurfIndex = 10
    .Angle = 1
End With
'Halley's
With Celestial(10)
    .Y = CenterScreenY
    .X = CenterScreenX - 500
    .Mass = 0.000005
    .SurfIndex = 11
    .Angle = 0
    .XVel = 0.000001
    .YVel = 0.0000001
End With
'A moon in orbit around jupiter
'With Celestial(10)
'    .Y = Celestial(5).Y - 5
'    .XVel = 0.220192753 + Celestial(5).XVel * 10 / Celestial(5).Mass
'    .Mass = 12
'    .SurfIndex = 11
'End With
'With Celestial(11)
'    .Y = CenterScreenY - 5
'    .X = CenterScreenX - 300
'    .XVel = 0
'    .YVel = 0
'    .Mass = 0.0001
'    .SurfIndex = 1
'End With
End Sub

Private Sub Form_Load()
    
    'Initialize DirectDraw
    DDraw.Initialize
    'Initialize DirectInput
    DInput.Initialize
    Physics.Initialize
    'Show the form
    Me.Show
    'Initialize sun and celestial(1)
    InitialVars
    'Run the main loop
    Running = True
    MainLoop

End Sub

Private Sub MainLoop()

Dim Freq As Currency
Dim StartTime As Currency
Dim EndTime As Currency
Static FrameCounter As Integer
Static FPSTimer As Long
Static FPS As Integer

On Error GoTo ErrOut
    
Do While Running

    'Initialize time-based modelling (maintains smooth movement on any computer)
    QueryPerformanceFrequency Freq
    QueryPerformanceCounter StartTime
    
    'Get keypresses
    HandleKeys
    'Draw the background image
    DDraw.DisplaySprite 0, 0, 0, Surfaces(0).Width, Surfaces(0).Height, , , ScreenWidth, ScreenHeight

    'Update and draw sprites
    HandleSprites
    
    'Draw text information
    'BackBuffer.DrawText 0, 0, "Fading - Press F (" & Fading & ")", False
    BackBuffer.DrawText 0, 0, "FPS: " & FPS, False
    BackBuffer.DrawCircle Celestial(0).X + 32, Celestial(0).Y + 32, ((Celestial(0).X - Celestial(10).X) ^ 2 + (Celestial(0).Y - Celestial(10).Y) ^ 2) ^ (1 / 2)
    BackBuffer.DrawText 0, 15, "Velocity: " & (Celestial(10).XVel ^ 2 + Celestial(10).YVel ^ 2) ^ (1 / 2) / Celestial(10).Mass, False
    BackBuffer.DrawText 0, 30, "Direction: " & Atn(Celestial(10).YVel / Celestial(10).XVel) / pi * 180, False
    'BackBuffer.DrawText 0, 15, "Speed of comet: " & Celestial(11).XVel / Celestial(11).Mass, False
    'BackBuffer.DrawText 0, 30, "Gravitational Constant= " & Gravity, False
    'For i = 0 To UBound(Celestial)
    '    With Celestial(i)
    '        BackBuffer.DrawLine .X + 32, .Y + 32, .X + 32 + .XVel / .Mass * 100, .Y + 32 + .YVel / .Mass * 100
    '    End With
    'Next i
    
    'Flip the backbuffer to the screen
    DDraw.Flip
    
    'Erase the backbuffer so that it can be drawn on again
    DDraw.ClearBuffer
    
    'Give windows its chance to do things
    DoEvents
    
    'Finish time-based modelling calculations
    QueryPerformanceCounter EndTime
    TimeElapsed = (EndTime - StartTime) / Freq
    
    'Calculate current frames per second
    If GetTickCount >= (FPSTimer + 1000) Then
        FPS = FrameCounter
        FrameCounter = 0
        FPSTimer = GetTickCount
    Else
        FrameCounter = FrameCounter + 1
    End If
    
Loop

'If an error occurs, leave the program
ErrOut:
ExitProgram
    
End Sub

Sub HandleSprites()

Dim i As Integer
Dim Acute, Force As Single 'Used in celestial-handling physics
Dim GravX(NumCelestials), GravY(NumCelestials) As Single

'Start the scene for D3D sprites
Dev.BeginScene
    
    'Calculate Gravitational effects
    
    For i = 0 To UBound(Celestial)
        'Total all the gravitation effects on celestial(i)
        For j = 0 To UBound(Celestial)
            If Not j = i Then
                Force = Gravity * Celestial(i).Mass * Celestial(j).Mass / ((Celestial(i).Y - Celestial(j).Y) ^ 2 + (Celestial(i).X - Celestial(j).X) ^ 2)
    
                If Celestial(i).X > Celestial(j).X And Celestial(i).Y > Celestial(j).Y Then
                    Acute = Atn((Celestial(i).Y - Celestial(j).Y) / (Celestial(i).X - Celestial(j).X))
                    GravX(i) = GravX(i) - Force * Cos(Acute)
                    GravY(i) = GravY(i) - Force * Sin(Acute)
                ElseIf Celestial(i).X < Celestial(j).X And Celestial(i).Y > Celestial(j).Y Then
                    Acute = Atn((Celestial(i).Y - Celestial(j).Y) / (Celestial(j).X - Celestial(i).X))
                    GravX(i) = GravX(i) + Force * Cos(Acute)
                    GravY(i) = GravY(i) - Force * Sin(Acute)
                ElseIf Celestial(i).X < Celestial(j).X And Celestial(i).Y < Celestial(j).Y Then
                    Acute = Atn((Celestial(j).Y - Celestial(i).Y) / (Celestial(j).X - Celestial(i).X))
                    GravX(i) = GravX(i) + Force * Cos(Acute)
                    GravY(i) = GravY(i) + Force * Sin(Acute)
                ElseIf Celestial(i).X > Celestial(j).X And Celestial(i).Y < Celestial(j).Y Then
                    Acute = Atn((Celestial(j).Y - Celestial(i).Y) / (Celestial(i).X - Celestial(j).X))
                    GravX(i) = GravX(i) - Force * Cos(Acute)
                    GravY(i) = GravY(i) + Force * Sin(Acute)
                End If
            End If
        Next j
    Next i
    
    'Update celestials
    
    For i = 0 To UBound(Celestial)
        With Celestial(i)
            'Modify momentum vectors with gravitational effects
            .XVel = .XVel + GravX(i)
            .YVel = .YVel + GravY(i)
            'Modify celestial positions accordingly
            .X = .X + .XVel / .Mass
            .Y = .Y + .YVel / .Mass
            'Rotate celestials
            .Angle = .Angle + .RotVel
            If .Angle > 2 * pi Then .Angle = .Angle - 2 * pi
            If .Angle < 0 Then .Angle = .Angle + 2 * pi
            'Draw celestials
            DDraw.DisplaySprite .SurfIndex, .X, .Y, Surfaces(.SurfIndex).Width, Surfaces(.SurfIndex).Height, 0, 0, Surfaces(.SurfIndex).Width, Surfaces(.SurfIndex).Height, False, 0, 1, 1, 1, .Angle
            'Draw gravity vectors for celestials
            'BackBuffer.DrawLine .X + 32, .Y + 32, .X + 32 + GravX(i), .Y + 32 + GravY(i)
        End With
    Next i
        
        
    'Draw Celestials onscreen
        
    'For i = 0 To UBound(Celestial)
    '    With Celestial(i)
    '    End With
    'Next i
    'Draw this sprite
    'DDraw.DisplaySprite CInt(Sprites(i).SurfIndex), Sprites(i).X, Sprites(i).Y, CSng(Sprites(i).Width), CSng(Sprites(i).Height), , , Sprites(i).Width * Sprites(i).ScaleFactor, Sprites(i).Height * Sprites(i).ScaleFactor, Sprites(i).ABOne, Sprites(i).Alpha, Sprites(i).R, Sprites(i).G, Sprites(i).B, Sprites(i).Angle
        
'Ends the scene for D3D sprites
Dev.EndScene

End Sub

Public Sub ExitProgram()
    'Unload the DirectDraw variables
    DDraw.Terminate
    'Unload the DirectInput variables
    DInput.Terminate
    'End the program
    End
    
End Sub

Private Sub HandleKeys()

Static Counter As Long
Static Counter2 As Long
Dim i As Integer
    
'Get the states of all the keys
DInput.CheckKeys

'Escape ends the program
If DInput.aKeys(DIK_ESCAPE).Pressed Then Running = False

If GetTickCount >= Counter Then
    Counter = GetTickCount + 100
        If DInput.aKeys(DIK_UP).Pressed Then
            Gravity = Gravity * 2
        ElseIf DInput.aKeys(DIK_DOWN).Pressed Then
            Gravity = Gravity / 2
        End If
End If

'Toggle scaling

'Adding and removing sprites
'If GetTickCount >= Counter Then
'    Counter = GetTickCount + 100
'    'Add a sprite
'    If DInput.aKeys(DIK_ADD).Pressed Then
'        AddSprite
'    'Remove a sprite
'    ElseIf DInput.aKeys(DIK_SUBTRACT).Pressed Then
'        For i = 0 To UBound(Sprites)
'            If Sprites(i).Alive = True Then
'                Sprites(i).Alive = False
'                NumSprites = NumSprites - 1
'                Exit Sub
'            End If
'        Next i
'    End If
'End If

End Sub
