; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1778&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 23. July 2003
; OS: Windows
; Demo: Yes

Structure Map 
  Index.s 
  Value.s 
EndStructure 
Global NewList Map.Map() 

Procedure MapPut(Index.s, Value.s) 
  Protected *z1.Byte, *z2.Byte, OK.l 
  
  ResetList(Map()) 
  While NextElement(Map()) 
    *z1 = @Index 
    *z2 = @Map()\Index 
    While *z1\b = *z2\b And *z1\b And *z2\b 
      *z1 + 1 
      *z2 + 1 
    Wend 
    If *z1\b = *z2\b 
      Map()\Value = Value 
      ProcedureReturn @Map() 
    EndIf 
  Wend 
  If AddElement(Map()) 
    Map()\Index = Index 
    Map()\Value = Value 
    ProcedureReturn @Map 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

Procedure.s MapGet(Index.s) 
  Protected *z1.Byte, *z2.Byte, OK.l 
  
  ResetList(Map()) 
  While NextElement(Map()) 
    *z1 = @Index 
    *z2 = @Map()\Index 
    While *z1\b = *z2\b And *z1\b And *z2\b 
      *z1 + 1 
      *z2 + 1 
    Wend 
    If *z1\b = *z2\b 
      ProcedureReturn Map()\Value 
    EndIf 
  Wend 
  ProcedureReturn "" 
EndProcedure 

a.l 
For a = 1 To 10 
  MapPut(Str(a), Str(11 - a)) 
Next 

For a = 1 To 10 
  Debug MapGet(Str(a)) 
Next
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
