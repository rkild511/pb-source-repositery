; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2032&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 21. August 2003
; OS: Windows
; Demo: No

OpenWindow(0,0,0,200,200,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  StringGadget(0, 0, 0, 200, 20, "ALT+S / RETURN") 

AddKeyboardShortcut(0,#PB_Shortcut_Alt|#PB_Shortcut_S,100) 
AddKeyboardShortcut(0,#PB_Shortcut_Return            ,101) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case 100 ; ALT+S 
          If GetFocus_() = GadgetID(0) ; StringGadget 
            MessageRequester("INFO","ALT+S im StringGadget",0) 
          EndIf 
        Case 101 ; Return 
          If GetFocus_() = GadgetID(0) 
            MessageRequester("INFO","RETURN im StringGadget",0) 
          EndIf 
      EndSelect 
  EndSelect 
ForEver 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
