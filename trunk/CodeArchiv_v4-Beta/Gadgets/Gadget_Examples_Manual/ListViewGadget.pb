; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,140,"ListViewGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ListViewGadget(0,10,10,250,120)
  For a=1 To 12
    AddGadgetItem (0,-1,"Item "+Str(a)+" of the Listview")   ; define listview content
  Next
  SetGadgetState(0,9)    ; set (beginning with 0) the tenth item as the active one
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP