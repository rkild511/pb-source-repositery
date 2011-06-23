; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9477&highlight=
; Author: GPI (updated for PB 4.00 by Andre)
; Date: 11. February 2004
; OS: Windows
; Demo: Yes


; Root character on a button
; Wurzelzeichen auf einem Schalter
If OpenWindow(1,0,0,200,200,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(1)) 
    Id=LoadFont(1,"Symbol",10) 
    ButtonGadget(1,90,90,40,40,Chr($D6)+Chr($60)) 
    SetGadgetFont(1,Id) 
    Repeat 
      event=WaitWindowEvent() 
      
    Until event=#PB_Event_CloseWindow 
  EndIf 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP