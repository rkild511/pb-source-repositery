; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2441&highlight=
; Author: GPI
; Date: 02. October 2003
; OS: Windows
; Demo: No


;MessageRequester("","test") 

; without #snd_async, the program is waiting 

Debug "SystemAsterisk (stern)" 
PlaySound_("SystemAsterisk",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT|#SND_ASYNC  ) 
Delay(500) 
Debug "SystemExclamation  (Advice)" 
PlaySound_("SystemExclamation",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT |#SND_ASYNC ) 
Delay(500) 
Debug "SystemExit (Systemstart)" 
PlaySound_("SystemExit",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT |#SND_ASYNC  ) 
Delay(500) 
Debug "SystemHand (Kritischer Abbruch)" 
PlaySound_("SystemHand",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT |#SND_ASYNC  ) 
Delay(500) 
Debug "SystemQuestion (Frage)" 
PlaySound_("SystemQuestion",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT |#SND_ASYNC  ) 
Delay(500) 
Debug "SystemStart (System-Start)" 
PlaySound_("SystemStart",0, #SND_ALIAS|#SND_NODEFAULT|#SND_NOWAIT|#SND_ASYNC   ) 
Delay(500)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
