; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7215&start=15
; Author: Psychophanta
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

Procedure.l CountStrings(a.s,s.s) 
  !cld          ;clear DF (Direction Flag) 
  !mov edi,dword[esp]   ;load edi register with pointer to first string 
  !mov esi,dword[esp+4] ;load esi register with pointer to second string (the string to search) 
  !xor eax,eax    ;set eax register to NULL 
  !mov bl,al      ;set bl register to NULL 
  !mov edx,esi  ;save this value in edx to avoid, as much as possible, to have to read data from memory in the main loop. 
  !;If any of two strings is empty then end program and matches found is 0: 
  !cmp byte[esi],bl  ;test if second string is empty 
  !jz fin           ;if so, then end 
  !;Main loop: 
  !mainloop: 
  !cmp byte[edi],bl  ;check if end of first string is reached 
  !jz fin   ;if not reached then end 
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
  !@@:inc eax    ;increment complete matches counter 
  !jmp mainloop   ;lets search for another possible complete match! 
  !fin: 
  ProcedureReturn 
EndProcedure 
;Grrr!: Z-80 had conditional CALL, Ix86 doesn't !? 
a$="ureruPururePe ruPurePurPuPure uresdfhg ureeurPeruPuruee sPuuredil hPPPrtur eurePuree urePurePur" 
b$="abcdeaaa" 
c.s="Pur":PokeB(@c+3,0):PokeB(@c+4,Asc("e")):PokeB(@c+5,0) 
d$="a" 
MessageRequester("Should be 1",Str(CountStrings(PeekS(@c+4),"e")),0) 
MessageRequester("Should be 1",Str(CountStrings(c,"Pur")),0) 
MessageRequester("Should be 0",Str(CountStrings(c,"Pure")),0) 
MessageRequester("Should be 1",Str(CountStrings(a$,"PPr")),0) 
MessageRequester("Should be 4",Str(CountStrings(b$,"a")),0) 
MessageRequester("Should be 1",Str(CountStrings(d$,"a")),0) 
MessageRequester("Should be 0",Str(CountStrings(d$,"aa")),0) 
MessageRequester("Should be 1",Str(CountStrings(b$,"aa")),0) 
MessageRequester("Should be 4",Str(CountStrings(a$,"Pure")),0) 


;Can use function input parameters as normal pointers: 
;Procedure.l CountStrings(*a,*s) 
;but then you have to call function using pointers too: 
;CountStrings(@a$,@"Pure")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
