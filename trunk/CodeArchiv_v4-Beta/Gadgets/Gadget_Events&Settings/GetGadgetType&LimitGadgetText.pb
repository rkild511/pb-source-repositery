; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2840&highlight=
; Author: FGK
; Date: 05. April 2005
; OS: Windows
; Demo: No



; IMPORTANT NOTE by Andre:
; Instead of the GetGadgetType() procedure there is now a native
; PB command called GadgetType() available with PB v4!

; Hab mir ne Proc gebastelt mit der man den Typ einer übergeben 
; GadgetID ermitteln kann. Ist nützlich wenn man in ner Routine 
; unterschiedlich auf Gadgets reagiern will oder überprüfen muß 
; ob ein geeignetes Gadget übergeben wurde. 
; 
Procedure.s GetGadgetType(Gadget.l) 
  Buffer.s = Space(256):len=255 
  GetClassName_(GadgetID(Gadget),@Buffer,@len) 
  Debug Buffer 
  ProcedureReturn Buffer 
EndProcedure 



; Note by Andre:
; Reworked the procedure to use the native GadgetType() command now.

; In diesem Beispiel kann man der Proc "LimitGadgetText" 
; wahlweise ein StringGadgetID oder CombogadgetID übergeben, 
; dessen Eingabelänge dann begrenzt wird. Kann für viele Aufgaben 
; nützlich sein zu wissen um welche Gadgetart es sich handelt. 
; 
Procedure LimitGadgetText(Gadget.l,MaxLen.l) 
  Select GadgetType(Gadget) 
    Case #PB_GadgetType_Editor, #PB_GadgetType_String
      SendMessage_(GadgetID(Gadget),#EM_LIMITTEXT,MaxLen,0) 
    Case #PB_GadgetType_ComboBox 
      SendMessage_(GadgetID(Gadget),#CB_LIMITTEXT,MaxLen,0) 
  EndSelect 
EndProcedure 

; original procedure
; Procedure LimitGadgetText(Gadget.l,MaxLen.l) 
;   Select GetGadgetType(Gadget) 
;     Case "Edit"  
;       SendMessage_(GadgetID(Gadget),#EM_LIMITTEXT,MaxLen,0) 
;     Case "ComboBox" 
;       SendMessage_(GadgetID(Gadget),#CB_LIMITTEXT,MaxLen,0) 
;   EndSelect 
; EndProcedure 

 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -