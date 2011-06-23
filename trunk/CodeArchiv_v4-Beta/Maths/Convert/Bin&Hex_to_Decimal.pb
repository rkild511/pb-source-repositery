; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=274&highlight=
; Author: GPI
; Date: 02. September 2003
; OS: Windows
; Demo: Yes

Procedure BinVal(a$); - Convert a String in binary-format in numeric value 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='%' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  Result=0 
  *adr.Byte=@a$ 
  For i=1 To Len(a$) 
    Result<<1 
    Select *adr\b 
      Case '0' 
      Case '1':Result+1 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn Result 
EndProcedure 

Procedure HexVal(a$); - Convert a String in hexdecimal-format in numeric value 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='$' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  Result=0 
  *adr.Byte=@a$ 
  For i=1 To Len(a$) 
    Result<<4 
    Select *adr\b 
      Case '0' 
      Case '1':Result+1 
      Case '2':Result+2 
      Case '3':Result+3 
      Case '4':Result+4 
      Case '5':Result+5 
      Case '6':Result+6 
      Case '7':Result+7 
      Case '8':Result+8 
      Case '9':Result+9 
      Case 'A':Result+10 
      Case 'B':Result+11 
      Case 'C':Result+12 
      Case 'D':Result+13 
      Case 'E':Result+14 
      Case 'F':Result+15 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn Result 
EndProcedure

; Demo:
Debug BinVal("%10010011")
Debug HexVal("$12E")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
