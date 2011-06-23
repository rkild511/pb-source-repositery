; German forum: http://www.purebasicforums.com/german/viewtopic.php?t=384&postdays=0&postorder=asc&start=10
; Author: PureFan 
; Date: 01. April 2005
; OS: Windows
; Demo: Yes

; Convert hexa-decimal numbers into decimal numbers
; It works only with 8 characters long hex strings, but is very fast for them!

; Hexadezimal-Zahlen in Dezimalzahlen umwandeln
; Assembler-Variante, die allerdings nur bei genau 8 Zeichen langen Hex-Strings funktioniert. 
; Da sie ohne Jumps und String-Befehle auskommt ist sie jedoch um einiges schneller! 

Procedure PureFans_Hex2Dec(Value) 
  !POP Edi 
  !PUSH Edi 
  !MOV Ebx,[Edi] 
  !SUB Ebx,030303030h 
  !MOV Eax,Ebx 
  !SHR Eax,4 
  !AND Eax,01010101h 
  !MOV Edx,7 
  !MUL Edx 
  !SUB Ebx,Eax 
  !AND Ebx,0F0F0F0Fh 
  !SHL bl,4 
  !OR bl,bh 
  !ROR Ebx,16 
  !SHL bl,4 
  !OR bh,bl 
  !SHL Ebx,8 
  !XOR bx,bx 
  !MOV Ecx,[Edi+4] 
  !SUB Ecx,030303030h 
  !MOV Eax,Ecx 
  !SHR Eax,4 
  !AND Eax,01010101h 
  !MOV Edx,7 
  !MUL Edx 
  !SUB Ecx,Eax 
  !AND Ecx,0F0F0F0Fh 
  !SHL cl,4 
  !OR cl,ch 
  !ROR Ecx,16 
  !SHL cl,4 
  !OR ch,cl 
  !SHL Ecx,8 
  !XOR cx,cx 
  !SHR Ecx,16 
  !OR Ecx,Ebx 
  !MOV Eax,Ecx 
  ProcedureReturn 
EndProcedure 

Debug Hex(PureFans_Hex2Dec(@"abcdef01")) 
Debug Hex(PureFans_Hex2Dec(@"ABCDEF01")) 
Debug Hex(PureFans_Hex2Dec(@"01234567")) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -