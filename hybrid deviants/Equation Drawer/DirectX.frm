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

Private Type Equation
    Active As Boolean
    Calculated As Boolean
    Degree As Integer
    Solutions() As Single
    FX(-ScreenWidth / 2 - 1 To ScreenWidth / 2) As Single
End Type

Dim Equations() As Equation
Dim NumEquations As Integer

'For FPS and time-based modelling calculations
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long
Dim TimeElapsed As Double

Private Sub Form_Load()
    
    'Initialize DirectDraw
    DDraw.Initialize
    'Initialize DirectInput
    DInput.Initialize
    'Initial Variables
    InitialVars
    'Show the form
    Me.Show
    'Run the main loop
    Running = True
    MainLoop

End Sub

Private Sub InitialVars()

ReDim Equations(0)
With Equations(0)
    .Active = True
    .Calculated = False
    .Degree = 3
    ReDim Preserve .Solutions(.Degree)
    .Solutions(1) = -15
    .Solutions(2) = 16
    .Solutions(3) = 7
End With

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
    
    'Calculate Equations
    For i = 0 To NumEquations
        If Equations(i).Active = True And Equations(i).Calculated = False Then
            For j = -ScreenWidth / 2 - 1 To ScreenWidth / 2
                Equations(i).FX(j) = CalculateFunctionX(j, Equations(i).Degree, Equations(i).Solutions)
            Next j
        End If
    Next i

    'Draw the background image

    'Update and draw sprites
    HandleSprites
    
    'Draw text information
    BackBuffer.DrawText ScreenWidth - 125, 0, "Frame Rate: " & FPS, False
    
    'Flip the backbuffer to the screen
    DDraw.Flip
    
    'Erase the backbuffer so that it can be drawn on again
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

'Start the scene for D3D sprites
Dev.BeginScene
    For i = 0 To NumEquations
        If Equations(i).Active = True Then
            For j = -ScreenWidth / 2 To ScreenWidth / 2
                BackBuffer.DrawLine TransformX(j - 1), TransformY(Equations(i).FX(j - 1)), TransformX(j), TransformY(Equations(i).FX(j))
            Next j
        End If
    Next i

    BackBuffer.DrawLine 0, ScreenHeight / 2, ScreenWidth, ScreenHeight / 2
    BackBuffer.DrawLine ScreenWidth / 2, 0, ScreenWidth / 2, ScreenHeight
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
