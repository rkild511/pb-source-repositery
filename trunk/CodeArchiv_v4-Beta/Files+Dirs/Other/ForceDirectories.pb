; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3145&highlight=
; Author: IB-Software
; Date: 15. December 2003
; OS: Windows
; Demo: Yes


; This function creates several (sub-) directories with only one call...

; Diese Funktion erstellt, im Gegensatz zu CreateDirectory von PB, mehrere
; Verzeichnisebenen mit einem einzigen Funktionsaufruf. 

Procedure ForceDirectories(Dir.s) 
  If Len(Dir.s) = 0 
    result = #False 
  Else 
    If (Right(Dir.s, 1) = "\") 
      Dir.s = Left(Dir.s, Len(Dir.s)-1) 
    EndIf 
    If (Len(Dir.s) < 3) Or FileSize(Dir.s) = -2 Or GetPathPart(Dir.s)= Dir.s 
      ProcedureReturn #False 
    EndIf 
    ForceDirectories(GetPathPart(Dir.s)); 
    CreateDirectory(Dir.s); 
    ProcedureReturn #True 
  EndIf 
EndProcedure  
 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
