; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 12. July 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,322,150,"EditorGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    EditorGadget (0,8,8,306,133,#PB_Container_Raised) 
    For a=0 To 5 
      AddGadgetItem(0,a,"Line "+Str(a)) 
    Next 
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP