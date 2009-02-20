Attribute VB_Name = "modData"
Public DataFile As New CDataFile

Sub Initialize()
    Set DataFile = New CDataFile
End Sub

Sub Terminate()
    Set DataFile = Nothing
End Sub

Function SplashTitle() As String
    SplashTitle = App.ProductName & " v. " & App.Major & "." & App.Minor & " build " & App.Revision
End Function

Private Sub RandItm(pItem As CItem, pLean As Integer, Optional pItmType As EnumItems = -1)
    Dim MgcLean As Integer
    If pItmType = -1 Then
        With pItem
            Select Case Roll(1, 100)
                Case Is < 50: pItmType = Armor
                    Select Case Roll(1, 50) + pLean
                        Case Is < 200:
                            .Name = "Chain Mail"
                            .Icon = ItemArmorMetal
                            .Weight = 30
                            .AddBonus AC, 10, ""
                            .ItemType = iArmor
                    End Select
                Case Else: pItmType = Weapon
                    Select Case Roll(1, 50) + pLean
                        Case Is < 200:
                            .Name = "Dagger"
                            .Icon = ItemWeaponDagger
                            .Weight = 1
                            .AddBonus Damage, 4, ""
                            .ItemType = iWeapon
                    End Select
            End Select
        End With
    End If
    If pItmType = Armor Then
    ElseIf pItmType = Weapon Then
    End If
End Sub

Sub ScatterItems(pMap As Variant, pAmount As Integer)
    Dim nCnt As Integer, nX As Integer, nY As Integer
    Dim NewItm As New CItem
    For nCnt = 1 To pAmount
        Do
            nX = Roll(1, Maps(pMap).Width) - 1
            nY = Roll(1, Maps(pMap).Height) - 1
        Loop Until Maps(pMap).Blocked(nX, nY) = False
        Set NewItm = Nothing
        RandItm NewItm, 0
        Itms.Add NewItm, pMap, nX, nY
    Next nCnt
End Sub

Function IsValidSlot(pItem As Integer, pSlot As Integer) As Boolean
    Dim eItem As EnumItems, eSlot As EnumSlots
    eItem = pItem
    eSlot = pSlot
    If eSlot = eSlotArmor Then
        If eItem = iArmor Then IsValidSlot = True
    ElseIf eSlot = eSlotPrimary Then
        If eItem = iWeapon Then IsValidSlot = True
    ElseIf eSlot = eSlotOffhand Then
        If eItem = iArmor Or iWeapon Then IsValidSlot = True
    End If
End Function

