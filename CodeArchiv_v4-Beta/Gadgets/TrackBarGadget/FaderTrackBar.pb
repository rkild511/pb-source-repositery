; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9155&highlight=
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 15. January 2004
; OS: Windows
; Demo: Yes


; Moving the middle trackbar button, will move the left + right trackbar in opposite directions...

Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #TrackBar_fade 
  #TrackBar_lplayer 
  #TrackBar_rplayer 
EndEnumeration 

OpenWindow(#Window_0, 310, 74, 545, 259, "bongmong",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
CreateGadgetList(WindowID(#Window_0)) 
TrackBarGadget(#TrackBar_fade, 90, 100, 370, 80, 0, 100) 
SetGadgetState(#TrackBar_fade,50) 
TrackBarGadget(#TrackBar_lplayer, 20, 30, 70, 220, 0, 100, #PB_TrackBar_Vertical) 
SetGadgetState(#TrackBar_lplayer,50) 
TrackBarGadget(#TrackBar_rplayer, 500, 30, 70, 220, 0, 100, #PB_TrackBar_Vertical) 
SetGadgetState(#TrackBar_rplayer,50) 
Repeat 
  EventID = WaitWindowEvent() 
  Select EventID 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #TrackBar_fade 
          result = GetGadgetState(#TrackBar_fade) 
          SetGadgetState(#TrackBar_lplayer,result) 
          SetGadgetState(#TrackBar_rplayer,100-result) 
      EndSelect 
  EndSelect 
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
