; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7458
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 06. September 2003
; OS: Windows
; Demo: No

If OpenWindow(1,300,250,400,200,"Window",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  ButtonGadget(1,20,50,80,25,"Press ALT+&1") : AddKeyboardShortcut(1,#PB_Shortcut_Alt|#PB_Shortcut_1,1) 
  StringGadget(2,120,50,100,25,"Press Enter here") : AddKeyboardShortcut(1,#PB_Shortcut_Return,2) 
  Repeat 
    ev=WaitWindowEvent() 
    If ev=#PB_Event_Menu 
      which=EventMenu() 
      If which=1 
        Debug "ALT+1 was pressed" 
      Else 
        If GetFocus_()=GadgetID(2) ; If you remove this then pressing Enter works anywhere. 
          Debug "Enter was pressed" 
        EndIf 
      EndIf 
    EndIf 
  Until ev=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
