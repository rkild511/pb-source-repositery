; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8586&highlight=
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 03. December 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,222,200,"ButtonGadgets",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ButtonGadget(1, 10, 10, 60, 20, "Button1", #PB_Button_Toggle) 
  ButtonGadget(2, 10, 50, 60, 20, "Button2", #PB_Button_Toggle) 
  ButtonGadget(3, 10, 90, 60, 20, "Button3", #PB_Button_Toggle) 
  SetGadgetState(1,#True) ; Push first button in. 
  cur=1 ; Remember which gadget is currently pushed in. 
  Repeat 
    ev=WaitWindowEvent() 
    If ev=#PB_Event_Gadget 
      id=EventGadget() 
      If id <> cur  ; <-- CHANGED IF STATEMENT HERE 
        SetGadgetState(cur,#False) ; Push old button "out". 
        ; REMOVED STATEMENT HERE 
        cur=id ; Remember new button. 
      EndIf 
    EndIf 
  Until ev=#PB_Event_CloseWindow 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
