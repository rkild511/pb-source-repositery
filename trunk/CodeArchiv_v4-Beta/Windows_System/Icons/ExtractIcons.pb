; http://www.rafb.net/paste/results/R4CgNu20.html
; Author: Unknown (older code, posted by pcfreak on IRC)
; Date: 12. March 2006
; OS: Windows
; Demo: No

OpenWindow(0,0,0,320,240,"Window",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
 
If CreateGadgetList(WindowID(0))
 ListIconGadget(1,10,10,300,220,"Icon #",280)
  count.l = ExtractIconEx_("C:\WINDOWS\explorer.exe",-1,0,0,0)
  For i = 0 To count - 1
   hIcon.l = 0
   ExtractIconEx_("C:\WINDOWS\explorer.exe",i,0,@hIcon,1)
   AddGadgetItem(1,-1,"Icon #" + Str(i),hIcon)
  Next
EndIf
 
Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -