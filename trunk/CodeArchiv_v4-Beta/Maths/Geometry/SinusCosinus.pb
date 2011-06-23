; German forum:
; Author: Daniel
; Date: 04. September 2002
; OS: Windows
; Demo: Yes



; Hab mal einen etwas anderen Sinus Cosinus Befehl geschrieben, bei dem man nicht das Bogenmass, 
; sondern die Grad angeben kann. Also genauso wie beim Taschenrechner. 


Procedure.f GSin(winkel.f) 
  preturn.f=Sin(winkel*(2*3.14159265/360)) 
  ProcedureReturn preturn 
EndProcedure 

Procedure.f GCos(winkel.f) 
  preturn.f=Cos(winkel*(2*3.14159265/360)) 
  ProcedureReturn preturn 
EndProcedure 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -