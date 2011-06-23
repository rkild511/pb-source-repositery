; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=29764#29764
; Author: remi_meier / Topsoft (updated for PB 4.00 by Andre)
; Date: 08. February 2004
; OS: Windows
; Demo: Yes

Procedure XorAsm(*ptrText, TextLen.l, *ptrKeyMin, *ptrKeyMax) 
  MOV Ebx, *ptrKeyMin  ;keyptr in Ebx 
  MOV Ecx, TextLen      ;l�nge des textes in Ecx f�r loop 
  MOV Esi, *ptrText      ;textptr in esi als source 
  MOV Edi, *ptrText      ;textptr in edi als destination 
  CLD                         ;stringfunk. von links nach rechts! 
  !l_S1:                      ;start von loop 
    !LODSb                  ;1.byte von source nach al 
    MOV ah, [Ebx]        ;byte von key nach ah 
    INC Ebx                 ;keyptr um 1 erh�hen 
    !XOR al, ah             ;XOR in al 
    !stosb                   ;al in text speichern 
    CMP Ebx, *ptrKeyMax ;wenn keyl�nge erreicht: 
    JNA l_W1              ;springe zu W1 wenn nicht gr�sser 
    MOV Ebx, *ptrKeyMin ;sonst ebx wieder auf 0 
    !l_W1:              
    DEC Ecx                ;counter decrementieren 
  JNZ l_S1                 ;falls ecx<>0 nach S1 springen 
EndProcedure 

Text.s = "warum funktionierts nicht???" 
TextLen.l = Len(Text) 
key.s = "subsubsubsubsubsub" 

XorAsm(@Text, TextLen, @key, @key + Len(key) - 1) 
Debug Text 
XorAsm(@Text, TextLen, @key, @key + Len(key) - 1) 
Debug Text 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm