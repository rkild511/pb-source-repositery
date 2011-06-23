; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9285&highlight=
; Author: blueznl
; Date: 25. January 2004
; OS: Windows, Linux
; Demo: Yes


; x_val() whatever to dec procedure

Procedure.l x_val(string.s) 
  Global x_val_type.l 
  Protected p,l,b,t,c 
  ; 
  ; *** as normal val() except it accepts also &H &O &0 &B % \ $ 0X 
  ; 
  string = UCase(Trim(string)) 
  l = Len(string) 
  t = 0 
  ; 
  If Left(string,1) = "$" 
    p = 1 
    b = 16 
  ElseIf Left(string,1) = "%" 
    p = 1 
    b = 2 
  ElseIf Left(string,1) = "\" 
    p = 1 
    b = 8 
  ElseIf Left(string,1) = "&B" 
    p = 2 
    b = 2 
  ElseIf Left(string,1) = "&O" 
    p = 2 
    b = 8 
  ElseIf Left(string,1) = "&0" 
    p = 2 
    b = 8 
  ElseIf Left(string,2) = "&H" 
    p = 2 
    b = 16 
  ElseIf Left(string,2) = "0X" 
    p = 2 
    b = 16 
  ; 
  ; ElseIf Left(string,1) = "0"           ; i don't like this one, as i often use 
  ;    p = 1                              ; preceding zeroes in front of decimals while 
  ;    b = 8                              ; c(++) would turn those into octals... brrr... 
  ;                                       ; well, it's up to you to uncomment these lines 
  Else 
    p = 0 
    b = 10 
  EndIf 
  ; 
  While p < l 
    p = p+1 
    c = Asc(Mid(string,p,1))-48 
    If c > 9 
      c = c - 7 
    EndIf 
    If c >= 0 And c < b 
      t = t*b+c 
    Else 
      l = p 
    EndIf 
  Wend 
  x_val_type = b 
  ; 
  ProcedureReturn t 
EndProcedure 


Debug x_val("%101100") 
Debug x_val("$AABBEE") 
Debug x_val("101100") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -