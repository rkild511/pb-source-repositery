; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 12. July 2003
; OS: Windows
; Demo: Yes

 If OpenWindow(0,0,0,270,80,"HyperLinkGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    HyperLinkGadget(0, 10, 10,250,20,"Red HyperLink", RGB(255,0,0)) 
    HyperLinkGadget(1, 10, 30,250,20,"Arial Underlined Green HyperLink", RGB(0,255,0)) 
    SetGadgetFont(1, LoadFont(0, "Arial", 12, #PB_Font_Underline)) 
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -