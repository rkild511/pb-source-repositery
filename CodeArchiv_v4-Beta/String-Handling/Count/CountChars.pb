; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7215&highlight=
; Author: Psychophanta
; Date: 13. August 2003
; OS: Windows
; Demo: Yes

; Counts the occurrences of a string inside another string
; Ermittelt, wie oft ein String in einem anderen String vorkommt

Procedure.l CountChars(a.s,s.s) 
  !mov edi,dword[esp]    ;pointer to the first character in string (first function parameter) 
  ;firstly we must found the lenght of the string: 
  !cld              ;clear DF (Direction Flag). Could be not necessary. 
  !xor al,al       ;set NULL character in AL register 
  !xor ebx,ebx  ;init counter 
  !mov ecx,ebx    ;lets set 4294967295 ($FFFFFFFF) characters maximum 
  !dec ecx 
  !repnz scasb    ;repeat comparing AL CPU register content with [edi] 
  !jecxz go    ;if NULL byte is not found within those 4294967295 characters then exit giving 0 
  !not ecx     ;else, some adjusts. Now we have the lenght at ecx register 
  !mov edi,dword[esp]     ;point again to the first character in string (first function parameter) 
  !mov eax,dword[esp+4] 
  !mov al,byte[eax]    ;al=character to find 
  !@@:REPNZ scasb   ;repeat comparing AL CPU register content with [edi] 
  !jecxz go     ;until ecx value is reached 
  !inc ebx       ;or a match is found 
  !jmp @r       ;continue comparing next character 
  !go:MOV eax,ebx   ;output the matches counter 
  ProcedureReturn 
EndProcedure 

;- Example 1
st.s="asfhaisu f78a.wetr.q8 fsa su.f789 ay " 
ch.s="." 
MessageRequester("",Str(CountChars(st,ch)),0)


;- Example 2  (by Karbon, from here: http://purebasic.myforums.net/viewtopic.php?t=7240&highlight=)
my_string.s = "this is the string I want to split" 

num_occurances.l = CountChars(my_string," ") 

Dim a_explode.s(num_occurances) 

For counter = 0 To num_occurances 
  
   ; 
   ; StringField indexes start at 1, not zero.. That's the reason for the +1 
   ; 
    new_string.s = StringField(my_string, counter + 1, " ") 
    
    a_explode(counter) = new_string 
    
Next 

For counter = 0 To num_occurances 

  Debug a_explode(counter) 
    
Next 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
