; English forum: 
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 17. September 2002
; OS: Windows
; Demo: Yes


Procedure IsDateValid(d,m,y)
  ; By PB (feel free to use in any way you wish).
  v=1 : d1=1 : m1=1 : y1=1 ; 1=Valid, 0=Invalid.
  If d<1 Or d>31
    d1=0 ; Day must be 1-31.
  ElseIf m<1 Or m>12
    m1=0 ; Month must be 1-12.
  ElseIf m=2 And d>28
    If d>29
      d1=0 ; February never has more than 29 days.
    Else
      ; Check if February of the year "y" is a Leap Year.  Note that the year
      ; 3600 is a one-off special case (www.google.com/search?q=leap+year+faq).
      d1=(y%4=0 And (y%100<>0 Or y%400=0) And y<>3600) ; %=Modulo
    EndIf
  ElseIf (m=4 Or m=6 Or m=9 Or m=11) And d=31
    d1=0 ; These months have only 30 days.
  ElseIf y<1900 Or y>2200
    y1=0 ; limit year to 300 year range
  EndIf
  If d1=0
    MessageRequester("Error","Invalid day in date!",0)
    v=0
  ElseIf m1=0
    MessageRequester("Error","Invalid month in date!",0)
    v=0
  ElseIf y1=0
    MessageRequester("Error","Invalid year in date!",0)
    v=0
  EndIf  
  ProcedureReturn v
EndProcedure
;
Debug IsDateValid(99,5,2002) ; Returns 0 (no month has >31 days).
Debug IsDateValid(20,5,2002) ; Returns 1 (this is a valid date).
Debug IsDateValid(31,6,2002) ; Returns 0 (June has only 30 days).
Debug IsDateValid(29,2,2000) ; Returns 1 (2000 is a Leap Year).
Debug IsDateValid(29,2,2002) ; Returns 0 (2002 isn't a Leap Year).
Debug IsDateValid(29,2,3600) ; Returns 0 (3600 isn't a Leap Year).

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -