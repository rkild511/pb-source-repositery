; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2623&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 23. October 2003
; OS: Windows
; Demo: Yes

EOL.s = Chr(13)+Chr(10) 

OpenWindow(1,200,200,200,100,"",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  For a = 0 To 100 : A$+"Line "+RSet(Str(a),3,"0")+EOL : Next a 
  StringGadget(1,0,0,200,100,A$,#ES_MULTILINE|#WS_VSCROLL|#WS_HSCROLL) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
