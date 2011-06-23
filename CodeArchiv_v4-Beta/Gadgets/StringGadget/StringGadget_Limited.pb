; http://www.purebasic.com
; Author: Andre Beer  (updated for PB4.00 by blbltheworm)
; Date: 27. June 2003
; OS: Windows
; Demo: No

If OpenWindow(0,50,150,322,120,"StringGadget Limited",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  #TxtGad = 0 : #StrGad = 1
  TextGadget  (#TxtGad,8,10,306,20,"StringGadget limited to 4 chars")
  StringGadget(#StrGad,8,40,306,20,"")
  SendMessage_(GadgetID(#StrGad), #EM_LIMITTEXT, 4, 0)  ; where 4 is the char limit you set 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP