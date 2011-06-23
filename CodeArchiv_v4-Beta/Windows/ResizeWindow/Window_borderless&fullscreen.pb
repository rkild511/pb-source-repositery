; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8953&highlight=
; Author: fsw (updated for PB4.00 by blbltheworm)
; Date: 31. December 2003
; OS: Windows
; Demo: No

; Borderless fullscreen window, press Esc to quit...
If OpenWindow(0, 0, 0, GetSystemMetrics_(#SM_CXSCREEN), GetSystemMetrics_(#SM_CYSCREEN), "Borderless Window", #PB_Window_BorderLess | #PB_Window_ScreenCentered) 
  
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 1) 
  
  Repeat : WaitWindowEvent() : Until EventMenu() = 1 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
