; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3610&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 03. February 2004
; OS: Windows
; Demo: Yes


; Shows a return handler with native PB commands
; Zeigt einen Return-Handler mit nativen PB-Befehlen

OpenWindow(1,200,200,400,200,"",#PB_Window_SystemMenu)
CreateGadgetList(WindowID(1))
StringGadget(1,10,10,300,20,"")
StringGadget(2,10,35,300,20,"")
StringGadget(3,10,60,300,20,"")
StringGadget(4,10,85,300,20,"")

AddKeyboardShortcut(1,#PB_Shortcut_Return,111)
SetActiveGadget(1)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Menu
      Select EventMenu()
        Case 111
          Select GetActiveGadget()
            Case 1
              ;MessageRequester("","StringGadget 1",0)
              SetActiveGadget(2)
            Case 2
              ;MessageRequester("","StringGadget 2",0)
              SetActiveGadget(3)
            Case 3
              ;MessageRequester("","StringGadget 3",0)
              SetActiveGadget(4)
            Case 4
              ;MessageRequester("","StringGadget 4",0)
              SetActiveGadget(1)
          EndSelect
      EndSelect
    Case #PB_Event_Gadget
      ; ...
  EndSelect
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger