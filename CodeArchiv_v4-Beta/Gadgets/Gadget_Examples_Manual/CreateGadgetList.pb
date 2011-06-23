; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

; Define your window first...
If OpenWindow(0,0,0,250,105,"Create gadgets...",#PB_Window_SystemMenu)
  ; Now create the gadget-list...
  If CreateGadgetList(WindowID(0))   ; the gadget-list was sucessfully created
    ; define your gadgets here...
    ButtonGadget(0,10,15,230,30,"Test button")
  Else                               ; the gadget-list couldn't be created
    ; show an error message here, end the program etc...
  EndIf  
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP