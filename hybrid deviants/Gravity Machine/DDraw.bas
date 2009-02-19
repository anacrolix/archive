Attribute VB_Name = "DDraw"
'Major DX Objects
Dim dx As New DirectX7
Dim DD As DirectDraw7
Dim D3D As Direct3D7
Public Dev As Direct3DDevice7

Dim Primary As DirectDrawSurface7           'Primary surface
Public BackBuffer As DirectDrawSurface7     'Backbuffer surface
Dim ddsdPrimary As DDSURFACEDESC2           'Primary surface description
Dim ddsdBackBuffer As DDSURFACEDESC2        'Backbuffer surface description

Public Const ScreenWidth As Long = 1024
Public Const ScreenHeight As Long = 768

Public Const pi As Single = 3.14159265358979
Const ColorKey As Long = 0                  'Transparency in RGB base 10 (BGR)

'The element type of the Surfaces() array
Public Type Surface
    Surface As DirectDrawSurface7
    Width As Integer
    Height As Integer
    D3DSurface As Boolean
End Type

'Array of surfaces
Public Surfaces() As Surface
'Current number of surfaces in Surfaces()
Public NumSurfaces As Integer
Public Sub Initialize()

'Handles errors
On Local Error GoTo ErrOut
    
'Creates the directdraw object
Set DD = dx.DirectDrawCreate("")
       
'Set the cooperative level and displaymode...
Call DD.SetCooperativeLevel(FrmDirectX.hWnd, DDSCL_FULLSCREEN Or DDSCL_EXCLUSIVE Or DDSCL_ALLOWREBOOT)
Call DD.SetDisplayMode(ScreenWidth, ScreenHeight, 16, 0, DDSDM_DEFAULT)
    
'Create the primary complex surface with one backbuffer, and specify D3D capabilities
ddsdPrimary.lFlags = DDSD_CAPS Or DDSD_BACKBUFFERCOUNT
ddsdPrimary.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_3DDEVICE Or DDSCAPS_FLIP Or DDSCAPS_COMPLEX Or DDSCAPS_VIDEOMEMORY
ddsdPrimary.lBackBufferCount = 1
Set Primary = DD.CreateSurface(ddsdPrimary)
    
'Get the backbuffer from the primary surface
Dim caps As DDSCAPS2
caps.lCaps = DDSCAPS_BACKBUFFER
Set BackBuffer = Primary.GetAttachedSurface(caps)
    
'Set the color (for text output) of the backbuffer
BackBuffer.SetForeColor vbWhite
    
'Initialize Direct3D for special surfaces
Set D3D = DD.GetDirect3D
Set Dev = D3D.CreateDevice("IID_IDirect3DHALDevice", BackBuffer)
    
'No surfaces yet (0 = 1 surface)
NumSurfaces = -1
    
'Load the surfaces we'll be using
LoadSurfaces
    
'Clears the buffer
ClearBuffer
    
Exit Sub
    
'If there's an error, exit the program
ErrOut:
Running = False
    
End Sub

Private Sub LoadSurfaces()

'Load the background image surface - Not D3D surface so it can be any size (640x480)
LoadSurface App.Path & "\stars.bmp", False
'Load the sprite surface - D3D Surface is true so we can use alpha blending, etc.
LoadSurface App.Path & "\sun.bmp", True
LoadSurface App.Path & "\mercury.bmp", True
LoadSurface App.Path & "\venus.bmp", True
LoadSurface App.Path & "\earth.bmp", True
LoadSurface App.Path & "\mars.bmp", True
LoadSurface App.Path & "\jupiter.bmp", True
LoadSurface App.Path & "\saturn.bmp", True
LoadSurface App.Path & "\uranus.bmp", True
LoadSurface App.Path & "\neptune.bmp", True
LoadSurface App.Path & "\pluto.bmp", True
LoadSurface App.Path & "\moon.bmp", True

End Sub

Public Sub ClearBuffer()

Dim DestRect As RECT

'Set up a rectangle as big as the screen
With DestRect
    .Bottom = ScreenHeight
    .Left = 0
    .Right = ScreenWidth
    .Top = 0
End With
    
'Fill the backbuffer with black
BackBuffer.BltColorFill DestRect, 0

End Sub

Public Sub LoadSurface(File As String, Optional D3DSprite As Boolean)

Dim CKey As DDCOLORKEY
Dim SurfaceDesc As DDSURFACEDESC2

On Error GoTo ErrOut

NumSurfaces = NumSurfaces + 1
ReDim Preserve Surfaces(NumSurfaces)

'If this is a D3D surface (for alpha blending, etc.), set it up accordingly
If D3DSprite = True Then
    SurfaceDesc.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT Or DDSD_CKSRCBLT
    SurfaceDesc.ddsCaps.lCaps = DDSCAPS_TEXTURE
    SurfaceDesc.ddsCaps.lCaps2 = DDSCAPS2_TEXTUREMANAGE
    
    'Set the color key
    SurfaceDesc.ddckCKSrcBlt.high = ColorKey
    SurfaceDesc.ddckCKSrcBlt.low = ColorKey
    
    'Create the surface
    Set Surfaces(NumSurfaces).Surface = DD.CreateSurfaceFromFile(File, SurfaceDesc)
    
    'Set the information for this surface
    Surfaces(NumSurfaces).Width = SurfaceDesc.lWidth
    Surfaces(NumSurfaces).Height = SurfaceDesc.lHeight
    Surfaces(NumSurfaces).D3DSurface = True
'Normal DirectDraw surface
Else
    SurfaceDesc.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT
    SurfaceDesc.ddsCaps.lCaps = DDSCAPS_VIDEOMEMORY Or DDSCAPS_OFFSCREENPLAIN
    
    'Create the surface
    Set Surfaces(NumSurfaces).Surface = DD.CreateSurfaceFromFile(File, SurfaceDesc)
    
    'Set up the color key
    CKey.low = ColorKey
    CKey.high = ColorKey
    Surfaces(NumSurfaces).Surface.SetColorKey DDCKEY_SRCBLT, CKey
    
    'Set the information for this surface
    Surfaces(NumSurfaces).Surface.SetForeColor vbBlack
    Surfaces(NumSurfaces).Width = SurfaceDesc.lWidth
    Surfaces(NumSurfaces).Height = SurfaceDesc.lHeight
End If

ErrOut:
Exit Sub

End Sub

Public Sub SetUpGeom(Verts() As D3DTLVERTEX, SurfIndex As Integer, Src As RECT, Dest As RECT, R As Single, G As Single, B As Single, A As Single, Angle As Single)
'This sub sets up the vertices for a sprite, taking into account
'width, height, vertex color, and rotation angle
'NOTE: R, G, and B dictate the color that the sprite will be -
'1, 1, 1 is normal, lower values will colorize the vertices

' * v1      * v3
' |\        |
' |  \      |
' |    \    |
' |      \  |
' |        \|
' * v0      * v2

Dim SurfW As Single
Dim SurfH As Single
Dim XCenter As Single
Dim YCenter As Single
Dim Radius As Single
Dim XCor As Single
Dim YCor As Single

'Width of the surface
SurfW = Surfaces(SurfIndex).Width
'Height of the surface
SurfH = Surfaces(SurfIndex).Height
'Center coordinates on screen of the sprite
XCenter = Dest.Left + (Dest.Right - Dest.Left - 1) / 2
YCenter = Dest.Top + (Dest.Bottom - Dest.Top - 1) / 2

'Calculate screen coordinates of sprite, and only rotate if necessary
If Angle = 0 Then
    XCor = Dest.Right
    YCor = Dest.Bottom
Else
    XCor = XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle)
    YCor = YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle)
End If

'0 - Bottom left vertex
dx.CreateD3DTLVertex _
XCor, _
YCor, _
0, _
1, _
dx.CreateColorRGBA(R, G, B, A), _
0, _
Src.Left / SurfW, _
(Src.Bottom + 1) / SurfH, _
Verts(0)

'Calculate screen coordinates of sprite, and only rotate if necessary
If Angle = 0 Then
    XCor = Dest.Left
    YCor = Dest.Bottom
Else
    XCor = XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle)
    YCor = YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle)
End If

'1 - Top left vertex
dx.CreateD3DTLVertex _
XCor, _
YCor, _
0, _
1, _
dx.CreateColorRGBA(R, G, B, A), _
0, _
Src.Left / SurfW, _
Src.Top / SurfH, _
Verts(1)

'Calculate screen coordinates of sprite, and only rotate if necessary
If Angle = 0 Then
    XCor = Dest.Right
    YCor = Dest.Top
Else
    XCor = XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle)
    YCor = YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle)
End If

'2 - Bottom right vertex
dx.CreateD3DTLVertex _
XCor, _
YCor, _
 0, _
 1, _
dx.CreateColorRGBA(R, G, B, A), _
0, _
(Src.Right + 1) / SurfW, _
(Src.Bottom + 1) / SurfH, _
Verts(2)

'Calculate screen coordinates of sprite, and only rotate if necessary
If Angle = 0 Then
    XCor = Dest.Left
    YCor = Dest.Top
Else
    XCor = XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle)
    YCor = YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle)
End If

'3 - Top right vertex
dx.CreateD3DTLVertex _
XCor, _
YCor, _
0, _
1, _
dx.CreateColorRGBA(R, G, B, A), _
0, _
(Src.Right + 1) / SurfW, _
Src.Top / SurfH, _
Verts(3)

End Sub

Public Sub DisplaySprite(SurfIndex As Integer, DestX As Single, DestY As Single, SrcWidth As Integer, SrcHeight As Integer, Optional SrcX As Single, Optional SrcY As Single, Optional DestWidth As Integer, Optional DestHeight As Integer, Optional ABOne As Boolean, Optional Alpha As Single, Optional R As Single, Optional G As Single, Optional B As Single, Optional Angle As Single)

Dim SrcRect As RECT
Dim DestRect As RECT
Dim TempVerts(3) As D3DTLVERTEX

On Error GoTo ErrOut

'No scaling info. is given, so assume source and dest. sizes are equal
If DestWidth = 0 Then DestWidth = SrcWidth
If DestHeight = 0 Then DestHeight = SrcHeight

'Set up the source rectangle
With SrcRect
    .Bottom = SrcY + SrcHeight
    .Left = SrcX
    .Right = SrcX + SrcWidth
    .Top = SrcY
End With
    
'Set up the destination rectangle
With DestRect
    .Bottom = DestY + DestHeight
    .Left = DestX
    .Right = DestX + DestWidth
    .Top = DestY
End With

'If this is a D3D surface (These surfaces need to be square, power of 2 sized)
If Surfaces(SurfIndex).D3DSurface = True Then

    'Set up the TempVerts(3) vertices
    SetUpGeom TempVerts, SurfIndex, SrcRect, DestRect, R, G, B, Alpha, Angle
    
    'Enable alpha-blending
    Dev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, True
    'Enable color-keying (ColorKey is drawn transparent)
    Dev.SetRenderState D3DRENDERSTATE_COLORKEYENABLE, True
    Dev.SetRenderState D3DRENDERSTATE_COLORKEYBLENDENABLE, True
    'Use Alpha Blend One alpha blending
    If ABOne = True Then
        Dev.SetRenderState D3DRENDERSTATE_SRCBLEND, D3DBLEND_ONE
        Dev.SetRenderState D3DRENDERSTATE_DESTBLEND, D3DBLEND_ONE
    'Alpha blend to a certain fade value (0 - 1)
    Else
        Dev.SetRenderState D3DRENDERSTATE_SRCBLEND, D3DBLEND_SRCALPHA
        Dev.SetRenderState D3DRENDERSTATE_DESTBLEND, D3DBLEND_INVSRCALPHA
        Dev.SetRenderState D3DRENDERSTATE_TEXTUREFACTOR, dx.CreateColorRGBA(1, 1, 1, Alpha)
        Dev.SetTextureStageState 0, D3DTSS_ALPHAOP, D3DTA_TFACTOR
    End If
    
    'Set the texture on the D3D device
    Dev.SetTexture 0, Surfaces(SurfIndex).Surface
    Dev.SetTextureStageState 0, D3DTSS_MIPFILTER, 3
    'Draw the triangles that make up our square texture
    Dev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_TLVERTEX, TempVerts(0), 4, D3DDP_DEFAULT
    'Turn off alphablending after we're done
    Dev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, False
Else
    'Blt the surface normally, without D3D features (these surfaces can be any size)
    BackBuffer.Blt DestRect, Surfaces(SurfIndex).Surface, SrcRect, DDBLT_KEYSRC Or DDBLT_WAIT
End If

ErrOut:
Exit Sub

End Sub

Public Sub Flip()

'Flip the backbuffer to the screen
Primary.Flip Nothing, DDFLIP_WAIT
    
End Sub

Public Sub Terminate()

Dim i As Integer

'This routine must destroy all surfaces and restore display mode
Set Primary = Nothing
Set BackBuffer = Nothing

For i = 0 To UBound(Surfaces)
    Set Surfaces(i).Surface = Nothing
Next i

'Clean up the D3D variables
Set D3D = Nothing
Set Dev = Nothing

Call DD.RestoreDisplayMode
Call DD.SetCooperativeLevel(FrmDirectX.hWnd, DDSCL_NORMAL)

Set DD = Nothing
Set dx = Nothing
    
End Sub
