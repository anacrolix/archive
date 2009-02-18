Attribute VB_Name = "modTypes"
Public Type typ_Char
    id As Long '0
    name As String * 32 '4
    x As Long '36
    y As Long '40
    z As Long '44
    unknown1(47) As Byte '48
    outfit As Long '96
    head As Long
    body As Long
    legs As Long
    feet As Long
    addons As Long '116
    lightIntensity As Long '120
    lightColor As Long '124
    unknown2(7) As Byte '128
    hp As Long '136
    speed As Long
    onScreen As Long '144
    skull As Long
    party As Long
    unknown4(3) As Byte
End Type

Public Type typ_Char_Mem
    battleSign As Long '-0xd8
    'unknown1(&H73) As Byte
    fistProgress As Long 'd4
    clubProgress As Long
    swordProgress As Long 'd0
    axeProgress As Long
    distanceProgress As Long
    shieldingProgress As Long
    fishingProgress As Long 'c0
    fist As Long
    club As Long
    sword As Long
    axe As Long 'b0
    distance As Long
    shielding As Long
    fishing As Long
    unknown3(&H3) As Byte 'a0
    followID As Long
    attackID As Long
    cap As Long
    stamina As Long '90
    soul As Long
    manaMax As Long
    manaCur As Long
    magicProgress As Long '80
    levelProgress As Long
    magic As Long
    level As Long
    exp As Long '70
    hpMax As Long
    hpCur As Long
    playerID As Long
    unknown2(&H5B) As Byte '-0x60
    char(LEN_CHAR - 1) As typ_Char
End Type

Public Type typ_Char_List
    name As String
    hp As Long
End Type
'
'Public Const SIZE_BP = 492
'Public Const LEN_BP = 16
'Public Const SIZE_ITEM = 12
'
'Public Const ADR_BP_NAME = &H600200
'Public Const ADR_BP_OPEN = ADR_BP_NAME - &H10
'Public Const ADR_BP_NUM_ITEMS = ADR_BP_NAME + &H28
'Public Const ADR_BP_MAX_ITEMS = ADR_BP_NAME + &H20
'Public Const ADR_BP_ITEM = ADR_BP_NAME + &H2C
'Public Const ADR_BP_ITEM_QUANTITY = ADR_BP_ITEM + 4

Public Type typ_Item
    id As Long
    extra1 As Long
    extra2 As Long
End Type

Public Type typ_Container
    open As Long '0
    unknown1(12 - 1) As Byte '4
    name As String * 32 '16
    maxItems As Long '48
    unknown2(4 - 1) As Byte '52
    itemCount As Long '56
    items(36 - 1) As typ_Item
End Type '492
