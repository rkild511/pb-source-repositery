; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3652&highlight=
; Author: Danilo
; Date: 08. February 2004
; OS: Windows
; Demo: Yes

; 2 WaitKey-Prozeduren, die auf einen Tastendruck in der Console warten. 
; WaitKey() wartet auf irgendeine Taste, WaitKey2() wartet auf 
; bestimmte Tasten die Du angeben kannst: 

; 
; by Danilo, 03.12.2003 
; 
Procedure.l WaitKey() 
  ; waits until the user presses a key 
  Repeat 
    asc = Asc(Inkey()) 
    If asc > 0 And asc < 127 
      key = asc 
    EndIf 
    Delay(10) 
  Until key 
  ProcedureReturn key 
EndProcedure 

Procedure.l WaitKey2(string$) 
  ; waits until the users presses a key 
  ; specified in string$ 
  Repeat 
    asc = Asc(Inkey()) 
    If asc > 0 And asc < 127 
      If FindString(string$,Chr(asc),1) 
        key = asc 
      EndIf 
    EndIf 
    Delay(10) 
  Until key 
  ProcedureReturn key 
EndProcedure 



OpenConsole() 

PrintN(""):Print("Input? ") 

For a = 1 To 10 ; get 10 chars with WaitChar 
  key = WaitKey() 
  If key=13 
    Break 
  ElseIf key > 31 
    Print(Chr(key)) 
  EndIf 
Next a 

PrintN(""):Print("Number? ") 

For a = 1 To 10 
  key = WaitKey2("0123456789."+Chr(13)) 
  If key=13 ; return 
    Break 
  EndIf 
  Print(Chr(key)) 
Next a

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger