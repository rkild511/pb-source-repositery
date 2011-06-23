; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1396&highlight=
; Author: Stefan Moebius (updated for PB 4.00 by Deeem2031)
; Date: 18. June 2003
; OS: Windows
; Demo: Yes


; Beispiel wie man Speicher füllen kann .
; Example for filling memory

Procedure MemLFill(Adr,AnzBytes,Dword.l)
  !PUSH Edi
  !CLD
  !MOV Edi,[p.v_Adr+4]
  !MOV Eax,[p.v_Dword+4]
  !MOV Ecx,[p.v_AnzBytes+4]
  !SHR Ecx,2
  !REP STOSD
  !POP Edi
EndProcedure


Procedure MemWFill(Adr,AnzBytes,Word.w)
  !PUSH Edi
  !CLD
  !MOV Edi,[p.v_Adr+4]

  !MOV AX,[p.v_Word+4]
  !SHL Eax,16
  !MOV AX,[p.v_Word+4]

  !MOV Ecx,[p.v_AnzBytes+4]
  !MOV Edx, Ecx
  !AND Edx, 0x00000003
  !SHR Ecx,2

  !REP STOSD
  !CMP Edx,0
  !JE EndeW

  !MOV Ecx,Edx
  !SHR Ecx,1
  !REP STOSW
  !EndeW:
  !POP Edi
EndProcedure


Procedure MemBFill(Adr,AnzBytes,Byt.b)
  !PUSH Edi
  !CLD
  !MOV Edi,[p.v_Adr+4]

  !MOV AL,[p.v_Byt+4]
  !SHL Eax,8
  !MOV AL,[p.v_Byt+4]
  !SHL Eax,8
  !MOV AL,[p.v_Byt+4]
  !SHL Eax,8
  !MOV AL,[p.v_Byt+4]

  !MOV Ecx,[p.v_AnzBytes+4]
  !MOV Edx, Ecx
  !AND Edx, 0x00000003
  !SHR Ecx,2

  !REP STOSD
  !CMP Edx,0
  !JE EndeB

  !MOV Ecx,Edx
  !REP STOSB
  !EndeB:
  !POP Edi
EndProcedure





;#################################### TEST ####################################
A$="####"


MemBFill(@A$,4,$50)
Debug A$
MemWFill(@A$,4,$7170)
Debug A$
MemLFill(@A$,4,$80808080)
Debug A$

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -