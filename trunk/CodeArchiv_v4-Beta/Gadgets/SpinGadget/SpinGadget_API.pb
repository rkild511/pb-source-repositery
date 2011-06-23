; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. June 2003
; OS: Windows
; Demo: No

HWND = OpenWindow(0, 100, 100, 400, 400, "Test...", #PB_Window_SystemMenu) 
If CreateGadgetList(WindowID(0)) 
    shwn = StringGadget(1,0,0,60,24,"") 
    uhwn = CreateUpDownControl_($560000A6,62,0,80,24,WindowID(0),1,GetModuleHandle_(0),shwn,500,0,250) 
EndIf 
Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
        Quit = 1 
    EndIf 
Until Quit = 1 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP