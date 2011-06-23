; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1423
; Author: GPI
; Date: 19. June 2003
; OS: Windows
; Demo: Yes

; Procedures for converting Binary + Hex values to Decimal

Procedure BinVal(a$) 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='%' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  result=0 
  *adr.byte=@a$ 
  For i=1 To Len(a$) 
    result<<1 
    Select *adr\B 
      Case '0' 
      Case '1':result+1 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn result 
EndProcedure 
Procedure HexVal(a$) 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='$' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  result=0 
  *adr.byte=@a$ 
  For i=1 To Len(a$) 
    result<<4 
    Select *adr\B 
      Case '0' 
      Case '1':result+1 
      Case '2':result+2 
      Case '3':result+3 
      Case '4':result+4 
      Case '5':result+5 
      Case '6':result+6 
      Case '7':result+7 
      Case '8':result+8 
      Case '9':result+9 
      Case 'A':result+10 
      Case 'B':result+11 
      Case 'C':result+12 
      Case 'D':result+13 
      Case 'E':result+14 
      Case 'F':result+15 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn result 
EndProcedure

;- Test
Debug BinVal("100100")
Debug HexVal("46BC")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
