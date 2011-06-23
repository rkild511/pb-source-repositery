; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8267&highlight=
; Author: Rings (updated for PB 4.00 by Andre)
; Date: 10. November 2003
; OS: Windows
; Demo: Yes

Dim MYArray.b(4711) 

Procedure Ubound(*Array) 
  ProcedureReturn PeekL(*Array-8) 
EndProcedure 

Debug Str(UBound(@MyArray(0)))
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
