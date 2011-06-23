; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9443&highlight=
; Author: Dare2
; Date: 09. February 2004
; OS: Windows
; Demo: Yes

Srce.s="String with  some multiple    spaces inside." 

; ---- eliminate extra spaces 

While FindString(Srce, "  ", 1) 
  Srce = ReplaceString(Srce, "  ", " ", 1, 1) 
Wend 

; ---- split 

k=1 
w.s=StringField(Srce, k, " ") 
While Len(w)>0 
  Debug w 
  k+1 
  w=StringField(Srce, k, " ") 
Wend 
Debug "Elements = "+Str(k-1) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -