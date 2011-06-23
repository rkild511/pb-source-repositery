; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8416
; Author: Rings
; Date: 19. November 2003
; OS: Windows
; Demo: No

Procedure DetectSafeMode() 
  ProcedureReturn GetSystemMetrics_(#SM_CLEANBOOT) 
EndProcedure 

Select DetectSafeMode() 
  Case 0 
   Debug "Windows is running normally." 
  Case 1 
   Debug "Windows started in Safe Mode" 
  Case 2 
   Debug "Windows started in Safe Mode with network support" 
EndSelect 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
