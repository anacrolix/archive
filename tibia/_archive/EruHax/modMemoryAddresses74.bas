Attribute VB_Name = "modMemoryAddresses74"
'Public Const ADDRESS_BATTLE_FIRST = &H49D08C 'first entry in battle list
'Public Const ADDRESS_PLAYER_X = &H127080 'static player x coord
'Public Const ADDRESS_PLAYER_Y = &H127084 'static player y coord
'Public Const ADDRESS_PLAYER_Z = &H127088 'static player z coord
'Public Const ADDRESS_EXPERIENCE = &H49D01C 'static player current exp

'battle list offsets and lengths
Public Const LENGTH_BATTLE_ENTRY = 156
Public Const LENGTH_BATTLE_ARRAY = 147

Public Const OFFSET_BATTLE_X = 32 'long
Public Const OFFSET_BATTLE_Y = 36 'long
Public Const OFFSET_BATTLE_Z = 40 'long
Public Const OFFSET_ONSCREEN = 136 'byte
Public Const OFFSET_BATTLE_ID = -4 'long
Public Const OFFSET_BATTLE_LIGHT = 112 'long/byte?

'Global BATTLELIST_ARRAY(ADDRESS_BATTLE_FIRST To (ADDRESS_BATTLE_FIRST + _
  LENGTH_BATTLE_ARRAY * LENGTH_BATTLE_ENTRY)) As Long

Public Const ADDRESS_HOTKEY_CTRL_F12 = &H5F27F8
