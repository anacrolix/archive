Attribute VB_Name = "Globals"
'This module is used to hold global allocations such as _
Types, Enums, Constants, and API calls

'Allocating Global Types

Enum Compass
    Station = 0
    North = 1
    East = 2
    South = 3
    West = 4
End Enum

'Type Map_Type               'Map Type for each square
'    Walkable As Boolean     'false the square is normal
'    TileX As Integer        'Holds the X interval for used tile
'    TileY As Integer        'Holds the Y interval for user tile
'    Portal As Boolean       'false if basic square, if true _
'                            DesX, and DesY need to be valued
'    TextureSet As Integer    'Holds the information of where the texture _
'                            come from
'    PortalName As String    'Holds the name of the map _
'                            that the portal will take the player to
'    DesX As Integer         'holds information for map destination X
'    DesY As Integer         'holds information for map destination Y
'End Type

'This type holds all the map's constant variables
Type Map_Set
    MapName As String               'Stored map name
    SkyColor As Integer
    EarthColor As Integer
    GroundHeight() As Integer
    'gWav As String               'Holds name of the assigned wav
    'gWavWait As Boolean          'True, if there is a wav assigned then _
    '                              program will wait until complete with loading map
    'gMapCreator As String        'Holds the creators name
    'gMapDescription As String    'Holds the users description
    'StartX As Integer            'Holds the start point X on this map
    'StartY As Integer            'Holds the start point Y on this map
    'Map() As Map_Type            'Map information - stores all values in an array
End Type

'Type Player_Type
'    Speed As Integer
'    XPos As Single
'    YPos As Single
'    XMap As Integer
'    YMap As Integer
'    Direction As Compass
'    ToMove As Integer
'End Type

Global MapInfo As Map_Set

'Global Char As Player_Type

