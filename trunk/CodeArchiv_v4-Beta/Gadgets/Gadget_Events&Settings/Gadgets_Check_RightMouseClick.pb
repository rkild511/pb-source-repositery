; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1646&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 08. July 2003
; OS: Windows
; Demo: No


Procedure WindowUnderCursor(hWnd) 
  GetCursorPos_(cursor.POINT) 
  MapWindowPoints_(0,hWnd,cursor,1) 
  ProcedureReturn ChildWindowFromPoint_(hWnd,cursor\x,cursor\y) 
EndProcedure 

hWin = OpenWindow(0,100,100,500,200, "Check right click", #PB_Window_MinimizeGadget) 
  CreateGadgetList(WindowID(0)) 
  hString = StringGadget(1, 10, 10, 60, 24, "String") 
  hText   = TextGadget(2, 100, 10, 60, 24, "Text") 
  hButton = ButtonGadget(3, 10, 40, 60, 24, "Button") 

Repeat 
  Select WaitWindowEvent() 
    Case #WM_RBUTTONDOWN ; any click anywhere in the window 
      Select WindowUnderCursor(WindowID(0)) 
        Case hString : MessageRequester("INFO","StringGadget",0) 
        Case hText   : MessageRequester("INFO","TextGadget",0) 
        Case hButton : MessageRequester("INFO","ButtonGadget",0) 
        Case hWin    : MessageRequester("INFO","Main Window",0) 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
