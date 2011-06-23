; English forum: 
; Author: Unknown  (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


OpenWindow(1,200,200,400,200,"",#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(1)) 
   hString1 = StringGadget(1,10,10,300,20,"") 
; 
AddKeyboardShortcut(1,#PB_Shortcut_Return,111) 
; 
Repeat 
   Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        End 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case 111 
            If GetFocus_() = hString1 
              MessageRequester("","StringGadget 1",0) 
              SetFocus_(hString1) 
            EndIf 
        EndSelect 
      Case #PB_Event_Gadget 
        ; ... 
   EndSelect 
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP