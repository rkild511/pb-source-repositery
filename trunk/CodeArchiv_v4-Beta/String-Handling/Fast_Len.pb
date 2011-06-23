; http://www.purebasic-lounge.de
; Author: Hellhound66
; Date: 06. October 2006
; OS: Windows
; Demo: Yes


; Note: This ASM code is especially faster on AMD processors. On Pentium (IV)
;       often the original PB Len() is the fastest function.

; Hinweis: Dieser ASM-Code ist insbesondere schneller auf AMD-Prozessoren. Auf
;          Pentium (IV) ist oftmals das originale PB Len() die schnellste Funktion.

DisableDebugger
Prototype HellLen(UserString.s)
Global HellLen.HellLen

Goto __JUMPOVER
__HellLen:
!PUSH Edi
!PUSH Ecx
!MOV Edi,[Esp+12]
!XOR Ecx,Ecx
!XOR Ebx,Ebx
!__OUTERLOOP:
!MOV Eax,dword[Edi]
!TEST Eax,255
!JZ __FINISHED
!INC Ecx
!TEST Eax,65280
!JZ __FINISHED
!INC Ecx
!SHR Eax,16
!TEST Eax,255
!JZ __FINISHED
!INC Ecx
!TEST Eax,65280
!JZ __FINISHED
!INC Ecx
!ADD Edi,4
!JMP __OUTERLOOP
!__FINISHED:
!MOV Eax,Ecx
!POP Ecx
!POP Edi
!RET 4
__JUMPOVER:

HellLen = ?__HellLen

Delay(100)
string.s = "Ich bin ein fieser Teststring"
TestZeit.l  = ElapsedMilliseconds()
For i=1 To 10000000
  HellLen(string)
Next
Zeit1 = ElapsedMilliseconds()-TestZeit

TestZeit.l  = ElapsedMilliseconds()
For i=1 To 10000000
  lstrlen_(string)
Next
Zeit2 = ElapsedMilliseconds()-TestZeit

TestZeit.l  = ElapsedMilliseconds()
For i=1 To 10000000
  Len(string)
Next
Zeit3 = ElapsedMilliseconds()-TestZeit


MessageRequester("Ergebnis","Es wurden je 10000000 Aufrufe gestartet"+#CRLF$+"Hellhound66 : "+Str(Zeit1)+" ms."+#CRLF$+"WinAPI brauchte : "+Str(Zeit2)+" ms."+#CRLF$+"PB brauchte : "+Str(Zeit3)+" ms."+#CRLF$,#PB_MessageRequester_Ok)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -