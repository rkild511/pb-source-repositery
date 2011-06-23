; English forum:
; Author: Unknown  (updated for PB4.00 by blbltheworm)
; Date: 21. March 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,640,480,"",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  StringGadget(0,8,8,626,466,"Does anybody know how to set this stringgadget to auto-word wrap? When the text is too long, it is cut out and this is my problem. Do you know understand what I mean? I want the gadget to automatically add a line return when the text is too long and continued in the next line. Can anybody help me? Please! Thank you!",#ES_MULTILINE | #ESB_DISABLE_LEFT | #ESB_DISABLE_RIGHT | #ES_AUTOVSCROLL | #WS_VSCROLL)
  Repeat
  Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP