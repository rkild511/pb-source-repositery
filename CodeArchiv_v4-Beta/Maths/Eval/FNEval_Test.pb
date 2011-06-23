; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8059&highlight=
; Author: tejon
; Date: 26. October 2003
; OS: Windows
; Demo: Yes

IncludeFile "FnEval.pb" 

; Some examples of valid expression...
; x$=eval("#pi/4") ;x$ now holds "7.85398163397448309e-1" 
; x$=eval("#e") ;x$ = "2.718281828459045" 
; x$=eval("a=(1/2)!") ; x$ = "8.86226925452758013e-1" also "a" holds "8.86226925452758013e-1" 
; x$=eval("a^2*4") ; = "3.14159265358979324" 

OpenConsole() 

ConsoleTitle ("FnEval test") 
a$=" " 
PrintN("enter an expression") 
While Len(a$)>0 
  Print("> ") 
  a$=Input() 
  PrintN("") 
  PrintN(eval(a$)) 
Wend 
a$=Input() 
CloseConsole() 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
