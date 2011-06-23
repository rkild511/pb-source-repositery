; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8118&highlight=
; Author: Psychophanta
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

; Function similar to FindString(), but this one returns the position of the
; last string found (starting searching from most right side to left side) 

Procedure.l RFindString(a.s,s.s) 
  !cld          ;clear DF (Direction Flag) 
  !mov edi,dword[esp]   ;load edi register with pointer to first string 
  !mov esi,dword[esp+4] ;load esi register with pointer to second string (the string to search) 
  !xor eax,eax    ;set eax register to NULL 
  !mov ebx,eax      ;set ebx register to NULL 
  !mov edx,esi  ;save this value in edx to avoid, as much as possible, to have to read data from memory in the main loop. 
  !;If any of two strings is empty then end program and matches found is 0: 
  !cmp byte[esi],bl  ;test if second string is empty 
  !jz go           ;if so, then end 
  !mainloop: 
  !cmp byte[edi],bl  ;check if end of first string is reached 
  !jz go   ;if not reached then end 
  !mov esi,edx  ;restore this 
  !cmpsb  ;what this instruction do is just compare byte[edi] with byte[esi] and increment edi and esi values by 1 
  !jnz mainloop ;if byte[edi]=byte[esi] then goto match label, because a match byte was found... 
  !;match: ;here we have got inside a second treatment: We are in a possible total match, lets see if it is a complete match or it is a fake: 
  !mov ecx,edi ;save this position 
  !@@: 
  !cmp byte[esi],bl  ;check if end of second string is reached 
  !jz @f   ;if so, here was a complete match 
  !cmpsb   ;compare one more byte 
  !jz @r   ;if equal, lets see if the deceit continues, or rather it could be a real complete match. 
  !mov edi,ecx  ;ohhh! it was a deceit! Restore this 
  !jmp mainloop ;What a patient! lets continue searching for another possible match and why not, a possible complete match... 
  !;complete match was found: 
  !@@:mov eax,ecx    ;capture position 
  !jmp mainloop   ;lets search for another possible complete match! 
  !go:cmp eax,ebx ;Check if there was any 
  !jz @f  ;if not then exit and return 0 
  !sub eax,dword[esp] ;some adjust 
  !@@: 
  ProcedureReturn 
EndProcedure 
;Grrr!: Z-80 has conditional CALL, Ix86 doesn't !? 

a$="PurePure" 
MessageRequester("Should be 9",Str(RFindString(a$+a$,a$)),0) 
MessageRequester("Should be 1",Str(RFindString(a$,"PurePure")),0) 
MessageRequester("Should be 7",Str(RFindString("asdfas"+a$,"PureP")),0) 
MessageRequester("Should be 12",Str(RFindString("asdfs"+a$,"r")),0) 

;Can use function input parameters as normal pointers: 
;Procedure.l RFindString(*a,*s) 
;but then you have to call function using pointers too: 
;RFindString(@a$,@"Pure") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
