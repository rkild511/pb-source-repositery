; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3537
; Author: Rob (updated for PB 4.00 by Andre)
; Date: 24. January 2004
; OS: Windows
; Demo: Yes

; Get the number of installed themes on WinXP
; Ermittelt die Anzahl der installierten 'Themes' unter WinXP

If OpenLibrary(0, "UxTheme.dll")

  *f = GetFunction(0, "IsThemeActive")

  If *f
    Debug "Themes: " + Str(CallFunctionFast(*f))
  EndIf

  CloseLibrary(0)
Else
  Debug "Keine XP Themes Unterstützung"
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -