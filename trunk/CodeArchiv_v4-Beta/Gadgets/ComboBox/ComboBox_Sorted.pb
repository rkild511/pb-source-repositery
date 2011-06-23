; http://www.purebasic.com
; Author: Andre Beer (updated for PB4.00 by blbltheworm)
; Date: 27. May 2003
; OS: Windows
; Demo: No

If OpenWindow(0,100,130,220,100,"ComboBox Sorted",#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
    cb.l = ComboBoxGadget(1,10,10,200,200,#CBS_SORT) 
    SendMessage_(cb,#CB_ADDSTRING,0,"3")    ; the items will be added in random order
    SendMessage_(cb,#CB_ADDSTRING,0,"4") 
    SendMessage_(cb,#CB_ADDSTRING,0,"1")    ; .... but they will be displayed in sorted order
    SendMessage_(cb,#CB_ADDSTRING,0,"2") 
  EndIf
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP