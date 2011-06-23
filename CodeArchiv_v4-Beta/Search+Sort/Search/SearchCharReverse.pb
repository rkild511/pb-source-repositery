; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2554&highlight=
; Author: Danilo
; Date: 14. October 2003
; OS: Windows
; Demo: Yes

Procedure SearchCharReverse(String$,char) 
  *Start    = @String$ 
  *Ende.BYTE = *Start + Len(String$) 
  While (*Start <> *Ende) 
    If *Ende\b & $FF = char 
      ProcedureReturn (*Ende - *Start) + 1 
    EndIf  
    *Ende - 1 
  Wend 
EndProcedure 

; The debug window will display the found positions, else 0 (not found)
Debug SearchCharReverse("Testing",'i') 
Debug SearchCharReverse("abcdefghijklmnopqrstuvwxy",'z') 
Debug SearchCharReverse("SearchCharReverse",'s') 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
