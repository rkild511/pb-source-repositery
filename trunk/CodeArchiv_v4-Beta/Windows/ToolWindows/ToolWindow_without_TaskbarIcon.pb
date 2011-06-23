; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6726
; Author: PB (adapted by Andre, updated for PB4.00 by blbltheworm)
; Date: 27. June 2003
; OS: Windows
; Demo: No

win = OpenWindow(0, 0, 0, 219, 85, "ToolWindow without Taskbar icon", #PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_ScreenCentered) 
SetWindowLong_(WindowID(0),#GWL_EXSTYLE,#WS_EX_TOOLWINDOW)   ; both lines are needed to avoid displaying
ResizeWindow(0,#PB_Ignore,#PB_Ignore,220,100) : ShowWindow_(WindowID(0),#SW_SHOW)    ; of your window on the taskbar

CreateGadgetList(win)
ButtonGadget(1,20,30,180,20,"Exit")

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget  ; check for a pushed button 
    Select EventGadget()
      Case 1  
        Quit = 1 
    EndSelect
  EndSelect    
Until Quit = 1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
