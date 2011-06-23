; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2868&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 01. December 2003
; OS: Windows
; Demo: No

Procedure InsertEditorText(gadget,Text$) 
  ProcedureReturn SendMessage_(GadgetID(gadget),#EM_REPLACESEL,0,Text$) 
EndProcedure 

EOL.s = Chr(13)+Chr(10) 

OpenWindow(0,0,0,300,330,"Insert",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  EditorGadget(0,5,5,290,290) 
   InsertEditorText(0,"Line 1"+EOL) 
   InsertEditorText(0,"Line 2"+EOL) 
   InsertEditorText(0,"Line 3") 
  ButtonGadget(1,5,300,100,20,"Insert 'xyz'") 
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1: InsertEditorText(0,"xyz") 
      EndSelect 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
