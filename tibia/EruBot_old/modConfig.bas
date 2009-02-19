Attribute VB_Name = "modConfig"
Option Explicit

Public Sub Config_Variable(fileNumber As Integer, writeElseRead As Boolean, ByRef var As Variant)
    If writeElseRead Then
        Write #fileNumber, var
    Else
        var = getNext(fileNumber)
    End If
End Sub

Public Sub Config_Title(fileNumber As Integer, writeElseRead As Boolean, title As String)
    If writeElseRead Then
        Write #fileNumber, title
    Else
        title = getNext(fileNumber)
    End If
End Sub

Public Sub Config_Control(fileNumber As Integer, writeElseRead As Boolean, target As Variant)
    If writeElseRead Then
        If TypeOf target Is CheckBox _
        Or TypeOf target Is HScrollBar _
        Or TypeOf target Is VScrollBar _
        Or TypeOf target Is OptionButton Then
            Write #fileNumber, target.Value
        ElseIf TypeOf target Is TextBox Then
            Write #fileNumber, target.Text
        ElseIf TypeOf target Is Label Then
            Write #fileNumber, target.Caption
        ElseIf TypeOf target Is ComboBox Then
            Write #fileNumber, target.ListIndex
        Else
            MsgBox "Attempt write unknown control type"
        End If
    Else
        If TypeOf target Is CheckBox _
        Or TypeOf target Is HScrollBar _
        Or TypeOf target Is VScrollBar _
        Or TypeOf target Is OptionButton Then
            target.Value = getNext(fileNumber)
        ElseIf TypeOf target Is TextBox Then
            target.Text = getNext(fileNumber)
        ElseIf TypeOf target Is Label Then
            target.Caption = getNext(fileNumber)
        ElseIf TypeOf target Is ComboBox Then
            target.ListIndex = getNext(fileNumber)
        Else
            MsgBox "Attempt write unknown control type"
        End If
    End If
End Sub

Public Sub Config_ControlArray(fileNumber As Integer, writeElseRead As Boolean, target As Variant)
    Dim lb As ListBox, i As Integer
    For i = 0 To target.Count - 1
        If TypeOf target(i) Is ListBox Then
            lb = target(i)
            Config_ListBox fileNumber, writeElseRead, "", lb
        Else
            Config_Control fileNumber, writeElseRead, target(i)
        End If
    Next i
End Sub

Public Sub Config_ListBox(fileNumber As Integer, writeElseRead As Boolean, title As String, target As Variant)
    If writeElseRead Then
        Dim i As Integer
        Write #fileNumber, title
        With target
            If .ListCount > 0 Then
                For i = 0 To .ListCount - 1
                    Write #fileNumber, .list(i)
                Next i
            End If
        End With
        Write #fileNumber, "<End List>"
    Else
        Dim temp As String
        getNext fileNumber
        With target
            .Clear
            Do
                temp = getNext(fileNumber)
                If temp <> "<End List>" Then .AddItem temp
            Loop Until temp = "<End List>"
        End With
    End If
End Sub

Public Function getNext(fileNumber As Integer) As Variant
    Dim temp As Variant
    Input #fileNumber, temp
    getNext = temp
End Function


