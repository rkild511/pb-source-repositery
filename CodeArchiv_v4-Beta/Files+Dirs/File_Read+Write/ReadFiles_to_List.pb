; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2211&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 05. September 2003
; OS: Windows
; Demo: Yes

FileName$="test.txt" 
Global NewList Liste.s() 
  
If ReadFile(0, FileName$) 
    
  Repeat 
    AddElement (Liste()) 
    Liste() = ReadString(0) 
  Until Eof(0) 

  CloseFile(0) 

  Debug "Anzahl eingelesener Zeilen =" 
  Debug CountList(Liste()) 

EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
