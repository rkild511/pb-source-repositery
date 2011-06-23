; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

hWnd=OpenWindow(0,10,10,200,200,"Test",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar) 

CreateGadgetList(hWnd) 
  TrackBarGadget(0, 10, 10, 100, 20, 0, 100) 
  TextGadget(1,10,40,100,20,"Lautstärke: 0")    

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      lautstaerke=GetGadgetState(0) 
      SetGadgetText(1,"Lautstärke: "+Str(lautstaerke)) 
      ; Jetzt einfach Lautstärke einstellen! 

    Case #PB_Event_CloseWindow 
      quit=1 
  EndSelect 
Until quit=1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP