Attribute VB_Name = "modLight"
'Global cur_player_address

Public Function hack_Light(lightAmount As Byte, setPlx As Boolean) As Byte
  'dont bother if tibia closed
  If Tibia_Hwnd = 0 Then Exit Function
  'quit if light hack disabled
  If Not setPlx Then Exit Function

  'read players current light value
  hack_Light = Memory_Read_Byte(player_Address + OFFSET_BATTLE_LIGHT)
  
  'hack lights
  Dim pAddress, address As Long
  
  pAddress = player_Address
  
  If Memory_Read_Byte(pAddress + OFFSET_BATTLE_LIGHT) <> lightAmount Then
    Memory_Write_Byte pAddress + OFFSET_BATTLE_LIGHT, lightAmount
  End If
  
  'For address = ADDRESS_BATTLE_FIRST To ADDRESS_BATTLE_LAST Step LENGTH_BATTLE_ENTRY
  '  If Memory_Read_Byte(address) <> &H0 Then
  '    If Memory_Read_Byte(address + BATTLE_OFFSET_LIGHT) <> lightAmount Then
  '      Memory_Write_Byte address + BATTLE_OFFSET_LIGHT, lightAmount
  '    End If
  '  Else
  '    Exit Function
  '  End If
  'Next address
End Function

Public Sub hack_Name()
 
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
      Call Memory_Write_Byte(player_Address() + curByte, Asc(Mid(newName, curByte + 1, 1)))
    Next curByte
    Call Memory_Write_Byte(player_Address() + Len(newName), 0)
  End If
End Sub

Public Function player_Address() As Long
  ' Input : Name of a creature/player
  ' Output: Creature Object  [X,Y,Z, Name and Address]
  Dim pX, pY, pZ As Long

  If Tibia_Hwnd = 0 Then Exit Function
    pX = Memory_Read_Long(ADDRESS_PLAYER_X)
    pY = Memory_Read_Long(ADDRESS_PLAYER_Y)
    pZ = Memory_Read_Long(ADDRESS_PLAYER_Z)
    'Loop through the BattleList
    For address = ADDRESS_BATTLE_FIRST To ADDRESS_BATTLE_LAST Step LENGTH_BATTLE_ENTRY
      If Memory_Read_Byte(address + OFFSET_ONSCREEN) = 1 Then
        If Memory_Read_Long(address + OFFSET_BATTLE_X) = pX And _
          Memory_Read_Long(address + OFFSET_BATTLE_Y) = pY And _
          Memory_Read_Long(address + OFFSET_BATTLE_Z) = pZ Then
            player_Address = address
            Exit Function
        End If
      End If
    Next address
End Function
