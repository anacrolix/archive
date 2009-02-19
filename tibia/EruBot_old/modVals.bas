Attribute VB_Name = "modVals"
'character array +0x5a000
Public Const ADR_ENCRYPTION_KEY = &H74B1A0
Public Const ADR_CHAR_FIRST = &H5F7990
Public Const ADR_PLAYER_X = &H5D16F0
Public Const ADR_HOTKEY = &H719EF0
Public Const ADR_BP_NAME = &H600200
Public Const ADR_VIP_NAME = &H5C4574
Public Const ADR_WHITE_TEXT = &H71DBE0
Public Const ADR_ACCOUNT_NUMBER = &H71C574 'note, short 0x100000
Public Const ADR_LOGIN_SERVER_IP = &H746710
Public Const ADR_GFX_VIEW_X = &H4ABF48
Public Const ADR_LOGIN_CHAR = &H74DB30
Public Const ADR_MAP_POINTER = &H5D4C20
Public Const ADR_FRAMERATE = &H71C2F4
'public const adr_rsa_key = &h6BFD70

Public Const LEN_CHAR = 150
Public Const SIZE_CHAR = &HA0

Public Const ADR_CHAR_ID = ADR_CHAR_FIRST
Public Const ADR_CHAR_NAME = ADR_CHAR_FIRST + 4
Public Const ADR_CHAR_X = ADR_CHAR_FIRST + 36
Public Const ADR_CHAR_Y = ADR_CHAR_FIRST + 40
Public Const ADR_CHAR_Z = ADR_CHAR_FIRST + 44
Public Const ADR_CHAR_GFX_DX = ADR_CHAR_FIRST + 48
Public Const ADR_CHAR_GFX_DY = ADR_CHAR_FIRST + 52
Public Const ADR_CHAR_WALKING = ADR_CHAR_FIRST + 76
Public Const ADR_CHAR_DIRECTION = ADR_CHAR_FIRST + 80
Public Const ADR_CHAR_FACING = ADR_CHAR_FIRST + 84
Public Const ADR_CHAR_OUTFIT = ADR_CHAR_FIRST + 96
Public Const ADR_CHAR_LIGHT = ADR_CHAR_FIRST + 120
Public Const ADR_CHAR_COLOR = ADR_CHAR_FIRST + 124
Public Const ADR_CHAR_HP = ADR_CHAR_FIRST + 136
Public Const ADR_CHAR_ONSCREEN = ADR_CHAR_FIRST + 144
Public Const ADR_CHAR_SKULL = ADR_CHAR_FIRST + 148
Public Const ADR_CHAR_PARTY = ADR_CHAR_FIRST + 152

'character details
Public Const ADR_PLAYER_ID = ADR_CHAR_FIRST - &H60
Public Const ADR_CUR_HP = ADR_PLAYER_ID - 4
Public Const ADR_MAX_HP = ADR_CUR_HP - 4
Public Const ADR_EXP = ADR_MAX_HP - 4
Public Const ADR_LEVEL = ADR_EXP - 4 '70
Public Const ADR_MAGIC = ADR_LEVEL - 4
Public Const ADR_LEVEL_PERCENT = ADR_MAGIC - 4
Public Const ADR_MAGIC_PERCENT = ADR_LEVEL_PERCENT - 4
Public Const ADR_CUR_MANA = ADR_MAGIC_PERCENT - 4 '70
Public Const ADR_MAX_MANA = ADR_CUR_MANA - 4
Public Const ADR_CUR_SOUL = ADR_MAX_MANA - 4
Public Const ADR_STAMINA = ADR_CUR_SOUL - 4
Public Const ADR_CUR_CAP = ADR_STAMINA - 4 '80
Public Const ADR_FOLLOW_ID = ADR_CUR_CAP - 4
Public Const ADR_TARGET_ID = ADR_FOLLOW_ID - 4
Public Const ADR_FISH = ADR_TARGET_ID - 8 '90
Public Const ADR_SHIELD = ADR_FISH - 4
Public Const ADR_DISTANCE = ADR_SHIELD - 4
Public Const ADR_AXE = ADR_DISTANCE - 4
Public Const ADR_SWORD = ADR_AXE - 4 'a0
Public Const ADR_CLUB = ADR_SWORD - 4
Public Const ADR_FIST = ADR_CLUB - 4
Public Const ADR_FISH_PERCENT = ADR_FIST - 4
Public Const ADR_SHIELD_PERCENT = ADR_FISH_PERCENT - 4 'b0
Public Const ADR_DISTANCE_PERCENT = ADR_SHIELD_PERCENT - 4
Public Const ADR_AXE_PERCENT = ADR_DISTANCE_PERCENT - 4
Public Const ADR_SWORD_PERCENT = ADR_AXE_PERCENT - 4
Public Const ADR_CLUB_PERCENT = ADR_SWORD_PERCENT - 4 'c0
Public Const ADR_FIST_PERCENT = ADR_CLUB_PERCENT - 4

Public Const ADR_BATTLE_SIGN = ADR_CHAR_FIRST - &HD8

'player position
Public Const ADR_PLAYER_Y = ADR_PLAYER_X - 4
Public Const ADR_PLAYER_Z = ADR_PLAYER_X - 8

'hotkeys

Public Const SIZE_HOTKEY = 256
Public Const LEN_HOTKEY = 35

Public Const ADR_HOTKEY_SENDAUTO = ADR_HOTKEY - (LEN_HOTKEY + 1)

'containers


Public Const SIZE_BP = 492
Public Const LEN_BP = 16
Public Const SIZE_ITEM = 12

Public Const ADR_BP_OPEN = ADR_BP_NAME - &H10
Public Const ADR_BP_NUM_ITEMS = ADR_BP_NAME + &H28
Public Const ADR_BP_MAX_ITEMS = ADR_BP_NAME + &H20
Public Const ADR_BP_ITEM = ADR_BP_NAME + &H2C
Public Const ADR_BP_ITEM_QUANTITY = ADR_BP_ITEM + 4

'inventory
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

'vip list

Public Const SIZE_VIP = &H2C '44
Public Const LEN_VIP = 99 '100 vips

Public Const ADR_VIP_ID = ADR_VIP_NAME - &H4
Public Const ADR_VIP_ONLINE = ADR_VIP_NAME + &H1E
Public Const ADR_VIP_SYMBOL = ADR_VIP_NAME + &H24

'log masks
Public Const MASK_SWORDS = &H80
Public Const MASK_POISONED = &H1
Public Const MASK_HASTED = &H40
Public Const MASK_SHIELDED = &H10

'outfit colors
Public Const OUTFIT_WHITE = 0
Public Const OUTFIT_PALEBLUE = 9
Public Const OUTFIT_PALEYELLOW = 3
Public Const OUTFIT_DIMYELLOW = 60
Public Const OUTFIT_YELLOW = 79
Public Const OUTFIT_CYAN = 85
Public Const OUTFIT_LIGHTBLUE = 86
Public Const OUTFIT_BLUE = 87
Public Const OUTFIT_RED = 94
Public Const OUTFIT_DARKYELLOW = 98
Public Const OUTFIT_BLACK = 114

'other addresses

Public Const ADR_GFX_VIEW_Z = ADR_GFX_VIEW_X - 8
'Public Const ADR_GFX_UNIDENT_Z = &HD025DC
Public Const ADR_GFX_VIEW_Y = ADR_GFX_VIEW_X - 4
'#define PLAYER_NAME         0x005F3DA6 // string
'Public Const ADR_MOUSE_OP = &H5F6D44
'    USE_LEFT_CLICK          = 1,    // finish use object, walk, click interface
'    USE_RIGHT_CLICK         = 2,    // prepare use object
'    USE_LEFT_RIGHT_CLICK    = 3,    // look; "You see..."
'    USE_DRAG                = 6,    // drag object
'    USE_OBJECT              = 7,    // use object (fishing rod)

Public Const SIZE_LOGIN_SERVER = &H70
Public Const LEN_LOGIN_SERVER = 5
Public Const ADR_LOGIN_SERVER_PORT = ADR_LOGIN_SERVER_IP + &H64

Public Const ADR_PASSWORD = ADR_ACCOUNT_NUMBER - &H20 'note, short 0x100000

'item values
Public Const ITEM_RUNE_UH = &HC58
Public Const ITEM_RUNE_SD = &HC53
Public Const ITEM_RUNE_BLANK = &HC4B
Public Const ITEM_RUNE_HMM = &HC7E
Public Const ITEM_RUNE_LMM = 3174

Public Const ITEM_RUNE_EXPLO = &HC80
Public Const ITEM_RUNE_GFB = &HC77
Public Const ITEM_RUNE_FBB = &HC3A

Public Const ITEM_VIAL = &HB3A
Public Const ITEM_MANAFLUID_EXTRA = &HA
Public Const ITEM_LIFE_RING = &HBEC
Public Const ITEM_WORM = &HDA4
Public Const ITEM_FISHING_ROD = &HD9B
Public Const ITEM_GOLD = &HBD7
Public Const ITEM_BOLT = &HD76
Public Const ITEM_ROPE = &HBBB
Public Const ITEM_BAG = 2853

Public Const ITEM_BACKPACK_BLACK = 2870
'distance items
Public Const ITEM_SPEAR = &HCCD
Public Const ITEM_SMALL_STONE = &H6F5
Public Const ITEM_THROWING_KNIFE = &HCE2
Public Const ITEM_THROWING_STAR = 3287
'weapons
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

Public Const ITEM_FOOD_FISH = &HDFA

'tiles

'OLD UNUSED CONSTANTS
'Public Const adrXGo = &H5F2AF0
'Public Const adrYGo = &H5F2AEC
'Public Const adrGo = &H49D0DC
'Public Const adrCharPos = &H12AE28
'Public Const adrWText = &H5F2DA8
'Public Const adrWhiteTT = &H5F2DA4

