; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1988&highlight=
; Author: Christian Stransky (CS2001)  (updated for PB4.00 by blbltheworm)
; Date: 15. August 2003 
; OS: Windows
; Demo: No

Procedure HideWindowFromShowingInTaskbar(WindowID, NewWindowHandle, show) 
  If show=1 
    HideWindow(WindowID,1) 
  EndIf 
  SetWindowLong_(WindowID(WindowID),#GWL_HWNDPARENT,NewWindowHandle) 
  If show=1 
    HideWindow(WindowID,0) 
  EndIf 
  ProcedureReturn 
EndProcedure 

OpenWindow(1, 0, 0, 0, 0, "Not Needed", #PB_Window_ScreenCentered) 
HideWindow(1,1) 

OpenWindow(0,0,0,400,100, "Not shown in the Taskbar",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
  ButtonGadget(0, 0, 0, 200, 100, "Hide Window from showing in Taskbar") 
  ButtonGadget(1, 200, 0, 200, 100, "Show Window in Taskbar") 
  DisableGadget(1,1) 
  
Repeat 
  EventID=WaitWindowEvent() 
  Select EventID 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          HideWindowFromShowingInTaskbar(0, WindowID(1), 0) 
          DisableGadget(0,1) 
          DisableGadget(1,0) 
        Case 1 
          HideWindowFromShowingInTaskbar(0, 0, 1) 
          DisableGadget(0,0) 
          DisableGadget(1,1) 
      EndSelect 
  EndSelect 
Until EventID=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
