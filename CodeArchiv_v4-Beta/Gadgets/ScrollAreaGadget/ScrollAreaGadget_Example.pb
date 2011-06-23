; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1634&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 07. July 2003
; OS: Windows
; Demo: Yes


If OpenWindow(0, 0, 0, 500, 500, "TEST", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget) 
  
  If CreateGadgetList(WindowID(0)) 
    ScrollAreaGadget(0, 0, 0, 500, 500, 1000, 1000, 5, #PB_ScrollArea_BorderLess) 
      StringGadget(1, 81, 94, 131, 532, "") 
      ListViewGadget(2, 287, 116, 189, 691) 
      TextGadget(3, 506, 638, 108, 137, "") 
    CloseGadgetList() 
  EndIf 
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
