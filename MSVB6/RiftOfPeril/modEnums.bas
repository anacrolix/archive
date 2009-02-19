Attribute VB_Name = "modEnums"

Public Enum EnumRaces
    Human = 0
    Dwarf = 1
    Elf = 2
    Halfling = 3
End Enum

Public Enum EnumDirection
    NorthWest = 1
    North = 2
    NorthEast = 3
    East = 4
    SouthEast = 5
    South = 6
    SouthWest = 7
    West = 8
    Nowhere = 9
End Enum

Public Enum EnumAbilities
    aStr = 0
    aDex = 1
    aCon = 2
    aInt = 3
    aWis = 4
    aCha = 5
End Enum

Public Enum EnumIcon
    'OTHER
    Blank = 0
    
    'ITEMS
    
    ItemArmorMetal = 51
    ItemWeaponDagger = 52
    
    'MONSTERS
    
    MonsterKobold = 50
    
    'MAP STUFF
    
    'mix
    DungeonMixNicheTopRightWallRight = 28
    DungeonOtherStandAlone = 33
    'fill
    DungeonFillCracks1 = 12
    DungeonFillCracks2 = 11
    DungeonFillBase = 10
    'corners
    DungeonCornerBottomRight = 13
    DungeonCornerBottomLeft = 15
    DungeonCornerTopLeft = 17
    DungeonCornerTopRight = 18
    'walls
    DungeonWallRight = 14
    DungeonWallLeft = 16
    DungeonWallBottom = 19
    DungeonWallTopKinked = 20
    DungeonWallTopSmooth = 21
    'niches
    DungeonNicheTopRight = 25
    DungeonNicheTopLeft = 24
    DungeonNicheBottomLeft = 27
    DungeonNicheBottomRight = 26
    'pinches
    DungeonPinchLeftRight = 23
    DungeonPinchTopBottom = 29
    'peninsula
    DungeonPeninsulaRight = 22
    DungeonPeninsulaBottom = 30
    DungeonPeninsulaTop = 31
    DungeonPeninsulaLeft = 32
    'floor
    DungeonFloorLightStone2 = 40
    DungeonFloorLightStone1 = 41
    'old
    DungeonFloorBase = 0
    DungeonFloorBloodStains = 3
    DungeonFloorAnimalTracks = 5
    CharacterStickFigure = 6
    WoodDoorClosed = 7
    MineEntrance = 8
End Enum

Public Enum EnumItems
    iArmor = 1
    iShield = 2
    iAmulet = 3
    iCloak = 4
    iGloves = 5
    iBracer = 6
    iBoots = 7
    iRing = 8
    iBelt = 9
    iPack = 10
    iScroll = 11
    iPotion = 12
    iWeapon = 13
End Enum

Public Enum EnumEnchantType
    NonMagic = 0
    Enchanted = 1
    Cursed = 2
End Enum



Public Enum EnumSlots
    eSlotPrimary = 0
    eSlotArmor = 1
    eSlotShield = 2
    eSlotOffhand = 3
    eSlotOvergarment = 4
    eSlotGloves = 5
    eSlotBracers = 6
    eSlotBoots = 7
    eSlotRing1 = 8
    eSlotRing2 = 9
    eSlotPack = 10
    eSlotBelt = 11
    eSlotGreaves = 12
    eSlotHelmet = 13
    eSlotNeckwear = 14
End Enum


Public Enum EnumEntity
    DungeonEntrance = 0
    DungeonExit = 1
    DoorClosed = 2
    DoorOpen = 3
End Enum

Public Enum EnumMapType
    Outdoors = 0
    Dungeon = 1
End Enum

Public Enum EnumTileType
    DungeonWall = 0
    DungeonFloor = 1
End Enum

Public Enum EnumClass
    Fighter = 0
    Cleric = 1
    Wizard = 2
End Enum

Public Enum EnumMonsters
    Kobold = 0
    Goblin = 1
End Enum

Public Enum EnumDamageTypes
    Normal = 0
    Fire = 1
    Cold = 2
    Lightning = 3
    Acid = 4
    DrainHP = 5
End Enum

Public Enum EnumBonusType
    AC = 0
    Attack = 1
    Damage = 2
End Enum

Public Enum EnumItemField
    Weight = 1
End Enum

Function RetSlotStr(pSlot As Integer) As String
    Dim eSlot As EnumSlots
    eSlot = pSlot
    If eSlot = eSlotArmor Then RetSlotStr = "Armor"
    If eSlot = eSlotBelt Then RetSlotStr = "Belt"
    If eSlot = eSlotBoots Then RetSlotStr = "Boots"
    If eSlot = eSlotBracers Then RetSlotStr = "Bracers"
    If eSlot = eSlotGloves Then RetSlotStr = "Gloves"
    If eSlot = eSlotGreaves Then RetSlotStr = "Greaves"
    If eSlot = eSlotHelmet Then RetSlotStr = "Helmet"
    If eSlot = eSlotOffhand Then RetSlotStr = "Off Hand"
    If eSlot = eSlotOvergarment Then RetSlotStr = "Overgarment"
    If eSlot = eSlotPack Then RetSlotStr = "Pack"
    If eSlot = eSlotPrimary Then RetSlotStr = "Primary Hand"
    If eSlot = eSlotRing1 Then RetSlotStr = "Left Ring"
    If eSlot = eSlotRing2 Then RetSlotStr = "Right Ring"
    If eSlot = eSlotShield Then RetSlotStr = "Shield"
    If eSlot = eSlotNeckwear Then RetSlotStr = "Neckwear"
End Function

