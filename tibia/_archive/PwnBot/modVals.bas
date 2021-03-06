Attribute VB_Name = "modVals"
'IN-GAME
Public Const ADR_GAME_STATUS = &H751B78
Public Const GAME_STATUS_CONNECTED = 8
Public Const GAME_STATUS_CONNECTING = 6
Public Const GAME_STATUS_DISCONNECTED = 0

'SERVER ADDRESSES
'login stuff
Public Const ADR_LOGIN_SERVER_IP = &H74A718 '&H746710
Public Const ADR_LOGIN_SERVER_PORT = ADR_LOGIN_SERVER_IP + &H64
Public Const LEN_LOGIN_SERVER = 5
Public Const SIZE_LOGIN_SERVER = &H70
Public Const ADR_LOGIN_CHAR_INDEX = &H751B38 '&H74DB30

'ENCRYPTION
Public Const ADR_ENCRYPTION_XTEA_KEY = &H74F1AC '&H74B1A0

'CHARACTER MEMORY
Public Const ADR_CHAR = &H5FB990 '&H5F7990
Public Const LEN_CHAR = 150
Public Const SIZE_CHAR = &HA0

Public Const ADR_CHAR_ID = ADR_CHAR
Public Const ADR_CHAR_NAME = ADR_CHAR + 4
Public Const ADR_CHAR_X = ADR_CHAR + 36
Public Const ADR_CHAR_Y = ADR_CHAR + 40
Public Const ADR_CHAR_Z = ADR_CHAR + 44
Public Const ADR_CHAR_GFX_DX = ADR_CHAR + 48
Public Const ADR_CHAR_GFX_DY = ADR_CHAR + 52
Public Const ADR_CHAR_WALKING = ADR_CHAR + 76
Public Const ADR_CHAR_DIRECTION = ADR_CHAR + 80
Public Const ADR_CHAR_FACING = ADR_CHAR + 84
Public Const ADR_CHAR_OUTFIT = ADR_CHAR + 96
Public Const ADR_CHAR_HEAD = ADR_CHAR + 100
Public Const ADR_CHAR_BODY = ADR_CHAR + 104
Public Const ADR_CHAR_LEGS = ADR_CHAR + 108
Public Const ADR_CHAR_FEET = ADR_CHAR + 112
Public Const ADR_CHAR_ADDONS = ADR_CHAR + 116
Public Const ADR_CHAR_LIGHT = ADR_CHAR + 120
Public Const ADR_CHAR_COLOR = ADR_CHAR + 124
Public Const ADR_CHAR_HP = ADR_CHAR + 136
Public Const ADR_CHAR_SPEED = ADR_CHAR + 140
Public Const ADR_CHAR_ONSCREEN = ADR_CHAR + 144
Public Const ADR_CHAR_SKULL = ADR_CHAR + 148
Public Const ADR_CHAR_PARTY = ADR_CHAR + 152

'player
Public Const ADR_PLAYER_ID = ADR_CHAR - &H60
Public Const ADR_CUR_HP = ADR_PLAYER_ID - 4
Public Const ADR_MAX_HP = ADR_CUR_HP - 4
Public Const ADR_EXP = ADR_MAX_HP - 4
Public Const ADR_LEVEL = ADR_EXP - 4 '70
Public Const ADR_MAGIC = ADR_LEVEL - 4
Public Const ADR_LEVEL_PERCENT = ADR_MAGIC - 4
Public Const ADR_MAGIC_PERCENT = ADR_LEVEL_PERCENT - 4
Public Const ADR_CUR_MANA = ADR_MAGIC_PERCENT - 4 '80
Public Const ADR_MAX_MANA = ADR_CUR_MANA - 4
Public Const ADR_CUR_SOUL = ADR_MAX_MANA - 4
Public Const ADR_STAMINA = ADR_CUR_SOUL - 4
Public Const ADR_CUR_CAP = ADR_STAMINA - 4 '90
Public Const ADR_ATTACK_ID = ADR_CUR_CAP - 4
Public Const ADR_FOLLOW_ID = ADR_ATTACK_ID - 4
Public Const ADR_FISH = ADR_FOLLOW_ID - 8 'a0
Public Const ADR_SHIELD = ADR_FISH - 4
Public Const ADR_DISTANCE = ADR_SHIELD - 4
Public Const ADR_AXE = ADR_DISTANCE - 4
Public Const ADR_SWORD = ADR_AXE - 4 'b0
Public Const ADR_CLUB = ADR_SWORD - 4
Public Const ADR_FIST = ADR_CLUB - 4
Public Const ADR_FISH_PERCENT = ADR_FIST - 4
Public Const ADR_SHIELD_PERCENT = ADR_FISH_PERCENT - 4 'c0
Public Const ADR_DISTANCE_PERCENT = ADR_SHIELD_PERCENT - 4
Public Const ADR_AXE_PERCENT = ADR_DISTANCE_PERCENT - 4
Public Const ADR_SWORD_PERCENT = ADR_AXE_PERCENT - 4
Public Const ADR_CLUB_PERCENT = ADR_SWORD_PERCENT - 4 'd0
Public Const ADR_FIST_PERCENT = ADR_CLUB_PERCENT - 4
Public Const ADR_BATTLE_SIGN = ADR_FIST_PERCENT - 4
Public Const CHAR_ONSCREEN = 1

'CODE MODS
Public Const ADR_SHOW_NAMES = &H4D7FFD
Public Const ADR_SHOW_NAMES_EX = &H4D8007
Public Const SHOW_NAMES_DEFAULT = 19573
Public Const SHOW_NAMES_EX_DEFAULT = 17013

'MAP
Public Const ADR_MAP_POINTER = &H60A038
Public Const Z_GROUND_LEVEL = 7
'const int MAP_POINTER                   = 0x0060A038;
Public Const LEN_TILE_ALL = 2016
Public Const SIZE_TILE = 172

Public Const LEN_TILE_X = 18
Public Const LEN_TILE_Y = 14
Public Const LEN_TILE_Z = 8

Public Const SIZE_OBJ = 12
Public Const LEN_OBJ = 13

Public Const OS_TILE_NUM_OBJ = 0
Public Const OS_TILE_OBJ_ID = 4
Public Const OS_TILE_OBJ_DATA1 = 8
Public Const OS_TILE_OBJ_DATA2 = 12

Public Const TILE_CHAR = &H63
Public Const TILE_LADDER = &H79C
Public Const TILE_TRANSPARENT = 470
'    TILE_LADDER_HOLE        = 411,
'    TILE_TRANSPARENT        = 470,
'
'    TILE_WATER_OLD          = 865,
'
'    TILE_WATER_FISH_BEGIN   = 4597,
'    TILE_WATER_FISH_END     = 4602,

'XRAY
Public Const ADR_SEE_ID = &H751C20
Public Const ADR_SEE_COUNT = &H74DC1C
Public Const ADR_SEE_Z = &H751B80
'// see (inspect)
'const int SEE_ID                        = 0x00751C20; // also 0x00751C2C
'const int SEE_COUNT                     = 0x0074DC1C;
'const int SEE_Z                         = 0x00751B80; // also 0x00751B90

'INVENTORY
Public Const SIZE_BP = 492
Public Const LEN_BP = 16
Public Const SIZE_ITEM = 12

Public Const ADR_BP_NAME = &H604200
Public Const ADR_BP_OPEN = ADR_BP_NAME - &H10
Public Const ADR_BP_NUM_ITEMS = ADR_BP_NAME + &H28
Public Const ADR_BP_MAX_ITEMS = ADR_BP_NAME + &H20
Public Const ADR_BP_ITEM = ADR_BP_NAME + &H2C
Public Const ADR_BP_ITEM_QUANTITY = ADR_BP_ITEM + 4

Public Const SLOT_HELMET = &H1
Public Const SLOT_NECK = &H2
Public Const SLOT_BACKPACK = &H3
Public Const SLOT_ARMOR = &H4
Public Const SLOT_RIGHT_HAND = &H5
Public Const SLOT_LEFT_HAND = &H6
Public Const SLOT_LEGS = &H7
Public Const SLOT_BOOTS = &H8
Public Const SLOT_RING = &H9
Public Const SLOT_AMMO = &HA
Public Const SLOT_INV = &H40

Public Const ADR_AMMO = ADR_BP_NAME - &H1C
Public Const ADR_RIGHT_HAND = ADR_AMMO + (SLOT_RIGHT_HAND - SLOT_AMMO) * SIZE_ITEM
Public Const ADR_LEFT_HAND = ADR_AMMO + (SLOT_LEFT_HAND - SLOT_AMMO) * SIZE_ITEM
Public Const ADR_RING = ADR_AMMO + (SLOT_RING - SLOT_AMMO) * SIZE_ITEM
Public Const ADR_NECK = ADR_AMMO + (SLOT_NECK - SLOT_AMMO) * SIZE_ITEM

'GAME VALUES
Public Const LIGHT_WHITE = &HD7
Public Const LIGHT_FULL = 77
Public Const ADDONS_MAX = 7
Public Const OUTFIT_MALE_SKINNY = &H80
Public Const OUTFIT_MALE_OLD = &H82
Public Const OUTFIT_COLOR_WHITE = 0
Public Const OUTFIT_COLOR_RED = &H5E
Public Const OUTFIT_COLOR_BLACK = &H72

Public Const DIR_NORTH = 0
Public Const DIR_EAST = 1
Public Const DIR_SOUTH = 2
Public Const DIR_WEST = 3
Public Const DIR_NORTH_EAST = 5
Public Const DIR_SOUTH_EAST = 6
Public Const DIR_SOUTH_WEST = 7
Public Const DIR_NORTH_WEST = 8

'battle sign masks
Public Const CONDITION_MASK_SWORDS = &H80
Public Const CONDITION_MASK_POISONED = &H1
Public Const CONDITION_MASK_HASTED = &H40
Public Const CONDITION_MASK_SHIELDED = &H10

'ITEM VALUES
Public Const ITEM_RUNE_UH = &HC58
Public Const ITEM_RUNE_SD = &HC53
Public Const ITEM_RUNE_BLANK = &HC4B
Public Const ITEM_RUNE_HMM = &HC7E
Public Const ITEM_RUNE_LMM = 3174
Public Const ITEM_RUNE_EXPLO = &HC80
Public Const ITEM_RUNE_GFB = &HC77
Public Const ITEM_RUNE_FBB = &HC3A

Public Const ITEM_VIAL = &HB3A
Public Const ITEM_VIAL_MANAFLUID = &HA
Public Const ITEM_LIFE_RING = &HBEC
Public Const ITEM_WORM = &HDA4
Public Const ITEM_FISHING_ROD = &HD9B
Public Const ITEM_GOLD = &HBD7
Public Const ITEM_BOLT = &HD76
Public Const ITEM_ROPE = &HBBB

'containers
Public Const ITEM_BAG = 2853
Public Const ITEM_BACKPACK_BLACK = 2870

'distance items
Public Const ITEM_SPEAR = &HCCD
Public Const ITEM_SMALL_STONE = &H6F5
Public Const ITEM_THROWING_KNIFE = &HCE2
Public Const ITEM_THROWING_STAR = 3287

'melee weapons
Public Const ITEM_GIANT_SWORD = &HCD1
Public Const ITEM_BRIGHT_SWORD = &HCDF
Public Const ITEM_CROSS_BOW = &HD15
Public Const ITEM_BOW = &HD16
Public Const ITEM_FIRE_AXE = &HCF8
Public Const ITEM_SKULL_STAFF = &HCFC
Public Const ITEM_DRAGON_HAMMER = &HCFA
Public Const ITEM_DRAGON_LANCE = &HCE6
Public Const ITEM_ICE_RAPIER = 3284

'anni stuff
Public Const ITEM_ELVEN_AMULET = 3082
Public Const ITEM_MIGHT_RING = 3048

'food
Public Const ITEM_FOOD_FISH = &HDFA

Public Function IsFood(id As Long) As Boolean
    Select Case id
        Case &HDF9& To &HE17&, &HE8B& To &HE94&: IsFood = True
        Case Else: IsFood = False
    End Select
End Function

Public Function TIME_ATTACK_RUNE(isEnforced As Boolean) As Long
    If isEnforced Then
        TIME_ATTACK_RUNE = 1000
    Else
        TIME_ATTACK_RUNE = 2000
    End If
End Function
