; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2620&start=10
; Author: Lars (updated for PB 4.00 by Andre)
; Date: 22. October 2003
; OS: Windows
; Demo: Yes

Dim Matrix(10, 10) 
For y = 0 To 10 
  For x = 0 To 10 
    Read Matrix(x, y) 
  Next x 
Next y 

Punkt.POINT 
Punkt\x = 5 
Punkt\y = 5 

For x = 0 To Punkt\x 
  If Matrix(x, Punkt\y) = 1 
    InX = 1 - InX 
  EndIf  
Next x 

For y = 0 To Punkt\y 
  If Matrix(Punkt\x, y) = 1 
    InY = 1 - InY 
  EndIf  
Next y 

If InX = 1 And InY = 1 
  Debug "Liegt im Bereich!" 
Else 
  Debug "Liegt nicht im Bereich" 
EndIf 
End 

DataSection 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
  Data.l 1,0,0,0,0,0,0,0,0,0,0 
  Data.l 1,1,0,0,0,0,0,0,0,0,0 
  Data.l 1,0,1,0,0,0,0,0,0,0,0 
  Data.l 1,1,0,0,0,0,0,0,0,0,0 
  Data.l 1,0,0,0,0,0,0,0,0,0,0 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
  Data.l 0,0,0,0,0,0,0,0,0,0,0 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
