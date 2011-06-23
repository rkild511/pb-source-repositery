; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1953&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 08. August 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 08.08.2003 - german forum 
; 
Procedure EditorGadgetCursorX(Gadget) 
  ; returns X-Pos of Cursor 
  REG = GadgetID(Gadget) 
  SendMessage_(REG,#EM_EXGETSEL,0,Range.CHARRANGE) 
  ProcedureReturn (Range\cpMax-(SendMessage_(REG,#EM_LINEINDEX,SendMessage_(REG,#EM_EXLINEFROMCHAR,0,Range\cpMin),0))+1) 
EndProcedure 

Procedure EditorGadgetCursorY(Gadget) 
  ; returns Y-Pos of Cursor 
  REG = GadgetID(Gadget) 
  SendMessage_(REG,#EM_EXGETSEL,0,Range.CHARRANGE) 
  ProcedureReturn SendMessage_(REG,#EM_EXLINEFROMCHAR,0,Range\cpMin)+1 
EndProcedure 

Procedure EditorGadgetCursorPos(Gadget) 
  ; returns relative Position of Cursor 
  SendMessage_(GadgetID(Gadget),#EM_EXGETSEL,0,Range.CHARRANGE) 
  ProcedureReturn Range\cpMax 
EndProcedure 

Procedure EditorGadgetLocate(Gadget,x,y) 
  ; Set cursor position 
  REG = GadgetID(Gadget) 
  CharIdx = SendMessage_(REG,#EM_LINEINDEX,y-1,0) 
  LLength = SendMessage_(REG,#EM_LINELENGTH,CharIdx,0) 
  If LLength >= x-1 
    CharIdx + x-1 
  EndIf 
  Range.CHARRANGE 
  Range\cpMin = CharIdx 
  Range\cpMax = CharIdx 
  SendMessage_(REG,#EM_EXSETSEL,0,Range) 
EndProcedure 



OpenWindow(1,200,200,300,200,"EditorGadget",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  EditorGadget(1,5,5,290,190) 
  
  AddGadgetItem(1,-1,"Hallo!") 
  AddGadgetItem(1,-1,"") 
  AddGadgetItem(1,-1,"Hier ein paar Proceduren") 
  AddGadgetItem(1,-1,"zur Steuerung des Cursors") 
  AddGadgetItem(1,-1,"im EditorGadget.") 

  EditorGadgetLocate(1,7,2) 

  SetActiveGadget(1) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
  EndSelect 
  SetWindowText_(WindowID(1),"X: "+Str(EditorGadgetCursorX(1))+" Y: "+Str(EditorGadgetCursorY(1))+" -- Position: "+Str(EditorGadgetCursorPos(1))) 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
