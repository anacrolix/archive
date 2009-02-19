Attribute VB_Name = "modTypes"
Public Type typ_Char_List
    name As String
    hp As Long
End Type

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

Public Enum typ_Damage
    DAMAGE_ENERGY
    DAMAGE_FIRE
    DAMAGE_FORCE
    DAMAGE_POISON
End Enum
