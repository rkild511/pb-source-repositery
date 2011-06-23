; German forum:
; Author: Danilo
; Date: 22. November 2002
; OS: Windows
; Demo: No


;Aktuelles Verzeichnis mit WinApi-Befehl ermitteln


buffer.s = Space(1000)
GetCurrentDirectory_(1000,@buffer)

MessageRequester("Current Directory",buffer,0) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -