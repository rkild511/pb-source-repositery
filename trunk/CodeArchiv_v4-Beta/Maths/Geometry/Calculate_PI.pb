; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8530&highlight=
; Author: akj (updated for PB4.00 by blbltheworm)
; Date: 28. November 2003
; OS: Windows
; Demo: Yes


;PI  AKJ  27-Nov-03 
; Based upon articles in Popular Computing Weekly 
; August 11-17 1988 page 27  and  March 16-22 1989 page 67 

; The result will be output to approximately the number of decimal places requested 
; Initially try 770 decimal places.  The last 8 digits should be 9999 9983 

Declare addbtoa() 
Declare subbfroma() 
Declare divcby25() 
Declare divdby57121() 
Declare divcbyn() 
Declare divdbyn() 

Global d, x, n 

OpenConsole() 
Print("Number of decimal places? ") 
np=Val(Input()) 
If np<4: np=4: EndIf 
PrintN("") 
x=10000 : xw=4 
d=np/xw+2 
; Working registers, each element holding an integer 0..9999 
Global Dim a(d) 
Global Dim b(d) 
Global Dim c(d) 
Global Dim d(d) 
it=(np/Log10(25)+5)/2 ; Number of iterations 
c(1) = 800 : d(1) = 9560 : n=-1 
For j=1 To it 
  n + 2 
  divcby25() 
  divcbyn() 
  addbtoa() 
  divdby57121() 
  divdbyn() 
  subbfroma() 
  n + 2 
  divcby25() 
  divcbyn() 
  subbfroma() 
  divdby57121() 
  divdbyn() 
  addbtoa() 
Next j 
; Print result 
Print("  3.1") 
For i=2 To d-1 
  Print(RSet(Str(a(i)),xw,"0")+" ") 
  If (i%15)=0 
    PrintN("") 
  EndIf 
Next i 
PrintN("") 
PrintN("Press ENTER") 
Input() 
CloseConsole() 
End 


Procedure addbtoa() ; Multi-precision addition 
  c=0 ; Carry 
  For i=d To 1 Step -1 
    s = a(i)+b(i)+c 
    c = s/x 
    a(i) = s%x 
  Next i 
EndProcedure 

Procedure subbfroma() 
  c = 0 
  For i=d To 1 Step -1 
    s = a(i)-b(i)-c 
    If s<0 
      s + x: c = 1 
    Else 
      c=0 
    EndIf 
    a(i) = s%x 
  Next i 
EndProcedure 

Procedure divcby25() 
  r = 0 ; Remainder 
  For i=1 To d 
    c = c(i)+x*r 
    c(i) = c/25 
    r=c%25 
  Next i 
EndProcedure 

Procedure divdby57121() 
  r = 0 
  For i=1 To d 
    c = d(i)+x*r 
    d(i) = c/57121 
    r=c%57121 
  Next i 
EndProcedure 

Procedure divcbyn() 
  ; b()=c()/n 
  r = 0 
  For i=1 To d 
    c = c(i)+x*r 
    b(i) = c/n 
    r=c%n 
  Next i 
EndProcedure 

Procedure divdbyn() 
  ; b()=d()/n 
  r = 0 
  For i=1 To d 
    c = d(i)+x*r 
    b(i) = c/n 
    r=c%n 
  Next i 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
