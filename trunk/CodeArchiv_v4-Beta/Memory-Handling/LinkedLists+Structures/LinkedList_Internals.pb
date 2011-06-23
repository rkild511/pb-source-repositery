; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8986&highlight=
; Author: Danilo
; Date: 03. January 2004
; OS: Windows
; Demo: Yes


; The values are directly saved in the element, after the 
; 2 standard entries for previous and next element. 

Structure LL 
  NextElement.l 
  PrevElement.l 
  Element.l[999999] 
EndStructure 

*mem.LL 

NewList list.Point() 

For a = 1 To 10 Step 2 
  *mem = AddElement (list()) 
  list()\x = a 
  list()\y = a+1 
Next a 

*mem = FirstElement( list() ) 
While *mem 
  Debug "This Element: "+StrU(*mem,#Long) 
  Debug "Prev Element: "+StrU(*mem\PrevElement,#Long) 
  Debug "Next Element: "+StrU(*mem\NextElement,#Long) 
  For a = 0 To SizeOf(POINT)/4-1 
    Debug "Value "+Str(a)+": "+StrU(*mem\Element[a],#Long) 
  Next a 
  Debug "----------" 
  *mem = NextElement( list() ) 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
