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
    Radius As Single
    Collision As Boolean
End Type

Dim Bat As Sprite
Dim Ball As Sprite

'For FPS and time-based modelling calculations
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long
Dim TimeElapsed As Double

Sub InitialVars()
With Ball
    .X = 0
    .Y = 0
    .XVel = 5
    .YVel = 5
    .Radius = 4
End With
With Bat
    .X = (ScreenWidth - Surfaces(SurfBat).Width) / 2 + 0.0001
    .Y = ScreenHeight - Surfaces(SurfBat).Height + 0.00001
    .XVel = 10
    .YVel = 0
    .Radius = 32
End With
End Sub

Private Sub Form_Load()
    
    'Initialize DirectDraw
    DDraw.Initialize
    'Initialize DirectInput
    DInput.Initialize
    'Show the form
    Me.Show
    'Initialize bat and ball
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
    DDraw.DisplaySprite SurfBG, 0, 0, Surfaces(SurfBG).Width, Surfaces(SurfBG).Height, 0, 0, ScreenWidth, ScreenHeight
    'DDraw.DisplaySprite 1, 0, 0, Surfaces(1).Width, Surfaces(1).Height, , , ScreenWidth, ScreenHeight

    'Update and draw sprites
    HandleSprites
    
    'Draw text information
    'BackBuffer.DrawText 0, 0, "Fading - Press F (" & Fading & ")", False
    
    BackBuffer.DrawText 0, 0, ((Ball.X - Bat.X) ^ 2 + (Ball.Y - Bat.Y) ^ 2) ^ (1 / 2), False
    If ((Ball.X - Bat.X) ^ 2 + (Ball.Y - Bat.Y) ^ 2) ^ (1 / 2) <= Ball.Radius + Bat.Radius Then
        BackBuffer.DrawText 0, 15, "Collision!", False
    End If
    BackBuffer.DrawText 0, 30, "Ball Direction: " & 180 * (Atn(Ball.YVel / Ball.XVel)) / pi, False
    BackBuffer.DrawText 0, 45, "Ball Velocity: " & ((Ball.XVel) ^ 2 + (Ball.YVel) ^ 2) ^ (1 / 2), False
    BackBuffer.DrawText 0, 60, "Normal (th): " & Atn((Ball.Y - Bat.Y) / (Ball.X - Bat.X)), False
    
    BackBuffer.DrawLine Ball.X + Surfaces(SurfBall).Width / 2, Ball.Y + Surfaces(SurfBall).Height / 2, Bat.X + Surfaces(SurfBat).Width / 2, Bat.Y + Surfaces(SurfBat).Height / 2
    
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
Dim BallAngle, ColNorm, Speed As Double 'Used in ball-handling physics

'Start the scene for D3D sprites
Dev.BeginScene
    
    'Move Bat if keys pressed
    If DInput.aKeys(DIK_LEFT).Pressed Then
        Bat.X = Bat.X - Bat.XVel
    ElseIf DInput.aKeys(DIK_RIGHT).Pressed Then
        Bat.X = Bat.X + Bat.XVel
    End If
    
    'Draw Bat
    DDraw.DisplaySprite SurfBat, Bat.X, Bat.Y, Surfaces(SurfBat).Width, Surfaces(SurfBat).Height, 0, 0, Surfaces(SurfBat).Width, Surfaces(SurfBat).Height, False, 0, 1, 1, 1, 0
        
    Ball.YVel = Ball.YVel + Gravity / 30
        
    'Limit Ball on-screen, bounce on walls
    With Ball
        .X = .X + .XVel
        .Y = .Y + .YVel
        If .X < 0 Or .X > ScreenWidth - Surfaces(SurfBall).Width Then
            .XVel = .XVel * -1
        End If
        If .Y < 0 Or .Y > ScreenHeight - Surfaces(SurfBall).Height Then
            .YVel = .YVel * -1
        End If
    End With
    
    'Collision Detection and Vector recalculator
    Collision Ball.X, Ball.Y, Ball.Radius, Bat.X, Bat.Y, Bat.Radius
    'DDraw.BackBuffer.DrawText ScreenWidth / 2, ScreenHeight / 2, "Collision", False
    'End If
    'Draw the ball
    DDraw.DisplaySprite SurfBall, Ball.X, Ball.Y, Surfaces(SurfBall).Width, Surfaces(SurfBall).Height, 0, 0, Surfaces(SurfBall).Width, Surfaces(SurfBall).Height, False, 0, 1, 1, 1, 0
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
