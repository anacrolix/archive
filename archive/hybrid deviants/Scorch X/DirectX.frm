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
'The current FPS
Dim nFPS As Integer

'Whether the program is still running
Dim bRunning As Boolean

'For FPS and time-based modelling calculations
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long
Dim dTimeElapsed As Double

Private Sub Form_Load()
Dim sMapSelected As String


    'Popup dialog to select map
    ''''
    'sMapSelected = InputBox("Put in map name...", "MAP SELECROTS")
    ''''
    'Load the map
    'Call LoadMap(sMapSelected)
    'Initialize DirectDraw

    
    DDraw.Initialize
    'Initialize DirectInput
    DInput.Initialize
    'Initialize DMusic
    'DMusic.Initialize
    'Show the form
    Me.Show
    'Run the main loop
    bRunning = True
    Call MainLoop
    
End Sub

Private Function LoadMap(sMapToLoad As String) As String
Dim sMapInfo As String
Dim sRead As String
Dim vMapInfo
Dim vTileInfo
Dim FileNo As Integer
    'Get the map from the file
    FileNo = FreeFile()
    Open App.Path & "\maps\" & sMapToLoad For Binary As FileNo
    Get FileNo, , MapInfo
    Close FileNo
    
    Char.Speed = 2
    Char.XPos = MapInfo.StartX * 32
    Char.YPos = MapInfo.StartY * 32
    Char.XMap = MapInfo.StartX
    Char.YMap = MapInfo.StartY
    Char.direction = Station
    Char.ToMove = 0
    
    'setting temp
'/set

End Function

Private Sub MainLoop()

Dim Freq As Currency
Dim StartTime As Currency
Dim EndTime As Currency
Static FrameCounter As Integer
Static FPSTimer As Long
'Static FPS As Integer

On Error GoTo ErrOut
    
Do While bRunning

    'Initialize time-based modelling (maintains smooth movement on any computer)
    QueryPerformanceFrequency Freq
    QueryPerformanceCounter StartTime
    
    'Get keypresses
    HandleKeys
    
    'Update and draw sprites
    HandleSprites
    
    'Draw text information
    'BackBuffer.DrawText 0, 0, "X (" & "X" & ")", False
    'BackBuffer.DrawText 30, 0, "Y (" & "Y" & ")", False
    'BackBuffer.DrawText 0, 30, "Rotation - Press R (" & Rotating & ")", False
    'BackBuffer.DrawText 0, 45, "Scaling - Press S (" & Scaling & ")", False
    'BackBuffer.DrawText 0, 60, "Colorize - Press C (" & Colorize & ")", False
    'BackBuffer.DrawText 0, 75, "+ / - To Add/Remove Sprites", False
    'BackBuffer.DrawText ScreenWidth - 200, 0, Str(nFPS) & " FPS", False
    'BackBuffer.DrawText 0, 90, "Sprites(0) XVel: " & Sprites(0).XVel & " YVel: " & Sprites(0).YVel & " Angle: " & Sprites(0).Angle, False
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

Public Sub ExitProgram()
    'Unload the DirectDraw variables
    DDraw.Terminate
    'Unload the DirectInput variables
    DInput.Terminate
    'End the program
    End
    
End Sub

Private Sub HandleSprites()

DDraw.DisplaySprite 0, 0, 0, 32, 32, 0, 0, 32, 32

End Sub
Private Sub HandleKeys()
    
'Get the states of all the keys
DInput.CheckKeys

'Escape ends the program
If DInput.aKeys(DIK_ESCAPE).Pressed Then bRunning = False
If DInput.aKeys(DIK_W).Pressed And Char.direction = Station Then
    Char.direction = North
    Char.ToMove = 32
End If

If DInput.aKeys(DIK_D).Pressed And Char.direction = Station Then
    Char.direction = East
    Char.ToMove = 32
End If

If DInput.aKeys(DIK_S).Pressed And Char.direction = Station Then
    Char.direction = South
    Char.ToMove = 32
End If

If DInput.aKeys(DIK_A).Pressed And Char.direction = Station Then
    Char.direction = West
    Char.ToMove = 32
End If
End Sub
