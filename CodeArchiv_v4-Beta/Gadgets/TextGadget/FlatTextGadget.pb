; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2223&highlight=
; Author: Kiffi (updated for PB 4.00 by Andre)
; Date: 26. February 2005
; OS: Windows
; Demo: No


; Display flat buttons in three different styles
; "Flache" Schalter in drei verschiedenen Stilen darstellen

If OpenWindow(0, 333, 70, 145, 105, "FlatTextGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(1, 8,  8, 128, 20, "Flat",     #PB_Text_Center | #PB_Text_Border) 
    TextGadget(2, 8, 40, 128, 20, "Flatter",  #PB_Text_Center | #SS_SUNKEN) 
    TextGadget(3, 8, 72, 128, 20, "Flattest", #PB_Text_Center | #WS_BORDER) 
    Repeat 
    Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP