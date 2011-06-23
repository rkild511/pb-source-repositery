; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2397&highlight=
; Author: NoOneKnows
; Date: 27. September 2003
; OS: Windows
; Demo: No

; Tested on WinXP + Win2000...
#TOKEN_QUERY = $08 

Procedure.s GetUserProfileDirectory() 
    OpenProcessToken_(GetCurrentProcess_(), #TOKEN_QUERY, @token) 

    Length.l = 512 
    directory$ = Space(Length) 
    
    GetUserProfileDirectory_(token, directory$, @Length) 
    ProcedureReturn Left(directory$, Length) + "\" 
EndProcedure 

Debug "Desktop-Verzeichnis: " + GetUserProfileDirectory() + "Desktop\" 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
