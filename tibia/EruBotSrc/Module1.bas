Attribute VB_Name = "Module1"
Option Explicit

Public Declare Function ReadMemory Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long) As Long
Public Declare Function WriteMemory Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long, ByVal val As Long) As Integer
Public Declare Function ReadMemoryString Lib "erudll.dll" (ByVal processHandle As Long, ByVal address As Long, ByVal size As Long) As String
Public Declare Function FullLight Lib "erudll.dll" (ByVal processHandle As Long) As Long
Public Declare Function EncodeXTEA Lib "erudll.dll" (ByRef buff As Byte, ByRef key As Byte) As Integer
Public Declare Function DecodeXTEA Lib "erudll.dll" (ByRef buff As Byte, ByRef key As Byte) As Integer
