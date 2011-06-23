; German forum: http://www.purebasic.fr/german/viewtopic.php?t=212&highlight=
; Author: NicTheQuick
; Date: 21. September 2004
; OS: Windows, Linux
; Demo: Yes


; all float variables will be extended to at least 4 leading chars
Procedure.s StrF_Ex(Float.f) 
  Protected Result.s, n.l 
  
  Result = RSet(StrF(Float, 2), 7, "0") 
  
  ProcedureReturn Result 
EndProcedure 

Debug StrF_Ex(12.4) 
Debug StrF_Ex(1234) 
Debug StrF_Ex(0.133) 
Debug StrF_Ex(0) 
Debug StrF_Ex(1234.56)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -