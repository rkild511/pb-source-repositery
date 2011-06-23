; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2967&highlight=
; Author: Froggerprogger
; Date: 29. November 2003
; OS: Windows
; Demo: Yes


;hier sp‰ter ggf. ?returnvalue mit @result o.‰. ersetzen 
word1.s = PeekS(?returnvalue) 
word2.s = PeekS(?returnvalue + 1 + Len(word1)) 
word3.s = PeekS(?returnvalue + 2 + Len(word1) + Len(word2)) 
word4.s = PeekS(?returnvalue + 3 + Len(word1) + Len(word2) + Len(word3)) 
word5.s = PeekS(?returnvalue + 4 + Len(word1) + Len(word2) + Len(word3) + Len(word4)) 

Debug word1 
Debug word2 
Debug word3 
Debug word4 
Debug word5 
End 

;Beispiel: 
DataSection 
  returnvalue: 
  Data.s "Dies" 
  Data.s "ist" 
  Data.s "ein" 
  Data.s "nullterminierter" 
  Data.s "Wortfluﬂ..." 
EndDataSection
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
