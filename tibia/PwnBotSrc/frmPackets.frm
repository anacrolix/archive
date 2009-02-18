VERSION 5.00
Begin VB.Form frmPackets 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Packet Watcher"
   ClientHeight    =   5925
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6150
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5925
   ScaleWidth      =   6150
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtOutgoing 
      BorderStyle     =   0  'None
      Height          =   5175
      Left            =   3120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   120
      Width           =   2895
   End
   Begin VB.TextBox txtIncoming 
      BorderStyle     =   0  'None
      Height          =   5175
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   120
      Width           =   2895
   End
End
Attribute VB_Name = "frmPackets"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

