; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6507
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 12. June 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,200,200,300,200,"test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  t$="This text goes inside a multiline StringGadget."+Chr(13)+Chr(10) 
  For r=1 To 10 : t$+Str(r)+Chr(13)+Chr(10) : Next 
  StringGadget(0,10,10,200,100,t$,#ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL|#WS_HSCROLL|#ESB_DISABLE_LEFT|#ESB_DISABLE_RIGHT) 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
