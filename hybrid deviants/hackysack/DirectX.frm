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



'Array of sprites
Dim NumSprites As Long

'For FPS and time-based modelling calculations
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

Private Sub InitialVars()
Foot.Dir = None
Foot.Radius = 32
Foot.Speed = 0
Foot.XPos = 320
Foot.YPos = ScreenHeight

'0=Pi
'90=pi/2
'180=2*pi
'270=3/2*pi

Ball.XVel = 1
Ball.YVel = 0
Ball.Radius = 5
Ball.XPos = ScreenWidth / 2 - 100
Ball.YPos = ScreenHeight / 2 - 100

End Sub


Private Sub Form_Load()
    
    'Initialize DirectDraw
    DDraw.Initialize
    'Initialize DirectInput
    DInput.Initialize
    'Show the form
    Me.Show
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

'On Error GoTo ErrOut
    
Do While Running

    'Initialize time-based modelling (maintains smooth movement on any computer)
    QueryPerformanceFrequency Freq
    QueryPerformanceCounter StartTime
    
    'Get keypresses
    HandleKeys
    Physics.Calculate
    
    'Update and draw
    HandleObjects
    BackBuffer.SetFillColor (0)
    BackBuffer.SetForeColor (0)
    'Draw text information
    BackBuffer.DrawText ScreenWidth - 140, 0, Str(FPS) & " FPS", False
    BackBuffer.DrawText 10, 10, Ball.XVel, False
    BackBuffer.DrawText 10, 20, Ball.YVel, False
    
    'Flip the backbuffer to the screen
    DDraw.Flip
    
    'Erase the backbuffer so that it can be drawn on again
    DDraw.ClearBuffer
    
    'Give windows its chance to do things
    DoEvents
    LastTime = TimeElapsed
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

Sub HandleObjects()
    
    'Draw ball
        BackBuffer.DrawCircle Ball.XPos, Ball.YPos, Ball.Radius
    'Draw foot
        BackBuffer.DrawCircle Foot.XPos, Foot.YPos, Foot.Radius
        
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
    
    'Get the states of all the keys
    DInput.CheckKeys

    'Escape ends the program
    If DInput.aKeys(DIK_ESCAPE).Pressed Then Running = False
    
    If DInput.aKeys(DIK_UP).Pressed Then
    ElseIf DInput.aKeys(DIK_RIGHT).Pressed Then
        Foot.Dir = Right
    ElseIf DInput.aKeys(DIK_DOWN).Pressed Then
    ElseIf DInput.aKeys(DIK_LEFT).Pressed Then
        Foot.Dir = 4
    End If
    
End Sub
