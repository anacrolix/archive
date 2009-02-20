Attribute VB_Name = "modKeepSake"
'WINAPI STUFF
' Constants for Raster Operations used by BitBlt function.
Public Const SRCAND = &H8800C6 ' dest = source AND dest
Public Const SRCCOPY = &HCC0020 ' dest = source
Public Const SRCPAINT = &HEE0086 ' dest = source OR dest

' The BitBlt Windows API call.
Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal ntilesize As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal ntilesize As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long

Private Declare Function SetBkColor Lib "gdi32" (ByVal hDC As Long, ByVal crColor As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal ntilesize As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Private Declare Function GetObject Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long

Public Const SPI_GETWORKAREA = 48
Declare Function SystemParametersInfo Lib "user32" _
Alias "SystemParametersInfoA" (ByVal uAction As Long, _
ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) _
As Long

'CONSTANTS
Public Const tilesize = 50

'GLOBALS
Global NoOfXSqrCanSee%, NoOfYSqrCanSee% 'how many squares can be seen
Global DisplayXOffset%, DisplayYOffset% 'pixels map is offset
Global PackOffset%, OtherOffset% 'offset for inventory
Global SplashFlag As Boolean ' used for timing the splash graphic
Global ScreenMaxtilesize% ' stores number of usable Y pixels in display
Global ScreenMaxWidth% ' stores number of usable X pixels in display
Global GameReady As Boolean

'TYPES
' Needed to get screen useful size
Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

'used in creating dungeon layout
Public Type RoomArray
    Visited As Boolean
    NorthExit As Boolean
    SouthExit As Boolean
    EastExit As Boolean
    WestExit As Boolean
End Type

Global Room(10, 10) As RoomArray

Public Type CoordinatesType
    X As Integer
    Y As Integer
    Map As Integer
End Type

Public Type CharArray ' Define the contents of the Character array
    Name As String ' Character's name
    Level As Integer
    X As Integer ' current X coordinate on map
    Y As Integer ' current Y coordinate on map
    MapNo As Integer ' current map number character is in
    AttVal As Integer
    DefVal As Integer
    StrMax As Integer ' characters maximum strength
    StrCur As Integer ' characters current strength
    IntMax As Integer ' characters maximum intelligence
    IntCur As Integer ' characters current intelligence
    ConMax As Integer
    ConCur As Integer
    DexMax As Integer ' characters maximum dexterity
    DexCur As Integer ' characters current dexterity
    HitPtMax As Integer ' characters maximum hit points
    HitPtCur As Integer ' characters current hit points
    Sword As Integer 'what object number the sword is
    Shield As Integer 'what object number the shield is
    Armor As Integer ' what object number the armor is
    Gold As Integer ' how much gold the hero has
End Type

Global Char As CharArray ' create the Character array
Global CharInv() As ItemArray ' define the character inventory array

Public Type ItemArray ' define the contents of the Items array
    Name As String ' Object's name
    Icon As Integer ' icon (graphic) number of the object
    X As Integer ' current X coordinate on map
    Y As Integer ' current Y coordinate on map
    MapNo As Integer ' current map number Object is in
    Placed As Boolean ' yes/no if item has been placed on map yet
    Type As Integer ' what kind of thing is it, 1=sword, 2=shield, etc.
    Worth As Integer ' how much is it worth
    Field1 As Integer ' these 5 fields are for any type specific info
    Field2 As Integer
    Field3 As Integer
    Field4 As Integer
    Field5 As Integer
End Type

Global Item() As ItemArray 'create space for 100 items

Public Type MonsterArray ' define the contents of the Monsters Array
    Name As String ' Monster's name
    Icon As Integer ' icon (graphic) number of the Monster
    X As Integer ' current X coordinate on map
    Y As Integer ' current Y coordinate on map
    MapNo As Integer ' current map number Monster is in
    Type As Integer ' what kind of Monster is it, 1=skeleton, 2=snake
    HitPtMax As Integer ' monsters maximum hit points
    HitPtCur As Integer ' monsters current hit points
    Weapon As New Attack
    Aggressiveness As Integer ' agressiveness rating percentage
    DefVal As Integer ' monsters defense value
End Type

Global Monster() As MonsterArray ' create space for 100 monsters

Public Type TileArray
    Blocked As Boolean
    Visible As Boolean
    Icon As Integer
End Type

Public Type MapArray
    Tile() As TileArray
End Type

Global World() As MapArray

Public Type UniverseArray ' define the contents of the Universe array
    DisplayXOffset As Integer ' x direction offset for displaying the map
    DisplayYOffset As Integer ' y direction offset for displaying the map
    Difficulty As Integer ' difficulty 0=easy, 1=medium, 2=hard
End Type

Global Universe As UniverseArray

' non-array global variables needed
Global CurObjNo% ' currently selected object number
Global CurMonNo% ' currently selected Monster number

Sub Main()
Call Initialize    'call the subroutine to set up all settings, fill in variables
SplashScreen.Show 1
Options.Show 1   'display the new/options/load/save/quit form
End Sub

Sub Initialize()
Randomize    ' Initialize random-number generator.
GameReady = False

End Sub

Sub NewGame()
Options.Hide ' remove the options form from the screen
Form1.Show ' show the blank form

Dim Prog As New frmProgress

ReDim Item(0)

Call Prog.StartProcess(Form1, "Initializing Game", "Generating Items")
DoEvents
'generate items
For X% = 1 To 150
    I% = 0
    Call CreateItem(I%, 1)
    DoEvents
Next X%
ReDim CharInv(19)
ReDim Monster(0)

Prog.SetOperation "Testing Form"
'test process form
'For blah = 1 To 1000000
'    DoEvents
'Next blah

Prog.SetOperation "Generating Monsters"
DoEvents

'generate monsters
For X% = 1 To 20
    I% = 0
    Call CreateMonster(I%)
    DoEvents
Next X%

Erase Room

Prog.SetOperation "Generating Maze"
DoEvents

Call CreateMaze
ReDim World(2)
ReDim World(2).Tile(100, 100)
Prog.SetOperation "Detailing Dungeon"
DoEvents
Call FillMap(2)
ReDim World(1).Tile(100, 100)
Prog.SetOperation "Detailing Outdoors"
DoEvents
Call FillOutsideMap(1)
Prog.SetOperation "Initializing Character"
DoEvents
Graphics.Hide
Char.StrMax = 50
Char.StrCur = 50 ' more than 100%!
Char.IntMax = 50
Char.IntCur = 50
Char.DexMax = 50
Char.DexCur = 50
Char.HitPtMax = 10
Char.HitPtCur = 10 ' just about dead!

DisplayXOffset% = 0
DisplayYOffset% = 0
Char.X = 50
Char.Y = 50
Char.MapNo = 1
Prog.SetOperation "Scattering Items"
Call ScatterItems
Prog.SetOperation "Scattering Monsters"
Call ScatterMonsters
Prog.SetOperation "Finalizing Maps"
Call CreateItem(12, 1) ' create dungeon entrance
With Item(CurObjNo%)
    .Name = "Dungeon Entrance"
    .Icon = 9
    .MapNo = 1
    .X = 50
    .Y = 48 ' 2 squares above hero's starting point
    .Field1 = 2 ' field1 is the destination map number
    .Field2 = 55 ' field2 is the X coordinate of the destination
    .Field3 = 100 ' field3 is the Y coordinate of the destination
End With

Call CreateItem(12, 2) ' create dungeon exit
With Item(CurObjNo%)
    .Name = "Dungeon Exit"
    .Icon = 8
    .MapNo = 2
    .X = 55
    .Y = 100 ' bottom center of dungeon
    .Field1 = 1 ' field1 is the destination map number
    .Field2 = 50 ' field2 is the X coordinate of the destination
    .Field3 = 48 ' field3 is the Y coordinate of the destination
End With

GameReady = True
Prog.SetOperation "Initializing Interface"
Call DrawMap
Call DisplayMessage(" ")
Call DisplayMessage("*** NEW GAME STARTED ***")
Call DisplayMessage(" ")

Prog.EndProcess
End Sub

Sub ScatterItems()
' this routine scatters items on the outdoor map
For lx% = LBound(Item) To UBound(Item)
Item(lx%).X = Int(Rnd * 100)
Item(lx%).Y = Int(Rnd * 100)
Item(lx%).MapNo = 1
Item(lx%).Placed = True
Next lx%
End Sub

Sub NewItem(nItem As Integer, sName As String, nIcon As Integer, Optional nWorth As Integer = 25, Optional nField1 As Integer, Optional nField2 As Integer, Optional nField3 As Integer)
With Item(nItem)
    .Name = sName
    .Icon = nIcon
    .Field1 = nField1
    .Field1 = nField2
    .Field3 = nField3
End With
End Sub

Sub CreateItem(ByVal ItmType As Integer, ByVal ItmMapNo As Integer)
'PART 1 - DESIGNATE VALUES
    'if random item requested
    If ItmType = 0 Then
        CurObjType% = Rnd * 9 + 1
    'otherwise type is value given
    Else
        CurObjType% = ItmType ' use the object they requested
    End If
    'check that type is within bounds
    If CurObjType% < 1 Or CurObjType% > 12 Then MsgBox "Invalid item type": CleanExit
    'assign item array position
    CurObjNo% = -1
    'assign empty slot if found
    For nX% = LBound(Item) To UBound(Item)
        If Item(nX%).Type = 0 Then CurObjNo% = nX%
    Next nX%
    'create new slot if none empty
    If CurObjNo% = -1 Then
        ReDim Preserve Item(UBound(Item) + 1)
        CurObjNo% = UBound(Item)
    End If
    'assign other properties
    With Item(CurObjNo%)
        .Type = CurObjType%
        .X = 0
        .Y = 0
        .MapNo = ItmMapNo
        .Placed = False
    End With
'PART 2 - ASSIGN ITEM TYPE DEPENDANT PROPERTIES
    seed% = Int(Rnd * 100)
    With Item(CurObjNo%)
        Select Case CurObjType% ' select a section of code based on the value of CurObjType%
            Case 1
                Select Case seed%
                    Case Is < 50: NewItem CurObjNo%, "Leather Armor", 10, 6, 600
                    Case Else: NewItem CurObjNo%, "Chain Mail Armor", 12, 30, 6000
                End Select
            Case 2: NewItem CurObjNo%, "Amulet", 20, 25
            Case 3: NewItem CurObjNo%, "Cloak", 30, 15
            Case 4: NewItem CurObjNo%, "Shield", 40, 500
            Case 5: NewItem CurObjNo%, "Wand", 50, 25
            Case 6: NewItem CurObjNo%, "Potion", 60, 25
            Case 7: NewItem CurObjNo%, "Ring", 70, 25
            Case 8: NewItem CurObjNo%, "Gloves", 80
            Case 9: NewItem CurObjNo%, "Boots", 90
            Case 10: NewItem CurObjNo%, "Sword", 100
            Case 11: NewItem CurObjNo%, "Gold", 110, 0, seed% + 1
        End Select
    End With
End Sub

Sub DeleteItem(ByVal Itm As Integer)
If Itm < LBound(Item) Or Itm > UBound(Item) Then ' check for invalid obj no
    MsgBox "DeleteItem discovered invalid Itm of" + Str(Itm)
    End
End If
Item(Itm).Placed = False ' flag item as gone
End Sub

Sub CreateMonster(ByVal Mon As Integer)
curmontype% = Mon
If Mon = 0 Then ' random object desired, pick the object
    curmontype% = Int(Rnd * 5) + 1
End If

If curmontype% < 1 Or curmontype% > 5 Then ' check for invalid Monster no
    MsgBox "CreateMonster discovered invalid CurMonType% of" + Str(curmontype%)
    End
End If

' now find an empty spot in the Monster array or append to the end
CurMonNo% = -1
For nX% = LBound(Monster) To UBound(Monster)
    If Monster(nX%).HitPtCur <= 0 Then CurMonNo% = nX%: Exit For
Next nX%
If CurMonNo% = -1 Then
    ReDim Preserve Monster(UBound(Monster) + 1)
    CurMonNo% = UBound(Monster)
End If
    
' this set of code is the same for all Monsters
With Monster(CurMonNo%)
    .Icon = curmontype%
    .Type = curmontype%
    .Aggressiveness = curmontype% * 15
    Select Case curmontype% ' select a section of code based on the value of CurMonType%
        Case 1 ' snake
            .Name = "Snake"
            .HitPtMax = RollResult(1, 4, 0)
            .DefVal = 70
            .Weapon.SetAttack SnakeBite
        Case 2 ' skeleton
            .Name = "Skeleton"
            .HitPtMax = RollResult(1, 8, 0)
            .DefVal = 55
            .Weapon.SetAttack SnakeBite
        Case 3 ' zombie
            .Name = "Zombie"
            .HitPtMax = RollResult(2, 8, 0)
            .DefVal = 60
            .Weapon.SetAttack ZomBash
        Case 4 ' giant spider
            .Name = "Giant Spider"
            .HitPtMax = RollResult(4, 8, 0)
            .DefVal = 100
            .Weapon.SetAttack SnakeBite
        Case 5 ' evil knight
            .Name = "Evil Knight"
            .HitPtMax = RollResult(6, 8, 1)
            .DefVal = 100
            .Weapon.SetAttack WarSword
        Case Else ' something is wrong because an invalid CurMon% was used
            MsgBox "CreateItem discovered invalid CurMonType% of" + Str(curmontype%)
            End
    End Select

' Set "Current" levels equal to "Max" levels
.HitPtCur = .HitPtMax
End With
End Sub

Sub DeleteMonster(ByVal Mon As Integer)
If Mon < LBound(Monster) Or Mon > UBound(Monster) Then ' check for invalid array no
MsgBox "DeleteMonster discovered invalid Mon of" + Str(Mon)
End
End If
Monster(Mon).HitPtCur = 0 ' flag item as gone

End Sub

Sub CreateMaze()
Dim CheckExit%(3) ' used to store exit directions in order to check
CurXSqr% = 5
CurYSqr% = 9 ' allways start in center of bottom row
NoOfSqrVisited = 0 'no rooms visited so far

Do Until NoOfSqrVisited = 100 ' start the master loop through all 100 rooms
    Room(CurXSqr%, CurYSqr%).Visited = True ' flag that we have been in this room
    NoOfSqrVisited = NoOfSqrVisited + 1 'have visited current room
    
    ' pick which directions we need to look for an exit
    ' 0=north, 1=south, 2=east, 3=west
    CheckExit%(0) = Int(Rnd * 4) ' check in a random direction
    For X% = 1 To 3
        CheckExit%(X%) = CheckExit%(X% - 1) + 1 ' next check the other direction
        If CheckExit%(X%) > 3 Then CheckExit%(X%) = 0 ' handle wraparound
    Next X%
    
    ' at this point CheckExit% has a set of directions to test
    ' loop through them looking for a legal room to move into. If we find a legal
    ' room, set a stop flag, update the "exits" variables and move to the new room
    Moved = False ' reset moved flag
    For X% = 0 To 3
        If CheckExit%(X%) = 0 And IsSquareLegal(CurXSqr%, CurYSqr% - 1) = True Then 'north exit
            Room(CurXSqr%, CurYSqr%).NorthExit = True ' there is a north exit from this room
            Room(CurXSqr%, CurYSqr% - 1).SouthExit = True ' there is a south exit in the new room
            CurYSqr% = CurYSqr% - 1 'move to new room
            Moved = True ' set moved flag
            Exit For ' get out of this for X% loop
        End If
        If CheckExit%(X%) = 1 And IsSquareLegal(CurXSqr%, CurYSqr% + 1) = True Then 'south exit
            Room(CurXSqr%, CurYSqr%).SouthExit = True ' there is a south exit from this room
            Room(CurXSqr%, CurYSqr% + 1).NorthExit = True ' there is a north exit in the new room
            CurYSqr% = CurYSqr% + 1 'move to new room
            Moved = True ' set moved flag
            Exit For ' get out of this for X% loop
        End If
        If CheckExit%(X%) = 2 And IsSquareLegal(CurXSqr% + 1, CurYSqr%) = True Then 'east exit
            Room(CurXSqr%, CurYSqr%).EastExit = True ' there is a east exit from this room
            Room(CurXSqr% + 1, CurYSqr%).WestExit = True ' there is a west exit in the new room
            CurXSqr% = CurXSqr% + 1 'move to new room
            Moved = True ' set moved flag
            Exit For ' get out of this for X% loop
        End If
        If CheckExit%(X%) = 3 And IsSquareLegal(CurXSqr% - 1, CurYSqr%) = True Then 'west exit
            Room(CurXSqr%, CurYSqr%).WestExit = True ' there is a west exit from this room
            Room(CurXSqr% - 1, CurYSqr%).EastExit = True ' there is a east exit in the new room
            CurXSqr% = CurXSqr% - 1 'move to new room
            Moved = True ' set moved flag
            Exit For ' get out of this for X% loop
        End If
    Next X%
    If Moved = False Then
    ' if we got to here then we have lookd through all 4 directions and
    ' could not find a legal exit
    Exit Do ' get out of master loop
    End If
Loop

End Sub

Public Function IsSquareLegal(ByVal X As Integer, ByVal Y As Integer) As Boolean
' this routine returns a true/false if the desired square is legal
' in the CreateMaze procedure
' notice the order of checks below, if the Room(X,Y) check was done first
' and X or Y equaled an 11 then the function would crash.
IsSquareLegal = False
If X < 0 Or X > 9 Then Exit Function
If Y < 0 Or Y > 9 Then Exit Function
If Room(X, Y).Visited = True Then Exit Function
IsSquareLegal = True
End Function

Sub FillMap(ByVal MapNo As Integer)
' this routine fills the Map array with the data from the Room array
For X% = 0 To 9
    For Y% = 0 To 9
    DoEvents
        If Room(X%, Y%).Visited = True Then 'make it a "room"
        ' first fill in center with "floor"
        For X1% = 2 To 9
            For Y1% = 2 To 9
                World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = False
                World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
            Next Y1%
        Next X1%
        ' now make the surrounding walls
        Thickness = Int(Rnd * 3) + 1
        For X1% = 1 To 10 ' make "North" wall
        For Y1% = 1 To Thickness
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = True
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
        Next Y1%
        Next X1%
        
        Thickness = Int(Rnd * 3) + 7
        For X1% = 1 To 10 ' make "South" wall
        For Y1% = Thickness To 10
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = True
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
        Next Y1%
        Next X1%
        For X1% = Int(Rnd * 3) + 7 To 10 ' make "East" wall
        For Y1% = 1 To 10
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = True
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
        Next Y1%
        Next X1%
        For X1% = 1 To Int(Rnd * 3) + 1 ' make "West" wall
        For Y1% = 1 To 10
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = True
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
        Next Y1%
        Next X1%
        ' now cut out any "exits"
        If Room(X%, Y%).NorthExit = True Then ' there is a north exit
        For Y1% = 1 To 5 ' draw exit north
        World(MapNo).Tile(X% * 10 + 5, Y% * 10 + Y1%).Blocked = False
        World(MapNo).Tile(X% * 10 + 5, Y% * 10 + Y1%).Visible = False
        Next Y1%
        End If
        If Room(X%, Y%).SouthExit = True Then ' there is a south exit
        For Y1% = 5 To 10 ' draw exit south
        World(MapNo).Tile(X% * 10 + 5, Y% * 10 + Y1%).Blocked = False
        World(MapNo).Tile(X% * 10 + 5, Y% * 10 + Y1%).Visible = False
        Next Y1%
        End If
        If Room(X%, Y%).EastExit = True Then ' there is a east exit
        For X1% = 5 To 10 ' draw exit east
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + 5).Blocked = False
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + 5).Visible = False
        Next X1%
        End If
        If Room(X%, Y%).WestExit = True Then ' there is a west exit
        For X1% = 1 To 5 ' draw exit east
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + 5).Blocked = False
        World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + 5).Visible = False
        Next X1%
        End If
        Else ' not used, fill with "walls"
        For X1% = 1 To 10
            For Y1% = 1 To 10
                World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Blocked = True
                World(MapNo).Tile(X% * 10 + X1%, Y% * 10 + Y1%).Visible = False
            Next Y1%
        Next X1%
        End If
    Next Y%
Next X%
    
    ' just in case of problem, force wall all the way around
For X% = 0 To 100
    World(MapNo).Tile(X%, 0).Blocked = True
    World(MapNo).Tile(X%, 100).Blocked = True
Next X%
For Y = 0 To 100
    World(MapNo).Tile(0, Y%).Blocked = True
    World(MapNo).Tile(100, Y%).Blocked = True
Next Y%
DoEvents
' Now force a good looking entrance to the dungeon!
X% = 5 ' starting square
Y% = 9
For Y1% = 100 To 95 Step -1 ' draw exit south
World(MapNo).Tile(X% * 10 + 5, Y1%).Blocked = False
World(MapNo).Tile(X% * 10 + 5, Y1%).Visible = False
Next Y1%
World(MapNo).Tile(X% * 10 + 5, 100).Icon = 25 ' force the special entrance graphic
World(MapNo).Tile(X% * 10 + 4, 100).Icon = 8 ' force the special entrance graphic
World(MapNo).Tile(X% * 10 + 6, 100).Icon = 13 ' force the special entrance graphic

Call FixUpMapGraphics(2) ' fix up the icons
End Sub

Sub FillOutsideMap(MapNo As Integer)
' this procedure fills the Map array (map number 1) with outside info

' step 1 - fill entire map with "ground" (icon 3)
For X% = 0 To 100
For Y% = 0 To 100
World(MapNo).Tile(X%, Y%).Blocked = False
World(MapNo).Tile(X%, Y%).Visible = False
Next Y%
Next X%

' step 2 - place a double row of "Mountains" (icon 4) around outside of map
For X% = 0 To 100
World(MapNo).Tile(X%, 0).Blocked = True
World(MapNo).Tile(X%, 1).Blocked = True
World(MapNo).Tile(X%, 99).Blocked = True
World(MapNo).Tile(X%, 100).Blocked = True
Next X%
For Y% = 0 To 100
World(MapNo).Tile(0, Y%).Blocked = True
World(MapNo).Tile(1, Y%).Blocked = True
World(MapNo).Tile(99, Y%).Blocked = True
World(MapNo).Tile(100, Y%).Blocked = True
Next Y%
' step 3 - for variety, place some random mountains
For X% = 2 To 98
If Rnd > 0.5 Then World(MapNo).Tile(X%, 2).Blocked = True
If Rnd > 0.5 Then World(MapNo).Tile(X%, 98).Blocked = True
Next X%
For Y% = 2 To 98
If Rnd > 0.5 Then World(MapNo).Tile(2, Y%).Blocked = True
If Rnd > 0.5 Then World(MapNo).Tile(98, Y%).Blocked = True
Next Y%

World(MapNo).Tile(50, 48).Icon = 55 ' force the special entrance graphic

Call FixUpMapGraphics(1) ' fix up the icons

' the map is done! except for items
End Sub

Sub DrawASquare(ByVal MapX As Integer, ByVal MapY As Integer, ByVal Src As Integer, ByVal IconNo As Integer)
' this routine puts a single square on the screen
' calling arguments:
' MapX, MapY = map value (0-100, 0-100) of what square this is
' Src = graphics source, 1=items, 2=monsters, 3=hero, 4=hit graphic
' IconNo = icon number to select

' since we know all the squares are 50x50 pixels, calculate the actual
' X,Y on the form
DestX% = (MapX - DisplayXOffset%) * 50
DestY% = (MapY - DisplayYOffset%) * 50
    Static Object As Picture
    Set Object = Graphics.ObjectMaster.Picture
'we need 3 different sources, depending on if the source is a
' item, monster or her cause they are all stored in different picture controls
sourcehandle& = Graphics.MapMaster.hDC
If Src = 1 Then sourcehandle& = Graphics.ObjectMaster.hDC
If Src = 2 Then sourcehandle& = Graphics.MonsterMaster.hDC
If Src = 3 Then sourcehandle& = Graphics.CharacterMaster.hDC
If Src = 4 Then sourcehandle& = Graphics.SplashMaster.hDC
'we need to calculate the actual X,Y on the picture control where the
' upperleft of the icon starts. For the hero they are both zero
' for the monsters the Y is always zero, for the objects we need
' to calculate the row and col and multiply by 50 (pixels)
iconrow% = Int(IconNo / 10)
iconcol% = IconNo - (iconrow% * 10)
sourcex% = iconcol% * 50
sourcey% = iconrow% * 50

Dim tempDC As Long      'DC for temporary data
Dim hTempBmp As Long    'Bitmap for temporary data

'blah.Render tempDC, 0, 0, 50, 50, sourceX%, sourceY%, 50, 50, Null
'success& = BitBlt(tempDC, 0, 0, 50, 50, blah.Render, sourceX%, sourceY%, SRCCOPY)
'SourceHandle& = Form1.pcbTemp.hDC

' the parameters of the bitBLT are as follows
' destination bitmap handle, dest x, dest y, x size to copy, y size to copy, source bitmap handle, source x, source y, copy type
If Src = 0 Then
    success& = BitBlt(Form1.hDC, DestX%, DestY%, 50, 50, sourcehandle&, sourcex%, sourcey%, SRCCOPY)
Else
    TransparentBlt Form1.hDC, tempDC, DestX%, DestY%, 0, 0, tilesize, tilesize, vbWhite
End If
' let the screen update
DoEvents
    
DeleteObject (hTempBmp)
DeleteDC (tempDC)

End Sub

Sub TransparentBlt(dsthDC As Long, srchDC As Long, X As Integer, Y As Integer, SrcX As Integer, SrcY As Integer, Width As Integer, tilesize As Integer, TransColor As Long)
    Dim maskDC As Long      'DC for the mask
    Dim tempDC As Long      'DC for temporary data
    Dim hMaskBmp As Long    'Bitmap for mask
    Dim hTempBmp As Long    'Bitmap for temporary data
    'First create some DC's. These are our gateways to assosiated bitmaps in RAM
    maskDC = CreateCompatibleDC(frmdisplay.hDC)
    tempDC = CreateCompatibleDC(frmdisplay.hDC)
    'Then we need the bitmaps. Note that we create a monochrome bitmap here!
    'this is a trick we use for creating a mask fast enough.
    hMaskBmp = CreateBitmap(tilesize, tilesize, 1, 1, ByVal 0&)
    hTempBmp = CreateCompatibleBitmap(frmdisplay.hDC, tilesize, tilesize)
    '..then we can assign the bitmaps to the DCs
    hMaskBmp = SelectObject(maskDC, hMaskBmp)
    hTempBmp = SelectObject(tempDC, hTempBmp)
    'Now we can create a mask..First we set the background color to the
    'transparent color then we copy the image into the monochrome bitmap.
    'When we are done, we reset the background color of the original source.
    TransColor = SetBkColor(frmmain.pcbgfx.hDC, TransColor)
    BitBlt maskDC, 0, 0, tilesize, tilesize, frmmain.pcbgfx.hDC, sourcex, sourcey, vbSrcCopy
    TransColor = SetBkColor(frmmain.pcbgfx.hDC, TransColor)
    'The first we do with the mask is to MergePaint it into the destination.
    'this will punch a WHITE hole in the background exactly were we want the
    'graphics to be painted in.
    BitBlt tempDC, 0, 0, tilesize, tilesize, maskDC, 0, 0, vbSrcCopy
    BitBlt frmdisplay.hDC, X, Y, tilesize, tilesize, tempDC, 0, 0, vbMergePaint
    'Now we delete the transparent part of our source image. To do this
    'we must invert the mask and MergePaint it into the source image. the
    'transparent area will now appear as WHITE.
    BitBlt maskDC, 0, 0, tilesize, tilesize, maskDC, 0, 0, vbNotSrcCopy
    BitBlt tempDC, 0, 0, tilesize, tilesize, frmmain.pcbgfx.hDC, sourcex, sourcey, vbSrcCopy
    BitBlt tempDC, 0, 0, tilesize, tilesize, maskDC, 0, 0, vbMergePaint
    'Both target and source are clean, all we have to do is to AND them together!
    BitBlt frmdisplay.hDC, X, Y, tilesize, tilesize, tempDC, 0, 0, vbSrcAnd
    'Now all we have to do is to clean up after us and free system resources..
    DeleteObject (hMaskBmp)
    DeleteObject (hTempBmp)
    DeleteDC (maskDC)
    DeleteDC (tempDC)
End Sub

Sub DrawMap()
If GameReady = False Then Exit Sub
' this routine draws the map on the form
' global variables expected:
' NoOfXSqrCanSee%, NoOfYSqrCanSee%
Form1.Cls ' erase old map on the form

' calculate new display offset based on character x,y position
DisplayXOffset% = Char.X
DisplayYOffset% = Char.Y
' use 1/2 of display size so hero is centered
DisplayXOffset% = DisplayXOffset% - (NoOfXSqrCanSee% / 2)
DisplayYOffset% = DisplayYOffset% - (NoOfYSqrCanSee% / 2)

For X% = 1 To 100 ' go through all the map
    For Y% = 1 To 100 ' go through all the map
        If X% - DisplayXOffset% >= 0 And X% - DisplayXOffset% < NoOfXSqrCanSee% Then
            If Y% - DisplayYOffset% >= 0 And Y% - DisplayYOffset% < NoOfYSqrCanSee% Then
                Call DrawASquare(X%, Y%, 0, World(Char.MapNo).Tile(X%, Y%).Icon)
            End If
        End If
    Next Y%
Next X%

' now for the objects
For X% = LBound(Item) To UBound(Item) ' go through all the objects
If Item(X%).MapNo = Char.MapNo Then ' don't bother if its on a different map
If Item(X%).X - DisplayXOffset% >= 0 And Item(X%).X - DisplayXOffset% < NoOfXSqrCanSee% Then
If Item(X%).Y - DisplayYOffset% >= 0 And Item(X%).Y - DisplayYOffset% < NoOfYSqrCanSee% Then
Call DrawASquare(Item(X%).X, Item(X%).Y, 1, Item(X%).Icon)
End If
End If
End If
Next X%

' now for the Monsters
For X% = LBound(Monster) To UBound(Monster) ' go through all the Monsters
If Monster(X%).MapNo = Char.MapNo And Monster(X%).HitPtCur > 0 Then ' don't bother if its on a different map or dead
If Monster(X%).X - DisplayXOffset% >= 0 And Monster(X%).X - DisplayXOffset% < NoOfXSqrCanSee% Then
If Monster(X%).Y - DisplayYOffset% >= 0 And Monster(X%).Y - DisplayYOffset% < NoOfYSqrCanSee% Then
Call DrawASquare(Monster(X%).X, Monster(X%).Y, 2, Monster(X%).Icon)
End If
End If
End If
Next X%


' draw the hero
Call DrawASquare(Char.X, Char.Y, 3, 0)
Form1.Refresh
End Sub

Sub CleanExit()
End
End Sub

Sub RedrawSquare(ByVal X As Integer, ByVal Y As Integer, ByVal MapNo As Integer, Optional bDrawMap As Boolean = True, Optional bDrawObjects As Boolean = True, Optional bDrawMonsters As Boolean = True, Optional bDrawHero As Boolean = True)

'draw map if required
If bDrawMap Then Call DrawASquare(X, Y, 0, World(MapNo).Tile(X, Y).Icon)

'draw objects
If bDrawObjects Then
    For nX% = LBound(Item) To UBound(Item)
    If Item(nX%).MapNo = Char.MapNo Then
        If Item(nX%).X = X And Item(nX%).Y = Y Then Call DrawASquare(X, Y, 1, Item(nX%).Icon)
    End If
    Next nX%
End If

'now draw a Monster if it was in that square and requested
If bDrawMonsters Then
    For nX% = LBound(Monster) To UBound(Monster)
        If Monster(nX%).MapNo = Char.MapNo Then
            If Monster(nX%).X = X And Monster(nX%).Y = Y And Monster(nX%).HitPtCur > 0 Then Call DrawASquare(X, Y, 2, Monster(nX%).Icon)
        End If
    Next nX%
End If

'draw hero if requested
If bDrawHero Then
    If Char.X = X And Char.Y = Y And Char.MapNo = MapNo Then Call DrawASquare(X, Y, 3, 0) ' just draw hero
End If
Form1.Refresh
End Sub

Sub MoveCharacter(ByVal DX As Integer, ByVal DY As Integer)

DirText$ = "The hero walks"
If DY = 1 Then DirText$ = DirText$ + " south"
If DY = -1 Then DirText$ = DirText$ + " north"
If DX = 1 Then DirText$ = DirText$ + " east"
If DX = -1 Then DirText$ = DirText$ + " west"

' step 3 - check to see if its a legal move
LegalMove = True
If Char.X + DX% < 1 Or Char.X + DX% > 100 Then LegalMove = False 'cant go off the map
If Char.Y + DY% < 1 Or Char.Y + DY% > 100 Then LegalMove = False 'cant go off the map
If LegalMove = True Then ' only check if inside map otherwise may crash
' check to see if the desired square is blocked
If World(Char.MapNo).Tile(Char.X + DX%, Char.Y + DY%).Blocked = True Then LegalMove = False
End If

' check to see if there is a monster on that square,
' if there is then call the Attack routine and exit so the hero doesn't attack ALL
' monsters in a square and doesn't actually move
For nX% = LBound(Monster) To UBound(Monster)
    If Monster(nX%).MapNo = Char.MapNo And Monster(nX%).HitPtCur > 0 Then
        If Monster(nX%).X = Char.X + DX% And Monster(nX%).Y = Char.Y + DY% Then
            Call Attack(1, nX%) ' 1=hero attacking, X% = monster number being attacked
            Exit Sub
        End If
    End If
Next nX%

' step 4 - if its a legal move, erase the character
' by drawing the ground where the hero is
If LegalMove = True Then
    'redraw heros location without hero
    RedrawSquare Char.X, Char.Y, Char.MapNo, , , , False
    
    ' step 5 - update the heros location
    Char.X = Char.X + DX%
    Char.Y = Char.Y + DY%
    Call DisplayMessage(DirText$)     'display action in text window

    ' step 6 - check to see if hero went off the screen
    NeedToRedraw% = False 'set flag
    If Char.X - DisplayXOffset% < 1 Then NeedToRedraw% = True
    If Char.Y - DisplayYOffset% < 1 Then NeedToRedraw% = True
    If Char.X - DisplayXOffset% >= NoOfXSqrCanSee% - 1 Then NeedToRedraw% = True
    If Char.Y - DisplayYOffset% >= NoOfYSqrCanSee% - 1 Then NeedToRedraw% = True
    
    ' step 7 - draw either just hero or whole screen
    If NeedToRedraw% = True Then
        Call DrawMap 'draw whole map
    Else
        Call DrawASquare(Char.X, Char.Y, 3, 0) ' just draw hero
        Form1.Refresh
    End If

    Call HeroWalkedOnSquare ' check to see if something happened when walked on square
End If

Call MonstersTurn
End Sub

Sub UpdateInventoryForm(Location As Integer)
'PART 1 - WIPE FORM CLEAN, BUBBLE OUT EMPTY PACK SLOTS
    'clear form
    With frmInventory
        'clear slots
        For lx% = 0 To 11
            If lx% <= 7 Then
                With .PackSlot(lx%)
                    .Cls
                    .DragMode = vbManual
                    .ContainsItem = False
                End With
                With .OtherSlot(lx%)
                    .Cls
                    .DragMode = vbManual
                    .ContainsItem = False
                End With
            End If
            With .InventorySlot(lx%)
                .Cls
                .DragMode = vbManual
                .ContainsItem = False
            End With
        Next lx%
        If Location = 0 Then .lblOther = "Ground"
    End With
    'begin bubbling
    CurX% = 12
    Do
        If CharInv(CurX%).Type = 0 Then
            Do
                For NewX% = CurX% To (UBound(CharInv) - 1)
                    CharInv(NewX%) = CharInv(NewX% + 1)
                Next NewX%
                ReDim Preserve CharInv(UBound(CharInv) - 1)
            Loop Until CharInv(CurX%).Type > 0 Or CurX% >= UBound(CharInv)
        End If
        CurX% = CurX% + 1
    Loop Until CurX% >= UBound(CharInv) Or UBound(CharInv) = 11
'PART 2 - ASSIGN PACKSCROLL VALUES AND PACKOFFSET%
With frmInventory.PackScroll
    'determine number of pack items
    For nX% = 12 To UBound(CharInv)
        If CharInv(nX%).Type > 0 Then PackCount% = PackCount% + 1
    Next nX%
    'if packoffset% is greater than required, reduce it
    If PackOffset% > PackCount% - 4 Then PackOffset% = PackOffset% - 4
    'if packcount is high enuff 2 require scrolling, activate it
    If PackCount% > 7 Then
        .Enabled = True
        .Max = Int(PackCount% / 4) - 1
        .Value = Int(PackOffset% / 4)
        ReDim Preserve CharInv(23 + Int(PackCount% / 4) * 4)
    'otherwise, disable it
    Else
        .Enabled = False
        .Max = 0
        PackOffset% = 0
        ReDim Preserve CharInv(19)
    End If
End With

'PART 3 - DRAW EQUIPPED AND PACKED ITEMS
With frmInventory
    For lx% = LBound(CharInv) To UBound(CharInv) 'all items in heroes inventory
        'load image if item is present in array
        If CharInv(lx%).Type > 0 Then
            'determine  source details
            IconNo = CharInv(lx%).Icon
            iconrow% = Int(IconNo / 10)
            iconcol% = IconNo - (iconrow% * 10)
            sourcex% = iconcol% * 50
            sourcey% = iconrow% * 50
            sourcehandle& = Graphics.ObjectMaster.hDC
            'if item is equipped
            If lx% < 12 Then
                With .InventorySlot(lx%)
                    .DragMode = vbAutomatic
                    .ContainsItem = True
                    success& = BitBlt(.hDC, 0, 0, 50, 50, sourcehandle&, sourcex%, sourcey%, SRCCOPY)
                    .Caption = CharInv(lx%).Name
                    .Refresh
                End With
            'if item is in current 8 pack items viewable
            ElseIf lx% >= (12 + PackOffset%) And lx% <= (19 + PackOffset%) Then
                With .PackSlot(lx% - 12 - PackOffset%)
                    .DragMode = vbAutomatic
                    .ContainsItem = True
                    .Caption = CharInv(lx%).Name
                    success& = BitBlt(.hDC, 0, 0, 50, 50, sourcehandle&, sourcex%, sourcey%, SRCCOPY)
                    .Refresh
                End With
            End If
        'no item present in slot
        Else
            'if item not present label equipment slots
            If lx% < 12 Then .InventorySlot(lx%).Caption = LoadResString(100 + lx%)
        End If
    Next lx%
End With

'PART 4 - OTHERSCROLLBAR VALUES AND OTHEROFFSET%
'determine number of other items
If Location = 0 Then 'not in shops
    For lx% = LBound(Item) To UBound(Item)
        With Item(lx%)
            If .Type > 0 And .X = Char.X And .Y = Char.Y And _
            .MapNo = Char.MapNo Then
                OtherCount% = OtherCount% + 1
            End If
        End With
    Next lx%
Else
    MsgBox "STUB-character not in normal location": CleanExit
End If
'if packoffset% is greater than required, reduce it
If OtherOffset% > OtherCount% - 4 Then OtherOffset% = OtherOffset% - 4
'if othercount is high enuff 2 require scrolling, activate it
With frmInventory.OtherScroll
    If OtherCount% > 7 Then
        .Enabled = True
        .Max = Int(OtherCount% / 4) - 1
        .Value = Int(OtherOffset% / 4)
    'otherwise, disable it
    Else
        .Enabled = False
        .Max = 0
        OtherOffset% = 0
    End If
End With

'PART 5 - DRAW OTHER ITEMS
CurOtherSlot% = 0
If Location = 0 Then
    For lx% = LBound(Item) To UBound(Item) 'all items in heroes inventory
        'load image if item is present in array
        If Item(lx%).Type > 0 And Char.MapNo = Item(lx%).MapNo And _
        Char.X = Item(lx%).X And Char.Y = Item(lx%).Y Then
            'determine  source details
            IconNo = Item(lx%).Icon
            iconrow% = Int(IconNo / 10)
            iconcol% = IconNo - (iconrow% * 10)
            sourcex% = iconcol% * 50
            sourcey% = iconrow% * 50
            sourcehandle& = Graphics.ObjectMaster.hDC
            'if item is equipped
            If CurOtherSlot% >= OtherOffset% And _
            CurOtherSlot% <= (OtherOffset% + 7) Then
                With frmInventory.OtherSlot(CurOtherSlot% - OtherOffset%)
                    .DragMode = vbAutomatic
                    .ContainsItem = True
                    success& = BitBlt(.hDC, 0, 0, 50, 50, sourcehandle&, sourcex%, sourcey%, SRCCOPY)
                    .Caption = Item(lx%).Name
                    .Refresh
                End With
            End If
            CurOtherSlot% = CurOtherSlot% + 1
        End If
    Next lx%
End If
    
'PART 6 - UPDATE FORM AND DOEVENTS
DoEvents
frmInventory.Refresh

End Sub

Sub PickUpItem()
' this routine picks up the item the hero is standing on

' part 1 - check to see if there is any inventory space left.
inventoryspace% = 0
For X% = 12 To UBound(CharInv) 'remember the HeroDetails form and the pictures!
    If CharInv(X%).Type = 0 Then inventoryspace% = X%: Exit For 'save the spot in the inventory
Next X%

If inventoryspace% = 0 Then
    Call DisplayMessage("Can't pick anything up, inventory full")
    Exit Sub ' quit back to main program
End If

' part 2 - now that we know there is room, check to see if the hero is
' standing on top of an object
PickUpAbleObj% = -1
For nX% = LBound(Item) To UBound(Item) ' loop through all objects
    'if object has same coords and on same map
    If Char.X = Item(nX%).X And Char.Y = Item(nX%).Y And _
    Char.MapNo = Item(nX%).MapNo Then
        PickUpAbleObj% = nX% ' save the object number of the match
        Exit For
    End If
Next nX%

If PickUpAbleObj% = -1 Then 'if no object present
    Call DisplayMessage(LoadResString(1000))
    Exit Sub ' quit back to main program
End If

' Part 3 - pick up the object
Item(PickUpAbleObj%).MapNo = -1 ' not on any map any more
Item(PickUpAbleObj%).X = 0 ' not on any map any more
Item(PickUpAbleObj%).Y = 0 ' not on any map any more
CharInv(inventoryspace%) = Item(PickUpAbleObj%)
Item(PickUpAbleObj%).Type = 0
Call DisplayMessage("Hero picked up: " + Item(PickUpAbleObj%).Name)

Call UpdateInventoryForm(0)

End Sub

Sub ShowInfo(ByVal MX As Integer, ByVal MY As Integer)
' this procedure moves the character
' MX, MY are the mouse x,y when the map(form)was clicked

' step 1, calculate map offset from the mouse x,y
' since we know all the squares are 50x50 pixels, calculate the actual
' X,Y on the form
ClickedMapX% = Int(MX / 50) + DisplayXOffset%
ClickedMapY% = Int(MY / 50) + DisplayYOffset%

' step 2 - check to see if an object was clicked on
ClickedOnObj% = 0
For X% = LBound(Item) To UBound(Item) ' loop through all objects
If ClickedMapX% = Item(X%).X And ClickedMapY% = Item(X%).Y And Char.MapNo = Item(X%).MapNo Then
ClickedOnObj% = X% ' save the object number of the match
End If
Next X%

If ClickedOnObj% > 0 Then 'clicked on an object
' move the invisible label under the mouse so it will show a tooltip
Form1.ToolTipActivator.Left = MX - 5
Form1.ToolTipActivator.Top = MY - 5
Form1.ToolTipActivator.ToolTipText = Item(ClickedOnObj%).Name
End If
End Sub

Sub HeroWalkedOnSquare()
' step 1 - see if the hero is on top of an object
    ObjOnTopOf% = -1
    For XX% = LBound(Item) To UBound(Item) ' loop through all objects
        If Item(XX%).Type > 11 And Char.X = Item(XX%).X And Char.Y = Item(XX%).Y And Char.MapNo = Item(XX%).MapNo Then
            ObjOnTopOf% = XX% ' on top of an object
        End If
    Next XX%
    If ObjOnTopOf% = -1 Then Exit Sub ' not on top of anything

' step 2 - check each "special" type of object
    'check for gold object
    If Item(ObjOnTopOf%).Type = 11 Then ' gold object
        Char.Gold = Char.Gold + Item(ObjOnTopOf%).Field1
        Item(ObjOnTopOf%).Type = 0
    Call DisplayMessage("Picked Up " + Str(Item(ObjOnTopOf%).Field1) + " gold.")
    End If
    'check for teleporter object
    If Item(ObjOnTopOf%).Type = 12 Then
    Char.MapNo = Item(ObjOnTopOf%).Field1
    Char.X = Item(ObjOnTopOf%).Field2
    Char.Y = Item(ObjOnTopOf%).Field3
    Call DisplayMessage("You stepped through a" + Item(ObjOnTopOf%).Name)
    Call DrawMap
    End If
End Sub

Sub ScatterMonsters()
' this routine scatters monsters on the outdoor map
For lx% = LBound(Monster) To UBound(Monster)
Monster(lx%).X = Int(Rnd * 100)
Monster(lx%).Y = Int(Rnd * 100)
Monster(lx%).MapNo = 1
Next lx%
End Sub


Sub MonstersTurn()
' this routine is called each turn after the hero moves, it determines which
' monsters can do things and calls them one at a time.

' check each monster and see if its alive and within 10 squares
For lx% = LBound(Monster) To UBound(Monster)
    AllowToMove$ = "Yes"
    If Monster(lx%).MapNo <> Char.MapNo Then AllowToMove$ = "No" ' not on same map
    If Monster(lx%).HitPtCur <= 0 Then AllowToMove$ = "No" ' dead    If Abs(Monster(lx%).X - Char.X) > 10 Then AllowToMove$ = "No" ' too far away
    If Abs(Monster(lx%).Y - Char.Y) > 10 Then AllowToMove$ = "No" ' too far away
    If AllowToMove$ = "Yes" Then Call MoveMonster(lx%) ' move the monster
Next lx%
End Sub

Sub MoveItem(Source As Control, Dest As Control, Index As Integer)
'PART 1 - DETERMINE MOVE VALIDITY
    'check for move 2 self
    If Source.Name = Dest.Name And Source.Index = Index Then MsgBox "moved 2 self": Exit Sub
    'moved to occupied position
    If (Dest.Name = "InventorySlot" Or Dest.Name = "PackSlot") _
        And CharInv(DestIndex%).Type > 0 Then MsgBox LoadResString(1001): Exit Sub
    'moving around on ground (pointless)
    If Dest.Name = "OtherSlot" And Source.Name = "OtherSlot" Then MsgBox "move from ground 2 ground pointless": Exit Sub
'PART 2 - DETERMINE SOURCE AND DEST INDEX
    DestIndex% = -1
    sourceindex% = -1
    'source inventory
    If Source.Name = "InventorySlot" Then sourceindex% = Source.Index
    'source pack
    If Source.Name = "PackSlot" Then sourceindex% = Source.Index + 12 + PackOffset%
    'source ground, determine index by counting through valid items
    If Source.Name = "OtherSlot" Then
        For nX% = LBound(Item) To UBound(Item)
            With Item(nX%)
                If .X = Char.X And .Y = Char.Y And .MapNo = Char.MapNo Then
                    If OtherCount% = Source.Index Then sourceindex% = nX%: Exit For
                    OtherCount% = OtherCount% + 1
                End If
            End With
        Next nX%
    End If
    'destination inventory, check that item is valid to move
    If Dest.Name = "InventorySlot" Then
        DestIndex% = Index
        If CharInv(DestIndex%).Type > 0 Then MsgBox LoadResString(1001): Exit Sub
        If Source.Name = "OtherSlot" And Item(sourceindex%).Type <> DestIndex% Then
            MsgBox LoadResString(1002): Exit Sub
        ElseIf Source.Name <> "OtherSlot" Then
            If CharInv(sourceindex%).Type <> DestIndex% Then MsgBox LoadResString(1002): Exit Sub
        End If
    End If
    'destination backpack
    If Dest.Name = "PackSlot" Then
        DestIndex% = Index + PackOffset% + 12
        If CharInv(DestIndex%).Type > 0 Then MsgBox LoadResString(1001): Exit Sub
    End If
    'destination ground
    If Dest.Name = "OtherSlot" Then
        For nX% = LBound(Item) To UBound(Item)
            If Item(nX%).Type = 0 Then DestIndex% = nX%: Exit For
        Next nX%
        If DestIndex% = -1 Then MsgBox "No empty slot found!", vbCritical, "Error": Exit Sub
    End If

'PART 3 - PERFORM MOVE OPERATIONS
    If Source.Name = "OtherSlot" Then
        CharInv(DestIndex%) = Item(sourceindex%)
        With Item(sourceindex%)
            .MapNo = 0
            .X = 0
            .Y = 0
            .Type = 0
        End With
    Else
        If Dest.Name = "OtherSlot" Then
            Item(DestIndex%) = CharInv(sourceindex%)
            CharInv(sourceindex%).Type = 0
            With Item(DestIndex%)
                .X = Char.X
                .Y = Char.Y
                .MapNo = Char.MapNo
            End With
        Else
            CharInv(DestIndex%) = CharInv(sourceindex%)
            CharInv(sourceindex%).Type = 0
        End If
    End If
'PART 4 - UPDATE INVENTORY SCREEN
    Call UpdateInventoryForm(0)
    Call MonstersTurn
End Sub

Sub MoveMonster(ByVal MonNo As Integer)
' this routine is called for each monster thats allowed to move and is within 10 squares

' calculate distance to hero
DistToHero% = Abs(Monster(MonNo).X - Char.X)
If Abs(Monster(MonNo).Y - Char.Y) > DistToHero% Then DistToHero% = Abs(Monster(MonNo).Y - Char.Y)
CurHPpercent% = (Monster(MonNo).HitPtCur / Monster(MonNo).HitPtMax) * 100

' notes: we will use DX,DY to hold the desired X,Y direction the monster should take
' we will use CurHPpercent% to store the current health %

' part 1 - if monster is outside "intelligence" range, move randomly
If DistToHero% >= Monster(MonNo).Aggressiveness Then ' outside range
    DX = 1 - Int(Rnd * 3) ' random movement
    DY = 1 - Int(Rnd * 3)
End If


' Part 2 - Monster is inside range and agressiveness rating is higher than damage so it heads for hero
If DistToHero% < Monster(MonNo).Aggressiveness And CurHPpercent% >= Monster(MonNo).Aggressiveness Then
    DX = 0
    If Monster(MonNo).X > Char.X Then DX = -1
    If Monster(MonNo).X < Char.X Then DX = 1
    DY = 0
    If Monster(MonNo).Y > Char.Y Then DY = -1
    If Monster(MonNo).Y < Char.Y Then DY = 1
End If

' Part 3 - Monster is inside range and agressiveness rating is lower than damage so it flees from hero
If DistToHero% < Monster(MonNo).Aggressiveness And CurHPpercent% < Monster(MonNo).Aggressiveness Then
    DX = 0
    If Monster(MonNo).X > Char.X Then DX = 1
    If Monster(MonNo).X < Char.X Then DX = -1
    DY = 0
    If Monster(MonNo).Y > Char.Y Then DY = 1
    If Monster(MonNo).Y < Char.Y Then DY = -1
End If

' Part 4 - If monster is next to hero it doesn't move, instead it attacks.
If DistToHero% <= 1 Then DX = 0: DY = 0
    ' at this point, we have the appropriate DX,DY values, now to move the monster
    ' First - check to see if its a legal move
LegalMove = True
If Monster(MonNo).X + DX < 1 Or Monster(MonNo).X + DX > 100 Then LegalMove = False 'cant go off the map
If Monster(MonNo).Y + DY < 1 Or Monster(MonNo).Y + DY > 100 Then LegalMove = False 'cant go off the map
If LegalMove = True Then ' only check if inside map otherwise may crash
    ' check to see if the desired square is blocked
    If World(Char.MapNo).Tile(Monster(MonNo).X + DX, Monster(MonNo).Y + DY).Blocked = True Then LegalMove = False
End If

' Second - if its a legal move, erase the monster from current square by drawing the ground
If LegalMove = True Then
' first calculate what if its visible
    LeftmostVisSquare% = DisplayXOffset%
    TopmostVisSquare% = DisplayYOffset%
    RightmostVisSquare% = LeftmostVisSquare% + NoOfXSqrCanSee% - 1
    BottommostVisSquare% = TopmostVisSquare% + NoOfYSqrCanSee% - 1
End If

If Monster(MonNo).X >= LeftmostVisSquare% And Monster(MonNo).X <= RightmostVisSquare% _
And Monster(MonNo).Y >= TopmostVisSquare% And Monster(MonNo).Y <= BottommostVisSquare% Then
    Call DrawASquare(Monster(MonNo).X, Monster(MonNo).Y, 0, World(Char.MapNo).Tile(Monster(MonNo).X, Monster(MonNo).Y).Icon)
End If
' now draw an object if it was in that square
For X% = LBound(Item) To UBound(Item)
    If Item(X%).X = Monster(MonNo).X And Item(X%).Y = Monster(MonNo).Y Then Call DrawASquare(Item(X%).X, Item(X%).Y, 1, Item(X%).Icon)
Next X%

' third - update the monster location
Monster(MonNo).X = Monster(MonNo).X + DX
Monster(MonNo).Y = Monster(MonNo).Y + DY

' fourth - if possible draw it
If Monster(MonNo).X >= LeftmostVisSquare% And Monster(MonNo).X <= RightmostVisSquare% _
And Monster(MonNo).Y >= TopmostVisSquare% And Monster(MonNo).Y <= BottommostVisSquare% Then
    Call DrawASquare(Monster(MonNo).X, Monster(MonNo).Y, 2, Monster(MonNo).Icon)
    Form1.Refresh
End If
' After the move, recalculate distance to hero and call Attack if appropriate
DistToHero% = Abs(Monster(MonNo).X - Char.X)
If Abs(Monster(MonNo).Y - Char.Y) > DistToHero% Then DistToHero% = Abs(Monster(MonNo).Y - Char.Y)
If DistToHero% <= 1 Then Call Attack(2, MonNo) ' note: 2 = monster attacks, MonNo = current monster number

End Sub

Sub UpdateCharacter()
'recalculate defense value
    Defense% = 0
    For Count% = 0 To 11
        If CharInv(Count%).Type > 0 Then
            With CharInv(Count%)
                Select Case CharInv(Count%).Type
                    Case 1, 3, 4, 8, 9: Defense% = Defense% + .Field1
                End Select
            End With
        End If
    Next Count%
    Defense% = Defense% + Char.DexCur
    Char.DefVal = Defense%
End Sub

Function RollResult(ByVal pNumDice, pDiceMax, pBonus As Integer) As Integer
    result% = 0
    For nRoll% = 1 To pNumDice
        result% = result% + Int(Rnd * pDiceMax) + 1
    Next nRoll%
    result% = result% + pBonus
    RollResult = result%
End Function

Sub Attack(ByVal Attacker As Integer, ByVal MonNo As Integer)
' this routine is called when an attack happens (either the player or monster)
' calling arguments
' Attacker = 1 if the player is attacking a monster, in which case the MonNo
' argument has the monster being attacked
' Attacker = 2 if a monster is attacking the player, in which case the MonNo
' argument is the monster that is attacking

Call UpdateCharacter

' if the hero is the one attacking
If Attacker = 1 Then
    lpercentchancetohit = Char.DexCur + Char.Level * 5 - Monster(MonNo).DefVal
    StrBonus% = Int(Char.StrCur / 5) - 10
    DamageDone% = RollResult(1, 8, StrBonus%)
    Call DisplayMessage("You have " & lpercentchancetohit & "% chance to hit")
    
    'show whether you hit or not
    If (Rnd * 100 + 1) < lpercentchancetohit Then
        Call DisplayMessage("You attack the " & Monster(MonNo).Name & " and hit for " & DamageDone% & " damage!")
    Else
        Call DisplayMessage("You attack the " & Monster(MonNo).Name & " miss!")
    End If
    
    Call MonstersTurn
End If

' if the monster is the one attacking
If Attacker = 2 Then
    Monster(MonNo).Weapon.Attack MonNo
End If

If Attacker = 1 Then Call DrawASquare(Monster(MonNo).X, Monster(MonNo).Y, 4, HitIcon%)
If Attacker = 1 Then
    With Monster(MonNo)
        Call RedrawSquare(.X, .Y, .MapNo)
    End With
End If
If Attacker = 2 Then
    With Char
        Call RedrawSquare(.X, .Y, .MapNo)
    End With
End If
Form1.Refresh

' reflect the damages to monster and hero
If Attacker = 1 Then
    Monster(MonNo).HitPtCur = Monster(MonNo).HitPtCur - DamageDone%
    If Monster(MonNo).HitPtCur <= 0 Then Call MonsterDeath(MonNo)
End If
If Attacker = 2 Then
    Char.HitPtCur = Char.HitPtCur - DamageDone%
    If Char.HitPtCur <= 0 Then
        MsgBox "You have died... suck poo!"
        End
    End If
End If

End Sub

Sub DisplayMessage(ByVal Msg As String)
' this routine displays the desired message onto the text window
' and updates the scroll list so its shown properly

Form1.List1.AddItem Msg
Form1.List1.TopIndex = Form1.List1.ListCount - 1

End Sub

Sub MonsterDeath(ByVal MonNo As Integer)
' this routine is called when a monster dies.
lx% = Monster(MonNo).X
ly% = Monster(MonNo).Y

Call DisplayMessage("and it died.")
Monster(MonNo).HitPtCur = 0 ' kill it

' now make it dissapear off the map
' draw the ground
Call DrawASquare(lx%, ly%, 0, World(Char.MapNo).Tile(lx%, ly%).Icon) ' draw ground
Form1.Refresh

' now for the objects that might have been in that square
For X% = LBound(Item) To UBound(Item) ' go through all the objects
    If Item(X%).MapNo = Char.MapNo Then ' don't bother if its on a different map
        If Item(X%).X = lx% And Item(X%).Y = ly% Then Call DrawASquare(lx%, ly%, 1, Item(X%).Icon)
    End If
Next X%

' now for any other monsters that might have been on that square
For X% = LBound(Monster) To UBound(Monster) ' go through all the Monsters
    If Monster(X%).MapNo = Char.MapNo Then ' don't bother if its on a different map
        If Monster(X%).X = lx% And Monster(X%).Y = ly% And Monster(X%).HitPtCur > 0 Then Call DrawASquare(lx%, ly%, 2, Monster(X%).Icon)
    End If
Next X%
Form1.Refresh

End Sub

Sub SaveGame()
MsgBox "stub": Exit Sub
' this routine saves the game to disk.

' set up the CommDialog control
Options.CommonDialog1.DialogTitle = "Save Game As" ' put in the header on top of the dialog box
Options.CommonDialog1.FileName = "SaveGame.tsv" ' put in a default name to save as
Options.CommonDialog1.DefaultExt = "tsv" ' put in the default file extensions to look for
Options.CommonDialog1.Filter = "Saved Games (*.tsv)|*.tsv|All Files (*.*)|*.*" ' show both extension types in the dialog
Options.CommonDialog1.ShowSave ' make it appear"

lFileName$ = Options.CommonDialog1.FileName ' get the filename returned by the dialog
If InStr(lFileName$, "\") = 0 Then Exit Sub ' user hit cancel, exit save function

'if we made it to here then a valid file name is in lFileName$

Open lFileName$ For Output As #1
' output a header
'Write #1, "Keep Sake v" & App.Major & App.Minor & App.Revision
' write out the character stats
'Write #1, Char.Armor, Char.DexCur, Char.DexMax, Char.Gold, Char.HitPtCur, Char.HitPtMax, Char.IntCur, Char.IntMax, Char.MapNo, Char.Name, Char.Shield, Char.StrCur, Char.StrMax, Char.Sword, Char.X, Char.Y
' write out the universe info
' write out the objects
'For lx% = LBound(Item) To UBound(Item)
'Write #1, Item(lx%).Field1, Item(lx%).Field2, Item(lx%).Field3, Item(lx%).Field4, Item(lx%).Field5, Item(lx%).Icon, Item(lx%).MapNo, Item(lx%).Name, Item(lx%).Placed, Item(lx%).Type, Item(lx%).Worth, Item(lx%).X, Item(lx%).Y
'Next lx%
' write out the monsters
'For lx% = LBound(Monster) To UBound(Item)
'Write #1, Monster(lx%).Aggressiveness, Monster(lx%).AttackType, Monster(lx%).AttackValue, Monster(lx%).DefenseValue, Monster(lx%).DexMax, Monster(lx%).DexMax, Monster(lx%).HitPtCur, Monster(lx%).HitPtMax
'Write #1, Monster(lx%).Icon, Monster(lx%).IntMax, Monster(lx%).IntMax, Monster(lx%).MapNo, Monster(lx%).Name, Monster(lx%).StrMax, Monster(lx%).StrMax, Monster(lx%).Type, Monster(lx%).X, Monster(lx%).Y
'Next lx%
' write out the maps
'For lx% = 0 To 100
'For ly% = 0 To 100
'Write #1, World(0).Tile(lx%, ly%).Icon, World(0).Tile(lx%, ly%).Blocked, World(0).Tile(lx%, ly%).Visible
'Write #1, World(1).Tile(lx%, ly%).Icon, World(1).Tile(lx%, ly%).Blocked, World(1).Tile(lx%, ly%).Visible
'Write #1, World(2).Tile(lx%, ly%).Icon, World(2).Tile(lx%, ly%).Blocked, World(2).Tile(lx%, ly%).Visible
'Next ly%
'Next lx%
'Close #1
End Sub

Sub LoadGame()
MsgBox "stub": Exit Sub
' this routine loads the game from disk
' set up the CommDialog control
Options.CommonDialog1.DialogTitle = "Load Saved Game" ' put in the header on top of the dialog box
Options.CommonDialog1.FileName = "SaveGame.tsv" ' put in a default name to save as
Options.CommonDialog1.DefaultExt = "tsv" ' put in the default file extensions to look for
Options.CommonDialog1.Flags = &H1004 ' This flag means only existing names are allowed and no read-only
Options.CommonDialog1.Filter = "Saved Games (*.tsv)|*.tsv|All Files (*.*)|*.*" ' show both extension types in the dialog

' make the dialog box appear
Options.CommonDialog1.ShowOpen ' make it appear"

' check the name returned
'lFileName$ = Options.CommonDialog1.FileName ' get the filename returned by the dialog
'If InStr(lFileName$, "\") = 0 Then Exit Sub ' user hit cancel, exit save function

'Open lFileName$ For Input As #1
' read the header and check it.
'Input #1, test$
'If test$ <> "Marks VB-RPG Game Save 1.0" Then
'MsgBox "Not a valid saved game", , "Error"
'Close #1
'Exit Sub
'End If
' read the character stats
'Input #1, Char.Armor, Char.DexCur, Char.DexMax, Char.Gold, Char.HitPtCur, Char.HitPtMax, Char.IntCur, Char.IntMax, Char.MapNo, Char.Name, Char.Shield, Char.StrCur, Char.StrMax, Char.Sword, Char.X, Char.Y
' read the universe info
'Input #1, Universe.Difficulty, Universe.DisplayXOffset, Universe.DisplayYOffset, Universe.TotMonsters, Universe.TotObjects
' read the objects
'For lx% = 0 To Universe.TotObjects
'Input #1, Item(lx%).Field1, Item(lx%).Field2, Item(lx%).Field3, Item(lx%).Field4, Item(lx%).Field5, Item(lx%).Icon, Item(lx%).MapNo, Item(lx%).Name, Item(lx%).Placed, Item(lx%).Type, Item(lx%).Worth, Item(lx%).X, Item(lx%).Y
'Next lx%
' read the monsters
'For lx% = 0 To Universe.TotMonsters
'Input #1, Monster(lx%).Aggressiveness, Monster(lx%).AttackType, Monster(lx%).AttackValue, Monster(lx%).DefenseValue, Monster(lx%).DexMax, Monster(lx%).DexMax, Monster(lx%).HitPtCur, Monster(lx%).HitPtMax
'Input #1, Monster(lx%).Icon, Monster(lx%).IntMax, Monster(lx%).IntMax, Monster(lx%).MapNo, Monster(lx%).Name, Monster(lx%).StrMax, Monster(lx%).StrMax, Monster(lx%).Type, Monster(lx%).X, Monster(lx%).Y
'Next lx%
' read the maps
'For lx% = 0 To 100
'For ly% = 0 To 100
'Input #1, World(0).Tile(lx%, ly%).Icon, World(0).Tile(lx%, ly%).Blocked, World(0).Tile(lx%, ly%).Visible
'Input #1, World(1).Tile(lx%, ly%).Icon, World(1).Tile(lx%, ly%).Blocked, World(1).Tile(lx%, ly%).Visible
'Input #1, World(2).Tile(lx%, ly%).Icon, World(2).Tile(lx%, ly%).Blocked, World(2).Tile(lx%, ly%).Visible
'Next ly%
'Next lx%
'Close #1

' now that the data is back into the arrays, show the game
Options.Hide ' remove the options form from the screen
Form1.Show ' show the blank form
Call DrawMap ' display everything
Call DisplayMessage(" ")
Call DisplayMessage("*** GAME LOADED ***")
Call DisplayMessage(" ")
End Sub

Sub FixUpMapGraphics(ByVal MapNum As Integer)
' this routine fixes up the map graphics with new wall icons
' parameters:
' MapNum = 2 for dungeon, 1 for Outside map

If MapNum = 1 Then lbaseIcon% = 30 ' start numbering outside icons at 30
If MapNum = 2 Then lbaseIcon% = 0 ' start numbering inside icons at 0

' main loop, go through each square and check it
For lx% = 0 To 100
    For ly% = 0 To 100
    DoEvents
        If World(MapNum).Tile(lx%, ly%).Icon = 0 Then ' skip if manually placed icon
            If World(MapNum).Tile(lx%, ly%).Blocked = False Then ' this square is a floor
                World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 1
                If Rnd > 0.7 Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 2 ' occasionally give a variation
                If Rnd > 0.7 Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 3 ' occasionally give a variation
            Else ' must be a blocked square
                World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 4 ' start with a default of the filled in wall icon
                If Rnd > 0.7 Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 5 ' occasionally give a variation
                If Rnd > 0.7 Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 6 ' occasionally give a variation
                ' now start checking for custom icon numbers using code string for requirements.
                If MatchMapCode(MapNum, lx%, ly%, "BBXBUXUU") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 7 'check for icon number 7
                If MatchMapCode(MapNum, lx%, ly%, "XBXBUXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 8 'check for icon number 8
                If MatchMapCode(MapNum, lx%, ly%, "XUUBUXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 9 'check for icon number 9
                If MatchMapCode(MapNum, lx%, ly%, "XBXBBXUX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 10 'check for icon number 10
                If MatchMapCode(MapNum, lx%, ly%, "XUXBBXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 11 'check for icon number 11
                If MatchMapCode(MapNum, lx%, ly%, "XBXUBUUX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 12 'check for icon number 12
                If MatchMapCode(MapNum, lx%, ly%, "XBXUBXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 13 'check for icon number 13
                If MatchMapCode(MapNum, lx%, ly%, "UUUUBXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 14 'check for icon number 14
                If MatchMapCode(MapNum, lx%, ly%, "XBXBBUBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 15 'check for icon number 15
                If MatchMapCode(MapNum, lx%, ly%, "XBXBBUUB") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 16 'check for icon number 16
                If MatchMapCode(MapNum, lx%, ly%, "XXXBBXBU") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 17 'check for icon number 17
                If MatchMapCode(MapNum, lx%, ly%, "XBXXUXBB") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 18 'check for icon number 18
                If MatchMapCode(MapNum, lx%, ly%, "XBUXBXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 19 'check for icon number 19
                If MatchMapCode(MapNum, lx%, ly%, "UBBBXXBX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 20 'check for icon number 20
                If MatchMapCode(MapNum, lx%, ly%, "XUUBUXUU") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 21 'check for icon number 21
                If MatchMapCode(MapNum, lx%, ly%, "UUUUUXBB") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 22 'check for icon number 22
                If MatchMapCode(MapNum, lx%, ly%, "UUXUBUUX") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 23 'check for icon number 23
                If MatchMapCode(MapNum, lx%, ly%, "XBXUUUUU") = True Then World(MapNum).Tile(lx%, ly%).Icon = lbaseIcon% + 24 'check for icon number 24
            End If
        End If
    Next ly%
Next lx%
DoEvents
End Sub

Function MatchMapCode(ByVal MapNo As Integer, ByVal CurX As Integer, ByVal CurY As Integer, ByVal Code As String) As Boolean
' this function returns a True/False
' it will check all the squares around the current square based on the code provided and return a True if the square matches the criteria
' parameters
' MapNo the map number to check (2 = dungeon, 1=outside)
' CurX, CurY the map x,y to check
' Code = 8 character code defining how to check surrounding squares
' X = don't care, B = must be blocked, U = must be unblocked
    MatchMapCode = True ' default to True, any failure will set it to false
    If CurX = 0 Or CurY = 0 Or CurX = 100 Or CurY = 100 Then
     MatchMapCode = False
     Exit Function ' if at edge, can't do anything without erroring out, return
    End If

' start checking each position one by one, if it doesn't match, set the function to false
    If Mid(Code, 1, 1) <> "X" Then ' Check the upperleft spot, ignore if X in that spot of the code
      If Mid(Code, 1, 1) = "B" And World(MapNo).Tile(CurX - 1, CurY - 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 1, 1) = "U" And World(MapNo).Tile(CurX - 1, CurY - 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 2, 1) <> "X" Then ' Check the above spot, ignore if X in that spot of the code
      If Mid(Code, 2, 1) = "B" And World(MapNo).Tile(CurX, CurY - 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 2, 1) = "U" And World(MapNo).Tile(CurX, CurY - 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 3, 1) <> "X" Then ' Check the upperright spot, ignore if X in that spot of the code
      If Mid(Code, 3, 1) = "B" And World(MapNo).Tile(CurX + 1, CurY - 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 3, 1) = "U" And World(MapNo).Tile(CurX + 1, CurY - 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 4, 1) <> "X" Then ' Check the straight left spot, ignore if X in that spot of the code
      If Mid(Code, 4, 1) = "B" And World(MapNo).Tile(CurX - 1, CurY).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 4, 1) = "U" And World(MapNo).Tile(CurX - 1, CurY).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 5, 1) <> "X" Then ' Check the straight right spot, ignore if X in that spot of the code
      If Mid(Code, 5, 1) = "B" And World(MapNo).Tile(CurX + 1, CurY).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 5, 1) = "U" And World(MapNo).Tile(CurX + 1, CurY).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 6, 1) <> "X" Then ' Check the lowerleft spot, ignore if X in that spot of the code
      If Mid(Code, 6, 1) = "B" And World(MapNo).Tile(CurX - 1, CurY + 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 6, 1) = "U" And World(MapNo).Tile(CurX - 1, CurY + 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 7, 1) <> "X" Then ' Check the below spot, ignore if X in that spot of the code
      If Mid(Code, 7, 1) = "B" And World(MapNo).Tile(CurX, CurY + 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 7, 1) = "U" And World(MapNo).Tile(CurX, CurY + 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If
    If Mid(Code, 8, 1) <> "X" Then ' Check the lowerright spot, ignore if X in that spot of the code
      If Mid(Code, 8, 1) = "B" And World(MapNo).Tile(CurX + 1, CurY + 1).Blocked = False Then MatchMapCode = False ' needs to be blocked and its not, set function to false
      If Mid(Code, 8, 1) = "U" And World(MapNo).Tile(CurX + 1, CurY + 1).Blocked = True Then MatchMapCode = False ' needs to be unblocked and its blocked, set function to false
    End If

End Function

