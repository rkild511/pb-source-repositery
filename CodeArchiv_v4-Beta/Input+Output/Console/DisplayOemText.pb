; www.purearea.net (Sourcecode collection by cnesm)
; Author: Andreas
; Date: 22. November 2003
; OS: Windows
; Demo: No

;##############################################
;Umlaute korrekt darstellen
;##############################################
;Andreas Miethe * November 2002
;##############################################


OpenConsole()
ClearConsole()
PrintN("")
X$ =""
PrintN ("Umlaute : �������")
CharToOem_("Umlaute : �������",x$)
PrintN (x$)
CharToOem_("Taste f�r Ende......",x$)
PrintN(x$)
Input()
CloseConsole()
; IDE Options = PureBasic v4.00 (Windows - x86)
; ExecutableFormat = Console
; Folding = -
; DisableDebugger