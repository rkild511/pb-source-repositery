; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2593
; Author: Danilo
; Date: 18. October 2003
; OS: Windows
; Demo: No

Procedure.s VerzeichnisKuerzen(String$) 
  String$ = Trim(String$) 
  If Right(String$,1)="\":String$ = Left(String$,Len(String$)-1):EndIf 
  ProcedureReturn GetFilePart(String$) 
  
EndProcedure 

Debug  VerzeichnisKuerzen("C:\Programme\Datene\Bilder\bild.jpg") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
