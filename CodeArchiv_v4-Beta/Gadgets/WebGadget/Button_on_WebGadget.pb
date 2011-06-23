; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=4873&highlight= 
; Author: coldarchon (updated for PB 4.00 by Andre + edel) 
; Date: 05. July 2004 
; OS: Windows 
; Demo: No 

ScreenWidth = 640 
ScreenHeight = 480 

hWnd = OpenWindow(0, 0, 0, ScreenWidth, ScreenHeight, "Button im Button", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered) 

CreateGadgetList(hWnd) 
ButtonGadget(1, ScreenWidth*0.4, ScreenHeight*0.4, ScreenWidth*0.2, ScreenHeight*0.2, "Button on WebGadget") 
WebGadget(0, 0, 0, ScreenWidth, ScreenHeight, "www.google.de") 
SetParent_(GadgetID(1),GadgetID(0)) 
SetActiveGadget(1) 

Repeat 
  Event = WaitWindowEvent() 
  Select Event 
  EndSelect 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -