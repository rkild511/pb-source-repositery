; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8676&highlight=
; Author: Danilo (updated for PB 4.00 by Deeem2031)
; Date: 11. December 2003
; OS: Windows
; Demo: Yes

; Important note: starting with PureBasic v4 it supports Doubles and Quads natively,
; so this example is only for demonstration!

Procedure Your_Function_That_Returns_Double() 
  !FLDPI 
EndProcedure 

Procedure.f CatchDoubleReturn(*x.DOUBLE) 
  !MOV  dword EAX,[p.p_x] 
  !FST  qword [EAX] 
  ProcedureReturn 
EndProcedure 

Procedure.f Double2Float(*x.DOUBLE) 
  !MOV  dword EAX,[p.p_x] 
  !FLD  qword [EAX] 
  ProcedureReturn 
EndProcedure 

; Call your function 
CallFunctionFast(@Your_Function_That_Returns_Double()) ; call DLL function 
Debug CatchDoubleReturn(my.DOUBLE) 

; now our double is in 'my' 
; PB cant handle doubles directly, so 
; lets convert it to float 
Debug Double2Float(my)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
