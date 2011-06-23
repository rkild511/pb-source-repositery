; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6278&highlight=
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 31. May 2003
; OS: Windows
; Demo: Yes

; Place a requester with using an invisible window
If OpenWindow(0,300,250,400,200,"Main App Window",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1,20,50,250,25,"Click to open file requester at top-left of screen") 
  Repeat 
    ev=WindowEvent() 
    If ev=#PB_Event_Gadget 
      OpenWindow(1,-9999,-9999,0,0,"Temp Hidden Window",0) ; Opens at top-left. 
      ;OpenWindow(1,9999,-9999,0,0,0,"Temp Hidden Window") ; Opens at top-right. 
      ;OpenWindow(1,9999,9999,0,0,0,"Temp Hidden Window") ; Opens at bottom-right. 
      ;OpenWindow(1,-9999,9999,0,0,0,"Temp Hidden Window") ; Opens at bottom-left. 
      OpenFileRequester("title","","*.*",0) 
      CloseWindow(1) 
    EndIf 
  Until ev=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
