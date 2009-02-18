Attribute VB_Name = "modINI"
Option Explicit
Private Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPrivateProfileIntA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal nDefault As Long, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileSection Lib "kernel32" Alias "GetPrivateProfileSectionA" (ByVal lpAppName As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileSectionNames Lib "kernel32" Alias "GetPrivateProfileSectionNamesA" (ByVal lpSectionNames As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileSection Lib "kernel32" Alias "WritePrivateProfileSectionA" (ByVal lpAppName As String, ByVal lpString As String, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long

Public Function ReadFromINI( _
    ByVal strFilePath As String, _
    ByVal strSection As String, _
    ByVal strKey As String, _
    Optional ByVal strDefault As String = "") _
As String
    'function to return the key value of any keys inside an ini section.
    Dim strBuffer As String
    strBuffer$ = String$(2048, Chr$(0&))
    ReadFromINI$ = Left$(strBuffer$, GetPrivateProfileString(strSection$, ByVal LCase$(strKey$), strDefault, strBuffer, Len(strBuffer), strFilePath$))
End Function

Public Sub WriteToINI(ByVal strFilePath As String, ByVal strSection As String, ByVal strKey As String, ByVal strKeyVal As String)
'sub to write a key and its value inside an ini section.but i
Call WritePrivateProfileString(strSection$, UCase$(strKey$), strKeyVal$, strFilePath$)
End Sub

Public Sub DeleteIniSection(ByVal strSection As String, ByVal strfullpath As String)
'sub to delete an entire ini section.
Call WritePrivateProfileString(strSection, 0&, 0&, strfullpath)
End Sub

Public Sub DeleteIniKey(ByVal strSection As String, ByVal strKeyname As String, ByVal strfullpath As String)
'sub to delete a particular key inside an ini section.
Call WritePrivateProfileString(strSection, strKeyname, 0&, strfullpath)
End Sub

Public Function CheckIfIniKeyExists(ByVal filePath As String, ByVal section, ByVal keyName As String) As Boolean
    'function to check if an ini key exists.
    Dim str1 As String, str2 As String
    str1 = ReadFromINI(filePath, section, keyName, "A")
    str2 = ReadFromINI(filePath, section, keyName, "B")
    If str1 = str2 Then CheckIfIniKeyExists = True
End Function

Public Function CheckIfIniSectionExists(ByVal strSection As String, ByVal strfullpath As String) As Boolean
'function to check if an ini section exists.
Dim strBuffer As String
Let strBuffer$ = String$(750, Chr$(0&))
CheckIfIniSectionExists = CBool(GetPrivateProfileSection(strSection$, strBuffer, Len(strBuffer), strfullpath$) > 0)
End Function

Public Function GetLongFromINI(ByVal strSection, ByVal strKeyname As String, ByVal strfullpath As String, Optional ByVal lngDefault As Long = 0) As Long
'function to return the Long portion of a key value. (will return 0 if the optional argument has not been passed and key value is non numeric or if key does not exist or is empty)
GetLongFromINI = GetPrivateProfileInt(strSection, strKeyname, lngDefault, strfullpath)
End Function

Public Sub RenameIniKey(ByVal strSection As String, ByVal strKeyname As String, ByVal strNewKeyname, ByVal strfullpath As String)
'sub to rename a particular key inside an ini section.
Dim tmpKeyValue As String
If CheckIfIniKeyExists(strSection, strKeyname, strfullpath) = False Then Exit Sub
tmpKeyValue = ReadFromINI(strSection, strKeyname, strfullpath)
Call WriteToINI(strSection, strNewKeyname, tmpKeyValue, strfullpath)
Call DeleteIniKey(strSection, strKeyname, strfullpath)
End Sub

Public Sub RenameIniSection(ByVal strSection As String, ByVal strNewSection As String, ByVal strfullpath As String)
'sub to rename an ini section name.
Dim KeyAndVal() As String, Key_Val() As String, strBuffer As String
Dim intx As Integer
Let strBuffer$ = String$(750, Chr$(0&))
Call GetPrivateProfileSection(strSection, strBuffer, Len(strBuffer), strfullpath)
KeyAndVal = Split(strBuffer, vbNullChar)
For intx = LBound(KeyAndVal) To UBound(KeyAndVal)
Key_Val = Split(KeyAndVal(intx), "=")
If UBound(Key_Val) = -1 Then Exit For
WriteToINI strNewSection, Key_Val(0), Key_Val(1), strfullpath
Next
DeleteIniSection strSection, strfullpath
Erase KeyAndVal: Erase Key_Val
End Sub

Public Sub LoadIniSectionsLB(ByVal lstB As ListBox, ByVal strfullpath As String)
'sub to load all of the ini section names into a listbox.
Dim sectnNames() As String, strBuffer As String
Dim intx As Integer
Let strBuffer$ = String$(750, Chr$(0&))
Call GetPrivateProfileSectionNames(strBuffer, Len(strBuffer), strfullpath)
sectnNames = Split(strBuffer, vbNullChar)
For intx = LBound(sectnNames) To UBound(sectnNames)
If sectnNames(intx) = vbNullString Then Exit For
lstB.AddItem sectnNames(intx)
Next
'If lstB.ListCount > 0 Then lst.Selected(0) = True '<<--if you want first list item in listbox selected
Erase sectnNames
End Sub

Public Function LoadIniSectionsArray(ByVal strfullpath As String) As String()
'function for populating array with all ini section names.
Dim sectnNames() As String, strBuffer As String
Let strBuffer$ = Space(1024)
Call GetPrivateProfileSectionNames(strBuffer, Len(strBuffer), strfullpath)
sectnNames = Split(strBuffer, vbNullChar)
LoadIniSectionsArray = Split(strBuffer, vbNullChar, UBound(sectnNames) - 1) 'vbLf
Erase sectnNames
End Function

Public Sub LoadIniSectionKeysLB(ByVal strSection As String, ByVal lstB As ListBox, ByVal strfullpath As String)
'sub to load all keys from an ini section into a listbox.
Dim KeyAndVal() As String, Key_Val() As String, strBuffer As String
Dim intx As Integer
Let strBuffer$ = String$(750, Chr$(0&))
Call GetPrivateProfileSection(strSection, strBuffer, Len(strBuffer), strfullpath)
KeyAndVal = Split(strBuffer, vbNullChar)
For intx = LBound(KeyAndVal) To UBound(KeyAndVal)
If KeyAndVal(intx) = vbNullString Then Exit For
Key_Val = Split(KeyAndVal(intx), "=")
If UBound(Key_Val) = -1 Then Exit For
lstB.AddItem Key_Val(0) '<--to get the keys prior to "=" delimiter only
'lstB.additem inikey(1) '<--to get the key values past the "=" delimiter only
Next
'If lstB.ListCount > 0 Then lst.Selected(0) = True '<<--if you want first list item in listbox selected
Erase KeyAndVal: Erase Key_Val
End Sub

Public Function GetSectionKeyCount(ByVal strSection As String, ByVal strfullpath As String) As Integer
    'function to get the key count of a particular ini section.
    Dim KeyAndVal() As String, strBuffer As String
    Dim intx As Integer, SectionKeyCount As Integer
    Let strBuffer$ = String$(750, Chr$(0&))
    Call GetPrivateProfileSection(strSection, strBuffer, Len(strBuffer), strfullpath)
    KeyAndVal = Split(strBuffer, vbNullChar)
    For intx = LBound(KeyAndVal) To UBound(KeyAndVal)
    If KeyAndVal(intx) = vbNullString Then Exit For
        SectionKeyCount = SectionKeyCount + 1
    Next
    GetSectionKeyCount = SectionKeyCount
    Erase KeyAndVal
End Function


