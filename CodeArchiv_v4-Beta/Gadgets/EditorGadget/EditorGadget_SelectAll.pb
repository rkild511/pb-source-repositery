; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9201&highlight=
; Author: Danilo (example added by Andre, updated for PB4.00 by blbltheworm)
; Date: 17. January 2004
; OS: Windows
; Demo: No

Procedure Selection_SelectAll(editorgadget)
  range.CHARRANGE\cpMin = 0 
  range\cpMax = -1 
  ProcedureReturn SendMessage_(GadgetID(editorgadget),#EM_EXSETSEL,0,@range) 
EndProcedure

OpenWindow(0,0,0,300,230,"EditorGadget - Select all",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  EditorGadget(0,5,5,290,190) 
  For a=0 To 5 
    AddGadgetItem(0,a,"Line "+Str(a)) 
  Next 
  ButtonGadget(1,5,200,100,20,"Select all") 
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1: Selection_SelectAll(0)
      EndSelect 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
