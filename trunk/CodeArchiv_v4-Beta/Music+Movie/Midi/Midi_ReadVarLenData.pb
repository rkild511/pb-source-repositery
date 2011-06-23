; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8639&highlight=
; Author: einander (updated for PB3.93 by ts-soft)
; Date: 07. December 2003
; OS: Windows
; Demo: Yes

; Here is another one, more musical focused, to read byte streams, and getting
; the pointer position for MIDIfile parsing.

; ReadVarLenData

Global Forward.l ; keeps pointer positiono
Procedure BSet(A, N) ; Sets the N bit
  ProcedureReturn A | 1 << N
EndProcedure

Procedure BClR(A, N) ; Clears the N bit
  ProcedureReturn BSet(A, N) ! BSet(0, N)
EndProcedure

Procedure BTST(A, N) ; Returns state of N bit
  If A & BClR(A, N) = A : ProcedureReturn 0 : EndIf
  ProcedureReturn 1
EndProcedure

Procedure Bin_Dec(bin$) ; Binary to decimal
  Le = Len(bin$)
  For i = 0 To Le-1
    A = Val(Mid(bin$, Le - i, 1))
    If A = 1
      b + Pow(2, i)
    EndIf
  Next
  ProcedureReturn(b)
EndProcedure

Procedure ReadVarLenData(PO) ;' ' returns value ot the Variable Length found from PO - keeps in Forward the number of  bytes in  VarLen
  Repeat
    PokeB(@by,PeekB(PO)& $FF)
    PO +1
    a$=RSet(Bin(by),8,"0")   ; very bad use of strings, sure Psycho found a better way...
    c$ + Mid(a$,2,Len(a$))
  Until BTST(by,7) = 0
  Forward=PO ; New pointer position
  ProcedureReturn Bin_Dec(c$)
EndProcedure

; TESTING ==============================
PO=AllocateMemory(30)
; Some Variable Length with defferent number of bytes, to test
; Pointer gets the new value from Forward
PokeB(PO,$FF) : PokeB(PO+1,$FF) :PokeB(PO+2,$FF) : PokeB(PO+3,$7F)
PokeB(PO+4,$C0) :PokeB(PO+5,$80) : PokeB(PO+6,$80) : PokeB(PO+7,$00)
PokeB(PO+8,$81) : PokeB(PO+9,$80) : PokeB(PO+10,$80) :PokeB(PO+11,$00)
PokeB(PO+12,$FF) : PokeB(PO+13,$FF) : PokeB(PO+14,$7F)
PokeB(PO+15,$C0) : PokeB(PO+16,$80) : PokeB(PO+17,$00)
PokeB(PO+18,$81) : PokeB(PO+19,$80) : PokeB(PO+20,$00)
PokeB(PO+21,$FF) : PokeB(PO+22,$7F)
PokeB(PO+23,$C0) : PokeB(PO+24,$00)
PokeB(PO+25,$81) : PokeB(PO+26,$00)
PokeB(PO+27,$7F) : PokeB(PO+28,$40)
PokeB(PO+29,$00)

p=PO
Repeat
  Debug Hex(ReadVarLenData(PO)) +" -- "+Str(Forward-PO)+" Bytes forward"
  PO=Forward
Until PO>=p+30

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
