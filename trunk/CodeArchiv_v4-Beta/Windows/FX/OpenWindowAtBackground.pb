; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1649&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 15. January 2005
; OS: Windows
; Demo: No


; Open window behind all other - so the button seems to be directly on the desktop
; Fenster hinter allen anderen öffnen - so erscheint der Schalter direkt auf dem Desktop zu liegen
OpenWindow(0, 0, 0, 120, 30, "ButtonOnDesktop", #PB_Window_BorderLess, GetDesktopWindow_()) 

CreateGadgetList(WindowID(0)) 
ButtonGadget(0, 0, 0, WindowWidth(0), WindowHeight(0), "Button") 

Repeat 
  SetWindowPos_(WindowID(0), #HWND_BOTTOM, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE) 
Until WaitWindowEvent() = #PB_Event_Gadget And EventGadget() = 0 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger