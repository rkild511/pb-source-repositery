; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12751&highlight=
; Author: sverson (updated for PB 4.00 by Andre)
; Date: 04. February 2005
; OS: Windows, Linux
; Demo: No

; Procedure that return CurrentDir as String - works for Linux and Windows
; This is just here to show the API way, there is a native command in PB with v4...

; Prozedur, um das aktuelle Verzeichnis als String zurückzugeben - arbeitet unter Linux und Windows
; Diese befindet sich nur noch hier, um den Weg per API zu zeigen. Es gibt mit PB v4 jetzt einen nativen Befehl...

Procedure.s MyGetCurrentDirectory() 
 currentdir.s = Space(255) ; <- 255 is defined as #MAX_PATH in Window, not Linux, oh well. 

 CompilerIf #PB_Compiler_OS = #PB_OS_Linux   ; Linux...
   getcwd_(@currendir, 255) 
   If Right(currentdir, 1) <>"/" : currentdir + "/" : EndIf 
 CompilerElse                                ; Windows...
   GetCurrentDirectory_(255, @currentdir) 
   If Right(currentdir,1)<>"\" : currentdir + "\" : EndIf 
 CompilerEndIf 
 ProcedureReturn currentdir 
EndProcedure

Debug MyGetCurrentDirectory()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -