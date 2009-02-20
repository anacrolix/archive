VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CDataFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'local variable(s) to hold property value(s)
Private oFSO, oDataFile
Private DataFilePath As String

Private Sub Class_Initialize()
    Set oFSO = CreateObject("Scripting.FileSystemObject")
    DataFilePath = App.Path & "\data.rop"
End Sub

Private Sub OpenFile()
    Set oDataFile = oFSO.OpenTextFile(DataFilePath, 1)
End Sub

Private Sub CloseFile()
    Set oDataFile = Nothing
End Sub

Public Function GetItmFld(pFieldNo As EnumItemField)
    OpenFile
    CloseFile
End Function

Public Function GetDataString(pSection As String, Optional pSubSection As String)
    Set oDataFile = oFSO.OpenTextFile(DataFilePath, 1)
    GoToSection pSection, pSubSection
    GetDataString = oDataFile.readline
    oDataFile.Close
End Function

Private Sub GoToSection(pSection As String, Optional pSubSection As String = "")
    Do
        If (oDataFile.readline = "//" & pSection) Then
            If pSubSection <> "" Then
                Do
                    If (oDataFile.readline = "/" & pSubSection) Then Exit Sub
                Loop
            Else
                Exit Sub
            End If
        End If
    Loop
End Sub

Public Sub GetMonster(pMonster As CMonster, pMonType As String)
    Dim Raw, Proc() As String
    OpenFile
    GoToSection "Monsters", pMonType
    Raw = oDataFile.readline
    Proc = Split(Raw, ",", 3)
    With pMonster
        .MaxHP = Roll(Int(Proc(0)), Int(Proc(1)), False) + Int(Proc(2))
        .CurHP = .MaxHP
    End With
    Raw = oDataFile.readline
    Proc = Split(Raw, ",", 3)
    With pMonster
        .XPVal = Int(Proc(0))
        .Gold = Int(Proc(1))
        .AC = Int(Proc(2))
    End With
    Raw = oDataFile.readline
    While Mid(Raw, 1, 1) <> "/"
        Proc = Split(Raw, ",", 5)
        pMonster.AddAttack Proc(0), Int(Proc(1)), Int(Proc(2)), Int(Proc(3)), Int(Proc(4))
        Raw = oDataFile.readline
    Wend
    CloseFile
End Sub

Public Sub GetMap(pLevel As CLevel, pLevelName As String)
    Dim Raw, Proc() As String
    Dim nY As Integer, nX As Integer
    Dim IconNo As EnumIcon, EntType As EnumEntity
    OpenFile
    GoToSection "Levels", pLevelName
    Raw = oDataFile.readline
    Proc = Split(Raw, ",", 2)
    pLevel.Width = Proc(0)
    pLevel.Height = Proc(1)
    For nY = 0 To pLevel.Height - 1
        Raw = oDataFile.readline
        Proc = Split(Raw, " ", pLevel.Width)
        For nX = 0 To pLevel.Width - 1
            With pLevel
                Select Case Proc(nX)
                    Case Is = "#":
                        IconNo = DungeonWallBase
                        .SetTile nX, nY, True, DungeonWall, IconNo
                    Case Is = ".", "@", "C":
                        IconNo = DungeonFloorBase
                        .SetTile nX, nY, False, DungeonFloor, IconNo
                End Select
            End With
        Next nX
    Next nY
    Raw = oDataFile.readline
    While Mid(Raw, 1, 1) <> "/"
        Proc = Split(Raw, ",", 4)
        Select Case Proc(2)
            Case "Entrance": IconNo = MineEntrance: EntType = DungeonEntrance
            Case "WoodDoor": IconNo = WoodDoorClosed: EntType = DoorClosed
        End Select
        pLevel.NewEntity Int(Proc(0)), Int(Proc(1)), IconNo, EntType, Proc(3)
        Raw = oDataFile.readline
    Wend
    CloseFile
End Sub

Private Sub Class_Terminate()
    Set oFSO = Nothing
End Sub
