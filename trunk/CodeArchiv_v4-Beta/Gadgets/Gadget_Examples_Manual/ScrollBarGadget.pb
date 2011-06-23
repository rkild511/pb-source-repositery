; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 13. July 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,305,140,"ScrollBarGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
    TextGadget       (2, 10, 25,250, 20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (0, 10, 42,250, 20, 0, 100, 30)
    SetGadgetState   (0, 50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (3, 10,115,250, 20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (1,270, 10, 25,120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (1,100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP