; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8326&highlight=
; Author: talun
; Date: 14. November 2003
; OS: Windows
; Demo: Yes

; masked password input 
; not for extended chars 
If OpenConsole() 
  PrintN("Password please: (return to exit)") 
  Passwd$ = "" 
  Repeat 
    xkey$ = Inkey() 
    If xkey$ <> "" 
      If Asc(xkey$)>=32 And Asc(xkey$) < 128 
        Passwd$ = Passwd$ + Left(xkey$, 1) 
        Print("*") 
      EndIf 
    EndIf  
  Until Left(xkey$, 1) = Chr(13)      
  PrintN("") 
  PrintN(Passwd$) 
  t$=Input() 
  CloseConsole() 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
