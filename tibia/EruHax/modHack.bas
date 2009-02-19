Attribute VB_Name = "modLight"

Global Player_Light As Long
Global BattleList_Address As Long

Type Creature
  ID(3) As Byte
  Name As String  'Name
  x As Long       'X coordinate
  y As Long       'Y coordinate
  Z As Long       'Z coordinate
  OnScreen As Byte
  address As Long 'Memory Address (not needed, but can be used in future)
End Type

Public Function Hack_Light(lightAmount As Byte, setPlx As Boolean) As Byte
  'dont bother if tibia closed
  If Tibia_Hwnd = 0 Then Exit Function
  
  'read players current light value
  Hack_Light = Memory_ReadByte(Player_Address + BATTLE_OFFSET_LIGHT)
  
  'quit if light hack disabled
  If Not setPlx Then Exit Function
  
  'hack lights
  Dim address As Long
  
  For address = LBound(BATTLELIST_ARRAY) To UBound(BATTLELIST_ARRAY) Step DISTANCE_CHARACTERS
    If Memory_ReadByte(address) <> &H0 Then
      If Memory_ReadByte(address + BATTLE_OFFSET_LIGHT) <> lightAmount Then
        Memory_WriteByte address + BATTLE_OFFSET_LIGHT, lightAmount
      End If
    Else
      Exit Function
    End If
  Next address
End Function

Public Sub Hack_Name()
 
  'hack player onscreen name
  
  'player name address
  Dim newName As String
  Dim curByte As Integer
 
  'Find Tibia
  If Tibia_Hwnd = 0 Then Exit Sub

  newName = InputBox("Input new onscreen name")
  If newName <> "" Then
    If Len(newName) > 32 Then newName = Left(newName, 31)
    
    For curByte = 0 To Len(newName) - 1
      Call Memory_WriteByte(Player_Address() + curByte, Asc(Mid(newName, curByte + 1, 1)))
    Next curByte
    Call Memory_WriteByte(Player_Address() + Len(newName), 0)
  End If
End Sub

Public Function Player_Address() As Long
  ' Input : Name of a creature/player
  ' Output: Creature Object  [X,Y,Z, Name and Address]
  Dim pX, pY, pZ As Long

  If Tibia_Hwnd = 0 Then Exit Function
    pX = Memory_ReadLong(ADDRESS_PLAYER_X)
    pY = Memory_ReadLong(ADDRESS_PLAYER_Y)
    pZ = Memory_ReadLong(ADDRESS_PLAYER_Z)
    'Loop through the BattleList
    For BattleList_Address = LBound(BATTLELIST_ARRAY) To UBound(BATTLELIST_ARRAY) _
      Step DISTANCE_CHARACTERS
      If Memory_ReadByte(BattleList_Address + BATTLE_OFFSET_ONSCREEN) = 1 Then
        If Memory_ReadLong(BattleList_Address + BATTLE_OFFSET_X) = pX And _
          Memory_ReadLong(BattleList_Address + BATTLE_OFFSET_Y) = pY And _
          Memory_ReadLong(BattleList_Address + BATTLE_OFFSET_Z) = pZ Then
            Player_Address = BattleList_Address
            Exit Function
        End If
      End If
    Next BattleList_Address
End Function

Public Function Convert_AngleToDirection(a As Double) As String
  Dim s As String
  
  If a >= -7 * PI / 8 And a < -5 * PI / 8 Then s = "south west"
  If a >= -5 * PI / 8 And a < -3 * PI / 8 Then s = "south"
  If a >= -3 * PI / 8 And a < -1 * PI / 8 Then s = "south east"
  If a >= -1 * PI / 8 And a < 1 * PI / 8 Then s = "east"
  If a >= 1 * PI / 8 And a < 3 * PI / 8 Then s = "north east"
  If a >= 3 * PI / 8 And a < 5 * PI / 8 Then s = "north"
  If a >= 5 * PI / 8 And a < 7 * PI / 8 Then s = "north west"
  If a >= 7 * PI / 8 Or a < -7 * PI / 8 Then s = "west"
  
  Convert_AngleToDirection = s
End Function

Public Function arctan(ByVal y As Double, ByVal x As Double) As Double
  Dim theta As Double

  If (Abs(x) < 0.0000001) Then
    If (Abs(y) < 0.0000001) Then
      theta = 0#
    ElseIf (y > 0#) Then
      theta = 1.5707963267949
    Else
      theta = -1.5707963267949
    End If
  Else
    theta = Atn(y / x)
    
    If (x < 0) Then
      If (y >= 0#) Then
        theta = 3.14159265358979 + theta
      Else
        theta = theta - 3.14159265358979
      End If
    End If
  End If
  arctan = theta
End Function

Public Function Get_DirectionToCreature(c As Creature) As String
  Dim dX, dY, dZ As Long
  Dim dist As Single
  Dim angle As Double
  Dim s, dir, distStr, alt As String
  
  dX = c.x - Memory_ReadLong(ADDRESS_PLAYER_X)
  dY = c.y - Memory_ReadLong(ADDRESS_PLAYER_Y)
  dZ = c.Z - Memory_ReadLong(ADDRESS_PLAYER_Z)
  
  angle = arctan(-dY, dX)
  dir = Convert_AngleToDirection(angle)
  dist = (dX ^ 2 + dY ^ 2) ^ (1 / 2)
  If dZ > 0 Then
    alt = "below you "
  ElseIf dZ < 0 Then
    alt = "above you "
  Else: alt = ""
  End If
  
  If dist = 0 And dZ = 0 Then
    s = "in your square"
  ElseIf dist < 6 Then
    If dZ = 0 Then
      s = "beside you"
    Else
      s = alt
    End If
  Else
    If dist >= 6 And dist < 50 Then
      distStr = "to the"
    ElseIf dist >= 50 And dist < 300 Then
      distStr = "far to the"
    Else
      distStr = "very far to the"
    End If
    s = alt & distStr & " " & dir
  End If
  
  Get_DirectionToCreature = s
End Function

Public Function Get_Creature(address As Long) As Creature
  Dim f As Creature
  Dim str1, str2() As String
  Dim i As Integer
  
  str1 = Memory_ReadString(address)
  str2 = Split(str1, Chr$(0))
  f.Name = str2(0)
  f.x = Memory_ReadLong(address + BATTLE_OFFSET_X)
  f.y = Memory_ReadLong(address + BATTLE_OFFSET_Y)
  f.Z = Memory_ReadLong(address + BATTLE_OFFSET_Z)
  f.OnScreen = Memory_ReadByte(address + BATTLE_OFFSET_ONSCREEN)
  For i = LBound(f.ID) To UBound(f.ID)
    f.ID(i) = Memory_ReadByte(address - i)
  Next i
  Get_Creature = f
End Function

Public Function Get_BattleListReadout() As String
  Dim address As Long 'the address of current creature
  Dim c As Creature 'the current creature being worked on in battle list
  Dim s As String 'the updated battle list readout
  
  If Tibia_Hwnd = 0 Then Exit Function
  
  For address = LBound(BATTLELIST_ARRAY) To UBound(BATTLELIST_ARRAY) Step DISTANCE_CHARACTERS
    c = Get_Creature(address)
    If c.Name <> "" Then
      s = s & c.Name & String(32 - Len(c.Name), " ") & vbTab _
        & Get_DirectionToCreature(c) & String(32 - Len(Get_DirectionToCreature(c)), " ") & vbTab _
'        & c.x & vbTab _
'        & c.y & vbTab _
'        & c.Z & vbTab
'      If c.OnScreen = 1 Then s = s & "onScrn"
      s = s & vbCrLf
    End If
  Next address
  Get_BattleListReadout = s
End Function

