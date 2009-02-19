Attribute VB_Name = "modCharMem"
Public Const CHARMEM_AGE_PERMITTED_DEFAULT = 25
Public charMem As typ_Char_Mem
Private lastCharMemUpdate As Long

Public Type typ_Char
    id As Long '0
    name As String * 32 '4
    x As Long '36
    y As Long '40
    z As Long '44
    unknown1(35) As Byte '48
    facing As Long '84
    unknown3(7) As Byte '88
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
    conditionIndicator As Long '-0xd8
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

Public Sub UpdateCharMem(Optional agePermitted As Long = CHARMEM_AGE_PERMITTED_DEFAULT)
    If GetTickCount >= lastCharMemUpdate + agePermitted Then
        ReadProcessMemory hProcClient, ADR_BATTLE_SIGN, charMem, Len(charMem), 0
        lastCharMemUpdate = GetTickCount
    End If
End Sub

'Public Function IsCharMemRecent(agePermitted As Long) As Boolean
'    If GetTickCount < lastCharMemUpdate + agePermitted Then IsCharMemRecent = True
'End Function
