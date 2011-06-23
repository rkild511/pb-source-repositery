; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7716
; Author: freak
; Date: 30. September 2003
; OS: Windows
; Demo: No


; This procedure let's you include a RTF file with IncludeBinary, and then 
; directly catch it, and load it into an EditorGadget. 

; Usefull if you want to make a static Text box, with nicely formated text
; for example. 

;- Code: 
; Usage: 
; CatchRTF(#EditorGadget, MemoryAddress) 
; 
; Streams a RTF file included by IncludeBinary directly into an EditorGadget. 
; 
; 
Procedure.l CatchRTF_Callback(dwCookie.l, pbBuff.l, cb.l, *pcb.LONG) 
  Shared CatchRTF_Address.l 
  CopyMemory(CatchRTF_Address, pbBuff, cb) 
  CatchRTF_Address + cb 
  *pcb\l = cb 
  ProcedureReturn 0 
EndProcedure 
; 
Procedure CatchRTF(Gadget.l, MemoryAddress.l) 
  Shared CatchRTF_Address.l 
  CatchRTF_Address = MemoryAddress 
  stream.EDITSTREAM\pfnCallback = @CatchRTF_Callback() 
  SendMessage_(GadgetID(Gadget), #EM_STREAMIN, #SF_RTF, @stream) 
EndProcedure    

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
