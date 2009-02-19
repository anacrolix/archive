VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "World"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"Maps"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private mvarMaps As Maps


Public Property Get Maps() As Maps
    If mvarMaps Is Nothing Then
        Set mvarMaps = New Maps
    End If


    Set Maps = mvarMaps
End Property


Public Property Set Maps(vData As Maps)
    Set mvarMaps = vData
End Property
Private Sub Class_Terminate()
    Set mvarMaps = Nothing
End Sub



