; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3181&highlight=
; Author: Danilo
; Date: 19. December 2003
; OS: Windows
; Demo: Yes

; 
; by Danilo, 15.12.2003 - english chat 
; 
Procedure RotL(num,count) ; rotate left 
  If count>0 And count<32 
    !MOV dword ECX,[ESP+4] 
    !ROL dword [ESP],cl 
  EndIf 
  ProcedureReturn num 
EndProcedure 

Procedure RotR(num,count) ; rotate right 
  If count>0 And count<32 
    !MOV dword ECX,[ESP+4] 
    !ROR dword [ESP],cl 
  EndIf 
  ProcedureReturn num 
EndProcedure 

Procedure SHR(num,count) ; unsigned shift right 
  If count>0 And count<32 
    !MOV dword ECX,[ESP+4] 
    !SHR dword [ESP],cl 
  EndIf 
  ProcedureReturn num 
EndProcedure 

Procedure SHL(num,count) ; unsigned shift left 
  If count>0 And count<32 
    !MOV dword ECX,[ESP+4] 
    !SHL dword [ESP],cl 
  EndIf 
  ProcedureReturn num 
EndProcedure 


For a = 0 To 31 
  Debug RSet(Bin(RotL(%1000100000000000,a)),32,"0") 
Next a 

For a = 0 To 31 
  Debug RSet(Bin(RotR(%100010000000000,a)),32,"0") 
Next a 

Debug "---" 

For a = 0 To 31 
  Debug RSet(Bin(SHL(%1,a)),32,"0") 
Next a 

For a = 0 To 31 
  Debug RSet(Bin(SHR($80000000,a)),32,"0") 
Next a

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -