; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,222,130,"SetGadgetFont",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
    If LoadFont(0,"Arial",16)
      SetGadgetFont(#PB_Default,FontID(0))   ; Set the loaded Arial 16 font as new standard
    EndIf
    ButtonGadget(0,10,10, 200, 30, "Button - Arial 16")
    SetGadgetFont(#PB_Default,#PB_Default)  ; Set the font settings back to original standard font
    ButtonGadget(1,10,50, 200, 30, "Button - standard")
    If LoadFont(0,"Courier",10,#PB_Font_Bold|#PB_Font_Underline)
      SetGadgetFont(#PB_Default,FontID(0))   ; Set the loaded Courier 10 font as new standard
    EndIf
    TextGadget(2,10,90,200,40,"Bold + underlined Courier 10 Text",#PB_Text_Center )
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP