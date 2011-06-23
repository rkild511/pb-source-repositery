; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8267&highlight= 
; Author: freak (updated for PB 4.00 by Deeem2031)
; Date: 09. November 2003 
; OS: Windows
; Demo: Yes

; ArrayMemorySize() shows the real size in memory. 
Procedure.l ArrayMemorySize(*Array) 
  !push dword [p.p_Array] 
  !sub dword [Esp], 20 
  !push dword 0 
  !push dword [PB_MemoryBase] 
  !call _HeapSize@12 
  ProcedureReturn 
  HeapSize_(0, 0, 0) ; make sure, _HeapSize@12 is defined 
EndProcedure 

; ArraySize() shows the total number of elements. 
Procedure ArraySize(*Array) 
  ProcedureReturn PeekL(*Array-8) 
EndProcedure 

Dim Array.l(50) 

Debug ArrayMemorySize(@Array()) 
Debug ArraySize(@Array()) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
