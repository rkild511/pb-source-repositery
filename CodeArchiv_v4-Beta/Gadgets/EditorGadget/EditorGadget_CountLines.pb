; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1920&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 05. August 2003
; OS: Windows
; Demo: No

Procedure PrintToEditorGadget(Gadget,Text.s) 
  AddGadgetItem(Gadget,-1,Text) 
  SendMessage_(GadgetID(Gadget),#EM_LINESCROLL,0,1) 
EndProcedure 


OpenWindow(1,200,200,300,200,"EditorGadget",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  EditorGadget(1,5,5,290,190) 
  
  PrintToEditorGadget(1,"Hallo!") 
  PrintToEditorGadget(1,"") 
  PrintToEditorGadget(1,"Das ist ein Test...") 
  PrintToEditorGadget(1,"...welcher Text im EditorGadget ausgibt.") 

  SetWindowText_(WindowID(1),"EditorGadget hat "+Str(CountGadgetItems(1))+" Zeilen") 

Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
