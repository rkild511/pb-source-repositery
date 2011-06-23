; German forum: http://www.purebasic.fr/german/viewtopic.php?t=399&highlight=
; Author: Danilo
; Date: 10. October 2004
; OS: Windows
; Demo: No


; Convert a long path/file name into the DOS 8.3 fomat
; Wandelt einen langen Pfad/Dateinamen in das DOS 8.3 Format um

; 
; by Danilo, 10.10.2004 - german forum 
; 
Procedure.s ShortFileName(File$) 
  ; 
  ; converts a long path/filename to 8.3 format 
  ; 
  len = Len(File$) 
  ShortName$ = Space(len) 
  If GetShortPathName_(File$,ShortName$,len) 
    ProcedureReturn ShortName$ 
  Else 
    ProcedureReturn "" 
  EndIf 
EndProcedure 

File$ = OpenFileRequester("Filename","","*.*",1) 
If File$ 
  Debug File$ 
  Debug ShortFileName(File$) 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -