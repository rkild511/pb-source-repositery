; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2141&highlight=
; Author: marcus
; Date: 31. August 2003
; OS: Windows
; Demo: Yes


; Automatically switching between procedures, depending on a given parameter
; Automatisches Umschalten zwischen Prozeduren, abhängig von einem übergebenen Parameter

; Kill program with Debugger for exit!

;FunktionenTest 

Procedure hello( *proc) 
Print("<") 
CallFunctionFast( *proc) 
Print(">") 
EndProcedure 

Procedure hello1() 
  Print("hello1") 
EndProcedure 

Procedure hello2() 
  Print("hello2") 
EndProcedure 

Procedure hello3() 
  Print("hello3") 
EndProcedure 

Procedure switchprocedure(procnumber.b) 
  par1.s="string1" 
  par2.s="string2" 
  Select procnumber 
  Case 1 
    ;hello1() 
    *hello_proc=@hello1() 
  Case 2 
    ;hello2() 
    *hello_proc=@hello2() 
  Case 3 
    ;hello3() 
    *hello_proc=@hello3() 
  Default 
    ;hello1() 
    *hello_proc=@hello1() 
  EndSelect 
  ProcedureReturn (*hello_proc) 
EndProcedure 


OpenConsole() 

i.b=0 
Repeat 
  i=i+1; 
  If i=4 
    i=1 
  EndIf 
  Delay(500) 
  *hello_proc=switchprocedure(i) 
  hello(*hello_proc) 
ForEver
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
