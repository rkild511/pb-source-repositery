; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7398
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 01. September 2003
; OS: Windows
; Demo: No

Procedure.s ExpandEnv (env$) 
    ; Call once to get size of required string... 
    sizerequired = ExpandEnvironmentStrings_ (env$, dest$, 0) 
    If sizerequired 
        ; Fill the new string with the path... 
        dest$ = Space (sizerequired) 
        result = ExpandEnvironmentStrings_ (env$, dest$, 159) 
    EndIf 
    ProcedureReturn dest$ 
EndProcedure 

Debug ExpandEnv ("%systemroot%") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
