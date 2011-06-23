; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2824&highlight=
; Author: MaxX@NRW (updated for PB4.00 by blbltheworm)
; Date: 14. November 2003
; OS: Windows
; Demo: No

Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Gadget_1
  #Gadget_2
  #Gadget_3
EndEnumeration


Procedure Open_Window_0()
  If OpenWindow(#Window_0, 216, 0, 400, 300, "Returnhandler...",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If CreateGadgetList(WindowID(#Window_0))
      StringGadget(#Gadget_1, 20, 110, 240, 40, "")
      StringGadget(#Gadget_2, 20, 20, 240, 30, "")
      StringGadget(#Gadget_3, 20, 60, 240, 40, "")

    EndIf
  EndIf
EndProcedure

Open_Window_0()
SetFocus_(GadgetID(#Gadget_2))
AddKeyboardShortcut(#Window_0,#PB_Shortcut_Return,100)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Menu
      Select EventMenu()
        Case 100
          If GetFocus_() = GadgetID(#Gadget_1)
            SetFocus_(GadgetID(#Gadget_2))
          ElseIf  GetFocus_() = GadgetID(#Gadget_3)
            SetFocus_(GadgetID(#Gadget_1))
          ElseIf  GetFocus_() = GadgetID(#Gadget_2)
            SetFocus_(GadgetID(#Gadget_3))
          EndIf
      EndSelect
  EndSelect
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP