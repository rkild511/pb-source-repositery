; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2976&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No

;Strukturen mit ein paar Voreinstellungen füllen
lf.LOGFONT
lf\lfHeight = 1000/75 ;Fonthoehe = 10 ist voreingestellt
PokeS(lf+28,"Arial") ;Arial ist voreingestellt

cf.CHOOSEFONT
cf\lStructSize = SizeOf(CHOOSEFONT)
cf\hwndOwner = GetDesktopWindow_()
cf\lpLogFont = @lf
cf\flags = #CF_BOTH|#CF_TTONLY|#CF_INITTOLOGFONTSTRUCT|#CF_LIMITSIZE
cf\nSizeMin = 10;minimale Fonthoehe
cf\nSizeMax = 10;maximale Fonthoehe

;Dialog aufrufen
ChooseFont_(cf)

;und die nötigen Daten auslesen
Debug "Fontname : " + PeekS(lf+28)
Debug "Height   : " + Str(cf\iPointSize/10)
If lf\lfUnderline > 0 : Debug "unterstrichen":EndIf
If lf\lfStrikeOut > 0 : Debug "durchgestrichen":EndIf
If lf\lfItalic = -1  : Debug "schräggestellt":EndIf
If lf\lfWeight > 400  : Debug "fett":EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
