; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

Procedure CountStringFields(String.s, TrennZ.s) 
  Protected a.l, Count.l 
  Count = 0
  For a = 1 To Len(String) 
    If Mid(String, a, 1) = TrennZ : Count + 1 : EndIf 
  Next 
  ProcedureReturn Count 
EndProcedure 

Text.s = "eins,zwei,drei,vier,fünf,sechs," 

Debug CountStringFields(Text, ",")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -