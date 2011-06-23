; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8362&highlight=
; Author: pupil
; Date: 15. November 2003
; OS: Windows
; Demo: No

; Question: Does anybody have a workaround for dynamic arrays in structures ?
; Answer: Use a pointer and use a dummy array to access it... see example

Structure testtype 
  a.l 
  b.s 
  parray.l ; array pointer 
EndStructure 

Structure dummytype 
  value.l[0] 
EndStructure 

a.testtype\parray = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT, 1024*4) 

*b.dummytype = a\parray 

For i = 0 To 10 
*b\value[i] = i 
  Debug *b\value[i] 
Next 

GlobalFree_(a\parray) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
