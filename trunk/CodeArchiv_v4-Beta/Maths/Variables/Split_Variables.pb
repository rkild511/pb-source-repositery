; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2026&highlight=
; Author: NicTheQuick
; Date: 19. August 2003
; OS: Windows
; Demo: Yes

Structure B4 
  b1.b 
  b2.b 
  b3.b 
  b4.b 
EndStructure 
Structure W2 
  w1.w 
  w2.w 
EndStructure 
Structure L1 
  l1.l 
EndStructure 

*b4.B4 
*w2.W2 
*l1.L1 

Wert.l = $01020304 

*b4 = @Wert 
*w2 = @Wert 
*l1 = @Wert 

Debug "Vier Bytes" 
Debug *b4\b1 
Debug *b4\b2 
Debug *b4\b3 
Debug *b4\b4 
Debug "" 
Debug "Zwei Words" 
Debug *w2\w1 
Debug *w2\w2 
Debug "" 
Debug "Ein Long" 
Debug *l1\l1

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
