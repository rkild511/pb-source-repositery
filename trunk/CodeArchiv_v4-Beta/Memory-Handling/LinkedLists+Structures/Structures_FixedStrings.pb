; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2064&highlight=
; Author: GPI
; Date: 22. August 2003
; OS: Windows
; Demo: Yes

Structure OwnString 
  String.b[100] ; String mit der Länge 99 + 0-Byte  /  String with length 99 + 0-byte
EndStructure 

a.OwnString 
PokeS(@a\String[0],"Hallo") ; maximal 99 Zeichen!  /  max. 99 chars!
Debug PeekS(@a\String[0])
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
