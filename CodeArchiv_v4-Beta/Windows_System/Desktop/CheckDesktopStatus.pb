; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2273&highlight=
; Author: Dige
; Date: 11. September 2003
; OS: Windows
; Demo: No

; Should work on WinXP, Win2000, NT - does NOT work on Win98SE !

; Überprüft, ob der Desktop gesperrt ist...

; Sperren ist möglich via:
; Bei der Benutzerkonten Verwaltung die 'klassische Anmeldeaufforderung' auswählen.
; Dann kann der Desktop mit Strg+Alt+Entf gesperrt werden. 
; oder via WinAPI:
; LockWorkStation_() 

Repeat 
  If GetInputDesktop_() > 0 
    Debug "Desktop is unlocked" 
  Else 
    Debug "Desktop is locked" 
  EndIf 
  Delay ( 1000 ) 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
