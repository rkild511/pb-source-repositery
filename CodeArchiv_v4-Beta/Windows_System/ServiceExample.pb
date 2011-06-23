; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14488
; Author: akee (updated for PB 4.00 by Andre)
; Date: 21. March 2005
; OS: Windows
; Demo: No

; Windows Service Framework
; -------------------------
; You can then go to Service Manger and Pause it, Continue, Stop and 
; Restart and just look at the ServiceExample.log to see the status 
; change. Remember to stop the service or else ServiceExample.log 
; will fill your hard disk... 

XIncludeFile "ServiceFramework.pbi" 
 
; 
Procedure ServiceProcedure(State.l) 
  Select State 
    Case #SERVICE_RUNNING 
      _WriteLog("RUNNING:" + Str(State)) 
    Case #SERVICE_PAUSED 
      _WriteLog("PAUSED:" + Str(State)) 
  EndSelect 
EndProcedure 


ServiceInit("My Service") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -