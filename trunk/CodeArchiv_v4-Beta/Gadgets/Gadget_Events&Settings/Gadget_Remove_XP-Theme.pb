; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9269&highlight=
; Author: Denis (updated for PB 4.00 by Andre, also added an example)
; Date: 26. January 2004
; OS: Windows
; Demo: No

; I use this code to remove XP theme from a specific gadget
; Entfernt den WinXP Look von einem bestimmten Gadget

Enumeration
  #Gadget1
  #Gadget2
EndEnumeration

OpenWindow(0,0,0,220,110,"WinXP Theme testing...",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If CreateGadgetList(WindowID(0))
  ButtonGadget(#Gadget1, 10, 15, 200, 30, "Button with XP Theme look")
  ButtonGadget(#Gadget2, 10, 60, 200, 30, "Button with removed XP Theme look")
EndIf


Result = LoadLibrary_("UxTheme.dll")

If Result
  Adress = GetProcAddress_(Result, "SetWindowTheme")
  CallFunctionFast(Adress ,GadgetID(#Gadget2),"","")
  FreeLibrary_(Result)
EndIf


Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP