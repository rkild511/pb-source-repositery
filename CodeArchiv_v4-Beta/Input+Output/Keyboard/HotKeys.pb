; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003 
; OS: Windows 
; Demo: No 


; Clear key buffers before use.
GetAsyncKeyState_(#VK_CONTROL)
GetAsyncKeyState_(#VK_SHIFT)
GetAsyncKeyState_(#VK_H)


;ALT is actually called MENU, so use VK_MENU instead of VK_ALT.
;It's just a strange Windows thing.  See here For a listing:
;
;http://216.26.168.92/vbapi/ref/other/virtualkeycodes.html

;
If OpenWindow(0,200,200,450,200,"Test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  ButtonGadget(0,50,50,100,21,"Press Shift+Ctrl+H")
  Repeat
    Sleep_(1) : ev=WindowEvent() ; Don't use WaitWindowEvent or we won't see the keypress.
    If GetAsyncKeyState_(#VK_H)=-32767 And GetAsyncKeyState_(#VK_CONTROL)=-32767 And GetAsyncKeyState_(#VK_SHIFT)=-32767
      MessageBeep_(#MB_ICONASTERISK)
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP