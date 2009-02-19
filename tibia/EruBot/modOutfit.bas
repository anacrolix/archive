Attribute VB_Name = "modOutfit"
Option Explicit

Public Const OUTFIT_SUPER_END = 7
Public Const OUTFIT_SUPER_START = 5
Public Const OUTFIT_NORMAL = 1

Public Function GetOutfitColor(colorIndex As Long) As Long
    Select Case colorIndex
        Case 1: GetOutfitColor = OUTFIT_BLUE
        Case 2: GetOutfitColor = OUTFIT_LIGHTBLUE
        Case 3: GetOutfitColor = OUTFIT_CYAN
        Case 4: GetOutfitColor = OUTFIT_PALEBLUE
        Case 5: GetOutfitColor = OUTFIT_WHITE
        Case 6: GetOutfitColor = OUTFIT_PALEYELLOW
        Case 8: GetOutfitColor = OUTFIT_DIMYELLOW
        Case 7: GetOutfitColor = OUTFIT_YELLOW
        Case 9: GetOutfitColor = OUTFIT_DARKYELLOW
    End Select
End Function
