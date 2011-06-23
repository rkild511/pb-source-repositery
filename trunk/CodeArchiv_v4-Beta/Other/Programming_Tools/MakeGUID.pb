; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2499&highlight=
; Author: Danilo (additional procedure by Andreas, updated for PB 4.00 by Andre)
; Date: 09. October 2003
; OS: Windows
; Demo: No


; Global Unique IDentifier, z.B.: 
; {451C5C80-7FA2-AD66-1ABF-DFA8F691CAF3} 

; Structure _GUID 
;   Data1.l 
;   Data2.w 
;   Data3.w 
;   Data4.b[8] 
; EndStructure 

; Ok, here follow the procedures, both do the same. Only one of them is needed.

; Danilo's version...
Procedure.s MakeGUID() 
  CoCreateGuid_(ID.GUID) 
  A$ = "{"+RSet(Hex(ID\Data1),8,"0") 
  A$ + "-"+RSet(Hex(ID\Data2 & $FFFF),4,"0") 
  A$ + "-"+RSet(Hex(ID\Data3 & $FFFF),4,"0") 
  A$ + "-"+RSet(Hex(ID\Data4[0] & $FF),2,"0") 
  A$ +     RSet(Hex(ID\Data4[1] & $FF),2,"0") 
  A$ + "-" 
  For a = 2 To 7 
    A$ + RSet(Hex(ID\Data4[a] & $FF),2,"0") 
  Next a 
  A$ + "}" 
  ProcedureReturn A$ 
EndProcedure 

; Andreas version... 
Procedure.s MakeGUID1() 
  LBuffer.s = Space(76) 
  SBuffer.s = Space(38) 
  CoCreateGuid_(GuidId.GUID) 
  StringFromGUID2_(GuidId,LBuffer,76); 
  WideCharToMultiByte_(0,0,LBuffer,76,SBuffer,38,0,0); 
  ProcedureReturn SBuffer 
EndProcedure 


OpenWindow(0,0,0,400,70,"GUID Generator",#PB_Window_TitleBar|#PB_Window_WindowCentered) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1, 10,10,185,20,"Generate!") 
  ButtonGadget(2,205,10,185,20,"Quit") 
  SetGadgetFont(#PB_Default,LoadFont(0,"Lucida Console",12)) 
  StringGadget(3,  5,40,390,22,"",#PB_String_ReadOnly) 
  
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 
          SetGadgetText(3,MakeGUID()) 
        Case 2 
          End 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
