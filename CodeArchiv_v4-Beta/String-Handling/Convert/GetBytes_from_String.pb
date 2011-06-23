; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2026&highlight=
; Author: NicTheQuick
; Date: 19. August 2003
; OS: Windows
; Demo: Yes

String.s = "Dies ist ein Test-String" 

Procedure GetBytes(*Address, Length.l) 
  Protected *b.Byte, *EndAddress 
  *EndAddress = *Address + Length - 1 
  For *b = *Address To *EndAddress 
    Debug *b\b 
  Next 
EndProcedure 

GetBytes(@String, Len(String))
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
