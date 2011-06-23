; English forum:
; Author: Paul (updated for PB4.00 by blbltheworm)
; Date: 12. April 2003
; OS: Windows
; Demo: No

#Window_Main=0
#Gadget_Main_String1=1
#Gadget_Main_String2=2
#Gadget_Main_String3=3
 
If OpenWindow(#Window_Main,165,0,182,131,"Example",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Window_Main))
    StringGadget(#Gadget_Main_String1,10,20,160,20,"")
    StringGadget(#Gadget_Main_String2,10,45,160,20,"")
    StringGadget(#Gadget_Main_String3,10,70,160,20,"")
  EndIf
EndIf
 
 
SetActiveGadget(#Gadget_Main_String1)
Repeat
  EventID=WaitWindowEvent()
  
  If GetAsyncKeyState_(#VK_DOWN)=-32767
    keybd_event_(#VK_DOWN,1,#KEYEVENTF_KEYUP,0)
    keybd_event_(#VK_TAB,1,0,0)
    keybd_event_(#VK_TAB,1,#KEYEVENTF_KEYUP,0)
  EndIf
  If GetAsyncKeyState_(#VK_UP)=-32767
    keybd_event_(#VK_UP,1,#KEYEVENTF_KEYUP,0)
    keybd_event_(#VK_SHIFT,1,0,0)
    keybd_event_(#VK_TAB,1,0,0)
    keybd_event_(#VK_TAB,1,#KEYEVENTF_KEYUP,0)
    keybd_event_(#VK_SHIFT,1,#KEYEVENTF_KEYUP,0)
  EndIf 
   
Until EventID=#PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP