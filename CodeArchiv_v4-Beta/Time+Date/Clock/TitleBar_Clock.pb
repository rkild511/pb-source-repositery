; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7024&highlight=
; Author: gnozal
; Date: 26. July 2003
; OS: Windows
; Demo: No

; This little app displays the date & time in the titlebar of any foreground window.
; Needs an include image "TitleBar-Clock.ico"

Global PopUpActif.b
If CreatePopupMenu(0)
  MenuItem(1, "Quit TitleBar-Clock")
EndIf
; -----------------------------------------------------------
Procedure.s WMGetText(Handle.l)
  
  Buffer.s = Space(255)
  SendMessage_(Handle, #WM_GETTEXT, 256, @Buffer)
  result.s = PeekS(@Buffer)
  ProcedureReturn result
  
EndProcedure
;
; -----------------------------------------------------------
Procedure WMSetText(Handle.l, Text.s)
  
  SendMessage_(Handle, #WM_SETTEXT, 0, Text.s)
  
EndProcedure
; -----------------------------------------------------------
Procedure DoEvents()
  
  If PopUpActif = 0
    msg.MSG
    If PeekMessage_(msg,0,0,0,1)
      TranslateMessage_(msg)
      DispatchMessage_(msg)
    Else
      Delay(1)
    EndIf
  Else
    Delay(1)
  EndIf
  
EndProcedure
; -----------------------------------------------------------
hWnd.l = 0
Last_hWnd.l = 0
WindowText.s = ""
LastWindowText.s = ""
NewWindowText.s = ""
Heure.s = ""
LastHeure.s = ""
OpenWindow(0,0,0,100,100,"TitleBar-Clock",#PB_Window_Invisible)
Icone1_ID.l = CatchImage(1, ?Icone1)
If Icone1_ID
  AddSysTrayIcon(1, WindowID(0), Icone1_ID)
  SysTrayIconToolTip(1, "TitleBar-Clock")
Else
  End
EndIf
Repeat
  ; Events
  Event.l = WindowEvent()
  PopUpActif = 0
  If Event = #PB_Event_SysTray
    EvenTypeID.l = EventType()
    If EvenTypeID = #PB_EventType_LeftDoubleClick Or EvenTypeID = #PB_EventType_RightClick
      DisplayPopupMenu(0, WindowID(0))
      PopUpActif = 1
    EndIf
  ElseIf Event = #PB_Event_Menu
    EventIDMenu.l = EventMenu()
    If EventIDMenu.l = 1
      CloseWindow(0)
      End
    EndIf
  EndIf
  ; Do Events
  DoEvents()
  ; Clock stuff
  hWnd = GetForegroundWindow_()
  If hWnd <> Last_hWnd
    If WindowText <> ""
      If Last_hWnd <> 0
        WMSetText(Last_hWnd,WindowText)
      EndIf
    EndIf
    If hWnd <> 0
      WindowText = WMGetText(hWnd)
      LastWindowText = WindowText
      Last_hWnd = hWnd
    EndIf
  Else
    If hWnd <> 0
      NewWindowText = WMGetText(hWnd)
;       Debug "NewWindowText = " + NewWindowText
;       Debug "WindowText = " + WindowText
;       Debug "LastWindowText = " + LastWindowText
      If NewWindowText <> LastWindowText
        WindowText = NewWindowText
      EndIf
      Heure.s = FormatDate("%dd/%mm/%yyyy  %hh:%ii:%ss", Date())
      If LastHeure <> Heure
        LastWindowText = WindowText + "  -  " + Heure
        WMSetText(hWnd,LastWindowText)
        SysTrayIconToolTip(1, "TitleBar-Clock - " + Heure)
        LastHeure = Heure
      EndIf
    EndIf
  EndIf
ForEver
DataSection
Icone1:
IncludeBinary "..\..\Graphics\Gfx\people.ico"  ; "TitleBar-Clock.ico"
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
