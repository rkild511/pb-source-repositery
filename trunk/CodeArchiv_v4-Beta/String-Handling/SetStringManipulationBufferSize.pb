; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7853&start=15
; Author: Fred
; Date: 03. November 2003
; OS: Windows
; Demo: 

; 64k limit was just a limit easy to remember.
; If you want more string buffer, just use the following code... 

Procedure SetStringManipulationBufferSize(Size) 

  PBStringBase.l = 0 
  PBMemoryBase.l = 0 
  
  !MOV eax, dword [PB_StringBase] 
  !MOV [esp+4],eax 
  !MOV eax, dword [PB_MemoryBase] 
  !MOV [esp+8],eax 
  
  HeapReAlloc_(PBMemoryBase, #GMEM_ZEROINIT, PBStringBase, Size) 
  
  !MOV dword [_PB_StringBase],eax 
  
EndProcedure 

; Set the buffer to 1 100 000 bytes... 
; 
SetStringManipulationBufferSize(1100000) ; 1,1 Mb for our strings... 


; And prove it ! 
; 

For k=0 To 10000 
  a$ + "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789" 
Next 

Debug Len(a$) 

; ExecutableFormat=Windows
; EnableAsm
; EOF
